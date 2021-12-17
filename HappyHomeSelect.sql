USE HappyHome;

# 1. How many users have saved more than two favorites?
SELECT COUNT(*) AS NumberOfUsers
FROM (
	SELECT UserName, COUNT(*) AS NumberOfFavorites
	FROM Favorite
	GROUP BY UserName
    HAVING NumberOfFavorites > 2) AS FavoritesPerUser;


# 2. What are the top five favorite counties? Include the counties in the result set.
SELECT Favorite.FipsCountyCode, CountyName, State, COUNT(*) AS NumberOfFavorites
FROM Favorite INNER JOIN County
	ON Favorite.FipsCountyCode = County.FipsCountyCode
GROUP BY Favorite.FipsCountyCode
ORDER BY NumberOfFavorites DESC, Favorite.FipsCountyCode
LIMIT 5;


# 3. In the past ten years, which counties have experienced the fewest natural disasters?
# List the top five “safest” counties.
SELECT County.FipsCountyCode, CountyName, State, COUNT(DisasterId) AS NumberOfDisasters
FROM County LEFT OUTER JOIN Disaster
	ON County.FipsCountyCode = Disaster.FipsCountyCode
WHERE `Year` IS NULL OR `Year` >= YEAR(CURDATE()) - 10
GROUP BY County.FipsCountyCode
ORDER BY NumberOfDisasters, County.FipsCountyCode
LIMIT 5;


# 4. What are the top ten counties with the lowest prices? Also list how many disasters
# they’ve had.
SELECT CountyHousePrice.FipsCountyCode, CountyName, State, CurrentPrice, NumberOfDisasters
FROM CountyHousePrice LEFT OUTER JOIN County
	ON CountyHousePrice.FipsCountyCode = County.FipsCountyCode
	LEFT OUTER JOIN (
		SELECT FipsCountyCode, COUNT(*) AS NumberOfDisasters
        FROM Disaster
        GROUP BY FipsCountyCode) AS DisastersPerCounty
		ON CountyHousePrice.FipsCountyCode = DisastersPerCounty.FipsCountyCode
ORDER BY CurrentPrice, CountyHousePrice.FipsCountyCode
LIMIT 10;


# 5. Which types of natural disasters happen most frequently in the last 10 years?
# List the top 10 disasters and their frequency
SELECT DisasterType AS MostFrequenctDisasters, COUNT(*) AS Frequency
	FROM Disaster
	WHERE `Year` >= YEAR(CURDATE()) - 10
	GROUP BY DisasterType
	ORDER BY Frequency DESC, DisasterType
	LIMIT 10;


# 6. List all disasters that have ever happened in Los Angeles County in California?
# Assume that there is no two counties in the same state having the same name.
SELECT FipsCountyCode, CountyName, State, DisasterId, Year, DisasterType, Description 
	FROM Disaster INNER JOIN County USING (FipsCountyCode) WHERE CountyName = "Los Angeles County" AND State = "CA";


# 7. What are the top 10 states with the least amount of disasters?
SELECT State, SUM(NumberOfDisasters) AS NumberOfDisastersPerState
	FROM County LEFT OUTER JOIN (
		SELECT FipsCountyCode, COUNT(*) AS NumberOfDisasters
		FROM Disaster
		GROUP BY FipsCountyCode) AS DisastersPerCounty
		ON County.FipsCountyCode = DisastersPerCounty.FipsCountyCode
	GROUP BY State
	ORDER BY NumberOfDisastersPerState, State
	LIMIT 10;


# 8. How many fires have occurred in California? 
SELECT COUNT(*) AS FiresInCalifornia
FROM County INNER JOIN Disaster
	ON County.FipsCountyCode = Disaster.FipsCountyCode
WHERE State = 'CA' AND DisasterType = 'Fire';


# 9. What is the index and buying recommendation of Barbour County in AL?
SELECT `Index`, IF(`index` = 3, 'Highly Recommended', IF(`index` = 2, 'Neutral', 'Not Recommended')) AS Recommendation
FROM Report INNER JOIN County USING (FipsCountyCode) WHERE CountyName = "Barbour County" AND State = "AL";


# 10. List all counties with the highest index(3) in Washington State
SELECT County.FipsCountyCode, CountyName
FROM County INNER JOIN Report
	ON County.FipsCountyCode = Report.FipsCountyCode
WHERE `Index` = 3 AND State = 'WA';

