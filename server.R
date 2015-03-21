library(ggvis)
library(pitchRx)
library(dplyr)
library(shinydashboard)

shinyServer(function(input, output, session) {
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
  
  # Create tooltip
  spraychart$id <- 1:nrow(spraychart)
  
  all_values <- function(x) {
    if(is.null(x)) return(NULL)
    
    paste0(spraychart$full.name[x$id],
           "<br>",
           spraychart$des[x$id]
    )
  }
  
  
  # Generate your plot using ggvis with reactive inputs      
  gv <- reactive({
    if (input$player !='') spraychart <- spraychart[which(spraychart$full.name==input$player),]
  })
  
  gv %>%
    ggvis(~x, ~-y) %>%
    layer_points(size := 30, size.hover := 200, fill = ~des, key:=~id) %>%
    scale_numeric("x", domain = c(0, 250), nice = FALSE) %>%
    scale_numeric("y", domain = c(0, -250), nice = FALSE) %>%
    hide_legend("stroke") %>%
    add_tooltip(all_values, "hover") %>%
    bind_shiny("plot", "plot_ui")
  
  # Output data table
  output$table <- renderDataTable({    
    unique(spraychart[, c("full.name", "team_abbrev")])
  })

  
})
