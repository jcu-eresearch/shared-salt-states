include:
  - jcu.nginx
  - jcu.repositories.eresearch

extend:
  # Ensure that the default Nginx repo is gone
  nginx-repository:
    pkgrepo:
      - absent

  # Install customised version supporting XSLT for HTML, AJP, Shibboleth + more
  nginx:
    pkg:
      - refresh: true
      - require:
        - pkgrepo: jcu-eresearch
