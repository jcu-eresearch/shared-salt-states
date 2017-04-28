include:
  - jcu.repositories.pgdg.pgdg92
  - .env_config

Install PostgreSQL92 Server Packages:
  pkg.installed:
    - pkgs:
      - postgresql92-devel
      - postgresql92-server
    - require:
      - pkg: pgdg-92
      - cmd: Setup PostgreSQL92 Environment
      - cmd: pgdg-92 yum update -y

PostgreSQL92 Init DB:
  cmd.wait:
# postgres init for RedHat and CentOS 7.1+ uses a special executable
{% if grains['os_family'] == 'RedHat' and grains['osrelease_info'][0] == 7 and grains['osrelease_info'][1] >= 1 %}
    - name: /usr/pgsql-9.2/bin/postgresql92-setup initdb
{% else %}
    - name: service postgresql-9.2 initdb
{% endif %}
    - watch:
      - pkg: Install PostgreSQL92 Server Packages

pgdg-92 yum update -y:
  cmd.run:
    - name: yum update -y
    - runas: root
    - require:
      - pkg: pgdg-92

/var/lib/pgsql/9.2/data/pg_hba.conf:
  file.managed:
    - source:
      - salt://jcu/postgresql/pg_hba.conf
    - user: postgres
    - group: postgres
    - mode: 600
    - require:
      - cmd: PostgreSQL92 Init DB

postgresql-9.2:
  service:
    - running
    - enable: True
    - watch:
      - cmd: PostgreSQL92 Init DB
      - file: /var/lib/pgsql/9.2/data/pg_hba.conf
