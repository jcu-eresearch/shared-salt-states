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
    - makedirs: True
    - template: jinja
    - require:
      - pkg: certbot

# Certbot recommends picking 2 random minutes each hour to run
certbot cron:
  cron.present:
    - name: certbot renew
    - identifier: SALT_CERTBOT_RENEW
    - user: root
    - minute: {{ salt['pillar.get']('certbot:renewal_minutes', (22, 52))|join(',') }}
    - require:
      - pkg: certbot
