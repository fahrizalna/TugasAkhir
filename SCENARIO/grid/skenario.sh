/bin/mv scenario.txt old.txt
echo -e '$node_(38) set X_ 0\n$node_(38) set Y_ 600.0\n$node_(38) set Z_ 0\n$node_(39) set X_ 600.0\n$node_(39) set Y_ 0\n$node_(39) set Z_ 0' > temp.txt
(/bin/cat temp.txt && /bin/cat old.txt) > scenario.txt
/bin/rm temp.txt old.txt
/bin/sed -i 's/-//g' scenario.txt

