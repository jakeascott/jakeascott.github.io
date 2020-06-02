# Arch Install Notes

1. Pre-installation
    a. Make bootable .iso and verify signature
    b. Check if EFI or BIOS: ls /sys/firmware/efi/efivars
    c. Check internet connection. For wifi, set config file in /etc/netctl
    d. Set system clock: timedatectl set-ntp true && timedatectl status
    NOTE: If font too small: `setfont latarcyrheb-sun32`

2. Partition Drives
    a. List: fdisk -l; Start: fdisk /dev/sd<x>
    b. Make GPT partitions for...
        EFI: 550M, partition type 'EFI System'
        SWAP: generally equal to RAM
        ROOT: rest of drive
    c. Format partitions:
        EFI: mkfs.fat -F32 /dev/<efi>
        ROOT: mkfs.ext4 /dev/<root>
    d. Designate swap partition: mkswap /dev/<swp> && swapon /dev/<swp>
    e. Mount drives
        mount /dev/<root> /mnt
        mkdir /mnt/boot && mount /dev/<efi> /mnt/boot
    NOTE: (BIOS) Ignore EFI and set <root> partition to 'Legacy BIOS Bootable'

3. Install Arch
    a. curl 'https://jakesco.github.io/update-mirrors.sh' | sh
    b. pacstrap /mnt base base-devel
    c. genfstab -U /mnt >> /mnt/etc/fstab
    d. arch-chroot /mnt
    e. pacman -S intel-ucode networkmanager ufw neovim git gnome-keyring

4. Configure system & install bootloader
    a. curl -O 'https://jakesco.github.io/configure-arch.sh' and run it
    b. curl -O 'https://jakesco.github.io/configure-<Boot Looder>.sh'
    d. (EFI) Run configure-systemd-boot.sh | (BIOS) Run configure-syslinux.sh
    e. Enable NetworkManager and ufw
    NOTE: SSD TRIM: systemctl enable fstrim.timer

5. 'exit' back to archiso, unmount drives 'umount -R /mnt', reboot, and remove iso.

6. Finish up
    a. Check networkmanager and ufw are working
    b. Grant user sudo privlages: visudo uncomment wheel entry of choice.
    c. disable root user: passwd -l root (undo with sudo passwd -u root)
    NOTE: Be SURE sudo works before you diable root password!
    NOTE: nmcli device wifi connect <SSID> password <PASS> hidden yes