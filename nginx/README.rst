Nginx
=====

The states here perform different tasks, depending on your requirements:

* ``init.sls`` performs a basic Nginx installation, including general
  configuration, adding JCU error/maintenance resources, and configuring
  iptables.
* ``custom.sls`` perfoms a custom Nginx installation from JCU's repository.
  This version of Nginx contains features like LDAP authentication, fancy
  indexes, and most importantly, Shibboleth integration.  Read more at
  `nginx-custom-build <https://github.com/jcu-eresearch/nginx-custom-build>`_.
* ``config.sls`` performs some extra Nginx configuration steps, including:

  * Host configuration (set your Pillar ``nginx.configuration`` to a file path)
  * Certificate installation (set ``nginx.certificate`` and ``nginx.key`` in
    your Pillar)
  * General templating (set ``nginx.host`` to be your hostname)
