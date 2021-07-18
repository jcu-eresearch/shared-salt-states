{% if grains['os'] == 'CentOS' and grains['osmajorrelease']|int >= 8 %}
include:
  - jcu.repositories.powertools
{% endif %}

# For full Pillow support (see https://pillow.readthedocs.io/en/latest/installation.html)
Pillow dependencies:
  pkg.installed:
    - pkgs:
      - libjpeg-turbo-devel
      - zlib-devel
      - libtiff-devel
      - lcms2-devel
      - libwebp-devel
      - tcl-devel
      - tk-devel
      - openjpeg2-devel
      - libimagequant-devel
    {% if grains['os'] == 'CentOS' and grains['osmajorrelease']|int >= 8 %}
    - require:
      - cmd: powertools repo
    {% endif %}
