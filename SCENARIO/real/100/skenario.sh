/bin/mv scenario.txt old.txt
echo -e '$node_(98) set X_ 0\n$node_(98) set Y_ 650.0\n$node_(98) set Z_ 0\n$node_(99) set X_ 650.0\n$node_(99) set Y_ 0\n$node_(99) set Z_ 0' > temp.txt
#echo -e '$node_(48) set X_ 0\n$node_(48) set Y_ 1000.0\n$node_(48) set Z_ 0\n$node_(49) set X_ 1000.0\n$node_(49) set Y_ 0\n$node_(49) set Z_ 0' > temp.txt
(/bin/cat temp.txt && /bin/cat old.txt) > scenario.txt
/bin/rm temp.txt old.txt
/bin/sed -i 's/-//g' scenario.txt

