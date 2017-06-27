# Remi's RPM repository: https://blog.remirepo.net/

{% if grains['os_family'] == 'RedHat' %}
include:
  - .epel

remi:
  pkg.installed:
    - unless: rpm -q remi-release
    - sources:
    {% if grains['osmajorrelease'] == '7' %}
      - remi-release: https://rpms.remirepo.net/enterprise/remi-release-7.rpm
    {% elif grains['osmajorrelease'] == '6' %}
      - remi-release: https://rpms.remirepo.net/enterprise/remi-release-6.rpm
    {% endif %}
{% endif %}
