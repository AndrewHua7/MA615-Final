library(shiny)
library(shinydashboard)
library(leaflet)
library(dplyr)
library(DT)
library(tidyr)
stops<-read.csv("C:/Users/HXP/Desktop/MA615 Final/stops.txt")
stoptimes2112<- read.csv("C:/Users/HXP/Desktop/MA615 Final/data2/stop_times2112.txt")
stoptimes2201<- read.csv("C:/Users/HXP/Desktop/MA615 Final/data2/stop_times2201.txt")
stoptimes2202<- read.csv("C:/Users/HXP/Desktop/MA615 Final/data2/stop_times2202.txt")
stoptimes2203<- read.csv("C:/Users/HXP/Desktop/MA615 Final/data2/stop_times2203.txt")
stoptimes2204<- read.csv("C:/Users/HXP/Desktop/MA615 Final/data2/stop_times2204.txt")
stoptimes2205<- read.csv("C:/Users/HXP/Desktop/MA615 Final/data2/stop_times2205.txt")
stoptimes2206<- read.csv("C:/Users/HXP/Desktop/MA615 Final/data2/stop_times2206.txt")
stoptimes2207<- read.csv("C:/Users/HXP/Desktop/MA615 Final/data2/stop_times2207.txt")
stoptimes2208<- read.csv("C:/Users/HXP/Desktop/MA615 Final/data2/stop_times2208.txt")
stoptimes2209<- read.csv("C:/Users/HXP/Desktop/MA615 Final/data2/stop_times2209.txt")
stoptimes2210<- read.csv("C:/Users/HXP/Desktop/MA615 Final/data2/stop_times2210.txt")
stoptimes2211<- read.csv("C:/Users/HXP/Desktop/MA615 Final/data2/stop_times2211.txt")

stoptimes <- rbind(stoptimes2112,stoptimes2201,stoptimes2202,stoptimes2203,
                   stoptimes2204,stoptimes2205,stoptimes2206,stoptimes2207,
                   stoptimes2208,stoptimes2209,stoptimes2210,stoptimes2211)

data <- stops %>% inner_join(stoptimes,by = c("stop_id"))
data2 <- data %>% 
  filter(stop_name %in% c("Boston University Central","Hynes Convention Center",
                          "Bowdoin","Boardway","Kendall/MIT","Aquarium",
                          "Logan Airport Ferry Terminal","Long Wharf (North)"))
        

data2 <- data2 %>%
  separate(stop_desc, c("name", "line", "decs"), sep = "-") 
data2 <-data2[complete.cases(data2$line), ] 

ui <- dashboardPage(
  dashboardHeader(),
  dashboardSidebar(
    selectInput("line", 
                label = "Line",
                choices = unique(data2$line),
                )
  ),
  dashboardBody(
    box(width = 12,
        leafletOutput(outputId = "map")
    ),
    verbatimTextOutput("map_marker_click"),
    DT::dataTableOutput("table")
  )
)

server <- function(input, output, session) {
  
  output$map <- renderLeaflet({
    leaflet(data2) %>% addTiles() %>%
      addCircleMarkers(lng = ~stop_lon, lat = ~stop_lat, 
                       popup = ~stop_name,
                       radius = 5,
                       color = "red")})
  
  
  
  
  
  observeEvent(input$mymap_marker_click, { 
    x <- input$mymap_marker_click  
    print(x)
  })
  
}

shinyApp(ui, server)
