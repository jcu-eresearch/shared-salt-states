/etc/profile.d/postgresql92_env.sh:
  file.managed:
    - source:
      - salt://jcu/postgresql/postgresql92/postgresql92_env.sh
    - user: root
    - group: root
    - mode: 644

Setup PostgreSQL92 Environment:
  cmd.run:
    - name: source /etc/profile.d/postgresql92_env.sh
    - require:
      - file: /etc/profile.d/postgresql92_env.sh
