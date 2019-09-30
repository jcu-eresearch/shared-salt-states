# Nodesource "official" Node.js packages: https://github.com/nodesource/distributions#rpminstall

{% if grains['os_family'] == 'RedHat' %}
nodesource:
  pkg.installed:
    - name: nodesource-release
    - unless: rpm -q nodesource-release
    - sources:
    {% if grains['osmajorrelease']|int == 7 %}
      - nodesource-release: https://rpm.nodesource.com/pub_10.x/el/7/x86_64/nodesource-release-el7-1.noarch.rpm
    {% elif grains['osmajorrelease']|int == 6 %}
      - nodesource-release: https://rpm.nodesource.com/pub_10.x/el/6/x86_64/nodesource-release-el6-1.noarch.rpm
    {% endif %}
{% endif %}
