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

  fun WSAGetLastError() : Int

  fun WSACleanup() : Int

  fun closesocket(WINSOCK) : Int

end