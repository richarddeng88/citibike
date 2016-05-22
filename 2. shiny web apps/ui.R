library(shiny);library(shinydashboard)
library(leaflet)
library(RColorBrewer)
library(scales)
library(lattice)
library(dplyr)
library(ggplot2)


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
                              menuItem("Geographics",tabName = "geo",icon=icon("calendar")),
                              menuItem("Exploratory Data Analysis", tabName = "eda", icon = icon("dashboard")),
                              menuItem("Modeling", tabName = "modeling", icon = icon("th"),badgeLabel = "new", badgeColor = "green"),
                              menuItem("About", tabName = "about", icon=icon("mortar-board"),
                                       menuSubItem("Source Code (Github)", icon = icon("file-code-o"), 
                                                   href = "https://github.com/richarddeng88"),
                                       menuSubItem("Linkin Profile", icon = icon("file-code-o"), 
                                                   href = "https://linkedin.com/in/richarddeng88"))
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
                                          tabPanel(strong("History Record"),
                                                   fluidRow(
                                                       column(width=4,
                                                            box(width = NULL,
                                                                title = strong("Controls"),
                                                                dateRangeInput("date","Input date:",format = "yyyy-mm",start="2013-07-01",end= "2016-03-31", min = "2013-07-1",max = "2016-03-31"),
                                                                sliderInput("slider", "Number of observations:", 1, 100, 50),
                                                                sliderInput("slider", "Number of observations:", 1, 100, 50),
                                                                radioButtons("weekday","click", c("Weekday","Weekend")),
                                                                radioButtons("gender","click", c("Male","Female"))
                                                                
                                                                
                                                            ),
                                                            box(width = NULL,plotOutput("plot1", height = 250))
                                                   ),
                                                   column(width = 8,
                                                          box(  width = NULL, collapsible = TRUE,
                                                                title = "aa", status = "primary", solidHeader = TRUE)
                                                   )
                                                   )
              
                                          ),
                                          
                                          tabPanel(strong("Daily Explorer"),
                                              box(
                                                  radioButtons("a","click", c("a","b")),
                                                  sliderInput("hour", "Hours of a day:", 1, 24, value = c(1, 24)))
                                                  
                                                   )
                                          
                                      )
    



                              ),
                              
                              # Second tab content
                              tabItem(tabName = "modeling",
                                      h2("Widgets tab content"),
                                      fluidRow(
                                          column(width = 4, 
                                                 tabBox( width = NULL,
                                                         tabPanel(h5("parameters"),
                                                                  
                                                                  sliderInput("k", "k:", value = 0.1, min = 0, max = 2, step=0.05)
                                                         ),
                                                         tabPanel(h5("dosage"),
                                                                  sliderInput("tfd", "Time of first dose:", value=0, min=0, max = 20, step=1),
                                                                  sliderInput("nd", "Number of doses:", value=1, min=0, max = 10, step=1),
                                                                  sliderInput("ii", "Interdose interval:", value = 9, min = 0.5, max = 15, step=0.5),
                                                                  sliderInput("amt", "Amount:", value = 5, min = 0, max = 20, step=1)
                                                         )
                                                 )),
                                          
                                          
                                          column(width = 8,
                                                 box(  width = NULL, plotOutput("plot",height="500px"), collapsible = TRUE,
                                                       title = "Plot", status = "primary", solidHeader = TRUE)
                                          ))
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
                                                                      draggable = TRUE, top = 50, left = "auto", right = 10, bottom = "auto",
                                                                      width = 300, height = "auto",
                                                                      
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