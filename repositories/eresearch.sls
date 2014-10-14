include:
  - jcu.yum.protectbase

jcu-eresearch:
   pkgrepo.managed:
      - humanname: JCU eResearch Custom Repo
      - baseurl: https://www.hpc.jcu.edu.au/rpm/
      - gpgcheck: 0
      - priority: 1
      - enabled: 1
      - protected: 1
      - require:
        - pkg: yum-plugin-protectbase
