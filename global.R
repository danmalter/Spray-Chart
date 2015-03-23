library(ggvis)
library(pitchRx)
library(dplyr)
library(shiny)
library(shinyapps)
library(shinydashboard)
library(Lahman)

# files <- c("inning/inning_hit.xml", "players.xml", "miniscoreboard.xml")
# my_db <- src_sqlite("MLB2014.sqlite3", create = TRUE)
# scrape(start = "2014-03-30", end = "2014-09-30", connect = my_db$con, suffix = files)
# 
# # There is no key that allows the tables to be joined through sqlite, so I write to a dataframe.
# locations <- select(tbl(my_db, "hip"), des, x, y, batter, pitcher, type, team, inning)
# locations <- as.data.frame(locations, n=-1)
# locations <- locations[!duplicated(locations),]
# names(locations)[names(locations) == 'batter'] <- 'batter.id'
# names(locations)[names(locations) == 'pitcher'] <- 'pitcher.id'
# 
# batters <- select(tbl(my_db, "player"), first, last, id, bats, team_abbrev)
# batters <- as.data.frame(batters, n=-1)
# batters <- batters[!duplicated(batters),]
# batters$full.name <- paste(batters$first, batters$last, sep = " ")
# names(batters)[names(batters) == 'id'] <- 'batter.id'
# batters <- batters[,-c(1,2)]
# 
# players <- as.data.frame(players, n=-1)
# names(players)[names(players) == 'id'] <- 'player.id'
# 
# # If scraping the whole season, you will need to take out non-mlb regular season games.
# batters <- batters[ !grepl("AL", batters$team_abbrev) , ]
# batters <- batters[ !grepl("NL", batters$team_abbrev) , ]
# batters <- batters[ !grepl("VER", batters$team_abbrev) , ]
# 
# # Merge the batters, location and players tables together.
# spraychart <- merge(locations, batters, by="batter.id")
# spraychart <- merge(spraychart, players, by.x="pitcher.id", by.y="player.id")
# names(spraychart)[names(spraychart) == 'full.name'] <- 'batter.name'
# names(spraychart)[names(spraychart) == 'full_name'] <- 'pitcher.name'
# names(spraychart)[names(spraychart) == 'des'] <- 'Description'


# To speed up the processing speed, I uploaded spraychart into Dropbox and reloaded the csv file from there.
#write.csv(spraychart, "spraycharts.csv")
spraychart <- paste("https://www.dropbox.com/s/nlunrtjgniw3bmg/spraycharts.csv?dl=0")
spraychart <- repmis::source_data(spraychart, sep = ",", header = TRUE)

# Player data stats for table
Master$name <- paste(Master$nameFirst, Master$nameLast, sep=' ')

bstats <- battingStats(data = Lahman::Batting, 
                       idvars = c("playerID", "yearID", "stint", "teamID", "lgID"), 
                       cbind = TRUE)
batting <- merge(bstats,
                 Master[,c("playerID","name")],
                 by="playerID", all.x=TRUE)

