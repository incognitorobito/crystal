module Crystal::System::Socket
  # Load MIME types from operating system source.
  # def self.load
end

{% if flag?(:unix) %}
  require "c/arpa/inet"
  require "c/netdb"
  require "c/netinet/in"
  require "c/netinet/tcp"
  require "c/sys/socket"
  require "c/sys/un"
  require "io/evented"
{% elsif flag?(:win32) %}
  {% raise "No win32 socket implementation available" %}
{% else %}
  {% raise "No Crystal::System implementation available" %}
{% end %}
