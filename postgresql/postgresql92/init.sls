include:
  - jcu.repositories.pgdg.pgdg92

Install PostgreSQL92 Packages:
  pkg.installed:
    - pkgs:
      - postgresql92-devel
      - postgresql92-server
    - require:
      - pkg: pgdg-92

/etc/profile.d/postgresql92_path.sh:
  file.managed:
    - source:
      - salt://jcu/postgresql/postgresql92/postgresql92_path.sh
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: Install PostgreSQL92 Packages

Add PostgreSQL92 to PATH:
  cmd.run:
    - name: source /etc/profile.d/postgresql92_path.sh
    - require:
      - file: /etc/profile.d/postgresql92_path.sh

PostgreSQL92 Init DB:
  cmd.wait:
    - name: service postgresql-9.2 initdb
    - watch:
      - pkg: Install PostgreSQL92 Packages

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
    - require:
      - cmd: Add PostgreSQL92 to PATH
