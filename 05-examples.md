# Habla v1 Examples

Examples below omit CRC bytes for readability unless stated.

## 1) DigitalWrite pin 25 = 1

Request fields:

- MessageType: Request (`0x00`)
- Sequence: `0x10`
- CommandKey: DigitalWrite (`0x12`)
- AccessoryKey: digitalPin (`0x01`)
- Payload: `[0x19, 0x01]` (pin 25, value true)

Pseudo-frame:

```text
48 42 01 00 01 00 10 00 01 12 01 02 00 19 01 CRC_LO CRC_HI
```

Ack response:

```text
48 42 01 00 00 03 10 00 01 12 01 01 00 00 CRC_LO CRC_HI
```

## 2) DigitalRead pin 25

Request:

```text
48 42 01 00 01 00 11 00 01 11 01 01 00 19 CRC_LO CRC_HI
```

Response payload:

- byte0 status (`0x00`)
- byte1 value (`0x01`)

```text
48 42 01 00 00 01 11 00 01 11 01 02 00 00 01 CRC_LO CRC_HI
```

## 3) I2C writeRead on bus i2c0

Intent:

- write register `0x00` to addr `0x68`
- read 6 bytes

Payload:

- op `0x03`
- addr `0x68`
- wlen `0x01`
- write byte `0x00`
- rlen `0x06`

Request:

```text
48 42 01 00 01 00 20 00 01 A3 30 05 00 03 68 01 00 06 CRC_LO CRC_HI
```

Response success with 6 bytes:

```text
48 42 01 00 00 01 20 00 01 A3 30 08 00 00 06 d0 d1 d2 d3 d4 d5 CRC_LO CRC_HI
```

## 4) Capability discovery

Request selector:

```text
48 42 01 00 01 00 30 00 01 81 00 01 00 01 CRC_LO CRC_HI
```

Response (example):

```text
48 42 01 00 00 01 30 00 01 81 00 0C 00 00 01 00 80 00 3F 01 1E 50 69 63 6F CRC_LO CRC_HI
```

## 5) Error response example

Unsupported command:

```text
MessageType=Response, payload=[0x04]
```

Where `0x04 = UNSUPPORTED_COMMAND`.

## 6) Ping device metadata

Request (`PING`, no payload):

```text
48 42 01 00 00 00 42 00 01 84 00 00 00 CRC_LO CRC_HI
```

Response payload format:

- byte0 status (`0x00`)
- byte1 `nameLen`, then `name` bytes
- next byte `versionLen`, then `version` bytes
- next 4 bytes `buildNumber` (uint32 LE)
- next byte `boardLen`, then `board` bytes

Example response payload:

```text
00 06 43 6f 73 61 4f 53 05 30 2e 31 2e 30 03 00 00 00 04 70 69 63 6f
```
