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
      - service: nginx
    - require_in:
      - cron: certbot cron
