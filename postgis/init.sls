include:
  - postgresql

Install PostGIS Packages:
  pkg.installed:
    - pkgs:
      - postgis2_92-devel
    - require:
      - pkg: Install PostgreSQL Repository
      - pkg: Install PostgreSQL Packages
