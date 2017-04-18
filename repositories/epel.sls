{% if grains['os_family'] == 'RedHat' %}
epel:
  pkg.installed:
    - name: epel-release
    - sources:
  {% if grains['osmajorrelease'] == '7' %}
      - epel-release: https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
  {% elif grains['osmajorrelease'] == '6' %}
      - epel-release: https://dl.fedoraproject.org/pub/epel/epel-release-latest-6.noarch.rpm
  {% endif %}
{% endif %}

