include:
   - jcu.repositories.eresearch
   - jcu.supervisord

# For base packages
Shibboleth package repository:
   file.managed:
      - name: /etc/yum.repos.d/security:shibboleth.repo
      - source: http://download.opensuse.org/repositories/security://shibboleth/RHEL_6/security:shibboleth.repo
      - source_hash: sha256=4279b0d9725d94f5ceeb9b4f10f4e9e7c0c306752605b154adaff5343b3236ab
      - user: root
      - group: root
      - mode: 644

# Install customised version supporting FastCGI
shibboleth:
   pkg.installed:
      - fromrepo: jcu-eresearch
      - require:
          - pkgrepo: jcu-eresearch 
          - file: Shibboleth package repository 

/opt/shibboleth:
    file.directory:
       - user: shibd
       - group: shibd

# Manage FastCGI applications
/etc/supervisord.d/shibboleth-fastcgi.ini:
   file.managed:
      - source: salt://jcu/shibboleth/shibboleth-fastcgi.ini
      - user: root
      - group: root
      - mode: 644
      - requires:
         - pkg: supervisord
         - pkg: shibboleth
         - file: /opt/shibboleth
      - watch_in:
         - service: supervisord

shibauthorizer:
   supervisord.running:
      - update: true
      - watch:
         - file: /etc/supervisord.d/shibboleth-fastcgi.ini

shibresponder:
   supervisord.running:
      - update: true
      - watch:
         - file: /etc/supervisord.d/shibboleth-fastcgi.ini
