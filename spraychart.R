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

# There is no key that allows the tables to be joined, so I write to a dataframe.
locations <- select(tbl(my_db, "hip"), des, x, y, batter, pitcher, type, team, inning)
locations <- as.data.frame(locations, n=-1)
locations <- locations[!duplicated(locations),]
names(locations)[names(locations) == 'batter'] <- 'batter.id'
names(locations)[names(locations) == 'pitcher'] <- 'pitcher.id'

batters <- select(tbl(my_db, "player"), first, last, id, bats, team_abbrev)
batters <- as.data.frame(batters, n=-1)
batters <- batters[!duplicated(batters),]
batters$full.name <- paste(batters$first, batters$last, sep = " ")
names(batters)[names(batters) == 'id'] <- 'batter.id'
batters <- batters[,-c(1,2)]

players <- as.data.frame(players, n=-1)
names(players)[names(players) == 'id'] <- 'player.id'

# If scraping the whole season, you will need to take out non-mlb regular season games.
batters <- batters[ !grepl("AL", batters$team_abbrev) , ]
batters <- batters[ !grepl("NL", batters$team_abbrev) , ]
batters <- batters[ !grepl("VER", batters$team_abbrev) , ]

# Merge the batters and location tables together.
spraychart <- merge(locations, batters, by="batter.id")
spraychart <- merge(spraychart, players, by.x="pitcher.id", by.y="player.id")
names(spraychart)[names(spraychart) == 'full.name'] <- 'batter.name'
names(spraychart)[names(spraychart) == 'full_name'] <- 'pitcher.name'
names(spraychart)[names(spraychart) == 'des'] <- 'Description'

# Subset to only look at Jose Abreu's spray chart
spraychart <- subset(spraychart, batter.name=="Jose Abreu")

# Create ggvis tooltip  
spraychart$id <- 1:nrow(spraychart)

all_values <- function(x) {
    if(is.null(x)) return(NULL)
    
    paste0("Pitcher: ",
           spraychart$pitcher.name[x$id],
           "<br>",
           spraychart$Description[x$id]
    )

  if(is.null(x)) return(NULL)
  
  paste0("Pitcher: ",
         spraychart$pitcher.name[x$id],
         "<br>",
         spraychart$Description[x$id]
  )
}


spraychart %>%
    ggvis(~x, ~-y+250) %>%
    layer_points(size := 30, size.hover := 200, fill = ~Description, key:=~id) %>%
    scale_numeric("x", domain = c(0, 250), nice = FALSE) %>%
    scale_numeric("y", domain = c(0, 250), nice = FALSE) %>%
    hide_legend("stroke") %>%
    add_tooltip(all_values, "hover") %>%
    add_axis("x", title = "x") %>%
    add_axis("y", title = "y") %>%
    add_axis("x", orient = "top", ticks = 0, title = 'Jose Abreu 2014 Spray Chart',
             properties = axis_props(
                 axis = list(stroke = "white"),
                 title = list(fontSize = 12),
                 labels = list(fontSize = 0)
             ))

  ggvis(~x, ~-y+250) %>%
  layer_points(size := 30, size.hover := 200, fill = ~Description, key:=~id) %>%
  scale_numeric("x", domain = c(0, 250), nice = FALSE) %>%
  scale_numeric("y", domain = c(0, 250), nice = FALSE) %>%
  hide_legend("stroke") %>%
  add_tooltip(all_values, "hover") %>%
  add_axis("x", title = "x") %>%
  add_axis("y", title = "y") %>%
  add_axis("x", orient = "top", ticks = 0, title = 'Jose Abreu 2014 Spray Chart',
           properties = axis_props(
             axis = list(stroke = "white"),
             title = list(fontSize = 12),
             labels = list(fontSize = 0)))
           ))
