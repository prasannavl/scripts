#!/bin/bash

set -Eeuo pipefail

pk() {
	# private key
	openssl genpkey -algorithm rsa -pkeyopt rsa_keygen_bits:${1:-2048} # -out key.pem
}

pk-verify() {
	openssl rsa -in ${1:?input required} -check
}

csr() {
	# certificate signing request with key
	openssl req -new -key ${1:?key required} # -out csr.pem
}

csr-verify() {
	openssl req -in ${1:?input required} -text -noout
}

x509() {
	# x509 from CSR and sign key
	openssl x509 -in ${1:?csr required} -req -signkey ${2:?signkey required} -days ${3:-365} # -out cert.pem
}

x509-verify() {
	# view x509
	openssl x509 -in ${1:?cert required} -text -noout
}

x509-verify-issuer() {
	# view x509
	openssl x509 -in ${1:?cert required} -text -noout -issuer -issuer_hash
}

x509-verify-hash() {
	openssl x509 -in ${1:?cert required} -hash -noout
}

x509-verify-dates() {
	openssl x509 -in ${1:?cert required} -noout -dates
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
	openssl x509 -inform der -in ${1:?input required} -out ${2:?output required}
}

pem-to-der() {
	openssl x509 -outform der -in ${1:?input required} -out ${2:?output required}
}

pem-to-pkcs12() {
	openssl pkcs12 -export -inkey ${1:-key.pem} -in ${2:-cert.pem} -out ${3:?output required} # -chain cacert.pem
}

pkcs12-to-pem() {
	openssl pkcs12 -in ${1:?input required} -out ${2:?output required}
}

pkcs12-to-pem-components() {
	openssl pkcs12 -in ${1:?input required} -out ${2:?cert out required} -clcerts -nokeys
	openssl pkcs12 -in ${1:?input required} -out ${3:?key out required} -nocerts -nodes
}

# Others

pkcs12-verify() {
	openssl pkcs12 -info -nodes -in ${1:?input required}
}

url-verify() {
	openssl s_client -connect ${1:?url required}:${2:-443} -showcerts
}

pubkey() {
	openssl rsa -in ${1:?input not set} -inform ${2:-pem} -pubout
}

main() {
	case ${1-} in 
		pk|pk-verify|csr|csr-verify|x509|x509-verify|x509-verify-issuer|x509-verify-hash|x509-verify-dates|pk-and-csr|self-x509|url-verify|pkcs12-verify)
			eval $1 "${2-} ${3-} ${4-} ${5-} ${6-} ${7-} ${8-} ${9-}"
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
	esac
}

main "$@"