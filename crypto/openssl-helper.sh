#!/bin/bash

set -Eeuo pipefail

pk() {
    # private key
    openssl genpkey -algorithm rsa -pkeyopt rsa_keygen_bits:${1:-2048} # -out key.pem
}

pk_verify() {
    openssl rsa -in ${1:?input required} -check
}

csr() {
    # certificate signing request with key
    openssl req -new -key ${1:?key required} # -out csr.pem
}

csr_verify() {
    openssl req -in ${1:?input required} -text -noout
}

x509() {
    # x509 from CSR and sign key
    openssl x509 -in ${1:?csr required} -req -signkey ${2:?signkey required} -days ${3:-365} # -out cert.pem
}

x509_verify() {
    # view x509
    openssl x509 -in ${1:?cert required} -text -noout
}

x509_verify_issuer() {
    # view x509
    openssl x509 -in ${1:?cert required} -text -noout -issuer -issuer_hash
}

x509_verify_hash() {
    openssl x509 -in ${1:?cert required} -hash -noout
}

x509_verify_dates() {
    openssl x509 -in ${1:?cert required} -noout -dates
}

pk_and_csr() {
    # one shot private key and csr
    openssl req -newkey rsa:${1:-2048} -nodes -days ${2:-365} -keyout ${3:-key.pem} -out ${4:-csr.pem}
}

self_x509() {
    # one shot self signed x509
    openssl req -x509 -sha256 -newkey rsa:${1:-2048} -nodes -days ${2:-365} -keyout ${3:-key.pem} -out ${4:-cert.pem}
}

# ---
# Format conversions
# ---

der_to_pem() {
    openssl x509 -inform der -in ${1:?input required} -out ${2:?output required}
}

pem_to_der() {
    openssl x509 -outform der -in ${1:?input required} -out ${2:?output required}
}

pem_to_pkcs12() {
    openssl pkcs12 -export -inkey ${1:-key.pem} -in ${2:-cert.pem} -out ${3:?output required} # -chain cacert.pem
    # -passout pass:
}

pkcs12_to_pem() {
    openssl pkcs12 -in ${1:?input required} -out ${2:?output required}
}

pkcs12_to_pem_components() {
    openssl pkcs12 -in ${1:?input required} -out ${2:?cert out required} -clcerts -nokeys
    openssl pkcs12 -in ${1:?input required} -out ${3:?key out required} -nocerts -nodes
}

# Others

pkcs12_verify() {
    openssl pkcs12 -info -nodes -in ${1:?input required}
}

url_verify() {
    openssl s_client -connect ${1:?url required}:${2:-443} -showcerts
}

pubkey() {
    openssl rsa -in ${1:?input not set} -inform ${2:-pem} -pubout
}

main() {
    COMMANDS=("pk" "pk_verify" "csr" "csr_verify" "pk_and_csr")
    COMMANDS+=("x509" "x509_verify" "x509_verify-issuer" "x509_verify-hash" "x509_verify-dates")
    COMMANDS+=("self_x509" "url_verify" "pkcs12_verify")
    COMMANDS+=("pubkey")
    COMMANDS+=("der_to_pem" "pem_to_der" "pem_to_pkcs12" "pkcs12_to_pem" "pkcs12_to_pem_components")
    for x in "${COMMANDS[@]}"; do
        if [[ "$x" == "${1-}" ]]; then
            eval "$@"
            return 0
        fi
    done
    usage
}

usage() {
    echo "Usage:"
    echo "$0 <commands>"
    echo ""
    echo "Commands:"
    echo ""
    echo "pk [bits (2048)]"
    echo "csr <pkey>"
    echo "x509 <csr> <signkey> [days (365)]"
    echo "pk_verify <key>"
    echo "csr_verify <csr>"
    echo "x509_verify <cert>"
    echo "x509_verify_issuer <cert>"
    echo "x509_verify_hash <cert>"
    echo "x509_verify_dates <cert>"
    echo "pk_and_csr [bits (2048)] [days (365)] [keyout (key.pem)] [csrout (csr.pem)]"
    echo "self_x509 [bits (2048)] [days (365)] [keyout (key.pem)] [certout (cert.pem)]"
    echo "url_verify <url> [port (443)]"
    echo "pkcs12_verify <pfx>"
    echo ""
    echo "All commands: "
    echo "${COMMANDS[@]}"
    return 1
}

main "$@"
