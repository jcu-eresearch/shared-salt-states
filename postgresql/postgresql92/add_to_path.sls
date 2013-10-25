/etc/profile.d/postgresql92_path.sh:
  file.managed:
    - source:
      - salt://jcu/postgresql/postgresql92/postgresql92_path.sh
    - user: root
    - group: root
    - mode: 644

Add PostgreSQL92 to PATH:
  cmd.run:
    - name: source /etc/profile.d/postgresql92_path.sh
    - require:
      - file: /etc/profile.d/postgresql92_path.sh
