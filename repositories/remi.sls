# Remi's RPM repository: https://blog.remirepo.net/

{% if grains['os_family'] == 'RedHat' %}

{% set requires_epel = grains['osmajorrelease']|int <= 7 %}
{% if requires_epel %}
include:
  - .epel
{% endif %}

remi:
  pkg.installed:
    - unless: rpm -q remi-release
    {% if requires_epel %}
    - require:
      - pkg: epel
    {% endif %}
    - sources:
    {% if grains['osmajorrelease']|int == 8 %}
      - remi-release: https://rpms.remirepo.net/enterprise/remi-release-8.rpm
    {% elif grains['osmajorrelease']|int == 7 %}
      - remi-release: https://rpms.remirepo.net/enterprise/remi-release-7.rpm
    {% elif grains['osmajorrelease']|int == 6 %}
      - remi-release: https://rpms.remirepo.net/enterprise/remi-release-6.rpm
    {% endif %}
{% endif %}
