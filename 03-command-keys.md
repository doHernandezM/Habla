# Habla v1 Command Registry

This registry is based on `Sources/Habla/CommandKeys.swift`.

## System (0x00-0x0F)

- `0x00` null

## Data Movement (0x10-0x1F)

- `0x10` PinMode
- `0x11` DigitalRead
- `0x12` DigitalWrite
- `0x13` AnalogRead
- `0x14` AnalogWrite
- `0x15` AnalogResolution
- `0x16` AnalogReference

## Control/Accessory (0x20-0x2F)

- `0x20` Activate
- `0x21` Deactivate
- `0x22` Accessory
- `0x23` ActivateLCD
- `0x24` SetCursor
- `0x25` Backlight
- `0x26` PrintLCD

## Declarations (0x30-0x3F)

- `0x30` commandDeclaration
- `0x31` commentDeclaration
- `0x32` operatorDeclaration
- `0x33` variableDeclaration
- `0x34` functionDeclaration
- `0x35` letDeclaration
- `0x36` varDeclaration
- `0x37` space

## Data Types and Flow (0x40-0x4F)

- `0x40` string
- `0x41` int
- `0x42` double
- `0x43` float
- `0x44` bool
- `0x45` TimeInterval
- `0x46` Delay
- `0x47` Loop
- `0x48` Variable

## Arithmetic (0x50-0x64)

- `0x50` add
- `0x51` subtract
- `0x52` multiply
- `0x53` divide
- `0x54` modulo
- `0x55` increment
- `0x56` decrement
- `0x57` negate
- `0x58` leftShift
- `0x59` rightShift
- `0x5A` bitwiseAND
- `0x5B` bitwiseOR
- `0x5C` bitwiseXOR
- `0x5D` square
- `0x5E` squareRoot
- `0x5F` absoluteValue
- `0x60` power
- `0x61` logarithm
- `0x62` sin
- `0x63` cos
- `0x64` tan

## Logical (0x65-0x6F)

- `0x65` logicalAnd
- `0x66` logicalOr

## Comparison (0x70-0x7F)

- `0x70` lessThan
- `0x71` greaterThan
- `0x72` equals

## Control Commands (0x80-0x8F)

- `0x80` echo
- `0x81` test
- `0x82` halt
- `0x83` interrupt
- `0x84` ping

### Ping (`0x84`) Response Payload (v1 extension)

When a device receives a `PING` request, it returns a `Response` with command key `0x84`
and payload:

- byte0: status (`0x00` = OK)
- byte1: `nameLen`
- bytes: UTF-8 `name`
- next byte: `versionLen`
- bytes: UTF-8 `version`
- next 4 bytes: `buildNumber` (uint32 little-endian)
- next byte: `boardLen`
- bytes: UTF-8 `board`

## Brackets (0x90-0x9F)

- `0x90` leftBracket
- `0x91` rightBracket

## Custom/User (0xA0-0xAF)

- `0xA0` userCustom
- `0xA1` unassigned
- `0xA2` print
- `0xA3` device
- `0xA4` ui
- `0xA5` user

## Error Code

- `0xFF` error

## AccessoryKey Registry

### Current Base

- `0x01` digitalPin
- `0x02` analogPin
- `0x10` printSerial
- `0x11` printNRF24
- `0x1F` builtInLED
- `0x21` lcdSetCursor
- `0x22` lcdBacklight
- `0x23` lcdPrint
- `0xFF` error

### Habla v1 Extensions

Reserved extension classes for `CommandKey.device` (`0xA3`) bus passthrough:

- `0x30` i2c0
- `0x31` i2c1
- `0x40` spi0
- `0x41` spi1
- `0x50` uart0
- `0x51` uart1
- `0x60` gpioBank
- `0x61` pwmBank
- `0x70` adcBank

Unknown extension keys must return `UNSUPPORTED_ACCESSORY`.

Note:

- these extension keys are profile-level conventions used with `CommandKey.device` (`0xA3`)
- they are not currently modeled in the Swift `AccessoryKey` enum
