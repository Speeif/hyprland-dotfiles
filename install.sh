#!/usr/env/bash

files=($(ls -d */))

function install {
    package=$(basename $1)

    read -p "Install $package dotfiles? [y/N]" answer

    if [[ "$answer" == "y" || "$answer" == "Y" ]]; then

        # TODO: SDDM
        if [[ "$package" == "SDDM" ]]; then
            str1="As this package creates a symlink in the"
            str2="/etc/ and /usr/ directories, the script"
            str3="may have to run using sudo."
            str4="This package is not installed using stow."

            printf "$str1\n$str2\n$str3\n\n$str4\n"
            read -p "Continue installing SDDM dotfiles? [y/N]" answer
            [[ "$answer" != "y" && "$answer" != "Y" ]] && return

            ln -s $PWD/$package/etc/sddm.conf.d /etc/sddm.conf.d
            ln -s $PWD/$package/usr/share/sddm /usr/share/sddm
            return
        fi
        
        stow $package
        return
    fi
} 

for file in "${files[@]}"; do
    # Check for basename
    echo $file

    install $file
done