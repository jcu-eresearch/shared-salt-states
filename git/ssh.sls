include:
  - jcu.git

Accept GIT attributes on SSH:
  file.append:
    - name: /etc/ssh/sshd_config
    - text: AcceptEnv GIT_*
  service.running:
    - name: sshd
    - enable: True
    - reload: True
    - watch:
      - file: Accept GIT attributes on SSH
