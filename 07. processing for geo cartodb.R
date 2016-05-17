library(dplyr)
one_day <- read.csv("citibike/one_day from 6am to 10pm.csv", stringsAsFactors = F)
one_day <- arrange(one_day, starttime)

df1 <- read.csv("citibike/geodata/1.csv", stringsAsFactors = F)
df2 <- read.csv("citibike/geodata/2.csv", stringsAsFactors = F)
df3 <- read.csv("citibike/geodata/3.csv", stringsAsFactors = F)
df4 <- read.csv("citibike/geodata/2488.csv", stringsAsFactors = F)

df <- rbind(df1,df2,df3,df4)
df <- select(df, -X)
df <- group_by(df, index)
df <-mutate(df_g, sum= sum(duration))


middle <- select(one_day, index, starttime, start.station.id, start.station.latitude,
                 start.station.longitude )
middle1 <- select(one_day, index, starttime, start.station.id)
names(middle) <- c("index", "starttime", "station_id", "latitude", "longitude")
a <- merge(middle1, df, by.x= "index", by.y="index", all.x=F, all.y = T)
names(a) <- c("index", "starttime", "station_id", "latitude", "longitude","duration","sum")
middle$duration <-0; middle$sum <- 0

d <- a[1,];d$index<-0
for (i in 1:2400){
    b <- a[a$index==i,]
    c <- middle[middle$index==i,]
    d <- rbind(d,c,b)
}

write.csv(one_day, file="geo_for_cartodb.csv",row.names = F)


############################ cycling time and distance estimation using googlemaps api in python#####################

df1 <- read.csv("citibike/dis_estimation0516/1.csv", stringsAsFactors = F)
a <- df[1,]

for (i in 1:9) {
    
    url <- paste("citibike/dis_estimation0516/",i,".csv",sep="")
    df <- read.csv(url, stringsAsFactors = F)
    a <- rbind(a,df)
}

file <- a[-1,]
write.csv(file, "citibike/dis_estimation.csv", row.names = F)


