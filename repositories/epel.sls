epel:
  pkg.installed:
    - sources:
      {% if grains['osmajorrelease'] == 7 %}
      - epel-release: https://mirrors.kernel.org/fedora-epel/7/x86_64/e/epel-release-7-2.noarch.rpm
      {% elseif grains['osmajorrelease'] == 6 %}
      - epel-release: https://mirrors.kernel.org/fedora-epel/6/x86_64/epel-release-6-8.noarch.rpm
      {% endif %}

