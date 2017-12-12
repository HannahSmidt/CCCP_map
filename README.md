# CCCP_map
This repository contains the code and data for creating a shiny application with a leaflet map that visualises change in events of violence across "settings of conflict" and over time. The map illustrates that violence crosses state borders and, by consequence, that "conflict setting" is the more appropriate unit of analysis that "country".

The maps uses data from the Uppsala Conflict Data Programme. The file process-udcp-data.R downloads the data and transform it into the dataset of analysis.

Shapefiles for the focus countries come from naturalearthdata.com. First run the code in get-focuscountries-shapefiles.R to download the shapefile data. Then execute the code in server and ui to create the shiny application with the leaflet map.

