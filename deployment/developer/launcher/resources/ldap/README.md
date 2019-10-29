Passwords in .ldif file are
base64 encoded sha256/512 hash of the password string.

To add an entry
ldapmodify -h localhost -p 10389 -D "uid=admin,ou=system" -a -w "secret" -f new_entry.ldif

TODO: Add a user with SSHA256 - which will generate a salt - this
is important for Reg Client.

