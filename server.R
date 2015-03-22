# server.R

shinyServer(function(input, output, session) {
  
  # Create tooltip
  spraychart$id <- 1:nrow(spraychart)
  
  all_values <- function(x) {
    if(is.null(x)) return(NULL)
    
    paste0("Pitcher: ",
           spraychart$pitcher.name[x$id],
           "<br>",
           spraychart$Description[x$id]
    )
  }
  
  
  # Generate your plot using ggvis with reactive inputs      
  gv <- reactive({
    if (input$player %in% spraychart$batter.name) spraychart <- spraychart[which(spraychart$batter.name==input$player),]
    spraychart <- subset(spraychart, Description %in% input$statistic)
  })
  
  gv %>%
    ggvis(~x, ~-y+250) %>%
    layer_points(size := 30, size.hover := 200, fill = ~Description, key:=~id) %>%
    scale_numeric("x", domain = c(0, 250), nice = FALSE) %>%
    scale_numeric("y", domain = c(0, 250), nice = FALSE) %>%
    hide_legend("stroke") %>%
    add_tooltip(all_values, "hover") %>%
    add_axis("x", title = "x") %>%
    add_axis("y", title = "y") %>%
    bind_shiny("plot", "plot_ui")
  
  
  # Output data table .... waiting for 2014 data in Lahman database
  output$table <- renderDataTable({    
    unique(spraychart[, c("batter.name", "team_abbrev")])
  })
  
  #   Aggregarte output data table .... waiting for 2014 data in Lahman database
  #   output$table <- renderDataTable({    
  #     aggregate(batting[c("G", "AB", "R", "H", "X2B", "X3B", "HR", "BB")], by=batting[c("name")], FUN=sum)
  #   })
  
})