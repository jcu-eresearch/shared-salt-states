Git
===

The states here perform different tasks, depending on your requirements:

* ``init.sls`` performs a basic Git installation.

* ``ssh.sls`` configures sshd to automatically accept environment variables.
  Take care with this as the ``AcceptEnv`` line is appended to the end of the
  sshd configuration and this **may break** your sshd configuration.
