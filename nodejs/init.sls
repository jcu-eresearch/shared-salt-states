{% if (grains['os'] == 'RedHat' and grains['osmajorrelease']|int < 8) or grains['os'] == 'CentOS' %}
include:
  - jcu.development_tools
  - jcu.repositories.nodesource
{% endif %}

nodejs:
{% if grains['os_family'] == 'RedHat' %}
  pkg.installed:
    {% if grains['os'] == 'RedHat' and grains['osmajorrelease']|int >= 8 %}
    - name: '@nodejs:14'
    {% else %}
    - require:
      - pkg: nodesource
      - pkg: Development Tools
    {% endif %}
{% else %}
  pkg.installed
{% endif %}
