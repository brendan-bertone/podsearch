# Podsearch

## Overview
For the ISTA 498 Capstone at the University of Arizona we set out to create an application that would transform the way of discovering new podcasts. The way we looked to accomplish this was to create an interactive application similiar to dating websites such as Tinder, Bumble, and Hinge to where the user would have podcast suggested to them based off the given variables and then based off the description and other information about the podcast they could choose to save the podcast or go to the next podcast. 

Next we will layout the process we took to create this application how it is running. 

## Design Overview
For this poject we wanted to create a design that wanted to create a logo that demonstrated our application while also using a color scheme that would utimately highlight all of our apps application and useability... 

## Kaggle Data Set
One of the most important variables that we wanted to implement into our application was podcasts that had categories and reviews. For those reasons we decided to use this kaggle dataset which had millions of podcasts with both of those variables. From this data we would choose our podcasts that we wanted to include in our application. It is also updated monthly to ensure that it has the most up to date information. 

Link: https://www.kaggle.com/datasets/thoughtvector/podcastreviews

For the application you need to download the JSON Files for the reviews, categories, and podcasts. 
![image](https://user-images.githubusercontent.com/86931268/232164130-01b38c58-6d35-4989-9942-9d4f1a768951.png)
![image](https://user-images.githubusercontent.com/86931268/232164039-d7244d35-3504-434e-afc2-3809784f94f3.png)

## Data Cleaning/Filtering
Once you have downloaded the JSON file the next step is to run the file called "podcast json Script.R" in RStudio. The purpose of this file is take the JSON files transform them into a dataframe, filter the # of podcasts to the ones we want, combine the podcast, categories, and reviews into one table, and lastly create a CSV with all the titles of the podcasts that we want to look for. 

We began by filtering the data to only include podcasts that had all the relevant data. From there we began filtering the data based on average rating and number of reviews contributing to the reviews. Due to time constrants and limations in our searching abilities we decided to only include podcasts that had a average rating of 5 with atleast 50 reviews. This left us with about 700 podcasts. Unfortuantely we found with the data that were was a limited number of podcasts that had written reviews with them so if we were to expand this project or add more variables in the future this would have been a good place to start. 

INPUT IMAGE OF Filtering. 

The result of this code is to print out a CSV file with all the titles of the podcasts. 

IMAGE OF CSV 
  
## Web Scrapper: Getting RSS Links
The purpose of this webscrapper is to get all the RSS links for the podcasts from the kaggle data. An RSS link is something that every podcast has which is usually and html/xml page that contains basic information about the podcast. We will use the links to gather more information about the podcasts such as number or episodes, descriptions, whether it's explicit, etc... The purpose of this though is to just get the RSS links. 
  
The way that this scrapper works is by taking the csv file from kaggle was a input. Take all the names of the.
  
## Web Scrapper: Collecting RSS Data

The second step in the webscraping is running an R script. This webscrapper takes CSVs of collected RSS links from the previous step and uses the XML and xml2 packages. The script iterates through each podcast in a CSV, pulling values from particular nodes and from averaged data. From there, a new row of data would be appended to an empty dataframe, podsearch_df, where users could analyze it and double-check that the webscraping went well. 

Some difficulties we ran into at this step were that not all RSS feeds were not structured the same. Many had missing values or stored information under different node names. An error message in the iteration would alert us to rows that would not be completable, and looking over podsearch_df alerted us to any issues that made it past the scraper that required our attention. 

From there, each podsearch_df was saved as a CSV, and towards the end of the webscraping task, the CSVs were combined to create the complete dataset of RSS data. This final script here also removed rows that were completely NAs, rows that were duplicate podcasts based on "title", and rows that had a value in "zodiac" that was not a zodiac.

## Merging The Datasets Kaggle and RSS

To merge the tidied Kaggle data and the collected RSS data, we created another R script. We read in both datasets and left-joined the Kaggle data to the RSS data with the index being "xml_link". We removed rows that had NAs for "categories", and the final dataset was exported as a CSV. The final column values of this dataset were: xml_link, title.x, description, show_link, number_episodes, explicit, birthday, zodiac, podcast_id, average_rating, ratings_count, categories.

## R-Shiny Dating Dashboard

The R-Shiny dating dashboard, which is being hosted on the React website, is comprised of a "filters" column on the left and the reactive datatable and 'dating app' tabs on the right. 

At the top of this app document, some final data mutations are made to the complete PodSearch dataset: the "birthday" timestamp is modified to not be as long, some variables are changed to be capitalized, individual categories are extracted from "categories", and HTML tags that were in "description" were removed. HTML style choices were also applied here.

Beneath that, the UI and server were defined to create the "dating dashboard"; users are encouraged to pick options within each filter to received a randomized "match" from the filtered dataset. In the table tab, they can modify the filters however they see fit to gather all of their "matches" at once. 

## R-Shiny Visualizations Dashboard


## React Website

