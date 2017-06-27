exclude:
  - sls: .pgdg

elgis:
  pkg.installed:
    - unless: rpm -q elgis-release
    - sources:
      - elgis-release: http://elgis.argeo.org/repos/6/elgis-release-6-6_0.noarch.rpm
