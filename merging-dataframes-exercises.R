# source: http://r-exercises.com/2016/04/14/merging-dataframes-exercises/

# Exercise 1

buildings <- data.frame(location=c(1, 2, 3), name=c("building1", "building2", "building3"))
data <- data.frame(survey=c(1,1,1,2,2,2), location=c(1,2,3,2,3,1), efficiency=c(51,64,70,71,80,58))

buildingStats <- merge(buildings, data, by = "location")

# Exercise 2

buildings <- data.frame(location=c(1, 2, 3), name=c("building1", "building2", "building3"))
data <- data.frame(survey=c(1,1,1,2,2,2), LocationID=c(1,2,3,2,3,1),
                   efficiency=c(51,64,70,71,80,58))

buildingStats <- merge(buildings, data, by.x = "location", by.y = "LocationID")

# Exercise 3: Inner Join

buildings <- data.frame(location=c(1, 2, 3), name=c("building1", "building2", "building3"))
data <- data.frame(survey=c(1,1,1,2,2,2), LocationID=c(1,2,3,2,3,1),
                   efficiency=c(51,64,70,71,80,58))

buildingStats <- merge(buildings, data)

# Exercise 4: Outer Join

buildings <- data.frame(location=c(1, 2, 3), name=c("building1", "building2", "building3"))
data <- data.frame(survey=c(1,1,1,2,2,2), location=c(1,2,3,2,3,1), efficiency=c(51,64,70,71,80,58))

buildingStats <- merge(buildings, data, by="location", all = TRUE)

# Exercise 5: Left Join

buildingStats <- merge(buildings, data, by="location", all.x = TRUE)

# Exercise 6: Right Join

buildingStats <- merge(buildings, data, by="location", all.y=TRUE)

# Exercise 7: Cross Join

buildingStats <- merge(buildings, data, by=NULL )

# Exercise 8: Merging Dataframe rows

buildings <- data.frame(location=c(1, 2, 3), name=c("building1", "building2", "building3"))
buildings2 <- data.frame(location=c(5, 4, 6), name=c("building5", "building4", "building6"))

allBuildings <- rbind(buildings, buildings2)

# Exercise 9

buildings3 <- data.frame(location=c(7, 8, 9),
                         name=c("building7", "building8", "building9"),
                         startEfficiency=c(75,87,91))

buildings3 <- buildings3[ , -3]

# Exercise 10

buildings3 <- data.frame(location=c(7, 8, 9),
                         name=c("building7", "building8", "building9"),
                         startEfficiency=c(75,87,91))

buildings[ , "startEfficiency"] <- NA

buildings2[ , "startEfficiency"] <- NA

allBuildings <- rbind(buildings, buildings2, buildings3)
