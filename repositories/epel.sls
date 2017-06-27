{% if grains['os_family'] == 'RedHat' %}
epel:
  pkg.installed:
    - name: epel-release
    - unless: rpm -q epel-release
  {% if grains['osfinger'] == 'Red Hat Enterprise Linux Server-7' %}
    - sources:
      - epel-release: https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
  {% elif grains['osfinger'] == 'Red Hat Enterprise Linux Server-6' %}
    - sources:
      - epel-release: https://dl.fedoraproject.org/pub/epel/epel-release-latest-6.noarch.rpm
  {% endif %}
{% endif %}

