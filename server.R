# server.R

shinyServer(function(input, output, session) {
  
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
  #output$table <- renderDataTable({    
  #  batting[, c("name", "yearID", "BA", "SO", "HR", "H", "R", "X2B", "BB")]
  #})

  output$table <- renderDataTable({    
    aggregate(batting[c("G", "AB", "R", "H", "X2B", "X3B", "HR", "BB")], by=batting[c("name")], FUN=sum)
  })
  
})
