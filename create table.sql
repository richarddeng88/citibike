CREATE TABLE trips_raw (
  trip_duration numeric,
  start_time timestamp ,
  stop_time timestamp ,
  start_station_id integer,
  start_station_name varchar(255),
  start_station_latitude numeric,
  start_station_longitude numeric,
  end_station_id integer,
  end_station_name varchar(255),
  end_station_latitude numeric,
  end_station_longitude numeric,
  bike_id integer,
  user_type varchar(255),
  birth_year varchar(255),
  gender varchar(255)
);

CREATE TABLE trips (
  id serial primary key,
  trip_duration numeric,
  start_time timestamp,
  stop_time timestamp,
  start_station_id integer,
  end_station_id integer,
  bike_id integer,
  user_type varchar(255),
  birth_year integer,
  gender integer
);

CREATE TABLE stations (
  id integer primary key,
  station_name varchar(255),
  latitude numeric,
  longitude numeric,
  nyct2010_gid integer,
  boroname varchar(255),
  ntacode varchar(255),
  ntaname varchar(255)
);

CREATE TABLE directions (
  start_station_id integer,
  end_station_id integer,
  directions jsonb
);

CREATE UNIQUE INDEX idx_directions_on_stations ON directions (start_station_id, end_station_id);

CREATE TABLE central_park_weather_observations_raw (
  station_id varchar(255),
  station_name varchar(255),
  date date,
  precipitation_tenths_of_mm numeric,
  snow_depth_mm numeric,
  snowfall_mm numeric,
  max_temperature_tenths_degrees_celsius numeric,
  min_temperature_tenths_degrees_celsius numeric,
  average_wind_speed_tenths_of_meters_per_second numeric
);

CREATE INDEX index_weather_observations ON central_park_weather_observations_raw (date);

CREATE VIEW central_park_weather_observations AS
SELECT
  date,
  precipitation_tenths_of_mm / (100 * 2.54) AS precipitation,
  NULLIF(snow_depth_mm, -9999) / (10 * 2.54) AS snow_depth,
  NULLIF(snowfall_mm, -9999) / (10 * 2.54) AS snowfall,
  max_temperature_tenths_degrees_celsius * 9 / 50 + 32 AS max_temperature,
  min_temperature_tenths_degrees_celsius * 9 / 50 + 32 AS min_temperature,
  CASE
    WHEN average_wind_speed_tenths_of_meters_per_second >= 0
    THEN average_wind_speed_tenths_of_meters_per_second / 10 * (100 * 60 * 60) / (2.54 * 12 * 5280)
  END AS average_wind_speed
FROM central_park_weather_observations_raw;
