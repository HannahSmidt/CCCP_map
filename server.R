# Shiny App
library("shiny")
library("leaflet")
library("sf")
library("tidyverse")
library("shinyjs")

source("process-udcp-data.R", local = TRUE)

load("data-raw/world_shapefiles.rdata")

focus_countries <- world_shapefiles %>%
  filter(GU_A3 %in% c(
    "COL",
    "VEN",
    "AFG",
    "PAK",
    "MEX",
    "MMR",
    "IRQ",
    "SYR",
    "RWA",
    "BDI",
    "COD"
  )) 

colors_list <- list("Violence against/from state" = "#1B9E77", 
                           "Violence between non-state actors" = "#D95F02", 
                           "Violence against civilians" = "#7570B3")


function(input, output, session) {
  
  # Add color depending on data Type
  pal <- colorFactor(palette = "Dark2", domain = gedDataR$type_of_vi)
  gedDataR$colors <- pal(gedDataR$type_of_vi)
  colorsLegend <- unique(pal(gedDataR$type_of_vi))
  
  # Weights for fatalities (use best for SCAD and ACLED too)
  gedDataR$weights <-NA
  gedDataR$weights <- log(gedDataR$best)
  gedDataR$weights[gedDataR$weights < 0] <- min(gedDataR$weights)
  
  # Add the legend for fatalities ("best")
  addLegendCustom <- function(map, colors, labels, sizes, opacity = 0.5, position = "bottomright"){
    colorAdditions <- paste0(colors, "; width:", sizes, "px; height:", sizes, "px")
    labelAdditions <- paste0("<div style='display: inline-block;height: ", sizes, "px;margin-top: 4px;line-height: ", sizes, "px;'>", labels, "</div>")
    return(addLegend(map, colors = colorAdditions, labels = labelAdditions, opacity = opacity, position = "bottomright", title = "Fatalities"))
  }
  
  
  # Filter data by slider input: year and type of violence
  filteredData <- reactive({
    gedDataR[which(gedDataR$year == input$range[1]
                   & gedDataR$type_of_vi == input$checkBox), ]
  })
  
  # Render map
  output$map <- renderLeaflet({
    # Use leaflet() here, and only include aspects of the map that
    # won't need to change dynamically
    
    if(is.null(input$range)){
      return()
    }
    
    shinyjs::hide(id = "loading-content",
                  anim = TRUE,
                  animType = "fade")
    
    leaflet(gedDataR) %>%
      addProviderTiles(providers$CartoDB.Positron) %>%
      addPolygons(data = focus_countries, color = "#444444", weight = 1
                  , opacity = 1.0, fillOpacity = 0.2, smooth = 0.5
                  , highlightOptions = highlightOptions(color = "black", weight = 2, bringToFront = TRUE),
                  options = pathOptions(clickable = FALSE)
      )
  })
  
  observe({
    data = filteredData()
    colorLegend <- unique(data$colors)
    sizesLegend <- c( min(data$weights), mean(data$weights), max(data$weights) )
    labelsLegend <- rev( round( c( min(data$best), mean(data$best), max(data$best) ), 0 ) )
    
    leafletProxy("map", data = filteredData()) %>%
      clearMarkers() %>%
      addCircleMarkers(~longitude, ~latitude, popup = ~as.character(dyad_name)
                       ,radius = ~weights, color = ~colors, stroke = TRUE, fillOpacity = 0.8) %>%
      clearControls() %>%
      addLegend("bottomleft", colors = as.character(colors_list), 
                labels = plyr::mapvalues(colorsLegend,
                                         from = as.character(colors_list),
                                         to = names(colors_list)), title = "Event type") %>%
      addLegendCustom(colors = rep(colorLegend, 3), labels = labelsLegend, sizes = sizesLegend)
  })
}
