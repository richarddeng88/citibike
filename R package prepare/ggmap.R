library(ggmap)
paris <- get_map(location = "paris")
str(paris)
ggmap(paris)

nyc <- get_map(location = "New York",source="google", maptype="terrain",crop=FALSE)
ggmap(nyc)
qmap("New York",zoom=12)

#different type of location 
myLocation <- c(lon = -73.97033, lat = 40.75323)
myLocation <- c(-130, 30, -105, 50)
ggmap(get_map(myLocation))


# zoom = integer from 3-21
ggmap(nyc,zoom=5)+geom_point(aes(x =  -73.97033, y = 40.75323), 
                   alpha = .5, color="darkred", size = 1)

geocode("the white house")

baylor <- "baylor university"
qmap(baylor, zoom = 14)
qmap(baylor, zoom = 14, source = "osm")

