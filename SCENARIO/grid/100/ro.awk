BEGIN{
rt_pkts = 0;
}

{
if (($1 == "s" || $1 == "f") && $4 == "RTR" && ($7 =="udp" || $7 == "AODV" || $7 =="message" || $7 =="AOMDV" || $7 =="OLSR")) rt_pkts++;
}

END{
printf("RO  : %d\n",rt_pkts);
}