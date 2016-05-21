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
daily_trips <- df %>% group_by(start.station.id) %>% summarize(daily_trips = round(sum(count)/dim(days)[1])+1) 
station <- merge(station, daily_trips, by.x = "station.id", by.y = "start.station.id", all = T)
write.csv(station, "citibike/station_for_map1.csv", row.names = F)


### calculate the station popularity ranking indicator
df$date <- as.Date(df$starttime) # load the full df data
df$count <- 1
df <- select(df, tripduration,start.station.id,start.station.name,end.station.id,gender,date,count)
df$ym <- format(df$date, "%Y-%m")

by_station_start <- df %>% group_by(ym, start.station.id) %>% summarize(trips=sum(count)) %>% arrange(desc(trips))
top10 <- filter(by_station_start, row_number() <= 100)
top10$count <- 1
top10 <- group_by(top10, start.station.id)
a <- summarize(top10, num=sum(count))
rank_start <- arrange(a, desc(num))

by_station_stop <- df %>% group_by(ym, end.station.id) %>% summarize(trips=sum(count)) %>% arrange(desc(trips))
top10 <- filter(by_station_stop, row_number() <= 100)
top10$count <- 1
top10 <- group_by(top10, end.station.id)
b <- summarize(top10, num=sum(count))
rank_end <- arrange(b, desc(num))


station <- read.csv("citibike/station_for_map1.csv", stringsAsFactors = F)
station <- merge(station, rank_start, by.x="station.id", by.y = "start.station.id", all.x = T, all.y=F)
station[is.na(station$num),]$num <- 0
station$rank_score <- (station$num + 3)*10
station <- select(station, -num)
write.csv(station, "citibike/station_for_map2.csv", row.names = F)

### EDA
hist(station$daily_trips)
plot(station$daily_trips, station$daily_trips)

a <- station %>% group_by(boro) %>% summarize(total = length(boro))
library(ggplot2)
ggplot(a, aes(x=boro, y=total)) + geom_bar(stat="identity",fill="darkgreen", colour="black")





