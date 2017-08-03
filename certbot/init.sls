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

# Certbot recommends running twice a day at a random minute to run
certbot cron:
  cron.present:
    - name: certbot renew --quiet --non-interactive
    - identifier: SALT_CERTBOT_RENEW
    - user: root
    - minute: {{ salt['pillar.get']('certbot:renewal_minute', 52) }}
    - hour: {{ salt['pillar.get']('certbot:renewal_hours', (4, 20))|join(',') }}
    - require:
      - pkg: certbot
