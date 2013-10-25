include:
  - jcu.repositories.pgdg.pgdg92
  - .add_to_path

Install PostgreSQL92 Server Packages:
  pkg.installed:
    - pkgs:
      - postgresql92-devel
      - postgresql92-server
    - require:
      - pkg: pgdg-92
      - cmd: Add PostgreSQL92 to PATH

PostgreSQL92 Init DB:
  cmd.wait:
    - name: service postgresql-9.2 initdb
    - watch:
      - pkg: Install PostgreSQL92 Server Packages

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
