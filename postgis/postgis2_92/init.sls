include:
  - jcu.repositories.pgdg.pgdg92
  - jcu.postgresql.postgresql92

Install PostGIS2_92 Packages:
  pkg.installed:
    - pkgs:
      - postgis2_92-devel
    - require:
      - pkg: pgdg-92
      - pkg: Install PostgreSQL92 Server Packages
    - refresh: True
    - watch_in:
      - service: postgresql-9.2
