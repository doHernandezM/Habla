import Foundation

public enum CommandKey: UInt8, CaseIterable, Codable, Sendable {
  // System / framing adjacents
  case null = 0x00

  // Data movement
  case pinMode = 0x10
  case digitalRead = 0x11
  case digitalWrite = 0x12
  case analogRead = 0x13
  case analogWrite = 0x14
  case analogResolution = 0x15
  case analogReference = 0x16

  // Accessory / control surface
  case activate = 0x20
  case deactivate = 0x21
  case accessory = 0x22
  case activateLCD = 0x23
  case setCursor = 0x24
  case backlight = 0x25
  case printLCD = 0x26

  // Declarations
  case commandDeclaration = 0x30
  case commentDeclaration = 0x31
  case operatorDeclaration = 0x32
  case variableDeclaration = 0x33
  case functionDeclaration = 0x34
  case letDeclaration = 0x35
  case varDeclaration = 0x36
  case space = 0x37

  // Value / type commands
  case string = 0x40
  case int = 0x41
  case double = 0x42
  case float = 0x43
  case bool = 0x44
  case timeInterval = 0x45
  case delay = 0x46
  case loop = 0x47
  case variable = 0x48

  // Arithmetic
  case add = 0x50
  case subtract = 0x51
  case multiply = 0x52
  case divide = 0x53
  case modulo = 0x54
  case increment = 0x55
  case decrement = 0x56
  case negate = 0x57
  case leftShift = 0x58
  case rightShift = 0x59
  case bitwiseAND = 0x5A
  case bitwiseOR = 0x5B
  case bitwiseXOR = 0x5C
  case square = 0x5D
  case squareRoot = 0x5E
  case absoluteValue = 0x5F
  case power = 0x60
  case logarithm = 0x61
  case sin = 0x62
  case cos = 0x63
  case tan = 0x64

  // Logical/comparison
  case logicalAnd = 0x65
  case logicalOr = 0x66
  case lessThan = 0x70
  case greaterThan = 0x71
  case equals = 0x72

  // Runtime control
  case echo = 0x80
  case test = 0x81
  case halt = 0x82
  case interrupt = 0x83
  case ping = 0x84

  // Delimiters and custom/user buckets
  case leftBracket = 0x90
  case rightBracket = 0x91
  case userCustom = 0xA0
  case unassigned = 0xA1
  case print = 0xA2
  case device = 0xA3
  case ui = 0xA4
  case user = 0xA5

  case error = 0xFF
}

public enum AccessoryKey: UInt8, CaseIterable, Codable, Sendable {
  case digitalPin = 0x01
  case analogPin = 0x02

  case printSerial = 0x10
  case printNRF24 = 0x11

  case builtInLED = 0x1F

  case lcdSetCursor = 0x21
  case lcdBacklight = 0x22
  case lcdPrint = 0x23

  case error = 0xFF
}

public enum MessageFlag: UInt8, Sendable {
  case ackRequired = 0x01
}

public enum MessageType: UInt8, CaseIterable, Codable, Sendable {
  case request = 0x00
  case response = 0x01
  case event = 0x02
  case ack = 0x03
  case nack = 0x04
}
