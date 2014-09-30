yum-cron:
   pkg:
     installed
   service.running:
      - enable: True
      - reload: True
      - watch:
          - pkg: yum-cron
