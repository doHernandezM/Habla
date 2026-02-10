# Habla v1 Conformance

## Conformance Levels

## Level 0: Frame Compliance

Required:

- Parse and emit Habla v1 frame header.
- Validate `Magic`, version major, payload length bounds, and CRC16.
- Support `Request`, `Response`, `Ack`, and `Nack`.
- Return explicit error codes.

## Level 1: Core GPIO

Required:

- `PinMode`, `DigitalRead`, `DigitalWrite`.
- `TEST` capability response selector `0x01`.
- At least one event subscription mechanism (pin change or heartbeat).

## Level 2: Analog and Accessory

Required:

- `AnalogRead` and/or `AnalogWrite`.
- `Accessory` command with at least one accessory key.

## Level 3: Bus Passthrough

Required:

- One or more of:
  - I2C passthrough (`DeviceCMD` + `i2c0`/`i2c1`),
  - SPI passthrough (`DeviceCMD` + `spi0`/`spi1`),
  - UART passthrough (`DeviceCMD` + `uart0`/`uart1`).

## Recommended Limits

- Max payload: >= 128 bytes.
- Reassembly buffer: >= 256 bytes.
- Max in-flight request sequences: >= 4.

## Interop Checklist

1. Command keys match `03-command-keys.md`.
2. Unknown `CommandKey` returns `UNSUPPORTED_COMMAND`.
3. Unknown `AccessoryKey` returns `UNSUPPORTED_ACCESSORY`.
4. Invalid payload returns `INVALID_PAYLOAD`.
5. CRC mismatch returns `BAD_CRC` Nack when possible.
6. Response `Sequence` equals request `Sequence`.
7. Fragmented frames reassemble in order and verify `PartCount`.
8. `ACK_REQUIRED` behavior is deterministic.

## Test Vectors (Minimum)

1. Valid frame with empty payload.
2. Frame with max unfragmented payload.
3. Corrupt CRC frame.
4. Unsupported command.
5. Fragmented two-part request and response.
6. Timeout and retry behavior with `ACK_REQUIRED`.

## Reference Implementation Guidance

- Keep parser state machine explicit:
  - `search_magic -> read_header -> read_payload -> read_crc -> validate`.
- Never execute commands before CRC validation.
- For event-heavy targets, isolate command RX from event TX queues.
