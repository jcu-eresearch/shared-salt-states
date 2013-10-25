include:
  - jcu.repositories.pgdg.pgdg92
  - .add_to_path

Install PostgreSQL92 Client Packages:
  pkg.installed:
    - pkgs:
      - postgresql92
      - postgresql92-devel
    - require:
      - pkg: pgdg-92
      - cmd: Add PostgreSQL92 to PATH
