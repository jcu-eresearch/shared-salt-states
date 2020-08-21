autoupdate-rpms:
  pkg.installed:
    {% if grains['osmajorrelease']|int >= 8 %}
    - name: dnf-automatic
    {% elif grains['osmajorrelease']|int <= 7 %}
    - name: yum-cron
    {% endif %}
  service.running:
    {% if grains['osmajorrelease']|int >= 8 %}
    - name: dnf-automatic.timer
    {% elif grains['osmajorrelease']|int <= 7 %}
    - name: yum-cron
    {% endif %}
    - enable: True
    - reload: True
    - watch:
      - pkg: autoupdate-rpms
