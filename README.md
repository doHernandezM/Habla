# Habla Protocol v1

Habla is a host-to-embedded control protocol for serial and serial-like links.
This draft uses `CommandKeys.swift` from CosasStudio as its opcode base and
defines a stricter wire format, reliability model, and payload rules.

## Document Set

- `01-habla-v1-overview.md`: scope, goals, and design principles.
- `02-wire-format.md`: frame layout, flags, message types, CRC, fragmentation.
- `03-command-keys.md`: opcode and accessory registry (v1 baseline).
- `04-operation-profiles.md`: payload schemas for GPIO, analog, buses, and system.
- `05-examples.md`: concrete request/response/event frame examples.
- `06-conformance.md`: minimum compliance profiles and test checklist.

## Status

- Version: `v1.0.0-draft`
- Maturity: Draft for implementation
- Compatibility target: 8-bit and 32-bit MCUs over UART/USB CDC/BLE UART/TCP

## Naming

- Protocol name: `Habla`
- Frame encoding: binary
- Endianness: little-endian for multi-byte integers
