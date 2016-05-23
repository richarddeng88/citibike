library(RMySQL);library(dplyr);library(ggplot2)
library(reshape2);library(zoo);library(scales);library(extrafont);library(grid);library(RPostgreSQL)
library(ggmap);library(rgdal);library(maptools);library(readr);library(minpack.lm)

df$date <- as.Date(df$starttime)
df$count <- 1

df <- df %>% select(date,bikeid,gender,month,hour,year,weekday,date,count)
df$gender[df$gender==1] = "male"
df$gender[df$gender==2] = "female"
df$gender[df$gender==0] = "unknown"  
df$is_weekday<- 1
df[df$weekday=="Sunday",]$is_weekday<- 0
df[df$weekday=="Saturday",]$is_weekday <- 0

prop.table(table(df$gender))
df<- df %>% filter(gender != "unknown")
# calculate the data we need
# day <- df %>% group_by(date) %>% summarize(trips = sum(count)) %>% 
#     mutate(trips_m=rollsum(trips, k = 15, na.pad = TRUE, align = "right"))
# 
# 
# kk <- df %>% group_by(date, gender, is_weekday) %>% mutate(trips = sum(count)) %>% distinct(date)
# kk <- as.data.frame(kk)

ff <- df %>% group_by() %>% summarize(trips = sum(count)) 

kk <- df %>% group_by(date,hour, gender, is_weekday) %>% summarize(trips = sum(count)) 
kk <- as.data.frame(kk)
write.csv(kk, file="c:/hour_ex_for_shiny.csv",row.names = F)

#ploting
ggplot(data = day, aes(x = date, y =trips )) +
    labs(title="NYC unique bikes used") +
    geom_line(size = 1, color = "darkgreen") +
    scale_x_date("Month") +
    scale_y_continuous("Citi Bike trips, trailing 15 days/Unit: thousands") +
    expand_limits(y = 0) 

ggplot(data = filter(kk, is_weekday==0), aes(x = gender, y = trips)) +
    geom_bar(stat="identity",position="dodge",color="red") +
    labs(title="NYC BIKE TRIPS BY HOUR OF THE DAY",y="Avg hourly trips")


