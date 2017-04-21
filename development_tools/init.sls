{% if grains['os_family'] == 'RedHat' %}
Development Tools:
  pkg.group_installed:
  {% if grains['osmajorrelease']|int >= 7 %}
    - name: Development Tools
  {% elif grains['osmajorrelease'] == '6' %}
    - name: Development tools
  {% endif %}
{% endif %}
