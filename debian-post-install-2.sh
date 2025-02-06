#!/usr/bin/env bash

# Verify that the NVIDIA drivers were correctly installed and nouveau kernel has been replaced

nvidia-smi
lspci -nnk | grep -A3 NVIDIA
lsmod | grep nvidia
