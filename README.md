# Habla

`Habla` is a binary frame protocol and codec stack used by this workspace.

This repository ships:

- `HablaC`: C codec + streaming parser
- `Habla`: Swift wrapper + key enums + pretty labels
- `HablaExample`: small encode/decode example
- protocol docs (`01` to `06`)

## Frame Snapshot

- magic: `0x48 0x42` (`HB`)
- version major: `0x01`
- CRC: CRC-16/CCITT-FALSE
- transport-agnostic byte stream (UART, USB CDC, BLE UART, TCP)

Message types:

- Request (`0x00`)
- Response (`0x01`)
- Event (`0x02`)
- Ack (`0x03`)
- Nack (`0x04`)

## Swift API

- `HablaCodec`
  - `encodedSize(payloadLength:)`
  - `makeHeader(...)`
  - `encode(...)`
  - `decode(...)`
- `HablaParser`
  - `init(storage:)`
  - `push(_:outFrame:outFrameLength:)`
  - `consume(frameLength:)`
  - `reset()`
- key enums:
  - `CommandKey`
  - `AccessoryKey`
  - `MessageType`
  - `MessageFlag` (`ackRequired`)

## Quick Start (Swift)

```swift
import Habla
import HablaC

var header = HablaCodec.makeHeader(
  flags: MessageFlag.ackRequired.rawValue,
  messageType: MessageType.request.rawValue,
  sequence: 0x10,
  commandKey: CommandKey.digitalWrite.rawValue,
  accessoryKey: AccessoryKey.digitalPin.rawValue
)

let payload: [UInt8] = [25, 1]
var output = [UInt8](repeating: 0, count: 64)
var written = 0

let status = output.withUnsafeMutableBufferPointer { out in
  payload.withUnsafeBufferPointer { body in
    HablaCodec.encode(
      header: &header,
      payload: body.baseAddress,
      payloadCount: body.count,
      output: out.baseAddress,
      outputCapacity: out.count,
      written: &written
    )
  }
}

print("encode status:", status, "bytes:", written)
```

## Pretty Labels

Use `HablaPrettyCatalog` for display strings:

```swift
let label = HablaPrettyCatalog.commandName(for: CommandKey.delay)
```

- Apple platforms: resolves from `Resources/Localizable.xcstrings`.
- other platforms: falls back to embedded English labels.
- if a key is missing from the string catalog, fallback text is used.

## Ping Extension

`CommandKey.ping` (`0x84`) request payload is empty.

Current response payload:

- `status` (`0x00` for OK)
- length-prefixed UTF-8 `name`
- length-prefixed UTF-8 `version`
- `buildNumber` (`UInt32`, little-endian)
- length-prefixed UTF-8 `board`

See `03-command-keys.md` and `05-examples.md`.

## Build

Swift package:

```sh
cd /Users/cosas/Desktop/Cosas/Code/Habla
swift build
```

C library:

```sh
cd /Users/cosas/Desktop/Cosas/Code/Habla
cmake -S . -B build
cmake --build build
```

## Document Map

- `01-habla-v1-overview.md`: goals and design principles
- `02-wire-format.md`: frame structure and CRC
- `03-command-keys.md`: command/accessory registry
- `04-operation-profiles.md`: payload profile guide
- `05-examples.md`: request/response examples
- `06-conformance.md`: implementation checklist

## Naming Notes

- Project names are written as `Habla`, `Serie`, `CosaOS`, and `CosasStudio`.
- Board family name is written as `Raspberry Pi Pico`.
- Protocol symbol references use enum style, for example:
  - `CommandKey.ping`
  - `AccessoryKey.builtInLED`
  - `MessageType.response`
