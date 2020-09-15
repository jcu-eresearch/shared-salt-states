{% set os_seven_and_below = grains['osmajorrelease']|int <= 7 %}
{% if os_seven_and_below %}
ntpdate:
  pkg.installed
{% endif %}

ntp:
  pkg.installed:
  {% if os_seven_and_below %}
    - require:
      - pkg: ntpdate
  {% else %}
    - name: chrony
    - allow_updates: True
  {% endif %}
  service.running:
    - enable: True
    - reload: True
    {% if os_seven_and_below %}
    - name: ntpd
    - watch:
      - pkg: ntp
    {% else %}
    - name: chronyd
    - watch:
      - pkg: chrony
    {% endif %}
