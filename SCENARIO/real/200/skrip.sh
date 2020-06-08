export SUMO_HOME=/usr/share/sumo
/usr/bin/python /usr/share/sumo/tools/randomTrips.py -n map.net.xml -e 198 -l --trip-attributes="departLane=\"best\" departSpeed=\"max\" departPos=\"random_free\"" -o trip.trips.xml
/usr/bin/duarouter -n map.net.xml -t trip.trips.xml -o route.rou.xml --ignore-errors --repair
/usr/bin/sumo -c sumo.sumocfg.xml --fcd-output scenario.xml
/usr/bin/python /usr/share/sumo/tools/traceExporter.py --fcd-input=scenario.xml --ns2mobility-output=scenario.txt
