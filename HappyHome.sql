CREATE SCHEMA IF NOT EXISTS HappyHome;
USE HappyHome;

DROP TABLE IF EXISTS Volcano;
DROP TABLE IF EXISTS Typhoon;
DROP TABLE IF EXISTS Tsunami;
DROP TABLE IF EXISTS Tornado;
DROP TABLE IF EXISTS Storm;
DROP TABLE IF EXISTS Snow;
DROP TABLE IF EXISTS Hurricane;
DROP TABLE IF EXISTS Freezing;
DROP TABLE IF EXISTS Flood;
DROP TABLE IF EXISTS Fire;
DROP TABLE IF EXISTS Earthquake;
DROP TABLE IF EXISTS Drought;
DROP TABLE IF EXISTS Disaster;
DROP TABLE IF EXISTS Favorite; 
DROP TABLE IF EXISTS Report; 
DROP TABLE IF EXISTS `User`;   
DROP TABLE IF EXISTS CountyHousePriceForecast;
DROP TABLE IF EXISTS CountyHousePrice;    
DROP TABLE IF EXISTS County;

CREATE TABLE County (
	FipsCountyCode VARCHAR(5),
    State VARCHAR(30) NOT NULL,
    CountyName VARCHAR(100) NOT NULL,
    PopularityIndex INT,
    CONSTRAINT pk_County_FipsCountyCode PRIMARY KEY (FipsCountyCode)
);

CREATE TABLE CountyHousePrice(
	FipsCountyCode VARCHAR(5),
    CurrentPrice INT NOT NULL,
    CONSTRAINT pk_CountyHousePrice_FipsCountyCode PRIMARY KEY (FipsCountyCode),
    CONSTRAINT fk_CountyHousePrice_FipsCountyCode FOREIGN KEY (FipsCountyCode)
		REFERENCES County(FipsCountyCode)
        ON UPDATE CASCADE ON DELETE CASCADE	
);

CREATE TABLE CountyHousePriceForecast(
	FipsCountyCode VARCHAR(5),
    HomePriceForecast DECIMAL(4, 4) NOT NULL,
    CONSTRAINT pk_CountyHousePriceForecast_FipsCountyCode PRIMARY KEY (FipsCountyCode),
    CONSTRAINT fk_CountyHousePriceForecast_FipsCountyCode FOREIGN KEY (FipsCountyCode)
		REFERENCES County(FipsCountyCode)
        ON UPDATE CASCADE ON DELETE CASCADE	
);

CREATE TABLE `User` (
	UserName VARCHAR(255),
    `Password` VARCHAR(255) NOT NULL,
    FirstName VARCHAR(255) NOT NULL,
    LastName VARCHAR(255) NOT NULL,
    Email VARCHAR(255) NOT NULL,
    CurrentZip INT,
    CONSTRAINT pk_User_UserName PRIMARY KEY (UserName)
);

CREATE TABLE Report (
	ReportId INT AUTO_INCREMENT,
    FipsCountyCode VARCHAR(5) NOT NULL,
    `Index` DECIMAL, # County might not have enough data
    Recommendation VARCHAR(3000),
    Created TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT pk_Report_ReportId PRIMARY KEY (ReportId),
    CONSTRAINT fk_Report_FipsCountyCode FOREIGN KEY (FipsCountyCode)
		REFERENCES County(FipsCountyCode)
        ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE Favorite (
	FavoriteId INT AUTO_INCREMENT,
    UserName VARCHAR(255) NOT NULL,
    FipsCountyCode VARCHAR(5) NOT NULL,
    CONSTRAINT pk_Favorite_FavoriteId PRIMARY KEY (FavoriteId),
    CONSTRAINT fk_Favorite_UserName FOREIGN KEY (UserName)
		REFERENCES `User`(UserName)
        ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT fk_Favorite_FipsCountyCode FOREIGN KEY (FipsCountyCode)
		REFERENCES County(FipsCountyCode)
        ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT uq_Favorite_UserName_FipsCountyCode UNIQUE (UserName,FipsCountyCode)
);

CREATE TABLE Disaster (
	DisasterId INT AUTO_INCREMENT,
    FipsCountyCode VARCHAR(5),
    `Year` INTEGER NOT NULL,
    DisasterType VARCHAR(25) NOT NULL,
    Description VARCHAR(255) NOT NULL,
    CONSTRAINT pk_Disaster_DisasterId PRIMARY KEY (DisasterId),
    CONSTRAINT fk_Disaster_FipsCountyCode FOREIGN KEY (FipsCountyCode)
		REFERENCES County(FipsCountyCode)
        ON UPDATE CASCADE ON DELETE SET NULL
);

CREATE TABLE Drought (
	DisasterId INT,
    Classification ENUM('Abnormally', 'Moderate', 'Severe',
		'Extreme', 'Exceptional'),
    CONSTRAINT pk_Drought_DisasterId PRIMARY KEY (DisasterId),
    CONSTRAINT fk_Drought_DisasterId FOREIGN KEY (DisasterId)
		REFERENCES Disaster(DisasterId)
        ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE Earthquake (
	DisasterId INT,
    Class ENUM('Minor', 'Light', 'Moderate', 'Strong', 'Major',
		'Great'),
    CONSTRAINT pk_Earthquake_DisasterId PRIMARY KEY (DisasterId),
    CONSTRAINT fk_Earthquake_DisasterId FOREIGN KEY (DisasterId)
		REFERENCES Disaster(DisasterId)
        ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE Fire (
	DisasterId INT,
    DangerLevel ENUM('Red flag', 'Low', 'Moderate', 'High',
		'Very high', 'Extreme'),
    CONSTRAINT pk_Fire_DisasterId PRIMARY KEY (DisasterId),
    CONSTRAINT fk_Fire_DisasterId FOREIGN KEY (DisasterId)
		REFERENCES Disaster(DisasterId)
        ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE Flood (
	DisasterId INT,
    Stage ENUM('Action', 'Minor', 'Moderate', 'Major', 'Record'),
    CONSTRAINT pk_Flood_DisasterId PRIMARY KEY (DisasterId),
    CONSTRAINT fk_Flood_DisasterId FOREIGN KEY (DisasterId)
		REFERENCES Disaster(DisasterId)
        ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE Freezing (
	DisasterId INT,
    Category ENUM('1', '2', '3', '4', '5'),
    CONSTRAINT pk_Freezing_DisasterId PRIMARY KEY (DisasterId),
    CONSTRAINT fk_Freezing_DisasterId FOREIGN KEY (DisasterId)
		REFERENCES Disaster(DisasterId)
        ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE Hurricane (
	DisasterId INT,
    Category ENUM('1', '2', '3', '4', '5'),
    CONSTRAINT pk_Hurricane_DisasterId PRIMARY KEY (DisasterId),
    CONSTRAINT fk_Hurricane_DisasterId FOREIGN KEY (DisasterId)
		REFERENCES Disaster(DisasterId)
        ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE Snow (
	DisasterId INT,
    EmergencyAdvisoryLevel ENUM('Level 1', 'Level 2', 'Level 3'),
    CONSTRAINT pk_Snow_DisasterId PRIMARY KEY (DisasterId),
    CONSTRAINT fk_Snow_DisasterId FOREIGN KEY (DisasterId)
		REFERENCES Disaster(DisasterId)
        ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE Storm (
	DisasterId INT,
    Type ENUM('Severe', 'Severe ice', 'Coastal'),
    CONSTRAINT pk_Storm_DisasterId PRIMARY KEY (DisasterId),
    CONSTRAINT fk_Storm_DisasterId FOREIGN KEY (DisasterId)
		REFERENCES Disaster(DisasterId)
        ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE Tornado (
	DisasterId INT,
    Classification ENUM('Weak', 'Strong', 'Violent'),
    CONSTRAINT pk_Tornado_DisasterId PRIMARY KEY (DisasterId),
    CONSTRAINT fk_Tornado_DisasterId FOREIGN KEY (DisasterId)
		REFERENCES Disaster(DisasterId)
        ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE Tsunami (
	DisasterId INT,
    AlertLevel ENUM('Information statement', 'Watch', 'Advisory',
		'Warning'),
    CONSTRAINT pk_Tsunami_DisasterId PRIMARY KEY (DisasterId),
    CONSTRAINT fk_Tsunami_DisasterId FOREIGN KEY (DisasterId)
		REFERENCES Disaster(DisasterId)
        ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE Typhoon (
	DisasterId INT,
    Category ENUM('1', '2', '3', '4', '5'),
    CONSTRAINT pk_Typhoon_DisasterId PRIMARY KEY (DisasterId),
    CONSTRAINT fk_Typhoon_DisasterId FOREIGN KEY (DisasterId)
		REFERENCES Disaster(DisasterId)
        ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE Volcano (
	DisasterId INT,
    AlertLevel ENUM('Minor unrest', 'Moderate unrest',
		'Minor eruption', 'Moderate eruption', 'Major eruption'),
    CONSTRAINT pk_Volcano_DisasterId PRIMARY KEY (DisasterId),
    CONSTRAINT fk_Volcano_DisasterId FOREIGN KEY (DisasterId)
		REFERENCES Disaster(DisasterId)
        ON UPDATE CASCADE ON DELETE CASCADE
);
