# Wireguard Documentation


## 1. Login via ssh

* Login to wireguard instance via ssh
   ```
    ssh -i mosip-aws.pem ubuntu@3.7.248.153
   ```

## 2. list files

* List files
   ```
   ls
   ```

## 3. Open assigned.txt file
* To assign the peer
   ```
   vim assigned.txt
   ```

## 4. Add the peers with name as below
* Write the name of the peer
   ```
   peer1 : XYZ
   ```

## 5. Change directory
* Change directory
   ```
     cd config
   ```
## 6. List peers
* List peers
   ```
     ls
   ```

## 7. Change directory
* Change directory (whichever the peer you have assigned in the assigned.txt file)
   ```
     cd peer1 
   ```
   ```
     vi peer1.conf file
     Delete DNS IP, then update allowed IP's(subnet ip of AWS), and then share the conf file with the peer.

