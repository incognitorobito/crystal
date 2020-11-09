require "./types"
require "./winsock2"

lib LibC
  SOCK_DGRAM     = 2
  SOCK_RAW       = 3
  SOCK_SEQPACKET = 5
  SOCK_STREAM    = 1
  SOL_SOCKET     = 65535
  SO_BROADCAST   = 32
  SO_KEEPALIVE   = 8
  SO_LINGER      = 128
  SO_RCVBUF      = 4098
  SO_REUSEADDR   = 4
  SO_SNDBUF      = 4097
  PF_INET        = 2
  PF_INET6       = 23
  PF_UNIX        = LibC::PF_LOCAL
  PF_UNSPEC      = 0
  PF_LOCAL       = 1
  AF_INET        = LibC::PF_INET
  AF_INET6       = LibC::PF_INET6
  AF_UNIX        = LibC::PF_UNIX
  AF_UNSPEC      = LibC::PF_UNSPEC
  SHUT_RD        = 0
  SHUT_RDWR      = 2
  SHUT_WR        = 1

  alias SocklenT = Int
  alias SaFamilyT = Short

  struct Sockaddr
    sa_family : SaFamilyT
    sa_data : StaticArray(Char, 14)
  end

  struct SockaddrStorage
    ss_family : SaFamilyT
    __ss_align : ULong
    __ss_padding : StaticArray(Char, 112)
  end

  struct Linger
    l_onoff : Int
    l_linger : Int
  end

  fun accept(fd : Int, addr : Sockaddr*, addr_len : SocklenT*) : Int
  fun bind(fd : Int, addr : Sockaddr*, len : SocklenT) : Int
  fun connect(fd : Int, addr : Sockaddr*, len : SocklenT) : Int
  fun getpeername(fd : Int, addr : Sockaddr*, len : SocklenT*) : Int
  fun getsockname(fd : Int, addr : Sockaddr*, len : SocklenT*) : Int
  fun getsockopt(fd : Int, level : Int, optname : Int, optval : Void*, optlen : SocklenT*) : Int
  fun listen(fd : Int, n : Int) : Int
  fun recv(fd : Int, buf : Void*, n : Int, flags : Int) : SizeT
  fun recvfrom(fd : Int, buf : Void*, n : Int, flags : Int, addr : Sockaddr*, addr_len : SocklenT*) : SizeT
  fun send(fd : Int, buf : Void*, n : Int, flags : Int) : SizeT
  fun sendto(fd : Int, buf : Void*, n : Int, flags : Int, addr : Sockaddr*, addr_len : SocklenT) : SizeT
  fun setsockopt(fd : Int, level : Int, optname : Int, optval :  Void*, optlen : SocklenT) : Int
  fun shutdown(fd : Int, how : Int) : Int
  fun socket(domain : Int, type : Int, protocol : Int) : Int
  fun socketpair(domain : Int, type : Int, protocol : Int, fds : StaticArray(Int, 2)) : Int
end
