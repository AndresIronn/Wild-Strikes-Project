<h1 style="background: linear-gradient(to right, red, orange, yellow); -webkit-background-clip: text; color: transparent; font-weight: bold; font-size: 48px;">Wildlife Strikes</h1>

![Images](Images/pic.png)

## Data Collection

The data used for this project was taken from Kaggle, but originally belongs to this page: https://wildlife.faa.gov/home. The FAA Wildlife Strike Database.
If you like to report a strike, feel free to use the link I recently provided 

## Goals

1) Analyze and clean the Wildlife Strikes dataset.
2) Use SQL queries to get useful insights, but first, divide the dataset into at least 2 related tables to increase the performance of queries.
3) Use Tableau for data visualization

## EDA

The dataset had 2 columns with an absurd amount of nulls (over 90%) and another one with around 20%. I dropped thr first 2 for obvious reasons and also the 3rd one because it was useless ('remarks' is the name).
There were no duplicates.
In some cases there were some letters were there should be numbers so I created some functions to change them.
Once all that was done, the dataframe was ready to be connected to MySQL

## Python Connection to MySQL

Using MySQL, I created a database called 'wild' including 3 distict tables:

### 1. Wildlife_Strike Table

- **Description:**
  - This table contains detailed information about each wildlife strike incident. It includes data on the date of the incident, the aircraft involved, the wildlife species, and various impact measures.

- **Key Columns:**
  - `record_id` (Primary Key)
  - `flightdate`
  - `aircraft_type`
  - `wildlife_species`
  - `cost_total`
  - `effect_indicated_damage`
  - `origin_state`

### 2. Airport Table

- **Description:**
  - This table holds information about the airports involved in the wildlife strike incidents. It provides details about the airport names and their locations.

- **Key Columns:**
  - `airport_id` (Primary Key)
  - `airport_name`
  - `origin_state`

### 3. Aircraft Table

- **Description:**
  - This table contains information about the aircraft types and models involved in the wildlife strikes. It provides details about the make, model, and type of each aircraft.

- **Key Columns:**
  - `aircraft_id` (Primary Key)
  - `aircraft_make_model`
  - `aircraft_type`

The cleaned data was populated into the **wild** database using Python’s SQL connector with the **to_sql** function from the pandas library.
After the tables were populated, I did some querys like group bys, subqueries, window functions, etc, to get useful insights

## Visualization with Tableau

In the final part of the project I did a story with 2 Dashboards showing how the strikes differ by State, species, and how were the dates and costs involved in the bird strikes incidents


