include:
  - jcu.certbot

# Certbot requires the ability to find nginx/apachectl on PATH
certbot cron PATH:
  cron.env_present:
    - name: PATH
    - user: root
    - value: /sbin:/bin:/usr/sbin:/usr/bin
    - require_in:
      - cron: certbot cron
