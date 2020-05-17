BEGIN{
recvd = 0;
hc = 0;
}

{
if (( $1 == "r") && ( $7 == "cbr" || $7 =="tcp" ) && ( $4=="AGT" )) recvd++;
if (( $1 == "r") && ( $4 == "RTR") && ( $7 == "cbr")) { hc = hc + 1; }
}


END{
printf("AHC : %.2f\n",hc/recvd);
}