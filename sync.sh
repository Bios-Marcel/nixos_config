#!/usr/bin/env bash

cp *.nix /etc/nixos/
echo "# vim:set ro: -\*- buffer-read-only:t -\*-" | tee -a /etc/nixos/*.nix

