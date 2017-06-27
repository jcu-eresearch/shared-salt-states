include:
  - jcu.git

# We prepend because this can't go after match blocks
Accept GIT attributes on SSH:
  file.prepend:
    - name: /etc/ssh/sshd_config
    - text: AcceptEnv GIT_AUTHOR_NAME GIT_COMMITTER_NAME GIT_COMMITTER_EMAIL GIT_AUTHOR_EMAIL

  # Make sshd reload, except on Vagrant where it runs separately
  service.running:
    - name: sshd
    - enable: True
    - reload: True
    - unless: test -d /vagrant
    - onchanges:
      - file: Accept GIT attributes on SSH
