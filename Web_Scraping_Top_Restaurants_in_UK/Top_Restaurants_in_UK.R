# Load required packages

library(rvest)
library(tidyr)
library(stringr)
library(dplyr)
library(readr)


# Scrape the required data from Squaremeal website

link <- "https://www.squaremeal.co.uk/restaurants/best/uk-top-100-restaurants_238"
page <- read_html(link)

name <- page %>% 
        html_elements(".mb-1 a") %>% 
        html_text2() %>% 
        str_trim(side = "both")
name

location <- page %>% 
            html_elements(".text-muted") %>% 
            html_text2() %>% 
            str_trim(side = "both")
location

cuisines <- page %>% 
            html_elements(".mr-1:nth-child(2)") %>%
            html_text2() %>% 
            str_trim(side = "both")
cuisines

average_price <- page %>% 
                 html_elements(".mr-1:nth-child(1)") %>% 
                 html_text2() %>% 
                 str_trim(side = "both")
average_price <- average_price[2:97]
average_price

raw_all <- page %>% 
           html_elements(".mt-2") %>% 
           html_text2() %>% 
           str_trim(side = "both")
raw_all


# Extract the Michelin Rating from raw_all

one <- str_extract(raw_all, "One")

two <- str_extract(raw_all, "Two")

three <- str_extract(raw_all, "Three")

rating <- data.frame(one, two, three)

rating <- unite(rating, michelin_stars, one, two, three, sep = "", 
                         na.rm = TRUE)


# Combine the scraped data into a table

top_uk_restaurant <- data.frame(name, location, cuisines, rating, average_price)

View(top_uk_restaurant)


# Remove the full stop and space at the beginning  of each restaurant's name

top_uk_restaurant <- top_uk_restaurant %>% 
                      separate(name, c(NA, "name"), "(\\.\\s)", extra = "merge")
head(top_uk_restaurant)


# Replace the blanks in the variable michelin_stars with "None"

top_uk_restaurant$michelin_stars[top_uk_restaurant$michelin_stars == ""] = "None"

head(top_uk_restaurant, 10)


# Remove any whitespace accidentally introduced during data manipulation

top_uk_restaurant <- top_uk_restaurant %>% 
                     mutate(across(where (is.character), str_trim))


# Export scraped data as csv file

write_csv(top_uk_restaurant, 
          "C:/Users/User/Documents/data/Top_Restaurants_in_UK.csv")

