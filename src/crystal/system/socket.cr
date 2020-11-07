module Crystal::System::Socket


end

{% if flag?(:unix) %}
  require "./unix/socket"
{% elsif flag?(:win32) %}
  require "./win32/socket"
{% else %}
  {% raise "No Crystal::System implementation available" %}
{% end %}
