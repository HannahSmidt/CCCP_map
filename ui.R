library(leaflet)

bootstrapPage(
  tags$style(type = "text/css", "html, body {width:100%;height:100%}",
             ".leaflet .legend i{
               border-radius: 50%;
               width: 10px;
               height: 10px;
               margin-top: 4px;
              }
              "),
  leafletOutput("map", width = "100%", height = "100%"
                ),
  absolutePanel(
    top = 10, right = 10,
    sliderInput(
      inputId = "range",
      label = "Choose a year",
      value = 1989, min = 1989, max = 2016,
      sep = ""
    ),
    selectInput(
      inputId = "checkBox",
      label = "Type of violence",
      choices = list(
        "Violence against/from state" = 1,
        "Violence between non-state" = 2,
        "Violence against civilians" = 3
      ),
      selected = 1
    )
  )
)