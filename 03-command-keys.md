# Habla v1 Command Registry

This registry is based on `CosasStudio/Models/CommandKeys.swift`.

## System (0x00-0x0F)

- `0x00` NULLCODE
- `0x01` SOH (reserved opcode in v1)
- `0x02` SOM (reserved opcode in v1)
- `0x03` EOM (reserved opcode in v1)
- `0x04` EOH (reserved opcode in v1)
- `0x05` Command1 (reserved)
- `0x06` Command2 (reserved)
- `0x07` Command3 (reserved)
- `0x08` Command4 (reserved)
- `0x09` Command5 (reserved)

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

- `0x30` CommandDec
- `0x31` CommentDec
- `0x32` OperatorDec
- `0x33` VariableDec
- `0x34` FuncDec
- `0x35` LetDec
- `0x36` VarDec
- `0x37` Space

## Data Types and Flow (0x40-0x4F)

- `0x40` StringType
- `0x41` IntType
- `0x42` DoubleType
- `0x43` FloatType
- `0x44` BoolType
- `0x45` TimeInterval
- `0x46` Delay
- `0x47` Loop
- `0x48` Variable

## Arithmetic (0x50-0x64)

- `0x50` AddOp
- `0x51` SubtractOp
- `0x52` MultiplyOp
- `0x53` DivideOp
- `0x54` ModuloOp
- `0x55` IncrementOp
- `0x56` DecrementOp
- `0x57` NegateOp
- `0x58` LeftShiftOp
- `0x59` RightShiftOp
- `0x5A` BitwiseANDOp
- `0x5B` BitwiseOROp
- `0x5C` BitwiseXOROp
- `0x5D` SquareOp
- `0x5E` SquareRootOp
- `0x5F` AbsoluteValueOp
- `0x60` PowerOp
- `0x61` LogarithmOp
- `0x62` SinOp
- `0x63` CosOp
- `0x64` TanOp

## Logical (0x65-0x6F)

- `0x65` AndOp
- `0x66` OrOp

## Comparison (0x70-0x7F)

- `0x70` LessOp
- `0x71` GreaterOp
- `0x72` EqualsOp

## Control Commands (0x80-0x8F)

- `0x80` ECHO
- `0x81` TEST
- `0x82` HALT
- `0x83` INTERRUPT
- `0x84` PING

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

- `0x90` LeftBracket
- `0x91` RightBracket

## Custom/User (0xA0-0xAF)

- `0xA0` UserCustomCMD
- `0xA1` UnassignedCMD
- `0xA2` PrintCMD
- `0xA3` DeviceCMD
- `0xA4` UICMD
- `0xA5` UserCMD

## Error Code

- `0xFF` ERRORCODE

## AccessoryKey Registry

### Current Base

- `0x01` digitalPin
- `0x02` analogPin
- `0x10` printSerial
- `0x11` printNRF24
- `0x1F` builtInLED
- `0x21` setCursor
- `0x22` backlight
- `0x23` printLCD
- `0xFF` error

### Habla v1 Extensions

Reserved extension classes for `DeviceCMD` and bus passthrough:

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
