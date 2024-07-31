-- CREATE DATABASE wild;
USE wild;


CREATE TABLE Aircraft (
    aircraft_id INT AUTO_INCREMENT PRIMARY KEY,
    aircraft_type VARCHAR(255),
    aircraft_make_model VARCHAR(255),
    aircraft_number_of_engines INT,
    aircraft_airline_operator VARCHAR(255),
    is_aircraft_large BOOLEAN
);

CREATE TABLE Airport (
    airport_id INT AUTO_INCREMENT PRIMARY KEY,
    airport_name VARCHAR(255),
    origin_state VARCHAR(255)
);

CREATE TABLE Wildlife_Strike (
    record_id INT PRIMARY KEY,
    aircraft_id INT,
    airport_id INT,
    wildlife_number_struck INT,
    wildlife_number_struck_actual INT,
    effect_indicated_damage VARCHAR(255),
    when_phase_of_flight VARCHAR(255),
    remains_of_wildlife_collected BOOLEAN,
    remains_of_wildlife_sent_to_smithsonian BOOLEAN,
    wildlife_size VARCHAR(255),
    conditions_sky VARCHAR(255),
    wildlife_species VARCHAR(255),
    pilot_warned_of_birds_or_wildlife BOOLEAN,
    cost_total FLOAT,
    feet_above_ground INT,
    number_of_people_injured INT,
    flightdate DATE,
    FOREIGN KEY (aircraft_id) REFERENCES Aircraft(aircraft_id),
    FOREIGN KEY (airport_id) REFERENCES Airport(airport_id)
);


-- CONTEOS
select count(*) from wildlife_strike;
select count(*) from airport;
select count(*) from aircraft;



-- QUERIES 

-- 1) Joins 

-- a) Wildlife strikes report with Aircraft and Airport information

SELECT 
    ws.record_id,
    ws.wildlife_number_struck,
    ws.wildlife_number_struck_actual,
    ws.effect_indicated_damage,
    ws.when_phase_of_flight,
    ws.flightdate,
    a.airport_name,
    a.origin_state,
    ac.aircraft_make_model,
    ac.aircraft_type
FROM 
    wildlife_strike ws
JOIN 
    airport a ON ws.airport_id = a.airport_id
JOIN 
    aircraft ac ON ws.aircraft_id = ac.aircraft_id;
    
    
    
-- b) Yearly incident counts by Aircraft type

SELECT
    YEAR(ws.flightdate) AS year,
    a.aircraft_type,
    COUNT(*) AS number_of_incidents
FROM
    wildlife_strike ws
JOIN
    aircraft a ON ws.aircraft_id = a.aircraft_id
GROUP BY
    YEAR(ws.flightdate),
    a.aircraft_type
ORDER BY
    year, number_of_incidents DESC;




-- 2) Window Functions

-- a) Total of strikes by year

SELECT 
    YEAR(ws.flightdate) AS year,
    COUNT(*) AS yearly_strikes,
    SUM(COUNT(*)) OVER (ORDER BY YEAR(ws.flightdate)) AS running_total_strikes
FROM 
    wildlife_strike ws
GROUP BY 
    YEAR(ws.flightdate);


-- b) Yearly total costs and cost rank by year

SELECT 
    YEAR(ws.flightdate) AS year,
    SUM(ws.cost_total) AS total_cost,
    RANK() OVER (ORDER BY SUM(ws.cost_total) DESC) AS cost_rank
FROM 
    wildlife_strike ws
GROUP BY 
    YEAR(ws.flightdate);   



-- 3) Aggregations/Group bys

-- a) wildlife species strike count and average cost

SELECT 
    ws.wildlife_species,
    COUNT(*) AS number_of_strikes,
    AVG(ws.cost_total) AS average_cost
FROM 
    wildlife_strike ws
GROUP BY 
    ws.wildlife_species;
    
    
-- b) Average cost by number of injured people

SELECT 
    number_of_people_injured,
    COUNT(*) AS total_incidents,
    AVG(cost_total) AS average_cost
FROM 
    wildlife_strike
GROUP BY 
    number_of_people_injured
ORDER BY 
    number_of_people_injured;



-- 3) Subquerys

-- a) The State with the Most Wildlife Strike Incidents

SELECT 
    a.origin_state,
    COUNT(*) AS number_of_incidents
FROM 
    wildlife_strike ws
JOIN 
    airport a ON ws.airport_id = a.airport_id
GROUP BY 
    a.origin_state
ORDER BY 
    number_of_incidents DESC
LIMIT 1;


-- b) Wildlife Strike Incidents with Cost Above Average

SELECT 
    ws.record_id,
    ws.cost_total,
    ws.wildlife_species
FROM 
    wildlife_strike ws
WHERE 
    ws.cost_total > (
        SELECT 
            AVG(cost_total)
        FROM 
            wildlife_strike
    );


-- 4) Date Field 

-- a) Number of strikes by date
SELECT 
    DATE_FORMAT(ws.flightdate, '%Y-%m') AS flight_month_year,
    COUNT(*) AS number_of_strikes
FROM 
    wildlife_strike ws
GROUP BY 
    flight_month_year
ORDER BY 
    flight_month_year;
    
    
-- b) Costs and incidents by quarter of the year

SELECT 
    CONCAT(YEAR(ws.flightdate), ' Q', QUARTER(ws.flightdate)) AS year_quarter,
    COUNT(*) AS total_strikes,
    AVG(ws.cost_total) AS average_cost
FROM 
    wildlife_strike ws
GROUP BY 
    year_quarter
ORDER BY 
    year_quarter;







