#!/bin/bash

# Install SCM Breeze
echo 'Installing SCM Breeze....'
echo

# Install SCM Breeze
git clone https://github.com/scmbreeze/scm_breeze.git ~/.scm_breeze && ~/.scm_breeze/install.sh && echo -n " > /dev/null 2>&1" >> ~/.zshrc
