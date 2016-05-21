library(shiny);library(shinydashboard)
library(leaflet)
library(RColorBrewer)
library(scales)
library(lattice)
library(dplyr)
library(ggplot2)


vars <- c(
    "Which year put in service?" = "year",
    "Boro" = "boro",
    "Avarage daily trips" = "daily_trips"
)

size <- c(
    "Same size" = "same",
    "Popularity Score" = "rank_score",
    "Avarage daily trips" = "daily_trips"
)

shinyUI(dashboardPage(skin = "purple", 
                      
                      dashboardHeader(title= "NYC Citibike Ridership Project",titleWidth=200,
                                      
                                      dropdownMenu(type = "messages",
                                                   messageItem(
                                                       from = "Sales Dept",
                                                       message = "Sales are steady this month."
                                                   )
                                      ),
                                      
                                      
                                      dropdownMenu(type = "notifications",
                                                   notificationItem(
                                                       text = "5 new users today",
                                                       icon("users")
                                                   )
                                      ),
                                      
                                      
                                      dropdownMenu(type = "tasks", badgeStatus = "success",
                                                   taskItem(value = 90, color = "green",
                                                            "Documentation"
                                                   )
                                      )
                                      
                      ),
                      
                      
                      sidebar <- dashboardSidebar(
                          sidebarMenu(
                              #sidebarUserPanel("Welcome to My Project !!!"),
                              sidebarSearchForm(textId = "searchText", buttonId = "searchButton",label = "Search..."),
                              menuItem("Geo",tabName = "geo",icon=icon("calendar")),
                              menuItem("Exploratory Analysis", tabName = "eda", icon = icon("dashboard")),
                              menuItem("Modeling", tabName = "modeling", icon = icon("th"),badgeLabel = "new", badgeColor = "green"),
                              menuItem("Github Source Code ", icon = icon("file-code-o"), 
                                       href = "https://github.com/richarddeng88"),
                              menuItem("My Linkin Profile ", icon = icon("file-code-o"), 
                                       href = "https://linkedin.com/in/richarddeng88")
                              
                          )
                      ),
                      
                      
                      
                      
                      body <- dashboardBody(
                          tabItems(
                              # First tab content
                              tabItem(tabName = "eda",
                                      fluidRow(
                                          box(plotOutput("plot1", height = 250)),
                                          box(
                                              title = "Controls",
                                              sliderInput("slider", "Number of observations:", 1, 100, 50),
                                              sliderInput("slider", "Number of observations:", 1, 100, 50)
                                          ),
                                          infoBox("new",20,icon=icon("credit card"))
                                          
                                      )
                              ),
                              
                              # Second tab content
                              tabItem(tabName = "modeling",
                                      h2("Widgets tab content")
                              ),
                              
                              
                              # Third tab content
                              tabItem(tabName = "geo",
                                      h2("Geographic tab content"),
                                      bootstrapPage("Interactive map",
                                                    
                                                    div(class="outer",
                                                        
                                                        tags$head(
                                                            # Include our custom CSS
                                                            includeCSS("styles.css"),
                                                            includeScript("gomap.js")
                                                        ),
                                                        
                                                        leafletOutput("map", width="100%", height="100%"),
                                                        
                                                        # Shiny versions prior to 0.11 should use class="modal" instead.
                                                        absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
                                                                      draggable = TRUE, top = 60, left = "auto", right = 20, bottom = "auto",
                                                                      width = 330, height = "auto",
                                                                      
                                                                      h2("Station Exploration"),
                                                                      
                                                                      selectInput("color", "Color", vars),
                                                                      selectInput("size", "Size", size, selected = "same"),
                                                                      
                                                                      plotOutput("histCentile", height = 200),
                                                                      plotOutput("scatterCollegeIncome", height = 250)
                                                        ),
                                                        
                                                        tags$div(id="cite",
                                                                 'Data compiled for ', tags$em('Coming Apart: The State of White America, 1960–2010'), ' by Charles Murray (Crown Forum, 2012).')
                                                    )
                                                    
                                                    
                                      )
                                      
                              )
                          )
                          
                          
                      )
)

    
    
    
    

    )