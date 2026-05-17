USE ms_health_project;

DROP TABLE IF EXISTS final_health_data;

CREATE TABLE final_health_data AS
SELECT
    Year,
    StateAbbr,
    StateDesc,
    CountyName,
    CAST(CountyFIPS AS CHAR) AS GEOID,
    CountyFIPS,
    LocationName,
    DataSource,
    Category,
    Measure,
    Data_Value_Unit,
    Data_Value_Type,
    Data_Value,
    Data_Value_Footnote_Symbol,
    Data_Value_Footnote,
    Low_Confidence_Limit,
    High_Confidence_Limit,
    TotalPopulation,
    NULL AS TotalPop18plus,
    Geolocation,
    LocationID,
    CategoryID,
    MeasureId,
    DataValueTypeID,
    Short_Question_Text
FROM stg_health_2020
WHERE 1 = 0;


INSERT INTO final_health_data
SELECT
    Year,
    StateAbbr,
    StateDesc,
    CountyName,
    CAST(CountyFIPS AS CHAR) AS GEOID,
    CountyFIPS,
    LocationName,
    DataSource,
    Category,
    Measure,
    Data_Value_Unit,
    Data_Value_Type,
    Data_Value,
    Data_Value_Footnote_Symbol,
    Data_Value_Footnote,
    Low_Confidence_Limit,
    High_Confidence_Limit,
    TotalPopulation,
    NULL AS TotalPop18plus,
    Geolocation,
    LocationID,
    CategoryID,
    MeasureId,
    DataValueTypeID,
    Short_Question_Text
FROM stg_health_2020;


INSERT INTO final_health_data
SELECT
    Year,
    StateAbbr,
    StateDesc,
    CountyName,
    CAST(CountyFIPS AS CHAR) AS GEOID,
    CountyFIPS,
    LocationName,
    DataSource,
    Category,
    Measure,
    Data_Value_Unit,
    Data_Value_Type,
    Data_Value,
    Data_Value_Footnote_Symbol,
    Data_Value_Footnote,
    Low_Confidence_Limit,
    High_Confidence_Limit,
    TotalPopulation,
    NULL AS TotalPop18plus,
    Geolocation,
    LocationID,
    CategoryID,
    MeasureId,
    DataValueTypeID,
    Short_Question_Text
FROM stg_health_2021;


INSERT INTO final_health_data
SELECT
    Year,
    StateAbbr,
    StateDesc,
    CountyName,
    CAST(CountyFIPS AS CHAR) AS GEOID,
    CountyFIPS,
    LocationName,
    DataSource,
    Category,
    Measure,
    Data_Value_Unit,
    Data_Value_Type,
    Data_Value,
    Data_Value_Footnote_Symbol,
    Data_Value_Footnote,
    Low_Confidence_Limit,
    High_Confidence_Limit,
    TotalPopulation,
    TotalPop18plus,
    Geolocation,
    LocationID,
    CategoryID,
    MeasureId,
    DataValueTypeID,
    Short_Question_Text
FROM stg_health_2023;


ALTER TABLE final_health_data
ADD COLUMN id INT AUTO_INCREMENT PRIMARY KEY FIRST;


DROP VIEW IF EXISTS clean_health_data;

CREATE VIEW clean_health_data AS
SELECT *
FROM final_health_data
WHERE Data_Value IS NOT NULL;


DROP VIEW IF EXISTS county_summary;

CREATE VIEW county_summary AS
SELECT
    CountyName,
    GEOID,
    ROUND(AVG(Data_Value), 2) AS avg_health_value,
    MIN(Data_Value) AS min_value,
    MAX(Data_Value) AS max_value,
    COUNT(DISTINCT MeasureId) AS total_measures
FROM clean_health_data
GROUP BY CountyName, GEOID;


DROP VIEW IF EXISTS measure_summary;

CREATE VIEW measure_summary AS
SELECT
    MeasureId,
    Measure,
    Category,
    ROUND(AVG(Data_Value), 2) AS avg_value,
    MIN(Data_Value) AS min_value,
    MAX(Data_Value) AS max_value,
    COUNT(*) AS records
FROM clean_health_data
GROUP BY MeasureId, Measure, Category;


DROP VIEW IF EXISTS yearly_summary;

CREATE VIEW yearly_summary AS
SELECT
    Year,
    ROUND(AVG(Data_Value), 2) AS avg_health_value,
    COUNT(*) AS records
FROM clean_health_data
GROUP BY Year;