df <- citi_data

df$starttime <- as.POSIXlt(df$starttime)
df$stoptime <- as.POSIXlt(df$stoptime)

df$year <- df$starttime$year+1900
df$month <- months(df$starttime)
df$weekday <- weekdays(df$starttime)
df$quarters <- quarters(df$starttime)
df$hour <- df$starttime$hour


df$gender[df$gender==1] = "male"
df$gender[df$gender==2] = "female"
df$gender[df$gender==0] = "unknown"   
########################################################################################
library(RMySQL);library(dplyr);library(ggplot2)
library(reshape2);library(zoo);library(scales);library(extrafont);library(grid);library(RPostgreSQL)
library(ggmap);library(rgdal);library(maptools);library(readr);library(minpack.lm)
gpclibPermit()
mydb <- dbConnect(MySQL(), user='root', password='1234', dbname='citibike', host='localhost')
dbListTables(mydb) 

#############################################################################################
#######################################################
######## monthly trip data overview 
t <- dbSendQuery(mydb, 'select * from tripcounts')
daily = fetch(t, n=-1)
daily = daily %>%
        mutate(dow = factor(dow, labels = c("Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat")),
               monthly = rollsum(trips, k = 15, na.pad = TRUE, align = "right"))
daily$monthly <- daily$monthly/1000

daily$date <- as.Date(daily$date)
        png("citibike/picts/monthly_total_trips.png", width = 640, height = 480)
        ggplot(data = daily, aes(x = date, y = monthly)) +
                labs(title="NYC MONTHLY CITIBIKE TRIPS") +
                geom_line(size = 1, color = "darkgreen") +
                scale_x_date("Month") +
                scale_y_continuous("Citi Bike trips, trailing 15 days/Unit: thousands") +
                expand_limits(y = 0) 
        dev.off()

#############################################################################################
########################################################################################
######## weekday vs weekend trip data overview      
by_dow = daily %>%
        filter(date >= "2013-07-01") %>%
        group_by(dow) %>%
        summarize(avg = mean(trips))

by_dow$weekday <- "weekday"
by_dow[by_dow$dow=="Sun",]$weekday <- "weekend"
by_dow[by_dow$dow=="Sat",]$weekday <- "weekend"

png(filename = "citibike/picts/trips_by_weekday.png", width = 640, height = 420)
ggplot(data = by_dow, aes(x = dow, y = avg, fill=weekday)) +
        geom_bar(stat="identity",position="dodge", colour="black") +
        labs(title="NYC AVG DAILY CITIBIKE TRIPS")+
        scale_x_discrete("Weekdays") +
        scale_y_continuous("Avg daily trips\n", labels = comma) +
        expand_limits(y = 0) 
dev.off()

#############################################################################################
############################################################################################
######## monthly trip data overview     
by_hour = query("SELECT * FROM aggregate_data_hourly ORDER BY weekday, hour")
by_hour = by_hour %>%
        mutate(timestamp_for_x_axis = as.POSIXct(hour * 3600, origin = "1970-01-01", tz = "UTC"),
               weekday = factor(weekday, levels = c(TRUE, FALSE), labels = c("Weekdays", "Weekends")),
               avg = trips / number_of_days)

png(filename = "citibike/picts/trips_by_hour.png", width = 640, height = 720)
ggplot(data = by_hour, aes(x = timestamp_for_x_axis, y = avg)) +
        geom_bar(stat = "identity", fill = citi_hex) +
        scale_x_datetime("", labels = date_format("%l %p")) +
        scale_y_continuous("Avg hourly Citi Bike trips\n", labels = comma) +
        title_with_subtitle("NYC Citi Bike Trips by Hour of Day", "Based on Citi Bike system data 9/2015–11/2015") +
        facet_wrap(~weekday, ncol = 1) +
        theme_tws(base_size = 20) +
        theme(strip.background = element_blank(),
              strip.text = element_text(size = rel(1)),
              panel.margin = unit(1.2, "lines"))
dev.off()



