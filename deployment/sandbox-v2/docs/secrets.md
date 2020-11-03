## Secrets
All secrets are stored in `secrets.yml`.  For a secure sandbox, edit the file and update all passwords.  Defaults may be used for development and testing, but be aware that the sandbox will not be secure with defaults. To edit `secrets.yml`:
```
$ av edit secrets.yml
```
If you update postgres passwords, then their ciphers will have to be updated in property files.  See section on Config Server below.

All the passwords used in `.properties` have been added in `secrets.yml` - some of them for pure informational purpose - to be able to find out the text password. IMPORTANT: if you change any password in `.properties` make sure `secrets.yml` is updated.

