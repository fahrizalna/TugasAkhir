ns2 ~/ns2/ns-allinone-2.35/ns-2.35/indep-utils/cmu-scen-gen/cbrgen.tcl -type cbr -nn 100 -seed 1 -mc 1 -rate 1.0 > cbr.txt
/bin/sed -i 's/$node_(1)/$node_(198)/g' cbr.txt
/bin/sed -i 's/$node_(2)/$node_(199)/g' cbr.txt

