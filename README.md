# Podsearch

## Created by Roberto Balderas, Brendan Bertone, Sydney Brandt, Jackie Ganem
## Mentor: Meaghan Wetherell

## Overview
For the ISTA 498 Capstone at the University of Arizona, we set out to create an application that would transform the way of discovering new podcasts. The way we looked to accomplish this was to create an interactive application similar to dating websites such as Tinder, Bumble, and Hinge where the user would have podcast suggested to them based off the given variables and then based on the description and other information about the podcast they could choose to save the podcast or go to the next podcast. 

Next, we will lay out the process we took to create this application and how it is running. 

## Design Overview
For this project we wanted to create a design that was fun and playful, much like many startups, the design aims to cater to a younger audience but is still useful to all ages. The color choice is the most evident of this aesthetic choice since the primary color of the website is a bright, energetic, and galactic purple. The zodiac color palette is also saturated with energetic colors that make the viewer want to view them all. The logo design of PodSearch is simple and iconic. The logo is made up of two chat bubbles, they both are meant to represent the letters “P” and “S.” The letter “P” consists of a microphone logo in order to symbolize the microphones used in creating podcasts and is unanimous with the idea of a podcast. The “S” is more representative of the letter “S,” just shaped in the way of a chat bubble. The designs for each zodiac sign are based on the corresponding zodiac constellations. The overall aesthetic is space themed which adds to the idea of exploration, much like how users are meant to search for their ideal podcast.



## Kaggle Data Set
One of the most important variables that we wanted to implement into our application was podcasts that had categories and reviews. For those reasons we decided to use this kaggle dataset which had millions of podcasts with both of those variables. From this data, we would choose our podcasts that we wanted to include in our application. It is also updated monthly to ensure that it has the most up-to-date information. 

Link: https://www.kaggle.com/datasets/thoughtvector/podcastreviews

For the application, you need to download the JSON Files for the reviews, categories, and podcasts. 
![image](https://user-images.githubusercontent.com/86931268/232164130-01b38c58-6d35-4989-9942-9d4f1a768951.png)
![image](https://user-images.githubusercontent.com/86931268/232164039-d7244d35-3504-434e-afc2-3809784f94f3.png)

## Data Cleaning/Filtering
Once you have downloaded the JSON file the next step is to run the file called "podcast json Script.R" in RStudio. The purpose of this file is take the JSON files transform them into a data frame, filter the # of podcasts to the ones we want, combine the podcast, categories, and reviews into one table, and lastly create a CSV with all the titles of the podcasts that we want to look for. 

We began by filtering the data to only include podcasts that had all the relevant data. From there we began filtering the data based on average rating and the number of reviews contributing to the reviews. Due to time constraints and limitations in our searching abilities we decided to only include podcasts that had an average rating of 5 with at least 50 reviews. This left us with about 700 podcasts. Unfortunately we found with the data that were was a limited number of podcasts that had written reviews with them so if we were to expand this project or add more variables in the future this would have been a good place to start. 

INPUT IMAGE OF FILTERING. 

The result of this code is to print out a CSV file with all the titles of the podcasts. 

IMAGE OF CSV 
  
## Web Scrapper: Getting RSS Links
The purpose of this web scrapper is to get all the RSS links for the podcasts from the Kaggle data. An RSS link is something that every podcast has which is usually an html/xml page that contains basic information about the podcast. We will use the links to gather more information about the podcasts such as the number or episodes, descriptions, whether it's explicit, etc... The purpose of this though is to just get the RSS links. 
  
The way that these scrapper works is by taking the CSV file from Kaggle was a input. Take all the names of the.
  
## Web Scrapper: Collecting RSS Data

## Merging The Datasets Kaggle and RSS

## R-Shiny Dashboard
Link: https://github.com/rbalderas1/PodSearchOne

For the dating app…

Link: https://github.com/rbalderas1/podsearch_visualiztions_v2

The visualizations dashboard is meant to visualize all of the podcast data that has been scraped and cleaned. This dashboard is meant to help inform users on what the data the dashboard consists of, which then gives the user an idea of what searches they can do. The dashboard consists of bar plots, line plots, and word clouds. The two main filters with the dashboard are the zodiac and the genre/category filters.

## React Website
The React website is meant to host the dating dashboard and visualizations dashboard in one place to make it easier for people to access our project. We went through the process of designing the color scheme, logos, and look of the website before we went through the process of building the website. The website was then created using React and pushed to an AWS server.
