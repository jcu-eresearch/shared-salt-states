python2-devel:
{% if grains['os_family'] == 'RedHat' and grains['osmajorrelease']|int < 8 %}
  pkg.installed:
    - name: python-devel
{% else %}
  pkg.installed
{% endif %}
