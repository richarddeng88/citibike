library(shiny);library(shinydashboard)
library(leaflet)
library(RColorBrewer)
library(scales)
library(lattice)
library(dplyr)
library(ggplot2)
library(plotly);library(zoo)

station <- read.csv("station_for_map2.csv", stringsAsFactors = F)
kk <- read.csv("hour_ex_for_shiny.csv", stringsAsFactors = F)

shinyServer( function(input, output,session) { 
    
    ### EDA PLOTING#####################
    output$date_start <- renderText(paste("The starting date is: ", input$date[1]))
    output$date_end <- renderText(paste("The ending date is:  ", input$date[2]))
    output$date_start1 <- renderText(paste("The starting date is: ", input$date[1]))
    output$date_end1 <- renderText(paste("The ending date is:  ", input$date[2]))
    
    data<- reactive({
        dis <- switch(input$weekday,
                      "Weekday" = 1,
                      "Weekend" = 0)
        gen <- switch(input$gender,
                      "Male" = "male",
                      "Female" = "female")
        ff <- kk[kk$is_weekday==dis & kk$gender== gen & kk$hour>=input$hour[1] & kk$hour<=input$hour[2],]
        #filter(kk, is_weekday==dis)
        ff <- ff[ff$date>=input$date[1] & ff$date <= input$date[2],]
        
        
    })
    
    
    output$plot <- renderPlotly({
        
        ff <- data()
        bb <- ff %>% group_by(hour) %>% summarize(trips= round(sum(trips)/(dim(ff)[1]/24))) %>% 
            mutate(timestamp_for_x_axis = as.POSIXct(hour * 3600, origin = "1000-01-01", tz = "UTC"))
        
      g<- ggplot(bb, aes(x=timestamp_for_x_axis, y=trips))+
            labs(title="NYC DAILY CITIBIKE TRIPS ") +
            geom_bar(stat="identity",position="dodge",color="black") +
            scale_x_datetime("", labels = date_format("%l %p")) 
        ggplotly(g)
        
    })
    
    output$plot1 <- renderPlotly({
        
        ff <- data()
        bb <- ff %>% group_by(date) %>% summarize(trips= sum(trips)/1000) %>% 
            mutate(trips_m=rollsum(trips, k = 15, na.pad = TRUE, align = "right"))
        bb$date <- as.Date(bb$date)
        
        g <- ggplot(bb, aes(x=date, y=trips_m))+
                labs(title="NYC MONTHLY CITIBIKE TRIPS (Unit:Thousand)") +
                geom_line(size = 1, color = "darkgreen") +
                scale_x_date("Month") +
                scale_y_continuous("Trips") +
                expand_limits(y = 0) 
        ggplotly(g)
    })
    
    
    
    ##### Create the map##################################################
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
                            colorData, 3, pretty = FALSE)
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
            sprintf("In service since: %s", as.character(selectedZip$year)),tags$br(),
            sprintf("Avarage daily trips: %s", as.integer(selectedZip$daily_trips)), tags$br(),
            sprintf("Popularity score: %s", as.integer(selectedZip$rank_score))
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
    
    output$pp1 <- renderPlot({
        data <- iris[1:input$c,1]
        hist(data)
    })
    
}

    

    
)
