library(mosaic)
library(ggplot2)
library(ggvis)
library(dplyr)
library(ggplot2)
library(RSQLite)
library(pitchRx)

files <- c("inning/inning_hit.xml", "players.xml", "miniscoreboard.xml")
my_db <- src_sqlite("MLB2014.sqlite3", create = TRUE)
scrape(start = "2014-03-30", end = "2014-09-30", connect = my_db$con, suffix = files)

# Simple example to demonstrate database query using dplyr
# Note that 'num' and 'gameday_link' together make a key that allows us to join these tables
locations <- select(tbl(my_db, "hip"), des, x, y, batter, pitcher, type, team, inning)
locations <- as.data.frame(locations, n=-1)
batters <- select(tbl(my_db, "player"), first, last, id, bats, team_abbrev)
batters <- as.data.frame(batters, n=-1)
names(batters)[names(batters) == 'id'] <- 'batter'

batters$full.name <- paste(batters$first, batters$last, sep = " ")
batters <- batters[ !grepl("AL", batters$team_abbrev) , ]
batters <- batters[ !grepl("NL", batters$team_abbrev) , ]
batters <- batters[ !grepl("VER", batters$team_abbrev) , ]

#write.csv(batters, "batters.csv")
#write.csv(locations, "locations.csv")

spraychart <- merge(locations, batters, by="batter")


que <- inner_join(locations, batters, by = NULL)
que$query #refine sql query if you'd like
pitchfx <- collect(que)
que <- merge(locations, batters)


locations <- as.data.frame(locations, n=-1)
batters <- select(tbl(my_db, "player"), first, last, id, bats, team_abbrev)
batters <- as.data.frame(batters, n=-1)
batters$full.name <- paste(batters$first, batters$last, sep = " ")
names(batters)[names(batters) == 'id'] <- 'batter'

spraychart <- merge(locations, batters, by="batter")
spraychart <- unique(spraychart)

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
