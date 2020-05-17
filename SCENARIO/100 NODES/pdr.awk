BEGIN {
        sendLine = 0;
        recvLine = 0;
}
 
$0 ~/^s.* AGT/ {
        sendLine ++ ;
}
 
$0 ~/^r.* AGT/ {
        recvLine ++ ;
}
 
END {
        print "PDR : " (recvLine/sendLine)*100 " %";
} 