#ifndef HABLA_H
#define HABLA_H

#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

#define HABLA_VERSION_MAJOR ((uint8_t)1u)
#define HABLA_VERSION_MINOR ((uint8_t)0u)

#define HABLA_MAGIC0 ((uint8_t)0x48u) /* H */
#define HABLA_MAGIC1 ((uint8_t)0x42u) /* B */

#define HABLA_FRAME_HEADER_SIZE ((size_t)13u)
#define HABLA_FRAME_CRC_SIZE ((size_t)2u)
#define HABLA_MIN_FRAME_SIZE (HABLA_FRAME_HEADER_SIZE + HABLA_FRAME_CRC_SIZE)

typedef enum habla_status {
  HABLA_STATUS_OK = 0,
  HABLA_STATUS_NEED_MORE = 1,
  HABLA_STATUS_FRAME_READY = 2,

  HABLA_STATUS_INVALID_ARGUMENT = -1,
  HABLA_STATUS_NO_BUFFER = -2,
  HABLA_STATUS_INVALID_LENGTH = -3,
  HABLA_STATUS_BAD_FRAME = -4,
  HABLA_STATUS_BAD_CRC = -5,
  HABLA_STATUS_UNSUPPORTED_VERSION = -6
} habla_status_t;

typedef enum habla_message_type {
  HABLA_MSG_REQUEST = 0x00,
  HABLA_MSG_RESPONSE = 0x01,
  HABLA_MSG_EVENT = 0x02,
  HABLA_MSG_ACK = 0x03,
  HABLA_MSG_NACK = 0x04
} habla_message_type_t;

typedef enum habla_error_code {
  HABLA_ERR_OK = 0x00,
  HABLA_ERR_BAD_FRAME = 0x01,
  HABLA_ERR_BAD_CRC = 0x02,
  HABLA_ERR_UNSUPPORTED_VERSION = 0x03,
  HABLA_ERR_UNSUPPORTED_COMMAND = 0x04,
  HABLA_ERR_UNSUPPORTED_ACCESSORY = 0x05,
  HABLA_ERR_INVALID_PAYLOAD = 0x06,
  HABLA_ERR_INVALID_PIN = 0x07,
  HABLA_ERR_BUS_ERROR = 0x08,
  HABLA_ERR_TIMEOUT = 0x09,
  HABLA_ERR_BUSY = 0x0A,
  HABLA_ERR_PERMISSION_DENIED = 0x0B,
  HABLA_ERR_INTERNAL_ERROR = 0x0C
} habla_error_code_t;

typedef struct habla_header {
  uint8_t version_major;
  uint8_t version_minor;
  uint8_t flags;
  uint8_t message_type;
  uint8_t sequence;
  uint8_t part_index;
  uint8_t part_count;
  uint8_t command_key;
  uint8_t accessory_key;
} habla_header_t;

typedef struct habla_frame {
  habla_header_t header;
  const uint8_t *payload;
  uint16_t payload_length;
  uint16_t crc16;
} habla_frame_t;

typedef struct habla_parser {
  uint8_t *buffer;
  size_t capacity;
  size_t length;
} habla_parser_t;

/* Returns full encoded frame size (header + payload + CRC). */
size_t habla_encoded_size(uint16_t payload_length);

/* CRC-16/CCITT-FALSE: poly=0x1021, init=0xFFFF, xorout=0x0000. */
uint16_t habla_crc16_ccitt(const uint8_t *data, size_t length);

/*
 * Encodes one frame into `out`.
 * - `out_written` returns bytes written.
 * - `header->part_count` of 0 is normalized to 1.
 */
habla_status_t habla_encode_frame(
    uint8_t *out,
    size_t out_capacity,
    const habla_header_t *header,
    const uint8_t *payload,
    uint16_t payload_length,
    size_t *out_written);

/*
 * Decodes a full frame from `frame`.
 * On success, `out_frame->payload` points inside `frame`.
 */
habla_status_t habla_decode_frame(
    const uint8_t *frame,
    size_t frame_length,
    habla_frame_t *out_frame);

/* Streaming parser helpers (single-byte push). */
void habla_parser_init(habla_parser_t *parser, uint8_t *buffer, size_t capacity);
void habla_parser_reset(habla_parser_t *parser);
void habla_parser_consume(habla_parser_t *parser, size_t frame_length);

/*
 * Push one byte into the parser.
 * Returns:
 * - HABLA_STATUS_NEED_MORE while waiting for a complete frame.
 * - HABLA_STATUS_FRAME_READY when `out_frame` is valid.
 * - negative error codes for malformed input.
 *
 * Note:
 * - On FRAME_READY, `out_frame->payload` points into parser->buffer.
 * - Call `habla_parser_consume(parser, out_frame_length)` after handling.
 */
habla_status_t habla_parser_push(
    habla_parser_t *parser,
    uint8_t byte,
    habla_frame_t *out_frame,
    size_t *out_frame_length);

#ifdef __cplusplus
}
#endif

#endif /* HABLA_H */
