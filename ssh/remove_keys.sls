include:
  - ..ssh

Remove SSH private key:
  file.absent:
    - name: /etc/ssh_keys/id_rsa
    - require:
      - file: SSH private key
