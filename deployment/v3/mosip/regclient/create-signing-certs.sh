# warning: do not use the certificates produced by this tool in production. This is for testing purposes only
# This is reference script, Use officially valid code signing certificate in production.

# The script starts from here
echo -e "$(tput setaf 2) \n USAGE: bash create-signing-certs.sh keyStorePwd \n";
echo "$(tput setaf 4) This script will create new rootCA, Partner certificates  $(tput sgr 0)";

if [[ $# -ne 1 ]]; then
    echo "$(tput setaf 1) keyStorePwd not provided; EXITING; $(tput sgr0)";
    exit 1;
elif [[ -z "${1// }" ]]; then
    echo "$(tput setaf 1) keyStorePwd is either empty or contains only spaces; EXITING; $(tput sgr0)";
    exit 1;
fi

files="client-openssl.cnf openssl.cnf root-openssl.cnf"
for file in $files; do
  if [[ ! -f $file ]]; then
    echo "$(tput setaf 1) $file not found; EXITING; $(tput sgr0)";
    exit 1;
  fi
done

## set headings string
CERT_DIR="create \"certs\" directory"
CA_Heading="creating CA certificate"
CLIENT_Heading="creating CLIENT certificate for CodeSigning"

## GENERATE KEYSTORE PASSWORD
KEYSTORE_PWD=$1

## create new certs directory
tput setaf 3
printf '\n_%*.0s' $(( $(tput cols)*10/100  -1 )) "" | tr " " "=" | tr "_" " "
echo -n " $CERT_DIR "
printf '%*.0s \n\n' $(( $(tput cols) - ${#CERT_DIR} - $(tput cols)*10/100 -5 ))  "" | tr " " "="
tput sgr0

rm -rf ./certs
mkdir ./certs
echo "created certs directory"

# certificate authority
tput setaf 3
printf '\n_%*.0s' $(( $(tput cols)*10/100  -1 )) "" | tr " " "=" | tr "_" " "
echo -n " $CA_Heading "
printf '%*.0s \n\n' $(( $(tput cols) - ${#CA_Heading} - $(tput cols)*10/100 -5 ))  "" | tr " " "="
tput sgr0

openssl genrsa -out ./certs/RootCA.key 4096
openssl req -new -x509 -days 1826 -key ./certs/RootCA.key -out ./certs/RootCA.crt -config ./root-openssl.cnf


# client certificate
tput setaf 3
printf '\n_%*.0s' $(( $(tput cols)*10/100  -1 )) "" | tr " " "=" | tr "_" " "
echo -n " $CLIENT_Heading "
printf '%*.0s \n\n' $(( $(tput cols) - ${#CLIENT_Heading} - $(tput cols)*10/100 -5 ))  "" | tr " " "="
tput sgr0

openssl genrsa -out ./certs/Client.key 4096
openssl req -new -key ./certs/Client.key -out ./certs/Client.csr -config ./client-openssl.cnf
openssl x509 -req -extensions v3_req -extfile ./client-openssl.cnf -days 1826 -in ./certs/Client.csr -CA ./certs/RootCA.crt -CAkey ./certs/RootCA.key -set_serial 01 -out ./certs/Client.crt
openssl verify -CAfile ./certs/RootCA.crt ./certs/Client.crt
openssl pkcs12 -export -in ./certs/Client.crt -inkey ./certs/Client.key -out ./certs/keystore.p12 -name "CodeSigning" -password pass:$KEYSTORE_PWD

