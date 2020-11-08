require "c/winnt"

@[Link("Ws2_32")]
lib LibC
  type WINSOCK = UInt64

  struct WSAData
    wVersion : WORD
    wHighVersion : WORD
  end

  fun WSAStartup(
    wVersionRequired : WORD,
    lpWSAData : WSAData*
  ) : Int

  fun WSAGetLastError() : UInt32

  fun WSACleanup() : UInt32

  fun closesocket(WINSOCK) : UInt32

end