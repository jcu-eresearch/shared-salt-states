yum-cron:
  pkg.installed: []
  service.running:
    - enable: True
    - reload: True
    - onchanges:
      - pkg: yum-cron
