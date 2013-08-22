Install PostgreSQL Repository:
  pkg.installed:
    - sources:
      - pgdg-centos92: http://yum.postgresql.org/9.2/redhat/rhel-6-x86_64/pgdg-centos92-9.2-6.noarch.rpm

Install PostgreSQL Packages:
  pkg.installed:
    - pkgs:
      - postgresql92-devel
      - postgresql92-server
    - require:
      - pkg: Install PostgreSQL Repository

/etc/profile.d/postgresql_path.sh:
  file.managed:
    - source:
      - salt://jcu/postgresql/postgresql_path.sh
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: Install PostgreSQL Packages

Add PostgreSQL to PATH:
  cmd.run:
    - name: source /etc/profile.d/postgresql_path.sh
    - require:
      - file: /etc/profile.d/postgresql_path.sh

Init PostgreSQL:
  cmd.wait:
    - name: service postgresql-9.2 initdb
    - watch:
      - pkg: Install PostgreSQL Packages

PostgreSQL Service:
  service:
    - name: postgresql-9.2
    - running
    - enable: True
    - watch:
      - cmd: Init PostgreSQL

/var/lib/pgsql/9.2/data/pg_hba.conf:
  file.managed:
    - source:
      - salt://jcu/postgresql/pg_hba.conf
    - user: postgres
    - group: postgres
    - mode: 600
    - require:
      - cmd: Init PostgreSQL
