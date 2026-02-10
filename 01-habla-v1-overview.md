# Habla v1 Overview

## Scope

Habla v1 standardizes communication between a desktop host and an embedded
target for:

- device identity and capability discovery,
- digital/analog pin control,
- accessory control (LED/LCD/print),
- bus passthrough (I2C/SPI/UART),
- telemetry and asynchronous events,
- deterministic error reporting.

## Non-Goals

- Firmware update transport (can be layered separately).
- Real-time hard guarantees over unreliable links.
- Hardware-specific register APIs in the protocol surface.

## Design Principles

1. Stable opcode base from `CommandKeys.swift`.
2. Transport-neutral framing that works over UART, USB CDC, BLE UART, and TCP.
3. Mandatory integrity check (CRC16).
4. Request/response model with optional ack mode and sequence IDs.
5. Clear capability negotiation so hosts can adapt across Pico/Arduino/ESP.
6. Minimal payload encoding complexity for low-memory targets.

## Entities

- Host: desktop/mobile/controller application.
- Target: embedded device running Habla firmware.
- Session: logical exchange identified by `sequence` and message direction.

## Versioning

- Protocol version field is carried in every frame.
- v1 devices must reject higher major versions with `UNSUPPORTED_VERSION`.
- Minor version mismatch is allowed if required capabilities are present.

## Compatibility with CosasStudio Command Keys

- Habla v1 keeps the numeric command key ranges from `CommandKeys.swift`.
- Legacy delimiter usage (`SOH/SOM/EOM/EOH`) is not used as frame delimiters in
  v1 framing. They remain reserved opcode values.
