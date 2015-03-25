## ui.R

library(shiny)
library(shinyapps)
library(shinydashboard)


shinyUI(dashboardPage(skin="black",
                      dashboardHeader(title = "MLB Spray Charts"),
                      dashboardSidebar(
                        sidebarMenu(
                          menuItem("Spray Charts", tabName = "offensiveSprayChart", icon = icon("star-o")),
                          menuItem("Spray Charts", tabName = "offensiveSprayChart", icon = icon("star-o")),
                          menuItem("About", tabName = "about", icon = icon("question-circle")),
                          menuItem("Source code", icon = icon("file-code-o"), 
                                   href = "https://github.com/danmalter/Spray-Chart"),
                          menuItem(
                            list(textInput("player", label = h5("Player Name"), value="Jose Abreu"),
                                              HTML
                                              ("<div style='font-size: 12px;'> Player name must be spelled correctly.</div>"))),
                          menuItem(
                            checkboxGroupInput("pitcher", label = h5("Pitcher Throw Type:"),
                                               c("Left Handed Pitcher"="L", "Right Handed Pitcher"="R"),
                                               selected=c("Left Handed Pitcher", "Right Handed Pitcher"), 
                                               inline = TRUE)), 
                          menuItem(
                            checkboxGroupInput("statistic", label = h5("Statistic:"),
                                             c("Bunt Out", "Flyout", "Groundout", "Lineout", 
                                               "Pop Out", "Home Run", "Single", "Double", "Triple", "Error", "Other"),
                                             selected=c("Bunt Out", "Flyout", "Groundout", "Lineout",
                                                        "Pop Out", "Home Run", "Single", "Double", "Triple",
                                                        "Error", "Other"), 
                                             inline = TRUE))  
                          )
                        )
                      ,
                      
                      
                      dashboardBody(
                        tags$head(
                          tags$style(type="text/css", "select { max-width: 360px; }"),
                          tags$style(type="text/css", ".span4 { max-width: 360px; }"),
                          tags$style(type="text/css",  ".well { max-width: 360px; }")
                        ),
                        
                        tabItems(  
                          tabItem(tabName = "about",
                                  h2("About this App"),
                                  
                                  HTML('<br/>'),
                                  
                                  fluidRow(
                                    box(title = "Author: Danny Malter", background = "black", width=7, collapsible = TRUE,
                                        
                                        helpText(p(strong("This application shows the spray charts for the selected MLB players.  X and Y coordinates are scraped off of mlb.com."))),
                                        
                                        helpText(p("Please contact",
                                                   a(href ="https://twitter.com/danmalter", "Danny on twitter",target = "_blank"),
                                                   " or at my",
                                                   a(href ="http://danmalter.github.io/", "personal page", target = "_blank"),
                                                   ", for more information, to suggest improvements or report errors.")),
                                        
                                        helpText(p("All code and data is available at ",
                                                   a(href ="https://github.com/danmalter/Spray-Chart", "my GitHub page",target = "_blank"),
                                                   "or click the 'source code' link on the sidebar on the left."
                                        ))
                                        
                                    )
                                  )
                          ),
                          tabItem(tabName = "offensiveSprayChart",

                          box(ggvisOutput("plot"), title = "MLB Spray Charts - 2014", width=12, collapsible = TRUE),
                          HTML('<br/>'),
                          box(dataTableOutput("table"), title = "Table of Players", width=12, collapsible = TRUE))
                          
                        )
                        
                        
                        
                  )
                      
      )
)