#include "habla.h"

#include <string.h>

enum {
  HABLA_OFFSET_MAGIC0 = 0,
  HABLA_OFFSET_MAGIC1 = 1,
  HABLA_OFFSET_VERSION_MAJOR = 2,
  HABLA_OFFSET_VERSION_MINOR = 3,
  HABLA_OFFSET_FLAGS = 4,
  HABLA_OFFSET_MESSAGE_TYPE = 5,
  HABLA_OFFSET_SEQUENCE = 6,
  HABLA_OFFSET_PART_INDEX = 7,
  HABLA_OFFSET_PART_COUNT = 8,
  HABLA_OFFSET_COMMAND_KEY = 9,
  HABLA_OFFSET_ACCESSORY_KEY = 10,
  HABLA_OFFSET_PAYLOAD_LEN_LO = 11,
  HABLA_OFFSET_PAYLOAD_LEN_HI = 12,
  HABLA_OFFSET_PAYLOAD = 13
};

static uint16_t habla_read_u16_le(const uint8_t *p) {
  return (uint16_t)((uint16_t)p[0] | ((uint16_t)p[1] << 8));
}

static void habla_write_u16_le(uint8_t *p, uint16_t value) {
  p[0] = (uint8_t)(value & 0xFFu);
  p[1] = (uint8_t)((value >> 8) & 0xFFu);
}

size_t habla_encoded_size(uint16_t payload_length) {
  return HABLA_FRAME_HEADER_SIZE + (size_t)payload_length + HABLA_FRAME_CRC_SIZE;
}

uint16_t habla_crc16_ccitt(const uint8_t *data, size_t length) {
  uint16_t crc = 0xFFFFu;
  size_t i = 0;
  uint8_t bit = 0;

  if (data == NULL && length > 0u) {
    return 0u;
  }

  for (i = 0; i < length; ++i) {
    crc ^= (uint16_t)((uint16_t)data[i] << 8);
    for (bit = 0; bit < 8u; ++bit) {
      if ((crc & 0x8000u) != 0u) {
        crc = (uint16_t)((crc << 1) ^ 0x1021u);
      } else {
        crc = (uint16_t)(crc << 1);
      }
    }
  }

  return crc;
}

habla_status_t habla_encode_frame(
    uint8_t *out,
    size_t out_capacity,
    const habla_header_t *header,
    const uint8_t *payload,
    uint16_t payload_length,
    size_t *out_written) {
  size_t total = 0;
  uint16_t crc = 0;
  uint8_t part_count = 0;

  if (out == NULL || header == NULL || out_written == NULL) {
    return HABLA_STATUS_INVALID_ARGUMENT;
  }
  if (payload_length > 0u && payload == NULL) {
    return HABLA_STATUS_INVALID_ARGUMENT;
  }

  total = habla_encoded_size(payload_length);
  if (out_capacity < total) {
    return HABLA_STATUS_NO_BUFFER;
  }

  out[HABLA_OFFSET_MAGIC0] = HABLA_MAGIC0;
  out[HABLA_OFFSET_MAGIC1] = HABLA_MAGIC1;
  out[HABLA_OFFSET_VERSION_MAJOR] =
      header->version_major == 0u ? HABLA_VERSION_MAJOR : header->version_major;
  out[HABLA_OFFSET_VERSION_MINOR] = header->version_minor;
  out[HABLA_OFFSET_FLAGS] = header->flags;
  out[HABLA_OFFSET_MESSAGE_TYPE] = header->message_type;
  out[HABLA_OFFSET_SEQUENCE] = header->sequence;
  out[HABLA_OFFSET_PART_INDEX] = header->part_index;
  part_count = header->part_count == 0u ? 1u : header->part_count;
  out[HABLA_OFFSET_PART_COUNT] = part_count;
  out[HABLA_OFFSET_COMMAND_KEY] = header->command_key;
  out[HABLA_OFFSET_ACCESSORY_KEY] = header->accessory_key;
  habla_write_u16_le(&out[HABLA_OFFSET_PAYLOAD_LEN_LO], payload_length);

  if (payload_length > 0u) {
    memcpy(&out[HABLA_OFFSET_PAYLOAD], payload, (size_t)payload_length);
  }

  crc = habla_crc16_ccitt(out, HABLA_FRAME_HEADER_SIZE + (size_t)payload_length);
  habla_write_u16_le(
      &out[HABLA_FRAME_HEADER_SIZE + (size_t)payload_length],
      crc);

  *out_written = total;
  return HABLA_STATUS_OK;
}

habla_status_t habla_decode_frame(
    const uint8_t *frame,
    size_t frame_length,
    habla_frame_t *out_frame) {
  uint16_t payload_length = 0;
  size_t expected_length = 0;
  uint16_t expected_crc = 0;
  uint16_t computed_crc = 0;

  if (frame == NULL || out_frame == NULL) {
    return HABLA_STATUS_INVALID_ARGUMENT;
  }
  if (frame_length < HABLA_MIN_FRAME_SIZE) {
    return HABLA_STATUS_INVALID_LENGTH;
  }
  if (frame[HABLA_OFFSET_MAGIC0] != HABLA_MAGIC0 ||
      frame[HABLA_OFFSET_MAGIC1] != HABLA_MAGIC1) {
    return HABLA_STATUS_BAD_FRAME;
  }

  payload_length = habla_read_u16_le(&frame[HABLA_OFFSET_PAYLOAD_LEN_LO]);
  expected_length = habla_encoded_size(payload_length);
  if (frame_length != expected_length) {
    return HABLA_STATUS_INVALID_LENGTH;
  }

  expected_crc = habla_read_u16_le(&frame[expected_length - HABLA_FRAME_CRC_SIZE]);
  computed_crc = habla_crc16_ccitt(frame, expected_length - HABLA_FRAME_CRC_SIZE);
  if (expected_crc != computed_crc) {
    return HABLA_STATUS_BAD_CRC;
  }

  if (frame[HABLA_OFFSET_VERSION_MAJOR] != HABLA_VERSION_MAJOR) {
    return HABLA_STATUS_UNSUPPORTED_VERSION;
  }

  out_frame->header.version_major = frame[HABLA_OFFSET_VERSION_MAJOR];
  out_frame->header.version_minor = frame[HABLA_OFFSET_VERSION_MINOR];
  out_frame->header.flags = frame[HABLA_OFFSET_FLAGS];
  out_frame->header.message_type = frame[HABLA_OFFSET_MESSAGE_TYPE];
  out_frame->header.sequence = frame[HABLA_OFFSET_SEQUENCE];
  out_frame->header.part_index = frame[HABLA_OFFSET_PART_INDEX];
  out_frame->header.part_count = frame[HABLA_OFFSET_PART_COUNT];
  out_frame->header.command_key = frame[HABLA_OFFSET_COMMAND_KEY];
  out_frame->header.accessory_key = frame[HABLA_OFFSET_ACCESSORY_KEY];
  out_frame->payload_length = payload_length;
  out_frame->payload = payload_length > 0u ? &frame[HABLA_OFFSET_PAYLOAD] : NULL;
  out_frame->crc16 = expected_crc;

  return HABLA_STATUS_OK;
}

void habla_parser_init(habla_parser_t *parser, uint8_t *buffer, size_t capacity) {
  if (parser == NULL) {
    return;
  }
  parser->buffer = buffer;
  parser->capacity = capacity;
  parser->length = 0u;
}

void habla_parser_reset(habla_parser_t *parser) {
  if (parser == NULL) {
    return;
  }
  parser->length = 0u;
}

void habla_parser_consume(habla_parser_t *parser, size_t frame_length) {
  if (parser == NULL || parser->buffer == NULL || parser->length == 0u || frame_length == 0u) {
    return;
  }
  if (frame_length >= parser->length) {
    parser->length = 0u;
    return;
  }
  memmove(
      parser->buffer,
      parser->buffer + frame_length,
      parser->length - frame_length);
  parser->length -= frame_length;
}

static void habla_parser_resync(habla_parser_t *parser) {
  if (parser == NULL || parser->buffer == NULL) {
    return;
  }
  while (parser->length > 0u) {
    if (parser->buffer[0] != HABLA_MAGIC0) {
      memmove(parser->buffer, parser->buffer + 1, parser->length - 1u);
      parser->length -= 1u;
      continue;
    }

    /* Keep a lone leading magic byte so the next push can complete 'HB'. */
    if (parser->length < 2u) {
      return;
    }

    if (parser->buffer[1] == HABLA_MAGIC1) {
      return;
    }

    memmove(parser->buffer, parser->buffer + 1, parser->length - 1u);
    parser->length -= 1u;
  }
}

habla_status_t habla_parser_push(
    habla_parser_t *parser,
    uint8_t byte,
    habla_frame_t *out_frame,
    size_t *out_frame_length) {
  uint16_t payload_length = 0;
  size_t expected_length = 0;
  habla_status_t status = HABLA_STATUS_OK;

  if (parser == NULL || parser->buffer == NULL || out_frame == NULL) {
    return HABLA_STATUS_INVALID_ARGUMENT;
  }
  if (parser->capacity < HABLA_MIN_FRAME_SIZE) {
    return HABLA_STATUS_NO_BUFFER;
  }

  if (parser->length >= parser->capacity) {
    parser->length = 0u;
    return HABLA_STATUS_NO_BUFFER;
  }
  parser->buffer[parser->length++] = byte;
  habla_parser_resync(parser);

  if (parser->length < HABLA_FRAME_HEADER_SIZE) {
    return HABLA_STATUS_NEED_MORE;
  }

  payload_length = habla_read_u16_le(&parser->buffer[HABLA_OFFSET_PAYLOAD_LEN_LO]);
  expected_length = habla_encoded_size(payload_length);

  if (expected_length > parser->capacity) {
    if (parser->length > 1u) {
      memmove(parser->buffer, parser->buffer + 1, parser->length - 1u);
    }
    parser->length -= 1u;
    habla_parser_resync(parser);
    return HABLA_STATUS_INVALID_LENGTH;
  }

  if (parser->length < expected_length) {
    return HABLA_STATUS_NEED_MORE;
  }

  status = habla_decode_frame(parser->buffer, expected_length, out_frame);
  if (status != HABLA_STATUS_OK) {
    if (parser->length > 1u) {
      memmove(parser->buffer, parser->buffer + 1, parser->length - 1u);
    }
    parser->length -= 1u;
    habla_parser_resync(parser);
    return status;
  }

  if (out_frame_length != NULL) {
    *out_frame_length = expected_length;
  }
  return HABLA_STATUS_FRAME_READY;
}
