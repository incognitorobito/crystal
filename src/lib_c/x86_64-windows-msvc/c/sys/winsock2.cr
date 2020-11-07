require "c/winnt"

@[Link("Ws2_32")]
lib LibC
  # WinSock Error Codes https://docs.microsoft.com/en-us/windows/win32/winsock/windows-sockets-error-codes-2
  WSA_IO_PENDING = 997
  WSAECONNREFUSED = 10061
  WSAEADDRINUSE = 10048

  type WINSOCK = UInt64

  struct WSAData
    wVersion : WORD
    wHighVersion : WORD
  end

  fun WSAStartup(
    wVersionRequired : WORD,
    lpWSAData : WSAData*
  ) : Int32

  fun WSAGetLastError() : Int32

  fun WSACleanup() : Int32

end