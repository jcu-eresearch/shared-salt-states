python2:
{% if grains['os_family'] == 'RedHat' and grains['osmajorrelease']|int < 8 %}
  pkg.installed:
    - name: python
{% else %}
  pkg.installed
{% endif %}
