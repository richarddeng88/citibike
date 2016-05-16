library(dplyr)
one_day <- read.csv("citibike/one_day.csv", stringsAsFactors = F)
one_day <- arrange(one_day, starttime)

df1 <- read.csv("citibike/geodata/1.csv", stringsAsFactors = F)
df2 <- read.csv("citibike/geodata/2.csv", stringsAsFactors = F)
df3 <- read.csv("citibike/geodata/3.csv", stringsAsFactors = F)
df4 <- read.csv("citibike/geodata/2488.csv", stringsAsFactors = F)

df <- rbind(df1,df2,df3,df4)








