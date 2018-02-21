#!/bin/bash

for alt in editor ex rview rvim vi view vim vimdiff; do
    update-alternatives --install /usr/bin/$alt $alt /usr/local/bin/vim 1
    update-alternatives --set $alt /usr/local/bin/vim
done
