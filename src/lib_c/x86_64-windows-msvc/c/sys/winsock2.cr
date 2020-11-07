require "c/winnt"

@[Link("Ws2_32")]
lib LibC

  WINSOCK_VERSION = 0x20000002
  WSA_IO_PENDING = 997;

  type WINSOCK = UInt64

  struct WSAData
    wVersion : WORD
    wHighVersion : WORD
  end

  fun WSAStartup(
    wVersionRequired : WORD,
    lpWSAData : WSAData*
  ) : Int32

end