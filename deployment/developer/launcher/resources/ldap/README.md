Passwords in .ldif file are
base64 encoded sha256/512 hash of the password string.

To add an entry
ldapmodify -h localhost -p 10389 -D "uid=admin,ou=system" -a -w "secret" -f new_entry.ldif

CAUTION: While adding entries make sure there no white spaces at the end of the line (now space or any other character)

TODO: Add a user with SSHA256 - which will generate a salt - this
is important for Reg Client.

Salted password hash:  hash(password + salt)
In LDAP with salted password hash is stored as follows:
base64 (salted password hash + salt)

