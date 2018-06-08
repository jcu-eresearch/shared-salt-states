include:
  - jcu.development_tools
  - jcu.repositories.nodesource

nodejs:
  {% if grains['os_family'] == 'RedHat' %}
  pkg.installed:
    - require:
      - pkg: nodesource
      - pkg: Development Tools
  {% else %}
  - pkg.installed
  {% endif %}
