library(shiny);library(shinydashboard)
library(leaflet)
library(RColorBrewer)
library(scales)
library(lattice)
library(dplyr)
library(ggplot2)
library(plotly)


vars <- c(
    "Which year put in service?" = "year",
    "Boros" = "boro",
    "Avarage daily trips" = "daily_trips"
)

size <- c(
    "Same size" = "same",
    "Popularity Score" = "rank_score",
    "Avarage daily trips" = "daily_trips"
)

shinyUI(dashboardPage(skin = "purple", 
                      
                      dashboardHeader(title= strong("NYC Citibike Analysis"),titleWidth=250,
                                      
#                                       dropdownMenu(type = "messages",
#                                                    messageItem(
#                                                        from = "Sales Dept",
#                                                        message = "Sales are steady this month."
#                                                    )
#                                       ),
#                                       
#                                       
#                                       dropdownMenu(type = "notifications",
#                                                    notificationItem(
#                                                        text = "5 new users today",
#                                                        icon("users")
#                                                    )
#                                       ),
                                      
                                      
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
                              menuItem("Geographics",tabName = "geo",icon=icon("calendar")),
                              menuItem("Exploratory Analysis", tabName = "eda", icon = icon("dashboard")),
                              #menuItem("Modeling", tabName = "modeling", icon = icon("th"),badgeLabel = "new", badgeColor = "green"),
                              menuItem("About", tabName = "about", icon=icon("mortar-board"),
                                       menuSubItem("Source Code (Github)", icon = icon("file-code-o"), 
                                                   href = "https://github.com/richarddeng88"),
                                       menuSubItem("others", icon = icon("file-code-o")))
#                               menuItem("Source Code (Github) ", icon = icon("file-code-o"), 
#                                        href = "https://github.com/richarddeng88"),
#                               menuItem("Linkin Profile ", icon = icon("file-code-o"), 
#                                        href = "https://linkedin.com/in/richarddeng88")
                              
                          )
                      ),
                      
                      
                      
                      
                      body <- dashboardBody(
                          tabItems(
                              # First tab content
                              tabItem(tabName = "eda",
                                      tabsetPanel("EDA",
                                          tabPanel(strong("Trips Explorer"),
                                                   fluidRow(
                                                       column(width=4,
                                                            box(width = NULL,
                                                                title = "Controls:",
                                                                dateRangeInput("date","Input date:",format = "yyyy-mm-dd",start="2013-07-01",end= "2016-03-31", 
                                                                               min = "2013-07-1",max = "2016-03-31"),
                                                                sliderInput("hour", "Time of a day (12am - 12pm):", 0, 23, value = c(0, 23)),
                                                                radioButtons("weekday","Is it weekend?", c("Weekday","Weekend")),
                                                                radioButtons("gender","Gender:", c("Male","Female"))
                                                                
                                                            )
                                                   ),
                                                   
                                                   column(width = 8,
                                                          tabBox(  width = NULL, 
                                                              tabPanel(title = strong("Daily Trips by Hour"),
#                                                                        collapsible = TRUE,
#                                                                        status = "primary", solidHeader = TRUE,
                                                                textOutput("date_start"),
                                                                textOutput("date_end"),
                                                                plotlyOutput("plot")
                                                                ),
                                                              tabPanel(title=strong("Daily Trips by Month"),
                                                                textOutput("date_start1"),
                                                                textOutput("date_end1"),
                                                                plotlyOutput("plot1")
                                                                       )
                                                                )
                                                   )
                                                   )
              
                                          ),
                                          
                                          tabPanel(strong(" "),
                                              fluidRow(
#                                                   column(width=4,
#                                                      box(width = NULL,
#                                                          radioButtons("a","click", c("a","b")),
#                                                          dateRangeInput("date","Input date:",format = "yyyy-mm",start="2013-07-01",end= "2016-03-31", 
#                                                                         min = "2013-07-1",max = "2016-03-31"),
#                                                          sliderInput("hour", "Hours of a day:", 1, 24, value = c(1, 24))
#                                                          )
#                                                       
#                                                   )

                                              )

                                                   )
                                          
                                      )
    



                              ),
                              
                              # Second tab content
                              tabItem(tabName = "modeling",
                                      fluidRow(
                                          box(title="aa",
                                              sliderInput("c","c",1,100,1))
                                      )

                              ),
                              
                              
                              # Third tab content
                              tabItem(tabName = "geo",
                                      h2("Geographic tab content"),
                                      fluidRow("Interactive map",
                                                
                                                    div(class="outer",
                                                        
                                                        tags$head(
                                                            # Include our custom CSS
                                                            includeCSS("styles.css"),
                                                            includeScript("gomap.js")
                                                        ),
                                                        
                                                        leafletOutput("map", width="100%", height="100%"),
                                                        
                                                        # Shiny versions prior to 0.11 should use class="modal" instead.
                                                        absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
                                                                      draggable = TRUE, top = 60, left = "auto", right = 10, bottom = "auto",
                                                                      width = 350, height = "auto",
                                                                      
                                                                      h2("Station Exploration"),
                                                                      
                                                                      selectInput("color", "Color", vars),
                                                                      selectInput("size", "Size", size, selected = "same"),
                                                                      
                                                                      plotOutput("histCentile", height = 200),
                                                                      plotOutput("scatterCollegeIncome", height = 250)
                                                        ),
                                                        
                                                        tags$div(id="cite",
                                                                 'Data compiled for ', tags$em('NYC Citi Bike Project'), ' by Qing (Richard) Deng (2016).')
                                                    )
                                                    
                                                    
                                      )
                                      
                              )
                          )
                          
                          
                      )
)

    
    
    
    

    )