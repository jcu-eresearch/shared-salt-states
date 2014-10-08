include:
  - jcu.nginx
  - jcu.repositories.eresearch

extend:
  nginx-repository:
    pkgrepo:
      - absent

  # Install customised version supporting XSLT for HTML, AJP, Shibboleth + more
  nginx:
    pkg:
      - fromrepo: jcu-eresearch
      - require:
        - pkgrepo: jcu-eresearch
