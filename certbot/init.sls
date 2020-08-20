# RHEL 7+ is packaged; anything less isn't
{% set is_packaged = grains['os_family'] == 'RedHat' and grains['osmajorrelease']|int >= 7 %}
{% set certbot_cmd = '/usr/bin/certbot' if is_packaged else '/usr/local/bin/certbot' %}

include:
  - jcu.repositories.epel

{% if is_packaged %}
certbot:
  pkg.installed:
    - require:
      - pkg: epel
{% else %}
certbot:
  file.managed:
    - name: /usr/local/bin/certbot
    - source: https://raw.githubusercontent.com/certbot/certbot/v1.7.0/certbot-auto
    - source_hash: sha256=ec0a39db4d0a6b68ae2bb903422b7a29deb41470ab3ebba69e7a4a703c18a7e5
    - user: root
    - group: root
    - mode: 755
    - require:
      - pkg: epel
{% endif %}

certbot configuration:
  file.managed:
    - name: /etc/letsencrypt/cli.ini
    - source: salt://jcu/certbot/cli.ini
    - makedirs: True
    - template: jinja
    - require:
      {% if is_packaged %}
      - pkg: certbot
      {% else %}
      - file: certbot
      {% endif %}

# Certbot recommends running twice a day at a random minute to run
certbot cron:
  cron.present:
    - name: {{ certbot_cmd }} renew --quiet --non-interactive
    - identifier: SALT_CERTBOT_RENEW
    - user: root
    - minute: {{ salt['pillar.get']('certbot:renewal_minute', 52) }}
    - hour: {{ salt['pillar.get']('certbot:renewal_hours', (4, 20))|join(',') }}
    - require:
      {% if is_packaged %}
      - pkg: certbot
      {% else %}
      - file: certbot
      {% endif %}
