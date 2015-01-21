include:
  - jcu.git

Accept GIT attributes on SSH:
  file.append:
    - name: /etc/ssh/sshd_config
    - text: AcceptEnv GIT_AUTHOR_NAME GIT_COMMITTER_NAME GIT_COMMITTER_EMAIL GIT_AUTHOR_EMAIL
  service.running:
    - name: sshd
    - enable: True
    - reload: True
    - watch:
      - file: Accept GIT attributes on SSH
