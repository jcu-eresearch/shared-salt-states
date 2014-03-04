Remove SSH public key:
   file.absent:
       - name: /etc/ssh_keys/id_rsa.pub
   
 
Remove SSH private key:
   file.absent:
       - name: /etc/ssh_keys/id_rsa
