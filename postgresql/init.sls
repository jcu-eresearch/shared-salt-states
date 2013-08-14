Install PostgreSQL Repository:
  pkg.installed:
    - sources:
      - pgdg: http://yum.postgresql.org/9.2/redhat/rhel-6-x86_64/pgdg-centos92-9.2-6.noarch.rpm

Install PostgreSQL Packages:
  pkg.installed:
    - pkgs:
      - postgresql92-devel
      - postgresql92-server
    - require:
      - pkg: Install PostgreSQL Repository
