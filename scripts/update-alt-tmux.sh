#!/bin/bash

update-alternatives --install /usr/bin/tmux tmux /usr/local/bin/tmux 1
update-alternatives --set tmux /usr/local/bin/tmux
