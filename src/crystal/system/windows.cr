# :nodoc:
module Crystal::System
  def self.retry_wstr_buffer
    buffer_size = 256
    buffer_arr = uninitialized LibC::WCHAR[256]

    buffer_size = yield buffer_arr.to_slice, true
    buffer = Slice(LibC::WCHAR).new(buffer_size)

    yield buffer, false
    raise "BUG: retry_wstr_buffer returned"
  end

  def self.make_word(b_low : UInt8, b_high : UInt8)
    return (b_low & 0xFF | (b_high & 0xFF << 8))
  end
end
