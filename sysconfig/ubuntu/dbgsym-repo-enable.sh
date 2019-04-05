ubuntu_release=$(lsb_release -cs)
cat <<END | sudo tee /etc/apt/sources.list.d/ubuntu-ddebs.list
deb http://ddebs.ubuntu.com ${ubuntu_release} main restricted universe multiverse
deb http://ddebs.ubuntu.com ${ubuntu_release}-updates main restricted universe multiverse
deb http://ddebs.ubuntu.com ${ubuntu_release}-proposed main restricted universe multiverse
END

# Add the keyring info
dpkg -l ubuntu-dbgsym-keyring &>/dev/null || sudo apt install ubuntu-dbgsym-keyring -y
