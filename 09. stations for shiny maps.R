library(dplyr)

## load data and indentify the year that the station is put in use. 
s2013 <- read.csv("citibike/2013stations.csv", stringsAsFactors = F)
s2015 <- read.csv("citibike/2015stations.csv", stringsAsFactors = F)
s2013 <- s2013 %>% arrange(station.id)
s2015 <- s2015 %>% arrange(station.id)
s2015$year <- 2013
s2015[!(s2015$station.id %in% s2013$station.id),"year"] <- 2015

station <- s2015
station$index <- seq(1,dim(station)[1])
write.csv(station, "citibike/station_for_map.csv", row.names = F)

## after geocoding the file, load back then data and change clean boro names
station <- read.csv("citibike/station_for_map.csv", stringsAsFactors = F)
station[station$boro=="Kings County","boro"] <- "Brooklyn"
man <- c("East Village","Midtown East","New York", "New York County","NY","Theater District")
station[(station$boro %in% man),"boro"] <- "Manhattan"
station[station$boro=="Queens County","boro"] <- "Queens"


## calculate the avg daily bike trips for each station.
df <- df2016 # load the data from save.data using 2016 data (2m records)
df$date <- as.Date(df$starttime)
df$count <- 1
days <- df %>% distinct(date)
daily_trips <- df %>% group_by(start.station.id) %>% summarize(daily_trips = sum(count)/dim(days)[1]) 
station <- merge(station, daily_trips, by.x = "station.id", by.y = "start.station.id", all = T)
#write.csv(station, "citibike/station_for_map.csv", row.names = F)


### calculate the station popularity ranking indicator




### EDA
hist(station$daily_trips)
plot(station$daily_trips, station$daily_trips)

a <- station %>% group_by(boro) %>% summarize(total = length(boro))
library(ggplot2)
ggplot(a, aes(x=boro, y=total)) + geom_bar(stat="identity",fill="darkgreen", colour="black")





