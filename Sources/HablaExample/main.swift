import Habla
import HablaC

let payload: [UInt8] = [25, 1]
var out = [UInt8](repeating: 0, count: 64)

var header = HablaCodec.makeHeader(
  flags: 0x01,
  messageType: 0x00,
  sequence: 0x10,
  partIndex: 0,
  partCount: 1,
  commandKey: 0x12,   // DigitalWrite
  accessoryKey: 0x01  // digitalPin
)

var written = 0
let encodeStatus: Int32 = out.withUnsafeMutableBufferPointer { outBuffer in
  payload.withUnsafeBufferPointer { payloadBuffer in
    HablaCodec.encode(
      header: &header,
      payload: payloadBuffer.baseAddress,
      payloadCount: payloadBuffer.count,
      output: outBuffer.baseAddress,
      outputCapacity: outBuffer.count,
      written: &written
    )
  }
}

guard encodeStatus == 0 else {
  fatalError("encode failed: \(encodeStatus)")
}

var decoded = habla_frame_t(
  header: header,
  payload: nil,
  payload_length: 0,
  crc16: 0
)
let decodeStatus: Int32 = out.withUnsafeBufferPointer { inBuffer in
  HablaCodec.decode(
    frame: inBuffer.baseAddress,
    frameLength: written,
    outFrame: &decoded
  )
}

guard decodeStatus == 0 else {
  fatalError("decode failed: \(decodeStatus)")
}

print("encoded bytes: \(written)")
print("decoded command: \(decoded.header.command_key)")
print("decoded payload length: \(decoded.payload_length)")
