#!/bin/bash

set -e

gap_packages_artifact_hash=4e4ea19bd0229040a3916e7a351a4fa7b43ae0b6

cd ~/.julia/artifacts

mv $gap_packages_artifact_hash bak

mkdir $gap_packages_artifact_hash

mv bak/gapdoc/ $gap_packages_artifact_hash
mv bak/primgrp/ $gap_packages_artifact_hash
mv bak/smallgrp/ $gap_packages_artifact_hash
mv bak/transgrp/ $gap_packages_artifact_hash
mv bak/autpgrp/ $gap_packages_artifact_hash
mv bak/alnuth/ $gap_packages_artifact_hash
mv bak/crisp/ $gap_packages_artifact_hash
mv bak/ctbllib/ $gap_packages_artifact_hash
mv bak/factint/ $gap_packages_artifact_hash
mv bak/fga/ $gap_packages_artifact_hash
mv bak/irredsol/ $gap_packages_artifact_hash
mv bak/laguna/ $gap_packages_artifact_hash
mv bak/polenta/ $gap_packages_artifact_hash
mv bak/polycyclic/ $gap_packages_artifact_hash
mv bak/repsn/ $gap_packages_artifact_hash # needed by GroupRepresentationsForCAP
mv bak/resclasses/ $gap_packages_artifact_hash
mv bak/sophus/ $gap_packages_artifact_hash
mv bak/tomlib/ $gap_packages_artifact_hash
mv bak/utils/ $gap_packages_artifact_hash # needed since GAP.jl commit 36d2092d225905e4dfc99d72725fd141be6bcf32
mv bak/packagemanager/ $gap_packages_artifact_hash

rm -rf bak

cd $gap_packages_artifact_hash

# remove unused data
rm -rf primgrp/data
rm -rf smallgrp/id*
rm -rf smallgrp/small*
rm -rf transgrp/data
rm -rf irredsol/data
rm -rf irredsol/fp
rm -rf ctbllib/data
rm -rf ctbllib/doc
rm -rf ctbllib/doc2
rm -rf tomlib/data
# this leads to unbound global variables
#rm -rf factint/tables
