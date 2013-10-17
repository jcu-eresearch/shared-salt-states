# You can't use pgdg with elgis active
# The two repositories are not compatible
exclude:
  - sls: .elgis

# PostgreSQL repository
pgdg-92:
  pkg.installed:
    - sources:
      - pgdg-centos92: http://yum.postgresql.org/9.2/redhat/rhel-6-x86_64/pgdg-centos92-9.2-6.noarch.rpm
