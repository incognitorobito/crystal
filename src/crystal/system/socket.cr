require "c/arpa/inet"
require "c/netdb"
require "c/netinet/in"
require "c/netinet/tcp"
require "c/sys/socket"

module Crystal::System::Socket


end


{% if flag?(:unix) %}
  require "c/sys/un"
  require "io/evented"
{% elsif flag?(:win32) %}
  require "c/sys/winsock2"
{% else %}
  {% raise "No Crystal::System implementation available" %}
{% end %}
