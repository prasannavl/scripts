#!/bin/bash

pk() {
	# private key
	openssl genpkey -algorithm rsa -pkeyopt rsa_keygen_bits:${1-2048} # -out key.pem
}

pk-verify() {
	openssl rsa -in $1 -check
}

csr() {
	# certificate signing request with key
	openssl req -new -key $1 # -out csr.pem
}

csr-verify() {
	openssl req -in $1 -text -noout
}

x509() {
	# x509 from CSR and sign key
	openssl x509 -in $1 -req -signkey $2 -days ${3:-365} # -out cert.pem
}

x509-verify() {
	# view x509
	openssl x509 -in $1 -text -noout
}

x509-verify-issuer() {
	# view x509
	openssl x509 -in $1 -text -noout -issuer -issuer_hash
}

x509-verify-hash() {
	openssl x509 -in $1 -hash -noout
}

x509-verify-dates() {
	openssl x509 -in $1 -noout -dates
}

pk-and-csr() {
	# one shot private key and csr
	openssl req -newkey rsa:${1:-2048} -nodes -days ${2:-365} -keyout ${3:-key.pem} -out ${4:-csr.pem}
}

self-x509() {
	# one shot self signed x509
	openssl req -x509 -sha256 -newkey rsa:${1:-2048} -nodes -days ${2:-365} -keyout ${3:-key.pem} -out ${4:-cert.pem}
}

# ---
# Format conversions
# ---

der-to-pem() {
	openssl x509 -inform der -in $1 -out $2
}

pem-to-der() {
	openssl x509 -outform der -in $1 -out $2
}

pem-to-pkcs12() {
	openssl pkcs12 -export -inkey ${1:-key.pem} -in ${2:-cert.pem} -out $3 # -chain cacert.pem
}

pkcs12-to-pem() {
	openssl pkcs12 -in $1 -out $2
}

pkcs12-to-pem-components() {
	openssl pkcs12 -in $1 -out ${2:?cert name not set} -clcerts -nokeys
	openssl pkcs12 -in $1 -out ${3:?key name not set} -nocerts -nodes
}

# Others

pkcs12-verify() {
	openssl pkcs12 -info -nodes -in $1
}

url-verify() {
	openssl s_client -connect ${1}:${2:-443} -showcerts
}

pubkey() {
	openssl rsa -in ${1:?input not set} -inform {2:-pem} -pubout
}

main() {
	case $1 in 
		pk|pk-verify|csr|csr-verify|x509|x509-verify|x509-verify-issuer|x509-verify-hash|x509-verify-dates|pk-and-csr|self-x509|url-verify|pkcs12-verify)
			eval $1 "$2 $3 $4 $5 $6 $7 $8 $9"
			;;
		*)
		echo "Usage: "
		echo "pk [bits (2048)]"
		echo "csr <pkey>"
		echo "x509 <csr> <signkey> [days (365)]"
		echo "pk-verify <key>"
		echo "csr-verify <csr>"
		echo "x509-verify <cert>"
		echo "x509-verify-issuer <cert>"
		echo "x509-verify-hash <cert>"
		echo "x509-verify-dates <cert>"
		echo "pk-and-csr [bits (2048)] [days (365)] [keyout (key.pem)] [csrout (csr.pem)]"	
		echo "self-x509 [bits (2048)] [days (365)] [keyout (key.pem)] [certout (cert.pem)]"
		echo "url-verify <url> [port (443)]"
		echo "pkcs12-verify <pfx>"
		exit 1;
	esac
}

main "$@"