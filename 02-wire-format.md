# Habla v1 Wire Format

## Frame Layout

All frames are binary:

| Offset | Size | Field | Description |
|---|---:|---|---|
| 0 | 1 | Magic0 | `0x48` (`H`) |
| 1 | 1 | Magic1 | `0x42` (`B`) |
| 2 | 1 | VersionMajor | `0x01` for Habla v1 |
| 3 | 1 | VersionMinor | `0x00` for Habla v1.0 |
| 4 | 1 | Flags | Reliability and routing flags |
| 5 | 1 | MessageType | Request/Response/Event/Ack/Nack |
| 6 | 1 | Sequence | Correlates request and response |
| 7 | 1 | PartIndex | Fragment index (0-based) |
| 8 | 1 | PartCount | Number of fragments (1 if unfragmented) |
| 9 | 1 | CommandKey | Primary opcode (`CommandKeys`) |
| 10 | 1 | AccessoryKey | Secondary selector (`AccessoryKeys` or extension) |
| 11 | 2 | PayloadLength | Little-endian payload bytes |
| 13 | N | Payload | Operation data |
| 13+N | 2 | CRC16 | CRC-16/CCITT-FALSE over bytes 0..(12+N) |

## Message Types

- `0x00` Request
- `0x01` Response
- `0x02` Event (unsolicited device->host)
- `0x03` Ack (frame accepted and queued)
- `0x04` Nack (frame rejected)

## Flags

- bit0 `ACK_REQUIRED`: receiver should return Ack/Nack.
- bit1 `IS_FRAGMENT`: payload split across multiple frames.
- bit2 `PRIORITY`: expedited handling requested.
- bit3 `EVENT_SUBSCRIPTION`: frame modifies event subscriptions.
- bit4..bit7 reserved (must be `0` in v1).

## Fragmentation

- If payload exceeds transport MTU, sender splits frame:
  - same `Sequence`, `CommandKey`, and `AccessoryKey`,
  - `PartIndex` increments from `0`,
  - `PartCount` constant across all parts.
- Receiver reassembles then validates semantic payload.

## Integrity

- CRC16 polynomial: `0x1021`, init `0xFFFF`, no reflection, xorout `0x0000`.
- CRC mismatch must produce `Nack` with `BAD_CRC`.

## Error Model

Nack/Response payload byte 0 is `ErrorCode` when failed:

- `0x00` OK
- `0x01` BAD_FRAME
- `0x02` BAD_CRC
- `0x03` UNSUPPORTED_VERSION
- `0x04` UNSUPPORTED_COMMAND
- `0x05` UNSUPPORTED_ACCESSORY
- `0x06` INVALID_PAYLOAD
- `0x07` INVALID_PIN
- `0x08` BUS_ERROR
- `0x09` TIMEOUT
- `0x0A` BUSY
- `0x0B` PERMISSION_DENIED
- `0x0C` INTERNAL_ERROR

## Timing Defaults

- Request timeout: 250 ms (host configurable).
- Retry count when `ACK_REQUIRED`: 2 retries.
- Backoff: 20 ms, then 50 ms.

## Transport Binding Notes

- UART/USB CDC: raw frame bytes.
- BLE UART: raw frame bytes, application-level reassembly recommended.
- TCP: raw frame stream; use frame parser by header + payload length + CRC.
