## ui.R

shinyUI(dashboardPage(skin="black",
                      dashboardHeader(title = "Hitters in Baseball"),
                      dashboardSidebar(
                        sidebarMenu(
                          menuItem("Spray Charts", tabName = "offensiveSprayChart", icon = icon("star-o")),
                          menuItem("About", tabName = "about", icon = icon("question-circle")),
                          menuItem("Source code", icon = icon("file-code-o"), 
                                   href = "https://github.com/danmalter/Batting"),
                          menuItem(
                            selectInput("player",
                                        label = h5("Top 10 Batting Averages 2014"),
                                        choices = list("Jose Altuve", "Victor Martinez", "Michael Brantley", "Adrian Beltre", 
                                                       "Justin Morneau", "Jose Abreu", "Josh Harrison", 
                                                       "Robinson Cano", "Andrew McCutchen", "Miguel Cabrera"),
                                          #list(textInput("player", label = h5("Player Name"), value="Jose Abreu"),
                                              HTML
                                              ("<div style='font-size: 12px;'> - You must have a player chosen.</div>")
                            )
                          )
                        )
                      
                      
                        
                      ),
                      
                      
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
                                        
                                        helpText(p(strong("This application is meant to compare the offensive statistics for any player in MLB history between 1901 and 2013."))),
                                        
                                        helpText(p("Please contact",
                                                   a(href ="https://twitter.com/danmalter", "Danny on twitter",target = "_blank"),
                                                   " or at my",
                                                   a(href ="http://danmalter.github.io/", "personal page", target = "_blank"),
                                                   ", for more information, to suggest improvements or report errors.")),
                                        
                                        helpText(p("All code and data is available at ",
                                                   a(href ="https://github.com/danmalter/Batting", "my GitHub page",target = "_blank"),
                                                   "or click the 'source code' link on the sidebar on the left."
                                        ))
                                        
                                    )
                                  )
                          ),
                          tabItem(tabName = "offensiveSprayChart",

                          box(ggvisOutput("plot"), title = "Spray Charts (Top 10 Batting Avgerages - 2014)", width=15, collapsible = TRUE),
                          HTML('<br/>'),
                          box(dataTableOutput("table"), title = "Table of Players", width=15, collapsible = TRUE))
                          
                        )
                        
                        
                        
                  )
                      
      )
)

