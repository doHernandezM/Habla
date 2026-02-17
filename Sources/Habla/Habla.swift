import HablaC

/// Thin Swift wrappers around the C Habla frame codec.
public enum HablaCodec {
  @inline(__always)
  /// Returns total encoded frame size for a payload length.
  public static func encodedSize(payloadLength: UInt16) -> Int {
    Int(habla_encoded_size(payloadLength))
  }

  @inline(__always)
  /// Builds a protocol header using current Habla version constants.
  public static func makeHeader(
    flags: UInt8 = 0,
    messageType: UInt8 = 0x00,
    sequence: UInt8 = 0,
    partIndex: UInt8 = 0,
    partCount: UInt8 = 1,
    commandKey: UInt8,
    accessoryKey: UInt8 = 0
  ) -> habla_header_t {
    habla_header_t(
      version_major: UInt8(HABLA_VERSION_MAJOR),
      version_minor: UInt8(HABLA_VERSION_MINOR),
      flags: flags,
      message_type: messageType,
      sequence: sequence,
      part_index: partIndex,
      part_count: partCount,
      command_key: commandKey,
      accessory_key: accessoryKey
    )
  }

  @inline(__always)
  /// Encodes a full Habla frame into `output`, returning C status codes.
  public static func encode(
    header: inout habla_header_t,
    payload: UnsafePointer<UInt8>?,
    payloadCount: Int,
    output: UnsafeMutablePointer<UInt8>?,
    outputCapacity: Int,
    written: inout Int
  ) -> Int32 {
    if payloadCount < 0 || payloadCount > Int(UInt16.max) {
      written = 0
      return Int32(HABLA_STATUS_INVALID_LENGTH.rawValue)
    }

    var localWritten: Int = 0
    let status = habla_encode_frame(
      output,
      outputCapacity,
      &header,
      payload,
      UInt16(payloadCount),
      &localWritten
    )
    written = localWritten
    return Int32(status.rawValue)
  }

  @inline(__always)
  /// Decodes one complete Habla frame from contiguous frame bytes.
  public static func decode(
    frame: UnsafePointer<UInt8>?,
    frameLength: Int,
    outFrame: inout habla_frame_t
  ) -> Int32 {
    Int32(habla_decode_frame(frame, frameLength, &outFrame).rawValue)
  }
}

/// Incremental Habla parser suitable for streaming serial input.
public struct HablaParser {
  private var parser: habla_parser_t

  @inline(__always)
  /// Creates a parser with caller-provided backing storage.
  public init(storage: UnsafeMutableBufferPointer<UInt8>) {
    parser = habla_parser_t(buffer: nil, capacity: 0, length: 0)
    habla_parser_init(&parser, storage.baseAddress, storage.count)
  }

  @inline(__always)
  /// Resets parser state and discards any buffered partial frame.
  public mutating func reset() {
    habla_parser_reset(&parser)
  }

  @inline(__always)
  /// Pushes one byte and reports parser/frame-ready status codes.
  public mutating func push(
    _ byte: UInt8,
    outFrame: inout habla_frame_t,
    outFrameLength: inout Int
  ) -> Int32 {
    var localLength: Int = 0
    let status = habla_parser_push(&parser, byte, &outFrame, &localLength)
    outFrameLength = localLength
    return Int32(status.rawValue)
  }

  @inline(__always)
  /// Consumes bytes that were used by the last reported frame.
  public mutating func consume(frameLength: Int) {
    habla_parser_consume(&parser, frameLength)
  }
}
