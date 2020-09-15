dnf-automatic:
  pkg.installed: []
  service.running:
    - enable: True
    - reload: True
    - watch:
      - pkg: dnf-automatic
