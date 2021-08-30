include:
  - jcu.nodejs

pm2:
  npm.installed:
    - require:
      - pkg: nodejs

# Command should be re-run if nodejs or pm2 are modified
pm2 startup:
  cmd.run:
    - prepend_path: /usr/local/bin
    - onchanges:
      - npm: pm2
      - pkg: nodejs

# Use onchanges_in in remote states to have pm2 save after their introduction
pm2 save:
  cmd.run:
    - prepend_path: /usr/local/bin
    - require:
      - npm: pm2
