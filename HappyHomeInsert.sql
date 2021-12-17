USE HappyHome;

LOAD DATA LOCAL INFILE '/Users/yueyangwu/Desktop/CS5200/Project/NaturalDisasterAPI/state_and_county_fips_master_final.csv' INTO TABLE County
	FIELDS TERMINATED BY ',' ENCLOSED BY '"'
	LINES TERMINATED BY '\n'
	IGNORE 1 LINES
	(@col1, @col2, @col3)
	SET FipsCountyCode = @col1, State = TRIM(TRAILING '\r' FROM @col3), CountyName = @col2;

LOAD DATA LOCAL INFILE '/Users/yueyangwu/Desktop/CS5200/Project/NaturalDisasterAPI/County_price.csv' INTO TABLE CountyHousePrice
	FIELDS TERMINATED BY ',' ENCLOSED BY '"'
	LINES TERMINATED BY '\n'
	IGNORE 1 LINES;

LOAD DATA LOCAL INFILE '/Users/yueyangwu/Desktop/CS5200/Project/NaturalDisasterAPI/DisasterDeclarationsSummaries_final.csv' INTO TABLE Disaster
	FIELDS TERMINATED BY ','
	LINES TERMINATED BY '\n'
	IGNORE 1 LINES;

LOAD DATA LOCAL INFILE '/Users/yueyangwu/Desktop/CS5200/Project/NaturalDisasterAPI/User.csv' INTO TABLE User
	FIELDS TERMINATED BY ',' 
	LINES TERMINATED BY '\n'
	IGNORE 1 LINES;

INSERT INTO Favorite (UserName, FipsCountyCode)
	VALUES ('househunter', 34007), ('househunter', 33001), ('househunter', 29045), ('househunter2', 34007), ('househunter2', 33001), 
	('househunter3', 34007), ('househunter3', 29045), ('househunter3', 19091), ('househunter3', 13189);
    
LOAD DATA LOCAL INFILE '/Users/yueyangwu/Desktop/CS5200/Project/NaturalDisasterAPI/Growth_Rate.csv' INTO TABLE CountyHousePriceForecast
	FIELDS TERMINATED BY ',' ENCLOSED BY '"'
	LINES TERMINATED BY '\n'
	IGNORE 1 LINES;

# Calculate Index and insert it into Report table
SELECT AVG(OriginalIndexTable.OriginalIndex), STD(OriginalIndexTable.OriginalIndex)
INTO @avgrt, @stdrt
 FROM (SELECT FipsCountyCode, CNT, HomePriceForecast, HomePriceForecast / CNT AS OriginalIndex 
 FROM (SELECT FipsCountyCode, COUNT(*) AS CNT 
 FROM Disaster 
 GROUP BY FipsCountyCode 
 ORDER BY FipsCountyCode DESC) AS CountyDisasterCNT 
 LEFT OUTER JOIN CountyHousePriceForecast USING (FipsCountyCode)
 ORDER BY OriginalIndex ASC) AS OriginalIndexTable GROUP BY FipsCountyCode
 LIMIT 1;
 
#insert code
INSERT INTO Report(FipsCountyCode, `Index`)
SELECT FipsCountyCode, FinalIndex FROM (
 SELECT FipsCountyCode,
 CASE # cast original index to a 1, 2, 3 index
  WHEN OriginalIndex > @avgrt + 0.01 * @stdrt
        THEN 3
        WHEN OriginalIndex < @avgrt - 0.01 * @stdrt
        THEN 1
        ELSE 2
        END AS FinalIndex
 FROM (
  #count original index
 SELECT FipsCountyCode, CNT, HomePriceForecast, HomePriceForecast / CNT AS OriginalIndex #original index
 FROM (
# get disaster data of each fipscode
 SELECT FipsCountyCode, COUNT(*) AS CNT 
 FROM Disaster 
 GROUP BY FipsCountyCode 
 ORDER BY FipsCountyCode DESC) AS CountyDisasterCNT 
 LEFT OUTER JOIN CountyHousePriceForecast USING (FipsCountyCode)
 ORDER BY OriginalIndex ASC) AS OriginalIndexTable GROUP BY FipsCountyCode
) AS FinalTable;
