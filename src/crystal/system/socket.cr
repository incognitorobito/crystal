require "c/arpa/inet"
require "c/netdb"
require "c/netinet/in"
require "c/netinet/tcp"
require "c/sys/socket"
require "io/evented"

module Crystal::System::Socket


end

{% if flag?(:unix) %}
  require "c/sys/un"
{% elsif flag?(:win32) %}
  require "c/sys/winsock2"
{% else %}
  {% raise "No Crystal::System implementation available" %}
{% end %}
