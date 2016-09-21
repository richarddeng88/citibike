library(RMySQL)
mydb <- dbConnect(MySQL(), user='root', password='1234', dbname='citibike', host='localhost')

dbListTables(mydb) # this will return the name of the tables. 
dbListFields(mydb, 'store') # This will return a list of the tables in our connection. 
dbListFields(mydb, 'tripdata')

#Running Queries:
t <- dbSendQuery(mydb, 'select * from nyctrip')
employees = fetch(t, n=-1)

## 
library(dplyr)
a <- arrange(citi, starttime)
