include:
  - jcu.rpm.dnf

powertools repo:
  cmd.run:
    - name: dnf config-manager --set-enabled powertools
    - require:
      - pkg: dnf-plugins-core
