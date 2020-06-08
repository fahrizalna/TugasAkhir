# REAL
# netconvert --osm-files map.osm --output-file map.net.xml
# GRID
netgenerate --grid --grid.number=4 --grid.length=200 --default.speed=20 --tls.guess=1 --output-file=map.net.xml
python /usr/share/sumo/tools/randomTrips.py -n map.net.xml -e 48 -l --trip-attributes="departLane=\"best\" departSpeed=\"max\" departPos=\"random\"" -o trip.trips.xml
duarouter -n map.net.xml -t trip.trips.xml -o route.rou.xml --ignore-errors --repair
sumo -c file.sumocfg --fcd-output scenario.xml
python /usr/share/sumo/tools/traceExporter.py --fcd-input=scenario.xml --ns2mobility-output=scenario.txt
