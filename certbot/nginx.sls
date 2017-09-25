# TODO: Adjust SELinux permissions if Certbot doesn't address
# https://github.com/certbot/certbot/issues/4716

include:
  - jcu.repositories.epel
  - jcu.nginx
  - jcu.certbot

python2-certbot-nginx:
  pkg.installed:
    - require:
      - pkg: epel
      - pkg: nginx

certbot nginx:
  cmd.run:
    - name: certbot --nginx --non-interactive
    - require:
      - pkg: python2-certbot-nginx
      - file: certbot configuration
    - require_in:
      - cron: certbot cron
    - watch_in:
      - service: nginx
