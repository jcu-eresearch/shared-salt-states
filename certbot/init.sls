include:
  - jcu.repositories.epel

certbot:
  pkg.installed:
    - require:
      - pkg: epel

certbot configuration:
  file.managed:
    - name: /etc/letsencrypt/cli.ini
    - source: salt://jcu/certbot/cli.ini
    - template: jinja
    - require:
      - pkg: certbot

certbot cron:
  cron.present:
    - name: certbot renew
    - identifier: SALT_CERTBOT_RENEW
    - user: root
    - minute: 22,52
    - require:
      - pkg: certbot
