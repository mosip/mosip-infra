Passwords in .ldif file are
base64 encoded sha256/512 hash of the password string.

To add an entry
ldapmodify -h localhost -p 10389 -D "uid=admin,ou=system" -a -w "secret" -f new_entry.ldif

