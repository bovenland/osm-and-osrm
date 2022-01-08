download:
	@wget -P ./data https://download.geofabrik.de/europe/netherlands-latest.osm.pbf

import:
	@osm2pgsql -U postgis -W -d postgis -H localhost --hstore -C 10000 ./data/netherlands-latest.osm.pbf

osrm: osrm-extract osrm-partition osrm-customize

osrm-extract:
	@docker run -t -v "$(CURDIR):/osm-data" osrm/osrm-backend osrm-extract -p /osm-data/cycling.lua /osm-data/data/netherlands-latest.osm.pbf

osrm-partition:
	@docker run -t -v "$(CURDIR):/osm-data" osrm/osrm-backend osrm-partition /osm-data/data/netherlands-latest.osrm

osrm-customize:
	@docker run -t -v "$(CURDIR):/osm-data" osrm/osrm-backend osrm-customize /osm-data/data/netherlands-latest.osrm

osrm-routed:
	@docker run -t -i -p 5000:5000 -v "$(CURDIR):/osm-data" osrm/osrm-backend osrm-routed --algorithm mld /osm-data/data/netherlands-latest.osrm
