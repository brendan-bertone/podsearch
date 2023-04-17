# load libraries
library(shiny)
library(shinydashboard)
library(fresh)
library(tidyverse)
library(remotes)
library(wordcloud)
library(wordcloud2)
library(RColorBrewer)
library(tm)

# reading data in
podsearch_df <- read_csv("podsearch_df_complete_04_08_2023_v1.csv")


# creating year column
podsearch_df <- podsearch_df %>% 
  mutate(year = substr(birthday, 12, 16)) %>% 
  mutate(year = as.numeric(year))

# creating year list
summary(podsearch_df)
year_list <- unique(podsearch_df$year)
year_list <- na.omit(year_list) 
year_list <- sort(year_list)

# Title casing some columns
podsearch_df$categories <- str_to_title(podsearch_df$categories)

# creating zodiac list
zodiac_list <- unique(podsearch_df$zodiac)

# cleaning description
podsearch_df$description <- gsub("<.*?>", " ", podsearch_df$description)

# UI ####################

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
                            text-align: justify;
                            }
                            h5 {
                            text-align: left;
                            font-size: 1.15em;
                            }
                            .btn, button {
                            display: block;
                            margin: 20px auto;
                            height: 50px;
                            width: 100px;
                            border-radius: 50%;
                            border: 2px solid #A64EFF;
                            }'))),
  titlePanel(h1("PodSearch Visuals")),
  fluidRow(
    column(2,
           selectInput("zodiac",
                       "Zodiac:",
                       c("None",
                         c("Aries", "Taurus", "Gemini", "Cancer", "Leo", "Virgo", "Libra", "Scorpio", "Sagittarius", "Capricorn", "Aquarius", "Pisces"))),
           selectInput("genre",
                       "Genre/Category:",
                       c("None",
                         c("Art", "Business", "Christianity", "Comedy", "Education", "Fiction", "Health", "History", "Kids", "Leisure", "Music", "News", "Religion", "Science", "Society", "Spirituality", "Sports", "Technology", "Tv")))
           ),
    mainPanel(column(12, 
                     (tabsetPanel(type="tabs",
                                  tabPanel("Timeline",
                                           h4("Select Zodiac to Highlight in Timeline"),
                                             plotOutput(outputId = "time_plot", width = "100%"),
                                           h2(""),
                                           plotOutput(outputId = "genre_time_plot", width = "100%")
                                           ),
                                  tabPanel("Episode and Explicit Distribution",
                                           plotOutput(outputId = "ep_plot", width = "100%"),
                                           h2(""),
                                           plotOutput(outputId = "explicit_plot", width = "100%")
                                           ),
                                  tabPanel("Zodiac Distribution",
                                           h3("Genre/Category Zodiac Distribution"),
                                           h4(textOutput(outputId = "genre_amount")),
                                           plotOutput(outputId = "genre_dist_plot", width = "100%"),
                                           h3("Total Zodiac Podcast Distrubtion"),
                                           plotOutput(outputId = "zodiac_plot", width = "100%")
                                           ),
                                  tabPanel("Word Cloud Zodiac",
                                           h3("Zodiac Word Cloud"),
                                           h5("Choose a Zodiac to change the word cloud!"),
                                           wordcloud2Output(outputId = "word_plot", width = "100%")
                                  ),
                                  tabPanel("Word Cloud Genre/Category",
                                           h3("Genre/Category Word Cloud"),
                                           h5("Choose a Genre/Category to change the word cloud!"),
                                           wordcloud2Output(outputId = "word_plot_2", width = "100%")
                                  )
                                  
                     ))))))

# SERVER ####################

server <- function(input, output) {

  output$time_plot <- renderPlot({
    
    # grouping things by zodiac and year
    filtered_df <- podsearch_df %>% 
      group_by(zodiac, year) %>% 
      summarise(counts = n())
    
    # this will plot the selected zodiac
    highlighted_line <- filtered_df %>% 
      filter(zodiac == input$zodiac)
    
    filtered_df %>% 
      ggplot(aes(x = year,
                 y =counts,
                 group = zodiac)) +
      geom_line(color = "grey", size = 1) +
      geom_point(data = highlighted_line,
                 color = "purple", size = 3) +
      geom_line(data = highlighted_line,
                color = "purple", size = 1) +
      theme(text = element_text(size = 15, family = "mono", face = "bold")) +
      labs(title = "How many Podcasts were released per year by Zodiac",
           x = "Podcast Release Year",
           y = "Number of Podcasts") +
      scale_x_discrete(limits = c(2007, 2009, 2011, 2013, 2015, 2017, 2019, 2021, 2023))
    
  })
  
  output$genre_time_plot <- renderPlot({
    
    # displaying error message in case no input is currently selected
    validate(
      need(input$genre != "None", "Please select Genre/Category")
    )
    
    # filtering the df by category and grouping by year
    filtered_df <- podsearch_df %>% 
      filter(grepl(input$genre, categories)) %>% 
      group_by(year) %>% 
      summarise(counts = n())
    
    filtered_df %>% 
      ggplot(aes(x = year,
                 y =counts)) +
      geom_line(color = "purple", size = 1) +
      theme(text = element_text(size = 15, family = "mono", face = "bold")) +
      labs(title = paste("How many",  toupper(input$genre),"Podcasts were released per year"),
           x = "Podcast Release Year",
           y = "Number of Podcasts") +
      scale_x_discrete(limits = c(2007, 2009, 2011, 2013, 2015, 2017, 2019, 2021, 2023))
    
  })
  
  output$genre_amount <- renderText({
    
    # This is to show how many podcasts contain the selected genre/category since there is a lot of overlap between filters
    genre_df <- podsearch_df %>% 
      filter(grepl(input$genre, categories))
    
    paste("There are", nrow(genre_df), "Podcasts in the", toupper(input$genre)," Genre/Category.")
  })
  
  output$genre_dist_plot <- renderPlot({
    
    # this is to show how the zodiac distribution of a selected genre/category
    genre_df <- podsearch_df %>% 
      filter(grepl(input$genre, categories))
    
    genre_df <- genre_df %>% 
      group_by(zodiac) %>% 
      summarise(counts = n())
    
    genre_df %>% 
      ggplot(aes(y = counts,
                 x = reorder(zodiac, -counts),
                 fill = zodiac,
                 group = zodiac)) +
      geom_bar(stat = "identity") +
      theme(text = element_text(size = 15, family = "mono", face = "bold"),
            axis.text.x = element_text(angle = 45)) +
      labs(title = paste(toupper(input$genre),"Zodiac Distribution"),
           x = "Zodiac",
           y = "Number of Podcasts")
    
  })
  
  output$zodiac_plot <- renderPlot({
    
    # this is to show the zodiac distribution of all the podcast data collected
    zodiac_df <- podsearch_df %>% 
      group_by(zodiac) %>% 
      summarise(counts = n())
    
    zodiac_df %>% 
      ggplot(aes(y = counts,
                 x = reorder(zodiac, -counts),
                 fill = zodiac,
                 group = zodiac)) +
      geom_bar(stat = "identity") +
      theme(text = element_text(size = 15, family = "mono", face = "bold"),
            axis.text.x = element_text(angle = 45)) +
      labs(title = "How many podcasts belong to each Zodiac",
           x = "Zodiac",
           y = "Number of Podcasts")
    
  })
  
  output$ep_plot <- renderPlot({
    
    # basic histogram to show the episode distribution of podcasts
    podsearch_df %>% 
      ggplot(aes(x = number_episodes)) +
      geom_histogram(fill = "#A64EFF",
                     color = "#F2EDF9") +
      labs(title = "How many episodes does the average Podcast have?",
           x = "Number of Episodes",
           y = "Number of Podcasts") +
      theme(text = element_text(size = 15, family = "mono", face = "bold"))
  })
  
  output$explicit_plot <- renderPlot({
    
    # basic bar plot to show the distribution of explicit vs non explicit podcasts in the data
    podsearch_df %>% 
      group_by(explicit) %>% 
      summarise(counts = n()) %>% 
      ggplot(aes(y = counts,
                 x = explicit)) +
      geom_bar(stat = "identity",
               fill = "#A64EFF") +
      geom_label(aes(label = counts), size = 5) +
      theme(text = element_text(size = 15, family = "mono", face = "bold")) +
      labs(title = "Podcast Explicit Distribution",
           x = "",
           y = "Number of Podcasts")
  })
  
  output$word_plot <- renderWordcloud2({
    
    # display error message if none is selected
    validate(
      need(input$zodiac != "None", "Please select Zodiac")
    )
    
    # wordcloud that changed bases on zodiac input
    word_df <- podsearch_df %>% 
      filter(zodiac == input$zodiac)
    
    # the words are gathered from the description column in the filtered df
    word_col <- Corpus(VectorSource(word_df$description))
    
    word_col <- word_col %>% 
      tm_map(removeNumbers) %>% 
      tm_map(removePunctuation) %>% 
      tm_map(stripWhitespace)
    
    word_col <- tm_map(word_col, content_transformer(tolower))
    word_col <- tm_map(word_col, removeWords, stopwords("english"))
    
    word_count <- TermDocumentMatrix(word_col)
    matrix <- as.matrix(word_count)
    words <- sort(rowSums(matrix), decreasing = TRUE)
    df <- data.frame(word = names(words), freq = words)
    
    wordcloud2(data = df, size = 1.6, color = "random-light", backgroundColor = "#291440")
  })
  
  output$word_plot_2 <- renderWordcloud2({
    
    # display error message if none is selected
    validate(
      need(input$genre != "None", "Please select Genre/Category")
    )
    
    # filtering bases on genre selected by the user
    word_df <- podsearch_df %>% 
      filter(grepl(input$genre, categories))
    
    # the words are gathered from the description column in the filtered df
    word_col <- Corpus(VectorSource(word_df$description))
    
    word_col <- word_col %>% 
      tm_map(removeNumbers) %>% 
      tm_map(removePunctuation) %>% 
      tm_map(stripWhitespace)
    
    word_col <- tm_map(word_col, content_transformer(tolower))
    word_col <- tm_map(word_col, removeWords, stopwords("english"))
    
    word_count <- TermDocumentMatrix(word_col)
    matrix <- as.matrix(word_count)
    words <- sort(rowSums(matrix), decreasing = TRUE)
    df <- data.frame(word = names(words), freq = words)
    
    wordcloud2(data = df, size = 1.6, color = "random-light", backgroundColor = "#291440")
  })
  
}

# Run the application 
shinyApp(ui = ui, server = server)
