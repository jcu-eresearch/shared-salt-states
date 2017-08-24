{% set ssh_user = salt['pillar.get']('ssh:user', 'root') %}
{% set ssh_group = salt['pillar.get']('ssh:group', 'root') %}

SSH private key:
  file.managed:
    - name: /etc/ssh_keys/id_rsa
    - user: {{ ssh_user }}
    - group: {{ ssh_group }}
    - mode: 600
    - makedirs: true
    - dir_mode: 700
    - contents_pillar: 'ssh:id_rsa'
