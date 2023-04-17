# Load libraries
library(shiny)
library(shinyjs)
library(shinydashboard)
library(fresh)
library(dplyr)
library(ggplot2)
library(tidyverse)
library(DT)
library(rsconnect)
library(stringr)

# Reads most recent CSV created by team in
podsearch_df <- read_csv("podsearch_df_complete_04_08_2023_v1.csv")

# Final mutations to various datapoints within the complete dataset:

# Making all cells have the same formatting in order to modify
podsearch_df$birthday <- str_replace(podsearch_df$birthday, "GMT", "+0000")
# Removing hour and minute from birthday
podsearch_df <- podsearch_df %>% 
  mutate(birthday = substr(birthday, 1, 16))

# Title casing some columns
podsearch_df$categories <- str_to_title(podsearch_df$categories)
podsearch_df$explicit <- str_to_title(podsearch_df$explicit)

# Removes some HTML tags from description strings, replacing with one space
podsearch_df$description <- gsub("<.*?>", " ", podsearch_df$description)

# Beginning of UI
ui <- fluidPage(
  tags$head(tags$style(HTML('* {
                            font-family: "Space Mono", monospace;
                            color: #291440;
                            background-color: #F2EDF9;
                            }
                            .shiny-input-container {
                            color: #291440;
                            }
                            .js-irs-0 .irs-single, .js-irs-0 .irs-bar-edge, .js-irs-0 .irs-bar {
                            background: #A64EFF;
                            }
                            h1 {
                            background-color: #A64EFF;
                            color: #F2EDF9;
                            padding: 15px
                            }
                            h3 {
                            font-weight: bold;
                            text-align: center;
                            }
                            h5 {
                            text-align: left;
                            font-size: 1.15em;
                            }
                            #pod-link {
                            text-align: center;
                            }
                            .btn, button {
                            display: block;
                            margin: 20px auto;
                            height: 50px;
                            width: 140px;
                            border-radius: 6%;
                            border: 2px solid #A64EFF;
                            font-weight: bold;
                            text-align: center;
                            }
                            img {
                            width: 300px;
                            height: auto;
                            padding-bottom: 15px;
                            padding-top: 15px;
                            border-radius: 10%;
                            display: block;
                            margin-left: auto;
                            margin-right: auto;
                            }
                            '))),
  titlePanel(h1("PodSearch")),
  fluidRow(
    column(2,
           sliderInput("number_episodes_slider",
                       "Select episode minimum:",
                       min = 1, max = 150,
                       value = 1),
           selectInput("explicit",
                       "Rating:",
                       c("None",
                         c("Explicit", "Not Explicit"))),
           selectInput("genre",
                       "Genre/Category:",
                       c("None",
                         c("Art", "Business", "Christianity", "Comedy", "Education", "Fiction", "Health", "History", "Kids", "Leisure", "Music", "News", "Religion", "Science", "Society", "Spirituality", "Sports", "Technology", "Tv"))),
           h5("Note: Select an option from each filter to receive a match."), # Added instructions to make app usage clearer
           h6("PodSearch dataset was last updated 04/08/2023"), # Added disclaimer of the data the app uses
           ),
    mainPanel(column(12, 
                     (tabsetPanel(type="tabs",
                                  tabPanel("Dating", 
                                           box(
                                             htmlOutput("filtered_podcast")
                                             ),
                                           ), # End of dating tab
                                  tabPanel("Table", 
                                           box(h2(""),
                                               h3("All eligible podcasts!"),
                                               h2(""),
                                               DT::dataTableOutput("table"))
                                           ) # End of table tab
                     ))))))

# Beginning of Server

#########################################################################################################
server <- function(input, output) {

  # Filter data based on selections
  output$table <- DT::renderDataTable(DT::datatable({
    data <- podsearch_df
    if (input$explicit != "None") {
      data <- data[data$explicit == input$explicit,]
    }
    if (input$genre != "None") {
      data <- data %>% 
        filter(grepl(input$genre, categories))
    }
    if (input$number_episodes_slider != 1){
      data <- data %>% 
        filter(number_episodes >= input$number_episodes_slider)
    }
    data[c("title", "description", "number_episodes", "categories", "explicit", "zodiac")]
    
  }))
  
  output$filtered_podcast <- renderText({
    
    if(input$explicit == "None" | input$number_episodes_slider == 1 | input$genre == "None") {
      paste(h2("Use filters to get your match!"))
    } else{
      
      filtered_df <- podsearch_df %>% 
        filter(number_episodes >= input$number_episodes_slider & explicit %in% input$explicit & grepl(input$genre, categories))
      
      pod_match <- sample_n(filtered_df, 1)
      pod_match %>% 
        mutate(title = paste0(h2(""),
                              h4("Meet your match!"),
                              h3(),
                              h3(title),
                              img(src=paste(zodiac, ".png", sep = "")),
                              h5(description),
                              column(4,
                                     h5("Number of Episodes:",number_episodes, "episodes"),
                                     h5("Birthday (air-date):", birthday)
                                     
                              ),
                              column(4,
                                     h5("Zodiac Sign:", zodiac),
                                     h5("Rating:", explicit)
                              ),
                              column(4,
                                     h5("Average Rating:", average_rating),
                                     h5("Categories:", categories)
                                     ),
                              column(12),
                              column(12,
                                     actionButton("podlinkButton", "Listen Now", icon = icon("podcast"),
                                                  onclick = paste0("window.open('", show_link, "', '_blank')") # added link functionality
                                     ))
                              )) %>% 
        pull(title)
      
    }
    
    
    
  })
  
  
}

# Run the application 
shinyApp(ui = ui, server = server)
