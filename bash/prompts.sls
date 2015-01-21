# Red coloured prompt for root
root user coloured prompt:
  file.append:
    - name: /root/.bashrc
    - text: 'export PS1="\[\033[01;31m\]\u\[\033[00m\]@\[\033[01;31m\]\h\[\033[00m\]:\[\033[01;34m\]\w$\[\033[00m\]# "'

# Green coloured prompt for anyone else listed in ``bash:users`` pillar
{% macro user_coloured_prompt(user_id) %}
{{ user_id }} user coloured prompt:
  file.append:
    - name: /home/{{ user_id }}/.bashrc
    - text: 'export PS1="\[\033[01;32m\]\u\[\033[00m\]@\[\033[01;32m\]\h\[\033[00m\]:\[\033[01;34m\]\w$\[\033[00m\] "'
{% endmacro %}

{% for user in salt['pillar.get']('bash:users') %}
{{ user_coloured_prompt(user) }}
{% endfor %}
