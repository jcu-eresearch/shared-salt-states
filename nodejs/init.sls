include:
  - jcu.repositories.nodesource

nodejs:
  {% if grains['os_family'] == 'RedHat' %}
  pkg.installed:
    - require:
      - pkg: nodesource
  {% else %}
  - pkg.installed
  {% endif %}
