###### 1.month trips calculated by my own data;
library(dplyr);library(ggplot2)
df$date <- as.Date(df$starttime)
df$count <- 1

calculation <-select(df, start.station.id,bikeid,gender,hour,weekday,date,count)

daily <- group_by(calculation, date)
by_day <- summarize(daily, trips=sum(count),bikes=length(unique(bikeid)))
by_day <- mutate(by_day,trips_m=rollsum(trips, k = 15, na.pad = TRUE, align = "right"),
                 bikes_m=rollmean(bikes, k = 35, na.pad = TRUE, align = "right"))

#png("citibike/picts/1. monthly_total_trips.png", width = 640, height = 480)
ggplot(data = by_day, aes(x = date, y = trips_m)) +
        labs(title="NYC MONTHLY CITIBIKE TRIPS") +
        geom_line(size = 1, color = "darkgreen") +
        scale_x_date("Month") +
        scale_y_continuous("Citi Bike trips, trailing 15 days/Unit: thousands") +
        expand_limits(y = 0) 
#dev.off()

#########2 unique bikes used perday calculated by my own data;#########################
#png("citibike/picts/2.unique_bike.png", width = 640, height = 480)
ggplot(data = by_day, aes(x = date, y = bikes_m)) +
        labs(title="NYC unique bikes used") +
        geom_line(size = 1, color = "blue") +
        scale_x_date("Month") +
        scale_y_continuous("Number of unique bikes used perdday, trailing 25 days") +
        expand_limits(y = 0) 
#dev.off()


####### 3. calculate trips by hour ####################################################
calculation$ifweekday <- 1
calculation[calculation$weekday=="Sunday",]$ifweekday  <- 0 
calculation[calculation$weekday=="Saturday",]$ifweekday  <- 0

hour <- group_by(calculation, date,hour)
hour_wday <- filter(hour,ifweekday==1)
hour_wend <- filter(hour,ifweekday==0)
by_hour_wday <- summarize(hour_wday, trips=sum(count))
by_hour_wend <- summarize(hour_wend, trips=sum(count))

by_hour_wday <- group_by(by_hour_wday,hour)
by_hour_wday <- summarize(by_hour_wday, avg=mean(trips))
by_hour_wend <- group_by(by_hour_wend,hour)
by_hour_wend <- summarize(by_hour_wend, avg=mean(trips))

by_hour_wday$ifweekday <- "weekday" ; by_hour_wend$ifweekday <- "weekend"
by_hour <- rbind(as.data.frame(by_hour_wend) ,as.data.frame(by_hour_wday))

#png(filename = "citibike/picts/3.avg trips by hour.png", width = 640, height = 420)
ggplot(data = by_hour, aes(x = hour, y = avg,fill=ifweekday)) +
        geom_bar(stat="identity",position="dodge",color="black") +
        labs(title="NYC BIKE TRIPS BY HOUR OF THE DAY",y="Avg hourly trips")+
        facet_grid(ifweekday~.)
#dev.off()

########## 4.  calculate how many unique bike station#################################
daily <- group_by(calculation, date)
by_day <- summarize(daily, station=length(unique(start.station.id)))
by_day <- mutate(by_day,
                 station_inuse = rollmean(station, k = 20, na.pad = TRUE, align = "right"))

#png("citibike/picts/4.station in use.png", width = 640, height = 480)
ggplot(data = by_day, aes(x = date, y = station_inuse)) +
        labs(title="NYC citibike station in use") +
        geom_line(size = 1, color = "darkblue") +
        scale_x_date("Month") +
        scale_y_continuous("Citi bike station in sue") +
        expand_limits(y = 0) 
#dev.off()
