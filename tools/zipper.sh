#! /bin/sh

for NME in data*
do
    7z a -t7z -mx9 $NME.7z $NME
done
