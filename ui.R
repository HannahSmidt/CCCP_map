library(leaflet)
library("shinyjs")

appCSS <- "
#loading-content {
position: absolute;
background: #FFFFFF;
opacity: 0.9;
z-index: 100;
left: 0;
right: 0;
height: 100%;
text-align: center;
color: #000000;
}
"

bootstrapPage(
  theme = "animate.min.css",
  useShinyjs(),
  inlineCSS(appCSS),
  tags$style(type = "text/css", "html, body {width:100%;height:100%}",
             ".leaflet .legend i{
             border-radius: 50%;
             width: 10px;
             height: 10px;
             margin-top: 4px;
             }
             "),
  div(id = "loading-content",
      fluidPage(
        h2(class = "animated infinite pulse", "Loading data...")
        # HTML("<img src=images/cruk-logo.png width='50%'></img>")
      )),
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