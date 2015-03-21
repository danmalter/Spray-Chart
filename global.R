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
   
   locations <- select(tbl(my_db, "hip"), des, x, y, batter, pitcher, type, team, inning)
   locations <- as.data.frame(locations)
   batters <- select(tbl(my_db, "player"), first, last, id, bats, team_abbrev)
   batters <- as.data.frame(batters, n=-1)
   batters$full.name <- paste(batters$first, batters$last, sep = " ")
   names(batters)[names(batters) == 'id'] <- 'batter'
   
   spraychart <- merge(locations, batters, by="batter") 
   names(spraychart)[names(spraychart) == 'des'] <- 'Description'


# For ease of loading into a Shiny app, I uploaded spraychart into Dropbox, did a bit of cleaning and reloaded the csv file from there.
spraychart <- paste("https://www.dropbox.com/s/nlunrtjgniw3bmg/spraycharts.csv?dl=0")
spraychart <- repmis::source_data(spraychart, sep = ",", header = TRUE)

# Player data stats
Master$name <- paste(Master$nameFirst, Master$nameLast, sep=' ')

bstats <- battingStats(data = Lahman::Batting, 
                       idvars = c("playerID", "yearID", "stint", "teamID", "lgID"), 
                       cbind = TRUE)
batting <- merge(bstats,
                 Master[,c("playerID","name")],
                 by="playerID", all.x=TRUE)

