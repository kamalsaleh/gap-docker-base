#!/bin/bash

set -e

gap_packages_artifact_hash=12258958e233a45a336c1b92681cc2cafbd1fb90

cd ~/.julia/artifacts

mv $gap_packages_artifact_hash bak

mkdir $gap_packages_artifact_hash

mv bak/GAPDoc-* $gap_packages_artifact_hash
mv bak/primgrp-* $gap_packages_artifact_hash
mv bak/SmallGrp-* $gap_packages_artifact_hash
mv bak/transgrp $gap_packages_artifact_hash
mv bak/autpgrp-* $gap_packages_artifact_hash
mv bak/alnuth-* $gap_packages_artifact_hash
mv bak/crisp-* $gap_packages_artifact_hash
mv bak/ctbllib-* $gap_packages_artifact_hash
mv bak/FactInt-* $gap_packages_artifact_hash
mv bak/fga $gap_packages_artifact_hash
mv bak/irredsol-* $gap_packages_artifact_hash
mv bak/laguna-* $gap_packages_artifact_hash
mv bak/polenta-* $gap_packages_artifact_hash
mv bak/polycyclic-* $gap_packages_artifact_hash
mv bak/resclasses-* $gap_packages_artifact_hash
mv bak/sophus-* $gap_packages_artifact_hash
mv bak/tomlib-* $gap_packages_artifact_hash
mv bak/PackageManager-* $gap_packages_artifact_hash

rm -rf bak

cd $gap_packages_artifact_hash

# remove unused data
rm -rf primgrp-*/data
rm -rf SmallGrp-*/id*
rm -rf SmallGrp-*/small*
rm -rf transgrp/data
rm -rf irredsol-*/data
rm -rf irredsol-*/fp
rm -rf ctbllib-*/data
rm -rf tomlib-*/data
# this leads to unbound global variables
#rm -rf FactInt-*/tables
