# REAL
# netconvert --osm-files map.osm --output-file map.net.xml
# GRID
# netgenerate --grid --grid.number=4 --grid.length=300 --default.speed=10 --tls.guess=1 --output-file=map.net.xml

# python /usr/share/sumo/tools/randomTrips.py -n real.net.xml -e 98 -l --trip-attributes="departLane=\"best\" departSpeed=\"max\" departPos=\"random\"" -o trip.trips.xml

# duarouter -n real.net.xml -t trip.trips.xml -o route.rou.xml --ignore-errors --repair

# sumo -c file.sumocfg --fcd-output scenario.xml

# python /usr/share/sumo/tools/traceExporter.py --fcd-input=scenario.xml --ns2mobility-output=scenario-real.txt