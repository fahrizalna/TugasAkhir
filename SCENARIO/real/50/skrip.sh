export SUMO_HOME=/usr/share/sumo
#/usr/bin/netconvert --osm-files ~/Downloads/map.osm --output-file map.net.xml
/usr/bin/python /usr/share/sumo/tools/randomTrips.py -n map.net.xml -e 48 -l --trip-attributes="departLane=\"best\" departSpeed=\"max\" departPos=\"random_free\"" -o trip.trips.xml
/usr/bin/duarouter -n map.net.xml -t trip.trips.xml -o route.rou.xml --ignore-errors --repair
/usr/bin/sumo -c sumo.sumocfg.xml --fcd-output scenario.xml
/usr/bin/python /usr/share/sumo/tools/traceExporter.py --fcd-input=scenario.xml --ns2mobility-output=scenario.txt
