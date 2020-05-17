import collections
import sys
import operator

# Usage: python trace_cbr.py <tracefile.tr>
filename = sys.argv[1]

lines = [line.rstrip('\n') for line in open(filename)]
links = dict()
drop_cbk = 0
drop_nrte = 0
drop_arp = 0
drop_ttl = 0
drop_col = 0
drop_end = 0
drop_out = 0
drop_ifq = 0
drop_tout = 0
drop_loop = 0
drop_bsy = 0
drop_sta = 0
drop_err = 0
drop_dup = 0
drop_ret = 0
for line in lines:
	line = line.split()
	node = line[2]
	packet_id = line[5]
	layer = line[6]

	if layer == "cbr":
		packet_id = int(packet_id)
		if packet_id in links:
			if node not in links[packet_id]:
				links[packet_id].append(node)
		else:
			links[packet_id] = [node]
		if line[0] == "D":
			drop_cause = "DROP-" + line[4]
			links[packet_id].append(drop_cause)
			if drop_cause == "DROP-CBK":
				drop_cbk += 1
			elif drop_cause == "DROP-NRTE":
				drop_nrte += 1
			elif drop_cause == "DROP-ARP":
				drop_arp += 1
			elif drop_cause == "DROP-TTL":
				drop_ttl += 1
			elif drop_cause == "DROP-COL":
				drop_col += 1
			elif drop_cause == "DROP-END":
				drop_end += 1
			elif drop_cause == "DROP-OUT":
				drop_out += 1
			elif drop_cause == "DROP-IFQ":
				drop_ifq += 1
			elif drop_cause == "DROP-TOUT":
				drop_tout += 1
			elif drop_cause == "DROP-LOOP":
				drop_loop += 1	
			elif drop_cause == "DROP-BSY":
				drop_bsy += 1
			elif drop_cause == "DROP-STA":
				drop_sta += 1
			elif drop_cause == "DROP-ERR":
				drop_err += 1
			elif drop_cause == "DROP-DUP":
				drop_dup += 1
			elif drop_cause == "DROP-RET":
				drop_ret += 1
				

links_sorted = collections.OrderedDict(sorted(links.items()))
for key, value in links_sorted.iteritems():
	print key, value
print "Drop CBK: ", drop_cbk
print "Drop NRTE: ", drop_nrte
print "Drop ARP: ", drop_arp
print "Drop TTL: ", drop_ttl
print "Drop COL: ", drop_col
print "Drop END: ", drop_end
print "Drop OUT: ", drop_out
print "Drop IFQ: ", drop_ifq
print "Drop TOUT: ", drop_tout
print "Drop LOOP: ", drop_loop
print "Drop BSY: ", drop_bsy
print "Drop STA: ", drop_sta
print "Drop ERR: ", drop_err
print "Drop DUP: ", drop_dup
print "Drop RET: ", drop_ret
print "Total Drop: ", (drop_cbk + drop_nrte + drop_arp + drop_ttl + drop_end + drop_col + drop_end + 
					drop_out + drop_ifq + drop_tout + drop_loop + drop_bsy + drop_sta + drop_err + drop_dup + drop_ret)