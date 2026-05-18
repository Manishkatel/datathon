USE ms_health_project;

SELECT COUNT(*) AS total_rows
FROM final_health_data;

SELECT Year, COUNT(*) AS records
FROM final_health_data
GROUP BY Year
ORDER BY Year;

SELECT
    COUNT(*) AS total_records,
    COUNT(DISTINCT CountyName) AS total_counties,
    COUNT(DISTINCT MeasureId) AS total_measures,
    MIN(Year) AS first_year,
    MAX(Year) AS latest_year
FROM clean_health_data;

SELECT
    Year,
    ROUND(AVG(Data_Value), 2) AS avg_health_value
FROM clean_health_data
GROUP BY Year
ORDER BY Year;

SELECT
    Category,
    ROUND(AVG(Data_Value), 2) AS avg_value,
    COUNT(*) AS records
FROM clean_health_data
GROUP BY Category
ORDER BY avg_value DESC;

SELECT
    MeasureId,
    Measure,
    Category,
    ROUND(AVG(Data_Value), 2) AS avg_value,
    MIN(Data_Value) AS min_value,
    MAX(Data_Value) AS max_value,
    COUNT(*) AS records
FROM clean_health_data
GROUP BY MeasureId, Measure, Category
ORDER BY avg_value DESC;

SELECT
    CountyName,
    GEOID,
    ROUND(AVG(Data_Value), 2) AS avg_health_value
FROM clean_health_data
GROUP BY CountyName, GEOID
ORDER BY avg_health_value DESC
LIMIT 15;

SELECT
    CountyName,
    GEOID,
    ROUND(AVG(Data_Value), 2) AS avg_health_value
FROM clean_health_data
GROUP BY CountyName, GEOID
ORDER BY avg_health_value ASC
LIMIT 15;

SELECT
    Year,
    ROUND(AVG(Data_Value), 2) AS avg_obesity
FROM clean_health_data
WHERE MeasureId = 'OBESITY'
GROUP BY Year
ORDER BY Year;

SELECT
    Year,
    ROUND(AVG(Data_Value), 2) AS avg_diabetes
FROM clean_health_data
WHERE MeasureId = 'DIABETES'
GROUP BY Year
ORDER BY Year;

SELECT
    Year,
    CountyName,
    GEOID,
    ROUND(Data_Value, 2) AS obesity_value
FROM clean_health_data
WHERE MeasureId = 'OBESITY'
ORDER BY Data_Value DESC
LIMIT 20;

SELECT
    Year,
    CountyName,
    GEOID,
    ROUND(Data_Value, 2) AS diabetes_value
FROM clean_health_data
WHERE MeasureId = 'DIABETES'
ORDER BY Data_Value DESC
LIMIT 20;

SELECT
    a.CountyName,
    a.GEOID,
    a.MeasureId,
    a.Measure,
    ROUND(a.Data_Value, 2) AS value_2020,
    ROUND(b.Data_Value, 2) AS value_2023,
    ROUND(b.Data_Value - a.Data_Value, 2) AS change_2020_to_2023
FROM clean_health_data a
JOIN clean_health_data b
    ON a.GEOID = b.GEOID
    AND a.MeasureId = b.MeasureId
WHERE a.Year = 2020
  AND b.Year = 2023
ORDER BY change_2020_to_2023 DESC
LIMIT 25;

SELECT
    a.CountyName,
    a.GEOID,
    a.MeasureId,
    a.Measure,
    ROUND(a.Data_Value, 2) AS value_2020,
    ROUND(b.Data_Value, 2) AS value_2023,
    ROUND(b.Data_Value - a.Data_Value, 2) AS change_2020_to_2023
FROM clean_health_data a
JOIN clean_health_data b
    ON a.GEOID = b.GEOID
    AND a.MeasureId = b.MeasureId
WHERE a.Year = 2020
  AND b.Year = 2023
ORDER BY change_2020_to_2023 ASC
LIMIT 25;

SELECT
    CASE
        WHEN CAST(REPLACE(TotalPopulation, ',', '') AS UNSIGNED) < 20000 THEN 'Small County'
        WHEN CAST(REPLACE(TotalPopulation, ',', '') AS UNSIGNED) BETWEEN 20000 AND 75000 THEN 'Medium County'
        ELSE 'Large County'
    END AS population_group,
    ROUND(AVG(Data_Value), 2) AS avg_health_value,
    COUNT(*) AS records
FROM clean_health_data
GROUP BY population_group
ORDER BY avg_health_value DESC;

SELECT *
FROM county_summary
ORDER BY avg_health_value DESC
LIMIT 10;

SELECT *
FROM measure_summary
ORDER BY avg_value DESC;

SELECT *
FROM yearly_summary
ORDER BY Year;

SELECT
    Year,
    StateAbbr,
    StateDesc,
    CountyName,
    GEOID,
    CountyFIPS,
    LocationName,
    Category,
    Measure,
    MeasureId,
    Data_Value_Unit,
    Data_Value_Type,
    Data_Value,
    TotalPopulation,
    TotalPop18plus,
    Geolocation
FROM clean_health_data;