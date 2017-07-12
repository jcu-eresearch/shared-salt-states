{% set ssh_user = salt['pillar.get']('ssh:user', 'root') %}
{% set ssh_group = salt['pillar.get']('ssh:group', 'root') %}

/etc/ssh_keys:
  file.directory:
    - user: {{ ssh_user }}
    - group: {{ ssh_group }}
    - mode: 700
    - makedirs: true

/etc/ssh_keys/id_rsa.pub:
  file.managed:
    - makedirs: true
    - user: {{ ssh_user }}
    - group: {{ ssh_group }}
    - mode: 644
    - contents_pillar: 'ssh:id_rsa.pub'
    - require:
      - file: /etc/ssh_keys

/etc/ssh_keys/id_rsa:
  file.managed:
    - makedirs: true
    - user: {{ ssh_user }}
    - group: {{ ssh_group }}
    - mode: 600
    - contents_pillar: 'ssh:id_rsa'
    - require:
      - file: /etc/ssh_keys/id_rsa.pub
