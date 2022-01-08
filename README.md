# OpenStreetMap Data & OSRM

## Start OSM PostGIS

    docker-compose up db

## Download and import OSM data

Download latest OSM extract:

    wget -P ./data https://download.geofabrik.de/europe/netherlands-latest.osm.pbf

Import OSM data with osm2pgsql:

    osm2pgsql -U postgis -W -d postgis -H localhost --hstore -C 10000 ./data/netherlands-latest.osm.pbf

When getting "No space left on device" errors during import, it can help removing some Docker containers and images:

    docker rm (docker ps -q -f 'status=exited')
    docker rmi (docker images -q -f "dangling=true")

## OSRM

First:

    docker run -t -v "$PWD:/osm" osrm/osrm-backend osrm-extract -p /osm/foot.lua /osm/data/netherlands-latest.osm.pbf
    docker run -t -v "$PWD:/osm" osrm/osrm-backend osrm-partition /osm/netherlands-latest.osrm
    docker run -t -v "$PWD:/osm" osrm/osrm-backend osrm-customize /osm/netherlands-latest.osrm

Then:

    docker run -t -i -p 5000:5000 -v "$PWD:/osm" osrm/osrm-backend osrm-routed --algorithm mld /osm/data/netherlands-latest.osrm

Do API call:

    curl "http://localhost:5000/route/v1/walking/53.4330,6.5830;53.40117,6.60953?steps=true"

See [API documentation](https://github.com/Project-OSRM/osrm-backend/blob/master/docs/http.md).

Or start web frontend:

    docker run -p 9966:9966 osrm/osrm-frontend


