# Gentoo packages

## Maintainers

- Rose

This repo contains the ebuilds for binary and non-binary versions of Horizon.

!! **Please read the ebuilds prior to building** !!

## Add this overlay

```bash
# install the tool if needed
sudo emerge --ask app-eselect/eselect-repository

# add the horizon overlay via eselect
sudo eselect repository add horizon git https://github.com/Fchat-Horizon/gentoo.git

# sync the newly added repo
sudo emaint sync -r horizon

# optional: verify it's registered/enabled
eselect repository list -i
```