#if canImport(Darwin)
import Foundation
#endif

/// Localizable label descriptor with key and English fallback.
public struct HablaPrettyLabel: Sendable, Hashable {
  public let localizationKey: String
  public let fallback: String

  public init(localizationKey: String, fallback: String) {
    self.localizationKey = localizationKey
    self.fallback = fallback
  }
}

/// Semantic palette tokens for rendering command and accessory badges.
public enum HablaPrettyColor: String, CaseIterable, Codable, Sendable {
  case cyan
  case blue
  case purple
  case brown
  case pink
  case green
  case red
  case orange
  case mint
  case yellow
  case teal
  case indigo
  case gray
}

/// Lookup catalog that maps Habla protocol enums to localized display metadata.
public enum HablaPrettyCatalog {
  /// Returns a localized descriptor for a `CommandKey`.
  public static func commandDescriptor(for command: CommandKey) -> HablaPrettyLabel {
    switch command {
    case .null: return .init(localizationKey: "habla.command.null", fallback: "Null")
    case .pinMode: return .init(localizationKey: "habla.command.pin_mode", fallback: "Pin Mode")
    case .digitalRead: return .init(localizationKey: "habla.command.digital_read", fallback: "Digital Read")
    case .digitalWrite: return .init(localizationKey: "habla.command.digital_write", fallback: "Digital Write")
    case .analogRead: return .init(localizationKey: "habla.command.analog_read", fallback: "Analog Read")
    case .analogWrite: return .init(localizationKey: "habla.command.analog_write", fallback: "Analog Write")
    case .analogResolution: return .init(localizationKey: "habla.command.analog_resolution", fallback: "Analog Resolution")
    case .analogReference: return .init(localizationKey: "habla.command.analog_reference", fallback: "Analog Reference")
    case .activate: return .init(localizationKey: "habla.command.activate", fallback: "Activate")
    case .deactivate: return .init(localizationKey: "habla.command.deactivate", fallback: "Deactivate")
    case .accessory: return .init(localizationKey: "habla.command.accessory", fallback: "Accessory")
    case .activateLCD: return .init(localizationKey: "habla.command.activate_lcd", fallback: "Activate LCD")
    case .setCursor: return .init(localizationKey: "habla.command.set_cursor", fallback: "Set Cursor")
    case .backlight: return .init(localizationKey: "habla.command.backlight", fallback: "Backlight")
    case .printLCD: return .init(localizationKey: "habla.command.print_lcd", fallback: "Print LCD")
    case .commandDeclaration: return .init(localizationKey: "habla.command.command_declaration", fallback: "Command Declaration")
    case .commentDeclaration: return .init(localizationKey: "habla.command.comment_declaration", fallback: "Comment Declaration")
    case .operatorDeclaration: return .init(localizationKey: "habla.command.operator_declaration", fallback: "Operator Declaration")
    case .variableDeclaration: return .init(localizationKey: "habla.command.variable_declaration", fallback: "Variable Declaration")
    case .functionDeclaration: return .init(localizationKey: "habla.command.function_declaration", fallback: "Function Declaration")
    case .letDeclaration: return .init(localizationKey: "habla.command.let_declaration", fallback: "Let Declaration")
    case .varDeclaration: return .init(localizationKey: "habla.command.var_declaration", fallback: "Var Declaration")
    case .space: return .init(localizationKey: "habla.command.space", fallback: "Space")
    case .string: return .init(localizationKey: "habla.command.string", fallback: "String")
    case .int: return .init(localizationKey: "habla.command.int", fallback: "Int")
    case .double: return .init(localizationKey: "habla.command.double", fallback: "Double")
    case .float: return .init(localizationKey: "habla.command.float", fallback: "Float")
    case .bool: return .init(localizationKey: "habla.command.bool", fallback: "Bool")
    case .timeInterval: return .init(localizationKey: "habla.command.time_interval", fallback: "Time Interval")
    case .delay: return .init(localizationKey: "habla.command.delay", fallback: "Delay")
    case .loop: return .init(localizationKey: "habla.command.loop", fallback: "Loop")
    case .variable: return .init(localizationKey: "habla.command.variable", fallback: "Variable")
    case .add: return .init(localizationKey: "habla.command.add", fallback: "Add")
    case .subtract: return .init(localizationKey: "habla.command.subtract", fallback: "Subtract")
    case .multiply: return .init(localizationKey: "habla.command.multiply", fallback: "Multiply")
    case .divide: return .init(localizationKey: "habla.command.divide", fallback: "Divide")
    case .modulo: return .init(localizationKey: "habla.command.modulo", fallback: "Modulo")
    case .increment: return .init(localizationKey: "habla.command.increment", fallback: "Increment")
    case .decrement: return .init(localizationKey: "habla.command.decrement", fallback: "Decrement")
    case .negate: return .init(localizationKey: "habla.command.negate", fallback: "Negate")
    case .leftShift: return .init(localizationKey: "habla.command.left_shift", fallback: "Left Shift")
    case .rightShift: return .init(localizationKey: "habla.command.right_shift", fallback: "Right Shift")
    case .bitwiseAND: return .init(localizationKey: "habla.command.bitwise_and", fallback: "Bitwise AND")
    case .bitwiseOR: return .init(localizationKey: "habla.command.bitwise_or", fallback: "Bitwise OR")
    case .bitwiseXOR: return .init(localizationKey: "habla.command.bitwise_xor", fallback: "Bitwise XOR")
    case .square: return .init(localizationKey: "habla.command.square", fallback: "Square")
    case .squareRoot: return .init(localizationKey: "habla.command.square_root", fallback: "Square Root")
    case .absoluteValue: return .init(localizationKey: "habla.command.absolute_value", fallback: "Absolute Value")
    case .power: return .init(localizationKey: "habla.command.power", fallback: "Power")
    case .logarithm: return .init(localizationKey: "habla.command.logarithm", fallback: "Logarithm")
    case .sin: return .init(localizationKey: "habla.command.sin", fallback: "Sin")
    case .cos: return .init(localizationKey: "habla.command.cos", fallback: "Cos")
    case .tan: return .init(localizationKey: "habla.command.tan", fallback: "Tan")
    case .logicalAnd: return .init(localizationKey: "habla.command.logical_and", fallback: "Logical And")
    case .logicalOr: return .init(localizationKey: "habla.command.logical_or", fallback: "Logical Or")
    case .lessThan: return .init(localizationKey: "habla.command.less_than", fallback: "Less Than")
    case .greaterThan: return .init(localizationKey: "habla.command.greater_than", fallback: "Greater Than")
    case .equals: return .init(localizationKey: "habla.command.equals", fallback: "Equals")
    case .echo: return .init(localizationKey: "habla.command.echo", fallback: "Echo")
    case .test: return .init(localizationKey: "habla.command.test", fallback: "Test")
    case .halt: return .init(localizationKey: "habla.command.halt", fallback: "Halt")
    case .interrupt: return .init(localizationKey: "habla.command.interrupt", fallback: "Interrupt")
    case .ping: return .init(localizationKey: "habla.command.ping", fallback: "Ping")
    case .leftBracket: return .init(localizationKey: "habla.command.left_bracket", fallback: "Left Bracket")
    case .rightBracket: return .init(localizationKey: "habla.command.right_bracket", fallback: "Right Bracket")
    case .userCustom: return .init(localizationKey: "habla.command.user_custom", fallback: "User Custom")
    case .unassigned: return .init(localizationKey: "habla.command.unassigned", fallback: "Unassigned")
    case .print: return .init(localizationKey: "habla.command.print", fallback: "Print")
    case .device: return .init(localizationKey: "habla.command.device", fallback: "Device")
    case .ui: return .init(localizationKey: "habla.command.ui", fallback: "UI")
    case .user: return .init(localizationKey: "habla.command.user", fallback: "User")
    case .error: return .init(localizationKey: "habla.command.error", fallback: "Error")
    }
  }

  /// Returns a localized descriptor for an `AccessoryKey`.
  public static func accessoryDescriptor(for accessory: AccessoryKey) -> HablaPrettyLabel {
    switch accessory {
    case .digitalPin: return .init(localizationKey: "habla.accessory.digital_pin", fallback: "Digital Pin")
    case .analogPin: return .init(localizationKey: "habla.accessory.analog_pin", fallback: "Analog Pin")
    case .printSerial: return .init(localizationKey: "habla.accessory.print_serial", fallback: "Print Serial")
    case .printNRF24: return .init(localizationKey: "habla.accessory.print_nrf24", fallback: "Print NRF24")
    case .builtInLED: return .init(localizationKey: "habla.accessory.built_in_led", fallback: "Built-in LED")
    case .lcdSetCursor: return .init(localizationKey: "habla.accessory.lcd_set_cursor", fallback: "LCD Set Cursor")
    case .lcdBacklight: return .init(localizationKey: "habla.accessory.lcd_backlight", fallback: "LCD Backlight")
    case .lcdPrint: return .init(localizationKey: "habla.accessory.lcd_print", fallback: "LCD Print")
    case .error: return .init(localizationKey: "habla.accessory.error", fallback: "Error")
    }
  }

  /// Returns a localized descriptor for a frame `MessageType`.
  public static func messageTypeDescriptor(for messageType: MessageType) -> HablaPrettyLabel {
    switch messageType {
    case .request: return .init(localizationKey: "habla.message.request", fallback: "Request")
    case .response: return .init(localizationKey: "habla.message.response", fallback: "Response")
    case .event: return .init(localizationKey: "habla.message.event", fallback: "Event")
    case .ack: return .init(localizationKey: "habla.message.ack", fallback: "Ack")
    case .nack: return .init(localizationKey: "habla.message.nack", fallback: "Nack")
    }
  }

  /// User-facing command/accessory label for known command values.
  public static func displayName(for command: CommandKey, accessory: AccessoryKey? = nil) -> String {
    if command == .accessory, let accessory {
      return accessoryName(for: accessory)
    }
    return commandName(for: command)
  }

  /// User-facing command/accessory label from raw protocol bytes.
  public static func displayName(for rawCommandKey: UInt8, rawAccessoryKey: UInt8? = nil) -> String {
    guard let command = CommandKey(rawValue: rawCommandKey) else {
      return "Unknown Command (0x\(hexByte(rawCommandKey)))"
    }

    let accessory = rawAccessoryKey.flatMap(AccessoryKey.init(rawValue:))
    return displayName(for: command, accessory: accessory)
  }

  /// Semantic color token for a command and optional accessory.
  public static func color(for command: CommandKey, accessory: AccessoryKey? = nil) -> HablaPrettyColor {
    switch command {
    case .accessory:
      return accessoryColor(for: accessory)

    case .commandDeclaration,
         .commentDeclaration,
         .operatorDeclaration,
         .variableDeclaration,
         .functionDeclaration,
         .letDeclaration,
         .varDeclaration,
         .space,
         .delay,
         .loop:
      return .purple

    case .string:
      return .green
    case .int:
      return .red
    case .double, .float:
      return .orange
    case .bool:
      return .mint
    case .timeInterval:
      return .yellow

    case .add,
         .subtract,
         .multiply,
         .divide,
         .modulo,
         .increment,
         .decrement,
         .negate,
         .leftShift,
         .rightShift,
         .bitwiseAND,
         .bitwiseOR,
         .bitwiseXOR,
         .square,
         .squareRoot,
         .absoluteValue,
         .power,
         .logarithm,
         .sin,
         .cos,
         .tan:
      return .brown

    case .logicalAnd, .logicalOr, .lessThan, .greaterThan, .equals:
      return .teal

    case .print:
      return .cyan
    case .device:
      return .indigo

    default:
      return .teal
    }
  }

  /// Semantic color token for raw command/accessory byte values.
  public static func color(for rawCommandKey: UInt8, rawAccessoryKey: UInt8? = nil) -> HablaPrettyColor {
    guard let command = CommandKey(rawValue: rawCommandKey) else {
      return .gray
    }

    let accessory = rawAccessoryKey.flatMap(AccessoryKey.init(rawValue:))
    return color(for: command, accessory: accessory)
  }

  public static func commandName(for command: CommandKey) -> String {
    localized(commandDescriptor(for: command))
  }

  public static func commandName(for rawCommandKey: UInt8) -> String {
    guard let command = CommandKey(rawValue: rawCommandKey) else {
      return "Unknown Command (0x\(hexByte(rawCommandKey)))"
    }
    return commandName(for: command)
  }

  public static func accessoryName(for accessory: AccessoryKey) -> String {
    localized(accessoryDescriptor(for: accessory))
  }

  public static func accessoryName(for rawAccessoryKey: UInt8) -> String {
    guard let accessory = AccessoryKey(rawValue: rawAccessoryKey) else {
      return "Unknown Accessory (0x\(hexByte(rawAccessoryKey)))"
    }
    return accessoryName(for: accessory)
  }

  public static func messageTypeName(for messageType: MessageType) -> String {
    localized(messageTypeDescriptor(for: messageType))
  }

  public static func messageTypeName(for rawMessageType: UInt8) -> String {
    guard let messageType = MessageType(rawValue: rawMessageType) else {
      return "Unknown Message Type (0x\(hexByte(rawMessageType)))"
    }
    return messageTypeName(for: messageType)
  }

  private static func localized(_ label: HablaPrettyLabel) -> String {
#if canImport(Darwin) && canImport(Foundation)
    Bundle.module.localizedString(forKey: label.localizationKey, value: label.fallback, table: "Localizable")
#else
    label.fallback
#endif
  }

  private static func hexByte(_ value: UInt8) -> String {
    let rendered = String(value, radix: 16, uppercase: true)
    if rendered.count == 1 {
      return "0\(rendered)"
    }
    return rendered
  }

  private static func accessoryColor(for accessory: AccessoryKey?) -> HablaPrettyColor {
    switch accessory {
    case .analogPin, .digitalPin:
      return .pink
    case .builtInLED:
      return .blue
    case .printSerial, .printNRF24, .lcdSetCursor, .lcdBacklight, .lcdPrint, .none, .error:
      return .cyan
    }
  }
}
