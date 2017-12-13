library("sf")
library("tidyverse")
library("leaflet")

## Obtained maps from http://www.naturalearthdata.com/downloads/50m-cultural-vectors/
download.file(
  url = "http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/50m/cultural/ne_50m_admin_0_countries.zip",
  destfile = "./data-raw/world-shape-files.zip"
)

unzip("data-raw/world-shape-files.zip", exdir = "data-raw/world-shape-files")
unlink("data-raw/world-shape-files.zip")

## Read in data using sf

world_shapefiles <- st_read("./data-raw/world-shape-files")
class(world_shapefiles)


save(world_shapefiles, file = "data-raw/world_shapefiles.rdata")

