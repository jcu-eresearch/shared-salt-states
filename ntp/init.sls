ntpdate:
  pkg.installed

ntp:
  pkg.installed:
    - require:
      - pkg: ntpdate
  service.running:
    - name: ntpd
    - enable: True
    - reload: True
    - require:
      - pkg: ntp
    - watch:
      - pkg: ntp
