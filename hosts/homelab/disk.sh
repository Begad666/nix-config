# !/bin/sh

echo "Formatting /dev/sda..."
parted /dev/sda -- mklabel gpt

echo "Creating boot partition /dev/sda1..."
parted /dev/sda -- mkpart ESP fat32 1MiB 2GiB
parted /dev/sda -- set 1 boot on
parted /dev/sda -- set 1 esp on
mkfs.vfat /dev/sda1

echo "Creating encrypted root partition /dev/sda2..."
parted /dev/sda -- mkpart nixos 2GiB 300GiB
cryptsetup luksFormat /dev/sda2
cryptsetup open /dev/sda2 crypt-nixos
ZPOOL_DEV=/dev/mapper/crypt-nixos
zpool create -o ashift=12 \
  -o autotrim=off \
  -O normalization=formD \
  -O relatime=on \
  -O dnodesize=auto \
  -O compression=zstd \
  -O acltype=posixacl \
  -O xattr=sa \
  -m none \
  rpool "$ZPOOL_DEV"

echo "Creating encrypted swap partition /dev/sda3..."
parted /dev/sda -- mkpart swap -32GiB 100%
cryptsetup luksFormat /dev/sda3
cryptsetup open /dev/sda3 crypt-swap
mkswap /dev/mapper/crypt-swap
swapon /dev/mapper/crypt-swap

echo "Creating encrypted keys partition /dev/sda4..."
# Exact sectors used here
parted /dev/sda -- mkpart keys 870463488s -32GiB
cryptsetup luksFormat /dev/sda4
cryptsetup open /dev/sda4 crypt-keys
mkfs.ext4 /dev/mapper/crypt-keys

echo "Creating Qubes partition /dev/sda5..."
# Exact sectors used here
parted /dev/sda -- mkpart qubes 300GiB 870463488s

echo "Generating encryption keys..."
mkdir -p /mnt/keys
mount /dev/mapper/crypt-keys /mnt/keys
openssl rand -out /mnt/keys/system.key 32
openssl rand -out /mnt/keys/user.key 32
chmod 0400 /mnt/keys/*.key
sync

echo "Creating ZFS datasets..."
zfs create -o mountpoint=none \
           rpool/local

zfs create -o mountpoint=legacy \
           -O atime=off \
           rpool/local/nix

zfs create -o encryption=aes-256-gcm \
           -o keyformat=raw \
           -o keylocation=file:///mnt/keys/system.key \
           -o mountpoint=none \
           rpool/system

zfs create -o mountpoint=legacy \
           rpool/system/root

zfs snapshot rpool/system/root@blank

zfs create -o mountpoint=legacy \
           rpool/system/persist

zfs create -o encryption=aes-256-gcm \
           -o keyformat=raw \
           -o keylocation=file:///mnt/keys/user.key \
           -o mountpoint=none \
           rpool/user

zfs create -o mountpoint=legacy \
           rpool/user/home

echo "Mounting filesystems..."

mount -t zfs rpool/system/root /mnt

mkdir -p /mnt/nix
mount -t zfs rpool/local/nix /mnt/nix

mkdir -p /mnt/home
mount -t zfs rpool/user/home /mnt/home

mkdir -p /mnt/persist
mount -t zfs rpool/system/persist /mnt/persist
