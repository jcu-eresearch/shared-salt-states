# TODO: Adjust SELinux permissions if Certbot doesn't address
# https://github.com/certbot/certbot/issues/4716

# RHEL 7+ is packaged; anything less isn't
{% set is_packaged = grains['os_family'] == 'RedHat' and grains['osmajorrelease']|int >= 7 %}
{% set certbot_cmd = 'certbot' if is_packaged else '/usr/local/bin/certbot' %}

include:
  - jcu.repositories.epel
  - jcu.nginx
  - jcu.certbot
  - jcu.certbot.cron

# Only install this package on EL7+
{% if is_packaged %}
python-certbot-nginx:
  pkg.installed:
    {% if grains['osmajorrelease']|int >= 8 %}
    - name: python3-certbot-nginx
    {% elif grains['osmajorrelease']|int == 7 %}
    - name: python2-certbot-nginx
    {% endif %}
    - require:
      - pkg: epel
      - pkg: nginx
{% endif %}


certbot nginx:
  cmd.run:
    - name: {{ certbot_cmd }} --nginx --non-interactive
    - require:
      - service: nginx
      {% if is_packaged %}
      - pkg: python-certbot-nginx
      {% endif %}
      - file: certbot configuration
    - require_in:
      - cron: certbot cron
