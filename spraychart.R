library(mosaic)
library(ggplot2)
library(ggvis)
library(dplyr)
library(ggplot2)
library(RSQLite)
library(pitchRx)
library(knitr)

files <- c("inning/inning_hit.xml", "miniscoreboard.xml", "players.xml")
my_db <- src_sqlite("MLB2014.sqlite3", create = TRUE)
my_db2 <- src_sqlite("MLB20140726.sqlite3", create = TRUE)
scrape(start = "2014-03-30", end = "2014-09-30", connect = my_db$con, suffix = files)

# Simple example to demonstrate database query using dplyr
# Note that 'num' and 'gameday_link' together make a key that allows us to join these tables
locations <- select(tbl(my_db, "hip"), des, x, y, batter, pitcher, type, team, inning)
locations <- as.data.frame(locations, n=-1)
batters <- select(tbl(my_db, "player"), first, last, id, bats, team_abbrev)
batters <- as.data.frame(batters, n=-1)
batters$full.name <- paste(batters$first, batters$last, sep = " ")
names(batters)[names(batters) == 'id'] <- 'batter'




spraychart <- merge(locations, batters, by="batter")
spraychart <- unique(spraychart)

spraychart.sox.cubs <- subset(spraychart, team_abbrev == "CWS" | team_abbrev == "CHC")
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

write.csv(spraychart.top10, "spraychart.csv")

spraychart$id <- 1:nrow(spraychart)

all_values <- function(x) {
  if(is.null(x)) return(NULL)
  
  paste0(spraychart$full.name[x$id],
         "<br>",
         spraychart$des[x$id]
  )
}


  spraychart %>%
    ggvis(~x, ~-y, stroke= ~full.name) %>%
    layer_points(size := 30, size.hover := 200, fill = ~type, key:=~id) %>%
    scale_numeric("x", domain = c(0, 250), nice = FALSE) %>%
    scale_numeric("y", domain = c(0, -250), nice = FALSE) %>%
    hide_legend("stroke") %>%
    add_tooltip(all_values, "hover")
