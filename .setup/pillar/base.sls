nginx:
   service-name: shared-salt-states
   contact-email: eresearch@example.com

shibboleth:
   test: true
   host: example.com
   entityID: https://example.com/shibboleth
   REMOTE_USER: auEduPersonSharedToken eppn persistent-id targeted-id
   supportContact: eresearch@example.com
   hosts:
      example.com:
         paths:
            '/':
               requireSession: 'false'
