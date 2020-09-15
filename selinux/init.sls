# Refer to /etc/selinux/targeted/contexts/files/file_contexts for details on
# SELinux contexts

# Contains semanage utility
policycoreutils-python:
  pkg.installed:
  {% if grains['os_family'] == 'RedHat' and grains['osmajorrelease']|int <= 7 %}
    - name: policycoreutils-python
  {% else %}
    - name: policycoreutils-python-utils
  {% endif %}
