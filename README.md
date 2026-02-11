# Habla

`Habla` is the binary host<->device protocol used by this workspace.

This repo includes:

- protocol documentation (`01` to `06` markdown files)
- C codec/parser (`HablaC`)
- Swift wrapper (`Habla`)
- tiny example app (`HablaExample`)

## Current Protocol Snapshot

- Frame magic: `0x48 0x42` (`HB`)
- Version major: `0x01`
- CRC: CRC-16/CCITT-FALSE
- Transport: UART / USB CDC / BLE UART / TCP byte streams

Primary message types:

- Request (`0x00`)
- Response (`0x01`)
- Event (`0x02`)
- Ack (`0x03`)
- Nack (`0x04`)

## Ping Command (Workspace Extension)

- Command key: `PING` (`0x84`)
- Request payload: empty
- Response payload format:
  - `status` (`0x00` for OK)
  - length-prefixed UTF-8 `name`
  - length-prefixed UTF-8 `version`
  - `buildNumber` (`UInt32`, little-endian)
  - length-prefixed UTF-8 `board`

See:

- `03-command-keys.md`
- `05-examples.md`

## Build

Swift package:

```sh
cd /Users/cosas/Desktop/Cosas/Code/Habla
swift build
```

CMake C library:

```sh
cd /Users/cosas/Desktop/Cosas/Code/Habla
cmake -S . -B build
cmake --build build
```

## Document Map

- `01-habla-v1-overview.md`: goals and design principles
- `02-wire-format.md`: frame structure, flags, CRC
- `03-command-keys.md`: command/accessory registry
- `04-operation-profiles.md`: operation payload schemas
- `05-examples.md`: request/response examples
- `06-conformance.md`: implementation checklist
