# Hyprland Dotfiles

This repository was created to host my hyprland dotfiles, which includes a select few of required packages, provided by `AUR` (Used `yay`) and `pacman` package managers.

## Used packages
1. sddm     (greeter)
1. swaylock (lock screen)
1. waybar   (bar)
1. starship (shell prompt)
1. rofi     (application launcher)
1. mako     (notification daemon)
1. pywal    (configurable color picker)
1. pacseek  (AUR and Arch database searcher)

## Additions
The `equil-theme` that is a part of this repository, is a theme that I have been concucting for some time. So far it's just a collection of bash scripts that's used to make it easier, to do specific things in hyprland. Like adjust volume, set background, launch rofi, etc.

Additionally, the `wallpapers` folder includes a couple of backgrounds that I enjoy, and have used to define theme configurations. It installs into `home/<usr-name>/wallpapers` as a symbolic link.

## Before you install
Some dotfiles are interlocked, and may result in some functions being limited if not all packages are present. That is, if not all packages are installed, the programs will not function as intended, and are due manual configuration... but who am I kidding, this is Arch users, everybody LIKES the manual configuration.

## Installing
There are 2 primary methods of installing, running the `install.sh` file, or manually installing each package independently.

### install.sh
Before the install.sh file can be executed, the user should need to change its permissions.

```bash
sudo chmod +x install.sh
```

Then simply follow the steps in your terminal, where you'll be prompted to install each package independently.