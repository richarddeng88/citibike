library(shiny);library(shinydashboard)
library(leaflet)
library(RColorBrewer)
library(scales)
library(lattice)
library(dplyr)
library(ggplot2)

station <- read.csv("station_for_map2.csv", stringsAsFactors = F)


shinyServer( function(input, output,session) { 
    
    # Create the map
    output$map <- renderLeaflet({
        leaflet(station) %>%
            addTiles(
                urlTemplate = "//{s}.tiles.mapbox.com/v3/jcheng.map-5ebohr46/{z}/{x}/{y}.png",
                attribution = 'Maps by <a href="http://www.mapbox.com/">Mapbox</a>'
            ) %>%
            # setView(lng=-74.00653609,lat = 40.70955958,zoom = 15)
            fitBounds(~min(longitude),~min(latitude),~max(longitude),~max(latitude))
    })
    
    # A reactive expression that returns the set of zips that are
    # in bounds right now
    zipsInBounds <- reactive({
        if (is.null(input$map_bounds))
            return(station[FALSE,])
        bounds <- input$map_bounds
        latRng <- range(bounds$north, bounds$south)
        lngRng <- range(bounds$east, bounds$west)
        
        subset(station,
               latitude >= latRng[1] & latitude <= latRng[2] &
                   longitude >= lngRng[1] & longitude <= lngRng[2])
    })
    
    # Precalculate the breaks we'll need for the two histograms
    centileBreaks <- hist(plot = FALSE, station$daily_trips, breaks = 20)$breaks
    
    output$histCentile <- renderPlot({
        # If no zipcodes are in view, don't plot
        if (nrow(zipsInBounds()) == 0)
            return(NULL)
        
        hist(zipsInBounds()$daily_trips,
             breaks = centileBreaks,
             main = "Histogram of Daily Trips",
             xlab = "How Many Trips per Day",
             xlim = range(station$daily_trips),
             col = 'orangered',
             border = 'black')
    })
    
    output$scatterCollegeIncome <- renderPlot({
        # If no zipcodes are in view, don't plot
        if (nrow(zipsInBounds()) == 0)
            return(NULL)
        
        print(xyplot(daily_trips ~ rank_score, data = zipsInBounds(), xlab="Popularity Score", 
                     ylab = "Daily Trips"))
        
#         a <- zipsInBounds() %>% group_by(boro) %>% summarize(total = length(boro))
#         ggplot(a, aes(x=boro, y=total)) + 
#             geom_bar(stat="identity",fill="black", colour="black") +
#             labs(title="Stations", x="Station Numbers", y="Boros")
        
    })
    
    
    
    # This observer is responsible for maintaining the circles and legend,
    # according to the variables the user has chosen to map to color and size.
    observe({
        colorBy <- input$color
        sizeBy <- input$size
        
        
        if (colorBy == "year") {
            # Color and palette are treated specially in the "superzip" case, because
            # the values are categorical instead of continuous.
            colorData <- ifelse(station$year == 2013, "2013", "2015")
            pal <- colorFactor(c("blue","firebrick3"), colorData)
        } else if (colorBy == "boro") {
            colorData <- station$boro
            pal <- colorFactor(c("forestgreen","blue","darkorchid4"), colorData)
        } else {
            colorData <- station[[colorBy]]
            pal <- colorBin(c("red","darkviolet","darkblue","black"),
                            colorData, 4, pretty = FALSE)
        }
        
        
        
        if (sizeBy == "same") {
            # Radius is treated specially in the "superzip" case.
            radius <- 90
        } else if (sizeBy == "rank_score") {
            radius <- station[[sizeBy]] / max(station[[sizeBy]]) * 150
        }
        else {
            radius <- station[[sizeBy]] / max(station[[sizeBy]]) * 300
        }
        
        
        
        leafletProxy("map", data = station) %>%
            clearShapes() %>%
            addCircles(~longitude, ~latitude, radius=radius, layerId=~station.id,
                       stroke=FALSE, fillOpacity=0.4, fillColor=pal(colorData)) %>%
            addLegend("bottomleft", pal=pal, values=colorData, title=colorBy,
                      layerId="colorLegend")
    })
    
    
    
    
    # Show a popup at the given location
    showZipcodePopup <- function(zipcode, lat, lng) {
        selectedZip <- station[station$station.id == zipcode,]
        content <- as.character(tagList(
            tags$h4("Station ID:", as.integer(selectedZip$station.id)),
            tags$strong(HTML(sprintf("%s, %s",
                                     selectedZip$latitude, selectedZip$longitude
            ))), tags$br(),
            sprintf("The staion's name: %s", as.character(selectedZip$station.name)), tags$br(),
            sprintf("The number of trips: %s", as.integer(selectedZip$daily_trips)), tags$br(),
            sprintf("In service since: %s", as.character(selectedZip$year))
        ))
        leafletProxy("map") %>% addPopups(lng, lat, content, layerId = zipcode)
    }
    
    
    
    # When map is clicked, show a popup with city info
    observe({
        leafletProxy("map") %>% clearPopups()
        event <- input$map_shape_click
        if (is.null(event))
            return()
        
        isolate({
            showZipcodePopup(event$id, event$lat, event$lng)
        })
    })
    
    
    
    
    set.seed(122)
    histdata <- rnorm(500)
    
    output$plot1 <- renderPlot({
        data <- histdata[seq_len(input$slider)]
        hist(data)
    })
    
}

    

    
)
