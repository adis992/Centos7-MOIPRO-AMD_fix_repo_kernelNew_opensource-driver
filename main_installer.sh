#!/bin/bash

# Definiši putanju glavnog foldera
MAIN_DIR="$(pwd)"

echo "Pokrećem instalaciju prema zadatom redosledu..."

# 1. Pokreni fix_repo_mv_repo.sh
echo "Pokrećem fix_repo_mv_repo.sh..."
cd "$MAIN_DIR/etc"
bash fix_repo_mv_repo.sh
if [ $? -ne 0 ]; then
    echo "fix_repo_mv_repo.sh nije uspeo! Zaustavljam instalaciju."
    exit 1
fi
cd "$MAIN_DIR"  # Vrati se u glavni direktorijum

# 2. Pokreni script_ssl-1.1-and_other_auto_install.sh
echo "Pokrećem script_ssl-1.1-and_other_auto_install.sh..."
cd "$MAIN_DIR/Missing-file-for-kernel-4.14.0-1"
bash script_ssl-1.1-and_other_auto_install.sh
if [ $? -ne 0 ]; then
    echo "script_ssl-1.1-and_other_auto_install.sh nije uspeo! Zaustavljam instalaciju."
    exit 1
fi
cd "$MAIN_DIR"  # Vrati se u glavni direktorijum

# 3. Pokreni install_kernel_dependecies.sh
echo "Pokrećem install_kernel_dependecies.sh..."
cd "$MAIN_DIR/Kernel-4.14.0-1"
bash install_kernel_dependecies.sh
if [ $? -ne 0 ]; then
    echo "install_kernel_dependecies.sh nije uspeo! Zaustavljam instalaciju."
    exit 1
fi
cd "$MAIN_DIR"  # Vrati se u glavni direktorijum

# 4. Pokreni drv-tbs.sh
echo "Pokrećem drv-tbs.sh..."
cd "$MAIN_DIR"
bash drv-tbs.sh
if [ $? -ne 0 ]; then
    echo "drv-tbs.sh nije uspeo! Zaustavljam instalaciju."
    exit 1
fi
cd "$MAIN_DIR"  # Vrati se u glavni direktorijum

echo "Instalacija završena uspešno."
