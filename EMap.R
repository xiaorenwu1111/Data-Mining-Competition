library(pacman)
p_load(tidyverse, data.table, geosphere, grid, jpeg, plyr)
library("tidyverse")
library("data.table")
library("geosphere")
library("grid")
library("jpeg")
library(dplyr)
download.file("https://raw.githubusercontent.com/jpatokal/openflights/master/data/airlines.dat",destfile = "airlines.dat", mode = "wb")
download.file("https://raw.githubusercontent.com/jpatokal/openflights/master/data/airports.dat",destfile = "airports.dat", mode = "wb")
download.file("https://raw.githubusercontent.com/jpatokal/openflights/master/data/routes.dat",destfile = "routes.dat", mode = "wb")
airlines <- fread("airlines.dat", sep = ",", skip = 1)
airports <- fread("airports.dat", sep = ",")
routes <- fread("routes.dat", sep = ",")
#添加列名
colnames(airlines) <- c("airline_id", "name", "alias", "iata", "icao", "callisign", "country", "active")
colnames(airports) <- c("airport_id", "name", "city", "country","iata", "icao", "latitude", "longitude","altitude", "timezone","dst","tz_database_time_zone","type", "source")
colnames(routes) <- c("airline", "airline_id", "source_airport", "source_airport_id","destination_airport","destination_airport_id","codeshare", "stops","equipment")
#类型转换
routes$airline_id <- as.numeric(routes$airline_id)
# airlines与routes数据融合

flights <- left_join(routes, airlines, by="airline_id")
# flights与airports数据融合
airports_orig <- airports[,c(5,7,8)]
colnames(airports_orig) <- c("source_airport","source_airport_lat", "source_airport_long")
airports_dest <- airports[, c(5, 7, 8)]
colnames(airports_dest) <- c("destination_airport", "destination_airport_lat", "destination_airport_long")
flights <- left_join(flights, airports_orig, by = "source_airport")
flights <- left_join(flights, airports_dest, by = "destination_airport")
#剔除缺失值
flights <- na.omit(flights, cols = c("source_airport_long", "source_airport_lat", "destination_airport_long", "destination_airport_lat"))
#最后数据如下
head(flights[,c(1:5)])

# 按航空公司拆分数据集
flights_split <- split(flights, flights$name)
# Calculate intermediate points between each two locations
flights_all <- lapply(flights_split, function(x) gcIntermediate(x[, c("source_airport_long", "source_airport_lat")], x[, c("destination_airport_long", "destination_airport_lat")], n=100, breakAtDateLine = FALSE, addStartEnd = TRUE, sp = TRUE))



# 转换为数据框
flights_fortified <- lapply(flights_all, function(x) ldply(x@lines, fortify))

# Unsplit lists
flights_fortified <- do.call("rbind", flights_fortified)
# Add and clean column with airline names

flights_fortified$name <- rownames(flights_fortified)

flights_fortified$name <- gsub("\\..*", "", flights_fortified$name)



# Extract first and last observations for plotting source and destination points (i.e., airports)

flights_points <- flights_fortified %>%
  
  group_by(group) %>%
  
  filter(row_number() == 1 | row_number() == n())


#下载图片
download.file("https://www.nasa.gov/specials/blackmarble/2016/globalmaps/BlackMarble_2016_01deg.jpg",destfile = "BlackMarble_2016_01deg.jpg", mode = "wb")
#加载并渲染图片
earth <- readJPEG("BlackMarble_2016_01deg.jpg", native = TRUE)
earth <- rasterGrob(earth, interpolate = TRUE)



install.packages('maps')

library(maps)

map("world", fill = TRUE, col = rainbow(200),ylim = c(-60, 90), mar = c(0, 0, 0, 0))

title("世界地图")

library(maps)

install.packages("mapdata")

library(mapdata)
map("china", col = "red4", ylim = c(18, 54), panel.first = grid())

title(" 中国地图")
