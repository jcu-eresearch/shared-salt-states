Nginx
=====

The states here perform different tasks, depending on your requirements:

* ``init.sls`` performs a basic Nginx installation, including general
  configuration, adding JCU error/maintenance resources, and configuring
  iptables.

* ``config.sls`` performs some extra Nginx configuration steps, including:

  * Host configuration (set your Pillar ``nginx.configuration`` to a file path)
  * Certificate installation (set ``nginx.certificate`` and ``nginx.key`` in
    your Pillar)
  * General templating (set ``nginx.host`` to be your hostname)

* ``php.sls`` performs an Nginx installation with dependencies on ``php-fpm``,
  the FastCGI runner required for PHP, and other resources.

* ``repo.sls`` sets up the stable nginx repository for yum.

* ``modules/`` contains various states for installation of dynamic modules
  including custom modules like ``nginx-http-shibboleth``.
