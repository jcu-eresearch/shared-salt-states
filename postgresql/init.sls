Install PostgreSQL Repository:
  pkg.installed:
    - sources:
      - pgdg92: http://yum.postgresql.org/9.2/redhat/rhel-6-x86_64/pgdg-centos92-9.2-6.noarch.rpm

Install PostgreSQL Packages:
  pkg.installed:
    - pkgs:
      - postgresql92-devel
      - postgresql92-server
    - require:
      - pkg: Install PostgreSQL Repository

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
