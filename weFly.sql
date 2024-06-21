DROP DATABASE WeFly;
CREATE DATABASE IF NOT EXISTS WeFly;
USE WeFly;

-- --- Airline TABLE --- --

CREATE TABLE IF NOT EXISTS Airline (
    -- ATTRIBUTES --
	ICAO VARCHAR(3),
    IATA VARCHAR(2) NOT NULL,
    Name VARCHAR(255) NOT NULL,
    CountryOfOrigin VARCHAR(255) NOT NULL,
	-- CONSTRAINTS --
    CONSTRAINT pk_Airline_ICAO PRIMARY KEY (ICAO)
);

INSERT IGNORE INTO Airline (ICAO, IATA, Name, CountryOfOrigin)
	VALUES ("TAP", "TP", "TAP Portugal", "Portugal"),
	("RYR", "FR", "Ryanair", "Ireland"),
    ("EJU", "EC", "easyJet Europe", "Austria"),
	("UAE", "EK", "Emirates", "United Arab Emirates"),
    ("ROT", "RO", "Tarom", "Romania"),
	("DLH", "LH", "Lufthansa", "Germany"),
    ("DTR", "DX", "DAT Danish Air Transport", "Denmark"),
	("KLM", "KL", "KLM Royal Dutch Airlines", "Netherlands"),
	("UAL", "UA", "United Airlines", "United States of America"),
	("JAL", "JL", "Japan Airlines", "Japan"),
    ("AIC", "AI", "Air India", "India"),
	("CAL", "CI", "China Airlines", "Taiwan"),
	("LAN", "LA", "LATAM Airlines", "Chile"),
	("QTR", "QR", "Qatar Airways", "Qatar"),
	("AAL", "AA", "American Airlines", "United States of America"),
	("AFR", "AF", "Air France", "France"),
    ("BAW", "BA", "British Airways", "United Kingdom"),
	("SIA", "SQ", "Singapore Airlines", "Singapore");

SELECT * FROM Airline;

-- --- Employee TABLE --- --

-- Observation: The employee ID is an internal number that the 
-- airline attributes to the employee, if a person works for 
-- more than one airline they will have another ID number.

CREATE TABLE IF NOT EXISTS Employee (
    -- ATTRIBUTES --
    -- The ID is an internal number that the airline attributes to the employee, 
    -- if a person works for more than one airline they will have another ID number.
	ID INT,
    NIF VARCHAR(9) NOT NULL,
    Name VARCHAR(255) NOT NULL,
    Gender VARCHAR(10) NOT NULL,
    DateOfBirth DATE NOT NULL,
    EmployedBy VARCHAR(4) NOT NULL,
	EmployedSince DATE NOT NULL,
	Role VARCHAR(20) NOT NULL,
	-- CONSTRAINTS --
    CONSTRAINT pk_Employee_ID PRIMARY KEY (ID),
	CONSTRAINT fk_Employee_EmployedBy FOREIGN KEY (EmployedBy) REFERENCES Airline(ICAO)
);

INSERT IGNORE INTO Employee (ID, NIF, Name, Gender, DateOfBirth, EmployedBy, EmployedSince, Role)
	VALUES (134, "282324704", "Kym Leigh", "Male", "1987-7-04", "RYR", "2018-2-22", "Technician"),
	(779, "289730252", "Rachel Orson", "Female", "1972-2-23", "BAW", "2020-1-10", "Pilot"),
    (345, "288119924", "Rita Valéria", "Female", "2000-5-18", "TAP", "2023-2-01", "Flight Attendant"),
	(23411, "268765432", "Étienne Dubois", "Male", "1991-01-25", "AFR", "2023-3-20", "Pilot"),
    (29820, "207332762", "Yoloxochitl Haritz", "Male", "1998-9-12", "ROT", "2023-1-23", "Technician"),
    (90131, "238765432", "Siobhan Kapoor", "Female", "1992-05-28", "AIC", "2022-2-22", "Flight Attendant"),
	(04050, "039333272", "Esteban Evaristo", "Male", "1991-9-12", "LAN", "2016-1-23", "Pilot"),
	(06722, "282109834", "Hiroshi Tanaka", "Male", "1985-11-15", "SIA", "2019-9-20", "Pilot"),
    (15133, "291797695", "Leonard Rose", "Male", "2003-12-09", "DTR", "2023-8-01", "Flight Attendant"),
	(45600, "288765432", "Harry Patel", "Male", "1994-06-14", "BAW", "2021-5-20", "Technician"),
	(4800, "188724430", "Samuel Anderson", "Male", "1981-06-14", "AAL", "2013-8-20", "Pilot"),
	(43189, "122736423", "Gilberto Sanchez", "Male", "1994-06-14", "LAN", "2021-7-07", "Technician"),
	(20012, "239829100", "Mahmed Muhalla", "Male", "1989-05-28", "UAE", "2017-2-22", "Pilot"),
	(02011, "239820010", "Joana Alves", "Non-Binary", "1995-03-08", "TAP", "2019-10-14", "Pilot"),
    (01232, "248765432", "Jack Smith", "Male", "1980-03-08", "UAL", "2010-05-10", "Pilot"),
	(20933, "248765432", "Jack Smith", "Male", "1980-03-08", "AAL", "2015-05-31", "Pilot"),
    (60282, "999999999", "Rayan S. Santana", "Male", "2002-05-10", "AAL", "2023-11-24", "Pilot"),
    (7893, "290135674", "Wolfgang Müller", "Male", "1988-12-10", "DLH", "2014-10-02", "Pilot"),
	(2991, "116802100", "Ziemei Dai", "Female", "1997-07-18", "CAL", "2022-6-01", "Pilot"),
    (202, "296803451", "Isabel Hernandez", "Female", "1997-07-18", "LAN", "2019-6-01", "Flight Attendant"),
    (567, "298765432", "Jiafei Chen", "Female", "2002-09-22", "CAL", "2023-11-22", "Flight Attendant");

SELECT * FROM Employee;

-- --- Pilot TABLE --- --

CREATE TABLE IF NOT EXISTS Pilot (
    -- ATTRIBUTES --
    ID INT,
    -- A pilot is currently a training pilot if the attribute IsTrainingPilotUntil is not null
    IsTrainingPilotUntil DATE,
	-- CONSTRAINTS --
    CONSTRAINT pk_TrainingPilots_ID PRIMARY KEY (ID),
    CONSTRAINT fk_TrainingPilots_ID FOREIGN KEY (ID) REFERENCES Employee(ID)
);
-- Allow only employees of type "Pilot" to be added to this table.
DELIMITER //
	CREATE TRIGGER tr_allow_only_pilots
	BEFORE INSERT ON Pilot
	FOR EACH ROW
	BEGIN
		DECLARE employee_role VARCHAR(20);

		SELECT Role INTO employee_role
		FROM Employee
		WHERE ID = NEW.ID;

		-- Check if the Role is not "Pilot", signal error if true
		IF employee_role <> 'Pilot' THEN
			SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = 'Only employees with the role "Pilot" can be inserted into the Pilot table.';
		END IF;
	END //
DELIMITER ;

INSERT IGNORE INTO Pilot (ID, IsTrainingPilotUntil)
VALUES (60282, null),
    (01232, '2023-12-25'),
	(20012, '2023-11-27'),
    (4800, null),
	(2991, null),
	(02011, null),
	(06722, null),
    (20933, null),
	(04050, '2023-11-27'),
	(779, '2023-11-27'),
	(7893, null);
    
SELECT E.EmployedBy, P.ID, E.Name, P.IsTrainingPilotUntil FROM Pilot P
INNER JOIN Employee E ON E.ID = P.ID;
    
-- --- PilotQualifications TABLE --- --

CREATE TABLE IF NOT EXISTS PilotQualifications (
    -- ATTRIBUTES --
    ID INT,
    Manufacturer VARCHAR(255) NOT NULL,
    PlaneModelCode VARCHAR(3) NOT NULL,
    Since DATE NOT NULL,
    HoursOfFlight INT NOT NULL, 
	-- CONSTRAINTS --
    CONSTRAINT pk_PilotQualifications_ID_Manufacturer_PlaneModelCode PRIMARY KEY (ID, Manufacturer, PlaneModelCode),
    CONSTRAINT fk_PilotQualifications_ID FOREIGN KEY (ID) REFERENCES Pilot(ID)
);

INSERT IGNORE INTO PilotQualifications (ID, Manufacturer, PlaneModelCode, Since, HoursOfFlight)
VALUES (60282, "Boeing", "737",'2022-08-08', 2000),
	(60282, "Boeing", "747",'2022-08-08', 1800),
    (01232, "Airbus", "380",'2014-08-08', 12000),
    (01232, "Boeing", "737",'2014-08-08', 12000),
	(20933, "Airbus", "380",'2014-08-08', 12000),
    (20933, "Boeing", "737",'2014-08-08', 12000),
	(20012, "Boeing", "747",'2018-08-08', 2000),
    (4800, "Boeing", "747",'2020-01-01', 8000),
    (4800, "Boeing", "737",'2020-01-01', 8000),
	(2991, "Embraer", "195",'2021-01-01', 10000),
	(02011, "Embraer", "190",'2021-12-03', 5000),
	(06722, "Boeing", "777",'2017-12-03', 3000),
	(04050, "Boeing", "747",'2019-08-01', 2300),
	(779, "Boeing", "747",'2019-10-01', 3000),
	(7893, "Airbus", "310",'2018-06-03', 11000);
    
SELECT * FROM PilotQualifications;

SELECT E.EmployedBy, E.Name, PQ.*, P.IsTrainingPilotUntil FROM PilotQualifications PQ
INNER JOIN Pilot P ON P.ID = PQ.ID
INNER JOIN Employee E ON E.ID = P.ID;
    
-- --- TechnicianQualifications TABLE --- --

CREATE TABLE IF NOT EXISTS TechnicianQualifications (
    -- ATTRIBUTES --
	ID INT,
    QualificationType VARCHAR(255),
	-- CONSTRAINTS --
    CONSTRAINT fk_TechnicianQualifications_ID FOREIGN KEY (ID) REFERENCES Employee(ID)
);
-- Allow only employees of type "Technician" to be added to this table.
DELIMITER //
	CREATE TRIGGER tr_allow_only_technicians
	BEFORE INSERT ON TechnicianQualifications
	FOR EACH ROW
	BEGIN
		DECLARE employee_role VARCHAR(20);

		SELECT Role INTO employee_role
		FROM Employee
		WHERE ID = NEW.ID;

		-- Check if the Role is not "Technician," signal error if true
		IF employee_role <> 'Technician' THEN
			SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = 'Only employees with the role "Technician" can be inserted into the TechnicianQualifications table.';
		END IF;
	END //
DELIMITER ;

INSERT IGNORE INTO TechnicianQualifications (ID, QualificationType)
VALUES (134, 'IT'),
    (134, 'Radio and Communications'),
    (29820, 'IT'),
    (45600, 'Mechanics'),
    (43189, 'Logistics');

SELECT TQ.QualificationType, E.* FROM TechnicianQualifications TQ
INNER JOIN Employee E ON E.ID = TQ.ID;

-- --- Country TABLE --- --

CREATE TABLE IF NOT EXISTS Country (
	-- ATTRIBUTES --
    CountryCode VARCHAR(2) NOT NULL,
	Name VARCHAR(255) NOT NULL,
    -- CONSTRAINTS --
    CONSTRAINT pk_Country_CountryCode PRIMARY KEY (CountryCode)
);

INSERT IGNORE Country
VALUES ("pt", "Portugal"),
("us", "United States of America"),
("ru", "Russia"),
("uk", "United Kingdom"),
("cn", "People's Republic of China"),
("mx", "Mexico"),
("br", "Brazil"),
("fr", "France"),
("ae", "United Arab Emirates"),
("de", "Germany"),
("jp", "Japan"),
("ie", "Ireland"),
("nl", "Netherlands"),
("it", "Italy"),
("au", "Australia"),
("th", "Thailand"),
("eg", "Egpyt"),
("kr", "South Korea"),
("tr", "Turkey"),
("ar", "Argentina"),
("za", "South Africa"),
("es", "Spain"),
("tw", "Taiwan"),
("ca", "Canada"),
("hk", "Hong Kong SAR"),
("sg", "Singapore"),
("qa", "Qatar");

-- --- Airport TABLE --- --

CREATE TABLE IF NOT EXISTS Airport (
    -- ATTRIBUTES --
	ICAO VARCHAR(4),
    IATA VARCHAR(3) NOT NULL,
    Name VARCHAR(255) NOT NULL,
	CountryCode VARCHAR(2) NOT NULL,
    City VARCHAR(255) NOT NULL,
    Coordinates VARCHAR(255) NOT NULL,
    OpeningHour TIME NOT NULL,
    ClosingHour TIME NOT NULL,
    MinimumTransferTime TIME NOT NULL,
    MaximumSupportedPlaneSize VARCHAR(10) NOT NULL, -- *** IR-17: Must be composed only by the words "Small", "Medium" , or "Large". ***
	-- CONSTRAINTS --
    CONSTRAINT pk_Airport_ICAO PRIMARY KEY (ICAO),
    CONSTRAINT chk_Airport_MaximumSupportedPlaneSize CHECK (MaximumSupportedPlaneSize IN ('Small', 'Medium', 'Large'))
);

INSERT IGNORE INTO Airport (ICAO, IATA, Name, CountryCode, City, Coordinates,
OpeningHour, ClosingHour, MinimumTransferTime, MaximumSupportedPlaneSize)
	VALUES ("LPPT", "LIS", "Humberto Delgado Airport", "pt", "Lisbon",
    "38°46′27″N 009°08′03″W", "00:00", "00:00", "00:45:00", "Large"),
    ("KLAX", "LAX", "Los Angeles International Airport",
    "us", "Los Angeles", "33°56′33″N 118°24′29″W", "00:00", "00:00", "02:00:00", "Large"),
    ("UUEE", "SVO", "Sheremetyevo Alexander S. Pushkin International Airport", "ru",
    "Moscow", "55°58′22″N 37°24′53″E", "05:00", "01:00", "01:30:00", "Large"),
	("EGLL", "LHR", "Heathrow Airport", "uk", "London", 
    "51°28′39″N 000°27′41″W", "06:00", "23:00", "01:30:00", "Large"),
	("ZBAD", "PKX", "Beijing Daxing International Airport", "cn",
    "Beijing", "39°30′33″N 116°24′38″E", "00:00", "00:00", "01:00:00", "Large"),
    ("PHNL", "HNL", "Daniel K. Inouye International Airport", "us",
    "Honolulu", "21°19′07″N 157°55′21″W", "04:15", "10:15", "02:00:00", "Large"),
    ("PANC", "ANC", "Ted Stevens Anchorage International Airport", "us",
    "Anchorage", "61°10′27″N 149°59′54″W", "00:00", "00:00", "02:00:00", "Large"),
	("MMMX", "MEX", "Mexico City International Airport", "mx",
    "Mexico City", "19°26′10″N 099°04′19″W", "00:00", "00:00", "02:00:00", "Large"),
	("SBGR", "GRU", "São Paulo/Guarulhos–Governor André Franco Montoro International Airport", "br",
    "São Paulo", "23°26′8″S 46°28′23″W", "00:00", "00:00", "02:00:00", "Large"),
	("LFPG", "CDG", "Paris Charles de Gaulle Airport", "fr",
    "Paris", "49°00′35″N 002°32′52″E", "00:00", "00:00", "01:30:00", "Large"),
	("KJFK", "JFK", "John F. Kennedy International Airport", "us",
    "New York City", "40°38′23″N 73°46′44″W", "00:00", "00:00", "01:35:00", "Large"),
	("OMDB", "DXB", "Dubai International Airport", "ae",
    "Dubai", "25°15′10″N 055°21′52″E", "08:00", "05:30", "03:00:00", "Large"),
	("EDDB", "BER", "Berlin Brandenburg Airport Willy Brandt", "de",
    "Berlin", "52°22′00″N 013°30′12″E", "00:00", "00:00", "01:00:00", "Large"),
	("RJTT", "HND", "Tokyo International Airport", "jp",
    "Tokyo", "35°33′12″N 139°46′52″E", "00:00", "00:00", "00:50:00", "Large"),
    ("KSFO", "SFO", "San Francisco International Airport", "us", "San Francisco", 
    "37°37′08″N 122°22′30″W", "00:00", "00:00", "02:00:00", "Large"),
	("EIDW", "DUB", "Dublin Airport", "ie", "Dublin", "53°25′17″N 006°16′12″W", "05:00", "00:00", "01:00:00", "Large"),
	("EGLC", "LCY", "London City Airport", "uk", "London", "51°30′19″N 000°03′19″E", 
    "06:00", "22:00", "00:45:00", "Medium"),
	("YSSY", "SYD", "Sydney Kingsford Smith International Airport", "au", "Sydney", "33°56′46″S 151°10′38″E", 
    "00:00", "00:00", "02:00:00", "Large"),
	("VTBS", "BKK", "Suvarnabhumi Airport", "th", "Bangkok", 
    "13°41′33″N 100°45′00″E", "00:00", "00:00", "01:30:00", "Large"),
    ("LPCS", "CAT", "Cascais Municipal Aerodrome", "pt", "Lisbon", 
    "38°43′32″N 009°21′19″W", "08:00", "20:00", "00:30:00", "Small"),
	("KORD", "ORD", "Chicago O'Hare International Airport", "us", "Chicago", "41°58′43″N 87°54′17″W", 
    "00:00", "00:00", "02:00:00", "Large"),
    ("HECA", "CAI", "Cairo International Airport", "eg", "Cairo", 
    "30°07′19″N 31°24′20″E", "00:00", "00:00", "03:00:00", "Large"),
	("RKSI", "ICN", "Incheon International Airport", "kr", "Seoul/Incheon", "37°27′48″N 126°26′24″E", "00:00", 
    "00:00", "01:30:00", "Large"),
	("LTFM", "IST", "Istanbul Airport", "tr", "Istanbul", 
    "41°15′44″N 28°43′40″E", "00:00", "00:00", "01:00:00", "Large"),
    ("EDDF", "FRA", "Frankfurt Airport", "de", "Frankfurt am Main", 
    "50°02′00″N 8°34′14″E", "00:00", "00:00", "00:45:00", "Large"),
	("SAEZ", "EZE", "Ministro Pistarini International Airport", "ar", "Buenos Aires", 
    "34°49′20″S 58°32′09″W", "00:00", "00:00", "03:00:00", "Large"),
    ("LIRF", "FCO", "Leonardo da Vinci–Fiumicino Airport", "it", "Rome", 
    "41°48′01″N 012°14′20″E", "00:00", "00:00", "03:00:00", "Large"),
    ("KATL", "ATL", "Hartsfield–Jackson Atlanta International Airport", 
    "us", "Atlanta", "33°38′12″N 84°25′41″W", "00:00", "00:00", "02:00:00", "Large"),
    ("FAOR", "JNB", "O. R. Tambo International Airport", "za", "Johannesburg", 
    "26°08′00″S 028°15′00″E", "00:00", "00:00", "01:00:00", "Large"),
	("ZSPD", "PVG", "Shanghai Pudong International Airport", "cn", "Shanghai", 
    "31°08′36″N 121°48′19″E", "00:00", "00:00", "02:45:00", "Large"),
	("SBGL", "GIG", "Rio de Janeiro/Galeão–Antonio Carlos Jobim International Airport", 
    "br", "Rio de Janeiro", "22°48′36″S 043°15′02″W", "00:00", "00:00", "03:45:00", "Large"),
	("VHHH", "HKG", "Hong Kong International Airport", "hk", "Hong Kong", 
    "22°18′32″N 113°54′52″E", "00:00", "00:00", "03:00:00", "Large"),
    ("WSSS", "SIN", "Singapore Changi Airport", "sg", "Singapore", 
    "1°21′33″N 103°59′22″E", "00:00", "00:00", "02:00:00", "Large"),
    ("OTHH", "DOH", "Hamad International Airport", "qa", "Doha", 
    "1°21′33″N 103°59′22″E", "00:00", "00:00", "00:45:00", "Large"),
    ("EHAM", "AMS", "Amsterdam Airport Schiphol", "nl", "Amsterdam", 
    "52°18′00″N 4°45′54″E", "00:00", "00:00", "00:50:00", "Large"),
    ("CYYZ", "YYZ", "Toronto Pearson International Airport", "ca", "Toronto", "43°40′36″N 079°37′50″W",
    "00:00", "00:00", "01:40:00", "Large"),
    ("RCTP", "TPE", "Taoyuan International Airport", "tw", "Taipei/Taoyuan", 
    "25°4′35″N 121°13′26″E", "00:00", "00:00", "01:45:00", "Large"),
    ("UUDD", "DME", "Domodedovo Mikhail Lomonosov International Airport", "ru", "Moscow",
    "55°24′31″N 37°54′22″E", "00:00", "00:00", "01:00:00", "Large"),
    ("LEMD", "MAD", "Adolfo Suárez Madrid–Barajas Airport", "es", "Madrid", 
    "40°28′20″N 003°33′39″W", "00:00", "00:00", "01:10:00", "Large");
    
SELECT a.* FROM Airport a
INNER JOIN Country c ON c.CountryCode = a.CountryCode;

-- Show only airport in mainland United States:
SELECT ICAO, IATA, Name FROM Airport WHERE CountryCode = "us" AND ICAO LIKE "K%";
-- Show airport in all of the United States:
SELECT ICAO, IATA, Name FROM Airport WHERE CountryCode = "us";
-- Show only airport with east longitude
SELECT Name, Coordinates FROM Airport WHERE Coordinates LIKE "%E";
-- Show countries that have airport in both the Eastern and Western hemispheres, and their airport.
SELECT c.Name AS Country, a.City, a.Name, a.Coordinates FROM Airport a
INNER JOIN Country c ON c.CountryCode = a.CountryCode
WHERE c.Name IN (
	SELECT c1.Name FROM Country c1
    INNER JOIN Airport a1 ON a1.CountryCode = c1.CountryCode
	WHERE a1.Coordinates LIKE '%E'
    AND EXISTS (
		SELECT 1 FROM Country c2
        INNER JOIN Airport a2 ON a2.CountryCode = c2.CountryCode
		WHERE c2.Name = c1.Name AND a2.Coordinates LIKE '%W'));
-- European airports
CREATE VIEW EuropeanAirports AS
SELECT * FROM Airport WHERE (ICAO LIKE 'L%' OR ICAO LIKE 'E%' OR ICAO LIKE 'U%');

-- --- Aircraft TABLE --- --

CREATE TABLE IF NOT EXISTS Aircraft (
    -- ATTRIBUTES --
    TailNumber VARCHAR(6) NOT NULL, -- *** IR-2: The tail number of a plane must have six digits. ***
    ModelCode VARCHAR(3) NOT NULL, -- *** IR-4: A plane's model must be a 3-digit code. ***
    Manufacturer VARCHAR(255) NOT NULL,
    ManufactureYear INT NOT NULL,
    MinimumFlightHours INT NOT NULL,
    RequiredNumberOfFlightAttendants INT NOT NULL,
    AircraftSize VARCHAR(10) NOT NULL, -- *** IR-16: Must be composed only by the words "Small", "Medium" , or "Large". ***
    OwnedBy VARCHAR(3) NOT NULL,
	-- CONSTRAINTS --
    CONSTRAINT pk_Aircraft_TailNumber_OwnedBy PRIMARY KEY (TailNumber, OwnedBy),
    CONSTRAINT chk_Aircraft_ManufactureYear CHECK (ManufactureYear > 1900),
    CONSTRAINT fk_Aircraft_OwnedBy FOREIGN KEY (OwnedBy) REFERENCES Airline(ICAO)
);

INSERT IGNORE INTO Aircraft(TailNumber, ModelCode, Manufacturer, ManufactureYear, 
MinimumFlightHours, RequiredNumberOfFlightAttendants, AircraftSize, OwnedBy)
VALUES
    ("ABC123", "310", "Airbus", 2020, 1000, 6, "Large", "DLH"),
    ("XYZ456", "737", "Boeing", 2019, 800, 6, "Large", "AAL"),
    ("DEF789", "190", "Embraer", 2022, 500, 4, "Medium", "TAP"),
	("DRT219", "340", "Airbus", 2020, 500, 8, "Large", "TAP"),
	("ZZZ421", "747", "Boeing", 2020, 1100, 10, "Large", "AAL"),
    ("YYY211", "747", "Boeing", 2020, 1100, 10, "Large", "LAN"),
    ("REA426", "380", "Airbus", 2019, 800, 8, "Large", "UAL"),
	("SSS230", "777", "Boeing", 2022, 1000, 10, "Large", "SIA"),
	("FFF230", "777", "Boeing", 2022, 1000, 10, "Large", "UAE"),
	("FD3020", "340", "Airbus", 2018, 500, 8, "Large", "AFR"),
	("BOO600", "747", "Boeing", 2021, 1100, 10, "Large", "BAW"),
	("HUA892", "195", "Embraer", 2022, 500, 4, "Medium", "CAL");

-- --- Flight TABLE --- --

CREATE TABLE IF NOT EXISTS Flight (
    -- ATTRIBUTES --
    FlightIdentifier VARCHAR(4) NOT NULL,
    OperatedBy VARCHAR(255) NOT NULL,
	FlightCode VARCHAR(8),
	-- The BasePrice attribute describes only the base price of the flight, 
    -- which is determined by the airline for the time of the flight,
    -- The FullPrice is the sum of BasePrice with SeatPrice, and is therefore calculated in the Ticket table.
    BasePrice DECIMAL(10, 2) NOT NULL,
	AssignedToAircraft VARCHAR(6) NOT NULL,
    Origin VARCHAR(4) NOT NULL,
	Destination VARCHAR(4) NOT NULL,
	Distance DECIMAL(10, 3) NOT NULL, -- Flight Distance is given in miles
    -- Flight times are given in Coordinated Universal Time (UTC)
	EstimatedDepartureTime DATETIME NOT NULL,
    RealDepartureTime DATETIME,
    EstimatedArrivalTime DATETIME NOT NULL,  
    RealArrivalTime DATETIME,
    IsCancelled BOOLEAN,
	IsPartOfNonDirectFlight BOOLEAN,
    -- *** IR-13: The Non-Direct Flight Routing Code must be an unique 11-character code, 
    -- beginning with the flight code of the first flight of a non-direct flight and ending 
    -- with "Rn", where n refers which stage the flight is in. Ex: "0001-AAL-R1". ***
    NonDirectFlightRoutingCode VARCHAR(11) UNIQUE,
	ConnectsFromFlightCode VARCHAR(8),
	ConnectsToFlightCode VARCHAR(8),
    -- CONSTRAINTS --
    CONSTRAINT pk_Flight_FlightCode_EstimatedDepartureTime_RealDepartureTime PRIMARY KEY (FlightCode, EstimatedDepartureTime, EstimatedArrivalTime),
    CONSTRAINT fk_Flight_Origin FOREIGN KEY (Origin) REFERENCES Airport(ICAO),
	CONSTRAINT fk_Flight_Destination FOREIGN KEY (Destination) REFERENCES Airport(ICAO),
    -- *** IR-10: The real and estimated arrival times must be dated after the real and estimated departure times. ***
    -- *** IR-15: The real and estimated departure times must be dated before the real and estimated arrival times. ***
	CONSTRAINT chk_Flight_Dates CHECK (EstimatedDepartureTime AND RealDepartureTime < EstimatedArrivalTime and RealArrivalTime),
    CONSTRAINT fk_Flight_AssignedToAircraft_OperatedBy FOREIGN KEY (AssignedToAircraft, OperatedBy) REFERENCES Aircraft(TailNumber, OwnedBy),
    -- *** IR-7: The origin of a flight must be different from its destination and vice-versa. ***
    CONSTRAINT chk_Flight_isOriginDestEqual CHECK (ORIGIN <> DESTINATION),
    -- *** IR-11: The "Connects From" flight code must be different from the "Connects To" flight code. ***
    -- *** IR-12: A non-direct flight can have either "Connects From" or "Connects To" set to null if 
    -- the flight is the first or the last of the sequence of flights for a trip, but both cannot be null. ***
	CONSTRAINT chk_NonDirectFlight CHECK (
		(IsPartOfNonDirectFlight = true AND NonDirectFlightRoutingCode IS NOT NULL AND 
			((ConnectsFromFlightCode IS NOT NULL AND ConnectsToFlightCode IS NULL) OR
			 (ConnectsToFlightCode IS NOT NULL AND ConnectsFromFlightCode IS NULL) OR
			 (ConnectsFromFlightCode IS NOT NULL AND ConnectsToFlightCode IS NOT NULL AND ConnectsFromFlightCode <> ConnectsToFlightCode))
		)
		OR (IsPartOfNonDirectFlight = false AND NonDirectFlightRoutingCode IS NULL AND 
			ConnectsFromFlightCode IS NULL AND ConnectsToFlightCode IS NULL)
	)
);

-- *** IR-14: A flight can only arrive at an airport if the aircraft is smaller than the maximum supported plane size of the airport ***
-- Trigger to ensure the aircraft size is supported by the airport and generate the FlightCode.
DELIMITER //
	CREATE TRIGGER tr_before_insert_Flight
	BEFORE INSERT ON Flight
	FOR EACH ROW
	BEGIN
		DECLARE aircraft_size VARCHAR(10);
		DECLARE airport_max_supported_size VARCHAR(10);

		-- Check if the assigned aircraft is bigger than the maximum supported size of the airport
		IF aircraft_size = 'Large' THEN
			SELECT MaximumSupportedPlaneSize INTO airport_max_supported_size
			FROM Airport
			WHERE ICAO = NEW.Destination;

			IF airport_max_supported_size = 'Small' THEN
				SIGNAL SQLSTATE '45000'
				SET MESSAGE_TEXT = 'Flight cannot land at the destination airport due to aircraft size';
			END IF;
		END IF;

		-- Generate the FlightCode using the updated values
		SET NEW.FlightCode = CONCAT(NEW.FlightIdentifier, "-", NEW.OperatedBy);
	END;
//DELIMITER ;

INSERT IGNORE INTO Flight (FlightIdentifier, OperatedBy, BasePrice, AssignedToAircraft, Origin, 
Destination, Distance, EstimatedDepartureTime, RealDepartureTime, EstimatedArrivalTime, 
RealArrivalTime)
	VALUES 
	-- Los Angeles -> San Francisco 
    ("0001", "AAL", 350.00, "XYZ456", "KLAX", "KSFO", 378.6,'2023-12-20 12:45:00', '2023-12-20 12:45:56', 
    '2023-12-20 14:12:00','2023-12-20 14:10:00'),
    -- London -> Tokyo
    ("0002", "BAW", 350.00, "BOO600", (SELECT ICAO FROM Airport WHERE IATA = "LHR" LIMIT 1), 
    (SELECT ICAO FROM Airport WHERE IATA = "HND" LIMIT 1), 5975,'2023-12-24 09:20:00', '2023-12-24 09:22:00', 
    '2023-12-24 22:10:00', '2023-12-24 22:11:37'),
	-- Moscow -> Dubai
    ("0003", "UAE", 350.00, "FFF230", (SELECT ICAO FROM Airport WHERE IATA = "DME" LIMIT 1), 
    (SELECT ICAO FROM Airport WHERE IATA = "DXB" LIMIT 1), 2261,'2023-11-12 06:25:00', '2023-11-12 06:35:12', 
    '2023-11-12 12:44:00','2023-11-12 12:54:03'),
	-- Sydney -> Singapore
	("0004", "SIA", 350.00, "SSS230", (SELECT ICAO FROM Airport WHERE Name = "Sydney Kingsford Smith International Airport" LIMIT 1), 
    (SELECT ICAO FROM Airport WHERE Name = "Singapore Changi Airport" LIMIT 1), 3907,'2023-11-30 13:42:00', 
    '2023-11-30 13:42:56','2023-11-30 21:12:00','2023-11-30 21:10:00'),
	-- São Paulo -> New York City
	("0005", "UAL", 350.00, "REA426", (SELECT ICAO FROM Airport WHERE IATA = "GRU" LIMIT 1), 
    (SELECT ICAO FROM Airport WHERE IATA = "JFK" LIMIT 1), 4762.18,'2023-09-11 12:45:00', 
    '2023-09-11 12:50:56','2023-09-11 23:00:00','2023-09-11 23:20:00'),
	-- Lisbon -> Paris
    ("0006", "TAP", 350.00, "DEF789", (SELECT ICAO FROM Airport WHERE IATA = "LIS" LIMIT 1), 
    (SELECT ICAO FROM Airport WHERE IATA = "CDG" LIMIT 1), 1091,'2023-12-01 12:45:00', 
    '2023-12-01 12:45:56','2023-12-01 14:12:00','2023-12-01 14:10:00'),
	-- Beijing -> San Francisco
	("0007", "UAL", 1800.00, "REA426", (SELECT ICAO FROM Airport WHERE IATA = "PKX" LIMIT 1), 
    (SELECT ICAO FROM Airport WHERE IATA = "SFO" LIMIT 1), 5913,'2023-11-29 04:12:00', 
    '2023-11-29 04:12:32','2023-11-29 18:28:00','2023-11-29 18:31:39'),
	-- New York City -> Singapore
	("0008", "SIA", 3000.00, "SSS230", (SELECT ICAO FROM Airport WHERE IATA = "JFK" LIMIT 1), 
    (SELECT ICAO FROM Airport WHERE IATA = "SIN" LIMIT 1), 9526,'2023-12-26 12:45:00', 
    '2023-12-26 12:45:56','2023-12-27 07:00:00','2023-12-27 07:10:00'),
	-- Atlanta -> Rio de Janeiro
	("0009", "LAN", 1500.00, "YYY211", (SELECT ICAO FROM Airport WHERE IATA = "ATL" LIMIT 1), 
    (SELECT ICAO FROM Airport WHERE IATA = "GIG" LIMIT 1), 4748.211,'2023-12-08 19:15:00', 
    '2023-12-08 19:15:13','2023-12-09 04:00:00','2023-12-09 03:55:09'),
	-- Taipei -> Seoul
    ("0010", "CAL", 900.00, "HUA892", (SELECT ICAO FROM Airport WHERE IATA = "TPE" LIMIT 1), 
    (SELECT ICAO FROM Airport WHERE IATA = "ICN" LIMIT 1), 907,'2023-12-20 12:45:00', 
    '2023-12-20 12:45:56','2023-12-20 14:12:00','2023-12-20 14:10:08'),
	-- Tokyo -> San Francisco
    ("0011", "AAL", 2000.00, "ZZZ421", (SELECT ICAO FROM Airport WHERE IATA = "HND" LIMIT 1), 
    (SELECT ICAO FROM Airport WHERE IATA = "SFO" LIMIT 1), 5145, '2023-12-20 08:05:00', 
    '2023-12-20 08:15:05','2023-12-20 23:00:00', '2023-12-20 23:05:56');
   
INSERT IGNORE INTO Flight (FlightIdentifier, OperatedBy, BasePrice, AssignedToAircraft, Origin, Destination, Distance, 
EstimatedDepartureTime, RealDepartureTime, EstimatedArrivalTime, RealArrivalTime, 
isPartOfNonDirectFlight, NonDirectFlightRoutingCode, ConnectsFromFlightCode, ConnectsToFlightCode)
	VALUES 
    -- Non-Direct Flight: Lisbon -> Tokyo -> Sydney
    ("0012", "DLH", 3500.00, "ABC123", (SELECT ICAO FROM Airport WHERE IATA = "LIS" LIMIT 1),
    (SELECT ICAO FROM Airport WHERE IATA = "HND" LIMIT 1), 6931,'2023-12-20 15:18:00', 
    '2023-12-20 15:18:00','2023-12-21 08:18:00','2023-12-21 08:18:00', true, "0012-DLH-R1", null, "0013-DLH"),
	("0013", "DLH", 1500.00, "ABC123", (SELECT ICAO FROM Airport WHERE IATA = "HND" LIMIT 1), 
    (SELECT ICAO FROM Airport WHERE IATA = "SYD" LIMIT 1), 4837,'2023-12-21 18:45:00', 
    '2023-12-21 18:45:56','2023-12-22 03:45:00','2023-12-22 03:46:03', true, "0012-DLH-R2", "0012-DLH", null),
	-- Non-Direct Flight: Shanghai -> Singapore -> Johannesburg -> Buenos Aires
    ("0014", "SIA", 1500.00, "SSS230", (SELECT ICAO FROM Airport WHERE IATA = "PVG" LIMIT 1), 
    (SELECT ICAO FROM Airport WHERE IATA = "SIN" LIMIT 1), 3406,'2023-12-31 00:45:00', 
    '2023-12-31 00:48:00','2023-12-31 05:40:00','2023-12-31 05:41:00', true, "0014-SIA-R1", null, "0015-SIA"),
    ("0015", "SIA", 1500.00, "SSS230", (SELECT ICAO FROM Airport WHERE IATA = "SIN" LIMIT 1), 
    (SELECT ICAO FROM Airport WHERE IATA = "JNB" LIMIT 1), 5380.03,'2023-12-31 07:40:00', 
    '2023-12-31 07:40:00','2023-12-31 18:20:00','2023-12-31 18:20:00', true, "0014-SIA-R2", "0014-SIA", "0016-LAN"),
    ("0016", "LAN", 1500.00, "YYY211", (SELECT ICAO FROM Airport WHERE IATA = "JNB" LIMIT 1), 
    (SELECT ICAO FROM Airport WHERE IATA = "EZE" LIMIT 1), 5041.457,'2023-12-31 21:35:00', 
    '2023-12-31 21:35:00','2024-01-01 12:25:00','2024-01-01 12:30:00', true, "0014-SIA-R3", "0015-SIA", null);
    
-- Show a flight's airline, origin airport, and destination airport
SELECT f.FlightCode, al.Name AS AirlineName, f.RealDepartureTime, o.Name AS OriginAirport, o.ICAO AS OriginICAO, o.IATA AS OriginIATA, co.Name AS OriginCountry, o.City AS OriginCity,
f.RealArrivalTime, d.Name AS DestinationAirport, d.ICAO AS DestinationICAO, d.IATA AS DestinationIATA, cd.Name AS DestinationCountry, d.City AS DestinationCity,
CONCAT(
	TIME_FORMAT(TIMEDIFF(f.RealArrivalTime, f.RealDepartureTime), '%H'), 'h ',
	TIME_FORMAT(TIMEDIFF(f.RealArrivalTime, f.RealDepartureTime), '%i'), 'm'
) AS FlightDuration
FROM Flight f
JOIN Airline al ON f.OperatedBy = al.ICAO
JOIN Airport o ON f.Origin = o.ICAO
JOIN Country co ON co.CountryCode = o.CountryCode
JOIN Airport d ON f.Destination = d.ICAO
JOIN Country cd ON cd.CountryCode = d.CountryCode
WHERE FlightCode = f.FlightCode;

-- Show all flights
SELECT * FROM Flight;

-- --- FlightEmployees TABLE --- --

CREATE TABLE IF NOT EXISTS FlightEmployees (
    -- ATTRIBUTES --
    ID INT NOT NULL,
    AssignedToFlight VARCHAR(8) NOT NULL,
    Role VARCHAR(20) NOT NULL,
	-- CONSTRAINTS --
    CONSTRAINT pk_FlightEmployees_ID_AssignedToFlight PRIMARY KEY (ID, AssignedToFlight),
    CONSTRAINT fk_FlightEmployees_ID FOREIGN KEY (ID) REFERENCES Employee(ID),
    CONSTRAINT fk_FlightEmployees_AssignedToFlight FOREIGN KEY (AssignedToFlight) REFERENCES Flight(FlightCode)
);

DELIMITER //
	-- *** IR-0: There may only be up to two co-pilots for each flight. ***
	CREATE TRIGGER tr_check_co_pilots
	BEFORE INSERT ON FlightEmployees
	FOR EACH ROW
	BEGIN
		DECLARE co_pilot_count INT;

		SELECT COUNT(*)
		INTO co_pilot_count
		FROM FlightEmployees
		WHERE AssignedToFlight = NEW.AssignedToFlight AND Role = 'Co-Pilot';

		IF NEW.Role = 'Co-Pilot' AND co_pilot_count >= 2 THEN
			SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = 'Error: There can only be up to two co-pilots for each flight.';
		END IF;
	END;

	-- *** IR-8: The commander and co-pilots must meet the required minimum of flight hours for the flight's assigned plane. ***
	CREATE TRIGGER tr_check_commander_flight_hours
	BEFORE INSERT ON FlightEmployees
	FOR EACH ROW
	BEGIN
		DECLARE commander_hours INT;

		SELECT MinimumFlightHours 
		INTO commander_hours
		FROM Aircraft
		WHERE TailNumber = (SELECT AssignedToAircraft FROM Flight WHERE FlightCode = NEW.AssignedToFlight);

		IF (NEW.Role = 'Commander' OR NEW.Role = "Co-Pilot") AND NEW.ID IN (
			SELECT ID
			FROM PilotQualifications
			WHERE HoursOfFlight < commander_hours AND PlaneModelCode = (SELECT ModelCode 
			FROM Aircraft
			WHERE TailNumber
            = (SELECT AssignedToAircraft FROM Flight WHERE FlightCode = NEW.AssignedToFlight))
		) THEN
			SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = 'Error: A commander or co-pilot does not meet the required minimum flight hours for the flight''s assigned plane.';
		END IF;
	END;

	-- *** IR-9: There can only be one commander per flight. ***
	CREATE TRIGGER tr_check_unique_commander
	BEFORE INSERT ON FlightEmployees
	FOR EACH ROW
	BEGIN
		DECLARE commander_count INT;

		SELECT COUNT(*)
		INTO commander_count
		FROM FlightEmployees
		WHERE AssignedToFlight = NEW.AssignedToFlight AND Role = 'Commander';

		IF NEW.Role = 'Commander' AND commander_count >= 1 THEN
			SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = 'Error: There can only be one commander per flight.';
		END IF;
	END;
//DELIMITER ;

INSERT INTO FlightEmployees (ID, AssignedToFlight, Role)
VALUES
    (60282, "0001-AAL", "Commander"),
    (4800, "0001-AAL", "Co-Pilot"),
    (20933, "0001-AAL", "Co-Pilot"),
	(779, "0002-BAW", "Commander"),
	(20012, "0003-UAE", "Commander"),
	(06722, "0004-SIA", "Commander"),
	(01232, "0005-UAL", "Commander"),
	(002011, "0006-TAP", "Commander"),
    (01232, "0007-UAL", "Commander"),
	(06722, "0008-SIA", "Commander"),
	(04050, "0009-LAN", "Commander"),
	(2991, "0010-CAL", "Commander"),
	(4800, "0011-AAL", "Commander"),
	(7893, "0012-DLH", "Commander"),
    (7893, "0013-DLH", "Commander"),
	(06722, "0014-SIA", "Commander"),
	(06722, "0015-SIA", "Commander"),
	(04050, "0016-LAN", "Commander"),
    (567, "0010-CAL", "Flight Attendant"),
    (202, "0009-LAN", "Flight Attendant"),
	(345, "0006-TAP", "Flight Attendant");

SELECT * FROM FlightEmployees;

-- --- Seat TABLE --- --

-- Observation: The "SeatID" primary key of the Seat Table consists of 
-- both the the number and row letter of the seat in the aircraft.

CREATE TABLE IF NOT EXISTS Seat (
    -- ATTRIBUTES --
    SeatID VARCHAR(2), -- Is composed of the seat number and row letter
    InAircraft VARCHAR(6) NOT NULL,
     -- *** IR-5: The class name must be denoted by a two-letter acronym -- (fc - first class, bc - business class, ec - economy class). ***
    Class VARCHAR(2) NOT NULL,
    -- The SeatPrice attribute describes only the price value of the seat in the aircraft, 
    -- therefore it is a static value.
	-- The FullPrice is the sum of BasePrice with SeatPrice, and is therefore calculated in the Ticket table.
    SeatPrice DECIMAL(10, 2) NOT NULL,
	-- CONSTRAINTS --
    CONSTRAINT pk_Seat_SeatID_InAircraft PRIMARY KEY (SeatID, InAircraft),
    CONSTRAINT fk_Seat_InAircraft FOREIGN KEY (InAircraft) REFERENCES Aircraft(TailNumber)
);

-- Trigger to ensure SeatID and Class are stored in uppercase and in the correct order
DELIMITER //
	CREATE TRIGGER tr_before_insert_Seat
	BEFORE INSERT ON Seat
	FOR EACH ROW
	BEGIN
		DECLARE num_part VARCHAR(255);
		DECLARE letter_part VARCHAR(255);
		
		-- Extract the number and letter parts
		SET num_part = LEFT(NEW.SeatID, 1);
		SET letter_part = RIGHT(NEW.SeatID, 1);
		
		-- Check if the number and letter are in the wrong order
		IF NOT (num_part REGEXP '^[0-9]+$' AND letter_part REGEXP '^[A-Za-z]$') THEN
			-- Switch the position of number and letter
			SET NEW.SeatID = CONCAT(letter_part, num_part);
		END IF;

		SET NEW.SeatID = UPPER(NEW.SeatID);
		SET NEW.Class = UPPER(NEW.Class);
	END;

	CREATE TRIGGER tr_before_update_Seat
	BEFORE UPDATE ON Seat
	FOR EACH ROW
	BEGIN
		DECLARE num_part VARCHAR(255);
		DECLARE letter_part VARCHAR(255);
		
		-- Extract the number and letter parts
		SET num_part = LEFT(NEW.SeatID, 1);
		SET letter_part = RIGHT(NEW.SeatID, 1);
		
		-- Check if the number and letter are in the wrong order
		IF NOT (num_part REGEXP '^[0-9]+$' AND letter_part REGEXP '^[A-Za-z]$') THEN
			-- Switch the position of number and letter
			SET NEW.SeatID = CONCAT(letter_part, num_part);
		END IF;

		SET NEW.SeatID = UPPER(NEW.SeatID);
		SET NEW.Class = UPPER(NEW.Class);
	END;
// DELIMITER ;

INSERT IGNORE INTO Seat (SeatID, InAircraft, Class, SeatPrice)
	VALUES ("1a", "XYZ456", "fc", 800.00),
    ("a1", "REA426", "bc", 800.00),
    ("2a", "REA426", "FC", 2400.00),
    ("3B", "FFF230", "BC", 800.00),
    ("4C", "YYY211", "EC", 100.00),
	("A5", "SSS230", "FC", 10000.00),
    ("6e", "DEF789", "EC", 50.00),
    ("7a", "HUA892", "BC", 400.00),
	("8a", "ZZZ421", "FC", 8000.00);

-- Show all seats
SELECT * FROM Seat;

-- Show all seat and the aircrafts they are in
SELECT S.SeatID AS SeatID, S.Class AS SeatClass, 
A.TailNumber, A.ModelCode, A.Manufacturer
FROM Seat S
INNER JOIN Aircraft A ON A.TailNumber = S.InAircraft;

-- --- Passenger TABLE --- --

CREATE TABLE IF NOT EXISTS Passenger (
    -- ATTRIBUTES --
	NIC VARCHAR(9),
    NIF VARCHAR(9) UNIQUE NOT NULL, -- *** IR-1: The NIF (Número de Identificação Fiscal) must be unique. ***
    Name VARCHAR(255) NOT NULL,
	PhoneNumber VARCHAR(15) NOT NULL,
    Email VARCHAR(255) NOT NULL,
    isFrequentFlyer BOOLEAN,
	-- CONSTRAINTS --
    CONSTRAINT pk_Passenger_NIC PRIMARY KEY (NIC)
); 
    
INSERT IGNORE INTO Passenger (NIC, NIF, Name, PhoneNumber, Email)
	VALUES ("123456789", "123456789", "Zara Thompson", "+15551234567", "zara.thompson@zmail.com"),
    ("101010101", "101010101", "Selena Gomes", "+15551234", "selenagomesandthescene@iehoo.com"),
	("835422143", "835422143", "Mei Xjiemomo", "+86964020099", "meixjie@zmail.com");
    
INSERT IGNORE INTO Passenger (NIC, NIF, Name, PhoneNumber, Email)
	VALUES ("987654321", "987654321", "Oliver Johnson", "+15559876543", "oliver.johnson.peanuts@zmail.com"),
    ("112358134", "112358134", "Emily Davis", "+15558765432", "emily.davis.auga@zmail.com"),
    ("235711131", "235711131", "Iara Kroft", "+44203457631", "iara.kroft.tombs@coldmail.com"),
    ("112131415", "112131415", "Harmony Simpson", "+351233456792", "harmonysimpssimps@zmail.com"),
    ("628496812", "628496812", "Aurora Starlight", "+7495555123", "aurorastarlightborealis@inlook.com"),
    ("248163264", "248163264", "Thomas Evergeen", "+351233456792", "thomasevereverevergreen@iehoo.com"),
    ("533199960", "831199962", "Vladmir Yakovsk", "+351911126192", "vladmiryak@coldmail.com"),
    ("305710142", "305710142", "Aurora Starlight", "+15518362400", "anotheraurora@iehoo.com"),
	("999999999", "999999999", "Rayan S. Santana", "+351964010468", "rayanssantana@coldmail.com");

-- Show only passenger that have an iehoo email
SELECT Name, PhoneNumber, Email FROM Passenger WHERE Email LIKE "%@iehoo%";

SELECT * FROM Passenger;

-- --- FrequentPassenger TABLE --- --

-- Observation: A passenger can only become a special frequent flyer only if 
-- they were already a classic frequent flyer and reach twenty thousand leagues.

CREATE TABLE IF NOT EXISTS FrequentPassenger (
    -- ATTRIBUTES --
	PassengerNIC VARCHAR(9) NOT NULL,
	AirlineICAO VARCHAR(3) NOT NULL,
	FrequentFlyerTier VARCHAR(7) NOT NULL,
	Miles DECIMAL(10, 3) NOT NULL,
	HasJulesVerneBonus BOOLEAN,
	-- CONSTRAINTS --
	CONSTRAINT pk_FrequentPassenger_PassengerNIC_AirlineICAO PRIMARY KEY(PassengerNIC, AirlineICAO),
    CONSTRAINT fk_FrequentPassenger_PassengerNIC FOREIGN KEY (PassengerNIC) REFERENCES Passenger(NIC),
	CONSTRAINT fk_FrequentPassenger_AirlineICAO FOREIGN KEY (AirlineICAO) REFERENCES Airline(ICAO)
);

-- *** IR-3 A frequent passenger may only be enrolled in a maximum of five Frequent Flyer airline programs. ***
-- Trigger to limit passenger to only be able to enroll in 5 airlines maximum
DELIMITER //
	CREATE TRIGGER tr_before_insert_frequent_passenger_enrolled_airlines
	BEFORE INSERT ON FrequentPassenger
	FOR EACH ROW
	BEGIN
		DECLARE nic_count INT;

		-- Count the occurrences of the NIC in the table
		SELECT COUNT(*) INTO nic_count
		FROM FrequentPassenger
		WHERE PassengerNIC = NEW.PassengerNIC;

		-- Check if the count is 5
		IF nic_count = 5 THEN
			SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = 'One passenger cannot enroll in more than 5 airlines';
		END IF;
	END;
    
	CREATE TRIGGER tr_before_update_frequent_passenger_enrolled_airlines
	BEFORE UPDATE ON FrequentPassenger
	FOR EACH ROW
	BEGIN
		DECLARE nic_count INT;

		-- Count the occurrences of the NIC in the table
		SELECT COUNT(*) INTO nic_count
		FROM FrequentPassenger
		WHERE PassengerNIC = NEW.PassengerNIC;

		-- Check if the count is 5
		IF nic_count = 5 THEN
			SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = 'One passenger cannot enroll in more than 5 airlines';
		END IF;
	END;
// DELIMITER ;

INSERT IGNORE INTO FrequentPassenger(PassengerNIC, AirlineICAO, FrequentFlyerTier, Miles, HasJulesVerneBonus)
	VALUES ("987654321", "UAE", "classic", 19000, false),
    ("112358134", "AAL", "classic", 19800, false),
    ("305710142", "TAP", "special", 90000, true),
	("101010101", "UAL", "classic", 10000, false),
	("999999999", "AAL", "special", 19999, false);

SELECT p.Name AS PassengerName, p.NIC, fpea.FrequentFlyerTier, fpea.Miles, fpea.HasJulesVerneBonus, a.Name AS EnrolledAirlineName, a.ICAO AS AirlineICAO
FROM Passenger p
INNER JOIN FrequentPassenger fpea
ON fpea.PassengerNIC = p.NIC
INNER JOIN Airline a
ON a.ICAO = fpea.AirlineICAO;

-- --- Ticket TABLE --- --

CREATE TABLE IF NOT EXISTS Ticket (
    -- ATTRIBUTES --
    ReceiptNumber INT AUTO_INCREMENT,
    ForSeat VARCHAR(2) NOT NULL,
    ForFlight VARCHAR(8) NOT NULL,
    InAircraft VARCHAR(6) NOT NULL,
	BookedBy VARCHAR(9) NOT NULL,
    FullPrice DECIMAL(10, 2) NOT NULL,
	-- CONSTRAINTS --
    CONSTRAINT pk_Ticket_ReceiptNumber PRIMARY KEY (ReceiptNumber),
	CONSTRAINT fk_Ticket_ForSeat_InAircraft FOREIGN KEY (ForSeat, InAircraft) REFERENCES Seat(SeatID, InAircraft),
	CONSTRAINT fk_Ticket_ForFlight FOREIGN KEY (ForFlight) REFERENCES Flight(FlightCode),
    CONSTRAINT fk_Ticket_BookedBy FOREIGN KEY (BookedBy) REFERENCES Passenger(NIC),
	-- *** IR-6: A passenger may only be allowed to purchase tickets for flights with distinct codes. ***
	CONSTRAINT uq_Ticket_ForFlight_BookedBy UNIQUE (ForFlight, BookedBy)
);

-- Generate the InAircraft and SeatPrice attributes
-- Calculate and update frequent passenger miles.
DELIMITER //
	CREATE TRIGGER tr_before_insert_Ticket
	BEFORE INSERT ON Ticket
	FOR EACH ROW
	BEGIN
		DECLARE num_part VARCHAR(255);
		DECLARE letter_part VARCHAR(255);
		DECLARE added_miles DECIMAL(10, 3);
        
		-- Extract the number and letter parts
		SET num_part = LEFT(NEW.ForSeat, 1);
		SET letter_part = RIGHT(NEW.ForSeat, 1);
		
		-- Check if the number and letter are in the wrong order
		IF NOT (num_part REGEXP '^[0-9]+$' AND letter_part REGEXP '^[A-Za-z]$') THEN
			-- Switch the position of number and letter
			SET NEW.ForSeat = CONCAT(letter_part, num_part);
		END IF;

		SET NEW.ForSeat = UPPER(NEW.ForSeat);
        
		SET NEW.InAircraft = (SELECT AssignedToAircraft FROM Flight WHERE FlightCode = NEW.ForFlight);
		SET NEW.FullPrice = (SELECT BasePrice FROM Flight WHERE FlightCode = NEW.ForFlight) + 
		(SELECT SeatPrice FROM Seat WHERE SeatID = NEW.ForSeat AND InAircraft = NEW.InAircraft);
        
		-- Get the distance of the flight
		SET added_miles = (SELECT Distance FROM Flight WHERE FlightCode = NEW.ForFlight);

		-- Update passenger miles in the Frequent Passenger table
		UPDATE FrequentPassenger
			SET Miles = CASE WHEN Miles IS NOT NULL AND EXISTS (
			SELECT 1 FROM Flight
			WHERE FlightCode = NEW.ForFlight
			AND OperatedBy = AirlineICAO) THEN 
				Miles + added_miles
			ELSE 
				Miles
			END,
			FrequentFlyerTier = CASE WHEN Miles >= 20000 THEN 
				'special'
			ELSE 
				FrequentFlyerTier
			END,
			HasJulesVerneBonus = CASE WHEN Miles >= 20000 THEN 
				true
			ELSE 
				HasJulesVerneBonus
			END
		WHERE PassengerNIC = NEW.BookedBy
		AND AirlineICAO = (
			SELECT OperatedBy
			FROM Flight
			WHERE FlightCode = NEW.ForFlight
		);
	END;
    
    CREATE TRIGGER tr_before_update_Ticket
	BEFORE UPDATE ON Ticket
	FOR EACH ROW
	BEGIN
		DECLARE num_part VARCHAR(255);
		DECLARE letter_part VARCHAR(255);
    
		-- Extract the number and letter parts
		SET num_part = LEFT(NEW.ForSeat, 1);
		SET letter_part = RIGHT(NEW.ForSeat, 1);
		
		-- Check if the number and letter are in the wrong order
		IF NOT (num_part REGEXP '^[0-9]+$' AND letter_part REGEXP '^[A-Za-z]$') THEN
			-- Switch the position of number and letter
			SET NEW.ForSeat = CONCAT(letter_part, num_part);
		END IF;

		SET NEW.ForSeat = UPPER(NEW.ForSeat);
	END;
// DELIMITER ;
    
INSERT IGNORE INTO Ticket (ReceiptNumber, ForSeat, ForFlight, BookedBy)
VALUES (1, "1a", "0001-AAL", "112358134"),
    (2, "a1", "0007-UAL","101010101"),
    (3, "3b", "0003-UAE", "533199960"),
    (4, "4c", "0009-LAN", "112131415"),
    (5, "5A", "0008-SIA", "235711131"),
	(6, "6E", "0006-TAP", "305710142"),
    (7, "7a", "0010-CAL", "835422143"),
	(8, "8a", "0011-AAL", "999999999"),
    (9, "2a", "0005-UAL", "101010101");
    
SELECT p.Name AS PassengerName, p.NIC, fpea.FrequentFlyerTier, fpea.Miles, fpea.HasJulesVerneBonus, a.Name AS EnrolledAirlineName, a.ICAO AS AirlineICAO
FROM Passenger p
INNER JOIN FrequentPassenger fpea
ON fpea.PassengerNIC = p.NIC
INNER JOIN Airline a
ON a.ICAO = fpea.AirlineICAO;
    
SELECT * FROM Ticket;
    
-- ••••• Show all passenger's trips and associated info •••••
SELECT
    AL.Name AS Airline,
    T.ReceiptNumber AS ReceiptNumber,
    T.BookedBy AS NIC,
    P.NIF AS NIF,
    P.Name AS Name,
    FP.FrequentFlyerTier AS FrequentPassengerTier,
    CONCAT((CASE WHEN AC.Manufacturer LIKE 'Boeing%' THEN 
				'Boeing '
			ELSE 
				CONCAT(AC.Manufacturer, ' ', LEFT(AC.Manufacturer, 1))
			END), '', AC.ModelCode) AS Aicraft,
	T.ForSeat AS Seat,
    S.Class,
    T.FullPrice,
    T.ForFlight AS FlightCode,
    E.Name AS CommanderName,
    A.ICAO AS OrigICAO,
    A.IATA AS OrigIATA,
    CA.Name AS OrigCountry,
    A.City AS OrigCity,
    A.Name AS OrigAirportName,
    B.ICAO AS DestICAO,
    B.IATA AS DestIATA,
    CB.Name AS DestCountry,
    B.City AS DestCity,
    B.Name AS DestAirportName,
	F.Distance AS FlightMiles,
    F.EstimatedDepartureTime, 
    F.RealDepartureTime, 
    F.EstimatedArrivalTime, 
    F.RealArrivalTime,
    CONCAT(
		TIME_FORMAT(TIMEDIFF(F.RealArrivalTime, F.RealDepartureTime), '%H'), 'h ',
		TIME_FORMAT(TIMEDIFF(f.RealArrivalTime, f.RealDepartureTime), '%i'), 'm'
	) AS FlightDuration
FROM Ticket T
INNER JOIN Passenger P ON P.NIC = (SELECT NIC FROM Passenger WHERE NIC = T.BookedBy)
INNER JOIN Seat S ON S.SeatID = T.ForSeat AND S.InAircraft = T.InAircraft
INNER JOIN Airline AL ON AL.ICAO = (SELECT OwnedBy FROM Aircraft WHERE TailNumber = S.InAircraft)
LEFT JOIN FrequentPassenger FP ON FP.PassengerNIC = T.BookedBy AND FP.AirlineICAO = AL.ICAO
INNER JOIN Aircraft AC ON AC.TailNumber = S.InAircraft
INNER JOIN Flight F ON F.FlightCode = T.ForFlight
INNER JOIN Employee E ON E.ID = (SELECT ID FROM FlightEmployees WHERE Role = "Commander" AND AssignedToFlight = F.FlightCode)
INNER JOIN Airport A ON A.ICAO = (SELECT Origin FROM Flight WHERE FlightCode = T.ForFlight)
INNER JOIN Country CA ON CA.CountryCode = A.CountryCode
INNER JOIN Airport B ON B.ICAO = (SELECT Destination FROM Flight WHERE FlightCode = T.ForFlight)
INNER JOIN Country CB ON CB.CountryCode = B.CountryCode;