# Habla v1 Operation Profiles

This file defines payload schemas for common operations. All integer fields are
little-endian.

## Common Conventions

- Pin index is logical pin number in the target profile.
- Boolean is one byte (`0x00` false, non-zero true).
- Strings are UTF-8 unless otherwise specified.

## 1) System and Session

### ECHO (`0x80`)

- Request payload: opaque bytes.
- Response payload: same bytes.

### TEST (`0x81`)

- Request payload: optional diagnostics selector.
- Response payload:
  - byte0 status (`0x00` OK),
  - byte1..n optional diagnostic data.

### HALT (`0x82`)

- Request payload: byte0 reason.
- Response payload: byte0 status.

## 2) GPIO and Analog

### PinMode (`0x10`)

- Payload:
  - byte0 pin
  - byte1 mode (`0=input`, `1=inputPullup`, `2=inputPulldown`, `3=output`)
  - byte2 drive (`0=default`, `1=2mA`, `2=4mA`, `3=8mA`, `4=12mA`)
- Response behavior:
  - Success: none (fire-and-forget)
  - Error: `NACK` with error code

### DigitalWrite (`0x12`)

- Payload:
  - byte0 pin
  - byte1 value
- Response behavior:
  - Success: none (fire-and-forget)
  - Error: `NACK` with error code

### DigitalRead (`0x11`)

- Request payload:
  - byte0 pin
- Response payload:
  - byte0 status
  - byte1 value

### AnalogWrite (`0x14`)

- Payload:
  - byte0 pin
  - byte1..byte2 value (0..maxWriteResolution)

### AnalogRead (`0x13`)

- Request payload:
  - byte0 pin
- Response payload:
  - byte0 status
  - byte1..byte2 value

### AnalogResolution (`0x15`)

- Payload:
  - byte0 readResolutionBits
  - byte1 writeResolutionBits

### AnalogReference (`0x16`)

- Payload:
  - byte0 reference selector (profile-defined)

## 3) Accessory and UI

Use `Accessory` (`0x22`) + `AccessoryKey`.

### builtInLED (`0x1F`)

- Payload:
  - byte0 value
- Response behavior:
  - Success: none (fire-and-forget)
  - Error: `NACK` with error code

### setCursor (`0x21`)

- Payload:
  - byte0 column
  - byte1 row

### backlight (`0x22`)

- Payload:
  - byte0 value

### printLCD (`0x23`)

- Payload:
  - byte0..n text UTF-8 (recommended <= 64 bytes)

## 4) DeviceCMD Bus Passthrough (`0xA3`)

Use `AccessoryKey` to select bus.

### I2C Write (i2c0/i2c1)

- Payload:
  - byte0 op (`0x01` write, `0x02` read, `0x03` writeRead)
  - byte1 addr7
  - byte2 wlen
  - byte3.. write bytes
  - next byte rlen (for read/writeRead)
- Response:
  - byte0 status
  - byte1 rlen actual
  - byte2.. read bytes

### SPI Transfer (spi0/spi1)

- Payload:
  - byte0 mode (0..3)
  - byte1 csBehavior (`0=manual`, `1=assert-per-transfer`)
  - byte2 freqDiv profile-defined
  - byte3 len
  - byte4.. tx bytes
- Response:
  - byte0 status
  - byte1 len
  - byte2.. rx bytes

### UART Transfer (uart0/uart1)

- Payload:
  - byte0 op (`0x01` config, `0x02` write, `0x03` read)
  - config sub-payload for `config`:
    - u32 baud
    - byte parity (`0 none`, `1 even`, `2 odd`)
    - byte stopBits (`1` or `2`)
  - write sub-payload for `write`:
    - byte len + bytes
  - read sub-payload for `read`:
    - byte lenRequested
- Response:
  - byte0 status
  - byte1 len
  - byte2.. bytes

## 5) Eventing

Event frame (`MessageType=0x02`) examples:

- Pin change event:
  - `CommandKey=DigitalRead`, payload: pin, value, timestamp32.
- Bus RX event:
  - `CommandKey=DeviceCMD`, accessory is bus key, payload contains bytes.

Host subscribes/unsubscribes via `EVENT_SUBSCRIPTION` flag and command-specific
payload selectors.

## 6) Capability Discovery (Required for Interop)

`CommandKey=TEST` with payload selector `0x01` returns capability block:

- byte0 status
- byte1 protocol major
- byte2 protocol minor
- byte3 maxPayloadLow
- byte4 maxPayloadHigh
- byte5 featureFlags0 (GPIO/ADC/PWM/I2C/SPI/UART)
- byte6 featureFlags1 (LCD/events/security)
- byte7 pinCount
- byte8..n optional vendor/model/firmware string
