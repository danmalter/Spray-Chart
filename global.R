library(ggvis)
library(pitchRx)
library(dplyr)
library(shiny)
library(shinyapps)
library(shinydashboard)
library(Lahman)


   files <- c("inning/inning_hit.xml", "miniscoreboard.xml", "players.xml")
   my_db <- src_sqlite("MLB2014.sqlite3", create = TRUE)
   scrape(start = "2014-03-30", end = "2014-09-30", connect = my_db$con, suffix = files)
   
   locations <- select(tbl(my_db2, "hip"), des, x, y, batter, pitcher, type, team, inning)
   locations <- as.data.frame(locations)
   batters <- select(tbl(my_db2, "player"), first, last, id, bats, team_abbrev)
   batters <- as.data.frame(batters, n=-1)
   batters$full.name <- paste(batters$first, batters$last, sep = " ")
   names(batters)[names(batters) == 'id'] <- 'batter'
   
   spraychart <- merge(locations, batters, by="batter") 

   spraychart.top10 <- subset(spraychart, full.name == "Jose Altuve" | full.name == "Victor Martinez" |
                                full.name == "Michael Brantley" | full.name == "Adrian Beltre" | full.name == "Justin Morneau" |
                               full.name == "Jose Abreu" | full.name == "Josh Harrison" | full.name == "Robinson Cano" | 
                               full.name == "Andrew McCutchen" | full.name == "Miguel Cabrera")
  spraychart.top10 <- unique(spraychart.top10)
  spraychart.top10$des <- as.factor(spraychart.top10$des)
  
  spraychart.top10$des <- factor(spraychart.top10$des,
                                 levels=c("Batter Interference", "Bunt Groundout", "Bunt Pop Out", "Double",
                                          "Error", "Fan interference", "Field Error", "Flyout", "Groundout",
                                          "Home Run", "Lineout", "Pop Out", "Single", "Triple"),
                                 labels=c("Other","Out", "Out", "Double", "Error", 
                                          "Other", "Error", "Out", "Out", "Home Run",
                                          "Out", "Out", "Single", "Triple"))


# For ease of loading into a Shiny app, I uploaded spraychart.top10 into Dropbox and loaded a csv file from there.
spraychart <- paste("https://www.dropbox.com/s/nrbehu5ypvzufqd/spraychart.csv?dl=0")
spraychart <- repmis::source_data(spraychart, sep = ",", header = TRUE)

# Player data stats
Master$name <- paste(Master$nameFirst, Master$nameLast, sep=' ')

bstats <- battingStats(data = Lahman::Batting, 
                       idvars = c("playerID", "yearID", "stint", "teamID", "lgID"), 
                       cbind = TRUE)
batting <- merge(bstats,
                 Master[,c("playerID","name")],
                 by="playerID", all.x=TRUE)

batting <- subset(batting, name == "Jose Altuve" | name == "Victor Martinez" |
                   name == "Michael Brantley" | name == "Adrian Beltre" | name == "Justin Morneau" |
                   name == "Jose Abreu" | name == "Josh Harrison" | name == "Robinson Cano" | 
                   name == "Andrew McCutchen" | name == "Miguel Cabrera")
