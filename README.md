<h1>${\textsf{\color{blue}WeFly}}$</h1>

<strong>WeFly</strong> is a database schema designed to manage data related to flights such as airlines, employees, flight information, 
aircraft, airports, and more.

- Tables:

  1. Airline Table<br>
  Purpose: Stores information about airlines.<br>
  Attributes: `ICAO, IATA, Name, CountryOfOrigin`<br>
  Constraints: Primary key on `ICAO`.

  3. Employee Table<br>
  Purpose: Stores information about airline employees.<br>
  Attributes: `ID, NIF, Name, Gender, DateOfBirth, EmployedBy (references Airline.ICAO), EmployedSince, Role`<br>
  Constraints: Primary key on `ID`, foreign key on `EmployedBy`.

  4. Pilot Table<br>
  Purpose: Extends Employee for pilots and stores additional pilot-specific information.<br>
  Attributes: `ID (references Employee.ID), IsTrainingPilotUntil`<br>
  Constraints: Primary key on `ID`, foreign key on `ID` referencing Employee.

  5. PilotQualifications Table<br>
  Purpose: Tracks qualifications of pilots.<br>
  Attributes: `ID (references Pilot.ID), Manufacturer, PlaneModelCode, Since, HoursOfFlight`<br>
  Constraints: Composite primary key on `ID`, `Manufacturer`, `PlaneModelCode`; foreign key on `ID`.

  6. TechnicianQualifications Table<br>
  Purpose: Tracks qualifications of technicians.<br>
  Attributes: `ID (references Employee.ID), QualificationType`<br>
  Constraints: Foreign key on `ID`, allowing only technicians to be added.

  7. Country Table<br>
  Purpose: Stores information about countries.<br>
  Attributes: `CountryCode, Name`<br>
  Constraints: Primary key on `CountryCode`.

  8. Airport Table<br>
  Purpose: Stores information about airports.<br>
  Attributes: `ICAO, IATA, Name, CountryCode, City, Coordinates, OpeningHour, ClosingHour, MinimumTransferTime, MaximumSupportedPlaneSize`<br>
  Constraints: Primary key on `ICAO`, check constraint on `MaximumSupportedPlaneSize`.

  9. Aircraft Table<br>
  Purpose: Stores information about aircraft.<br>
  Attributes: `TailNumber, ModelCode, Manufacturer, ManufactureYear, MinimumFlightHours, RequiredNumberOfFlightAttendants, AircraftSize, OwnedBy (references Airline.ICAO)`<br>
  Constraints: Composite primary key on `TailNumber`, `OwnedBy`; foreign key on `OwnedBy`.

  10. Flight Table<br>
  Purpose: Stores information about flights.<br>
  Attributes: `FlightIdentifier, OperatedBy (references Airline.ICAO), FlightCode, BasePrice, AssignedToAircraft, Origin, Destination, Distance, EstimatedDepartureTime, RealDepartureTime, EstimatedArrivalTime, RealArrivalTime, IsCancelled, IsPartOfNonDirectFlight, NonDirectFlightRoutingCode, ConnectsFromFlightCode, ConnectsToFlightCode`<br>
  Constraints: Composite primary key on `FlightCode`, `EstimatedDepartureTime`, `EstimatedArrivalTime`; various foreign keys and check constraints.

  11. FlightEmployees Table<br>
  Purpose: Tracks employees assigned to flights.<br>
  Attributes: `ID (references Employee.ID), AssignedToFlight (references Flight.FlightCode), Role`<br>
  Constraints: Composite primary key on `ID`, `AssignedToFlight`; various triggers enforce business rules.

  12. Seat Table<br>
  Purpose: Stores information about seats in aircraft.<br>
  Attributes: `SeatID, InAircraft (references Aircraft.TailNumber), Class, SeatPrice`<br>
  Constraints: Composite primary key on `SeatID`, `InAircraft`; triggers enforce data integrity.

  13. Passenger Table<br>
  Purpose: Stores information about passengers.<br>
  Attributes: `NIC, NIF, Name, PhoneNumber, Email, isFrequentFlyer`<br>
  Constraints: Primary key on `NIC`, unique constraint on `NIF`, various data integrity constraints.

  14. FrequentPassenger Table<br>
  Purpose: Stores information about frequent passengers of airlines.<br>
  Attributes: `PassengerNIC, AirlineICAO, FrequentFlyerTier, Miles, HasJulesVerneBonus`<br>
  Constraints: Composite primary key on `PassengerNIC` and `AirlineICAO`, foreign keys on `PassengerNIC` and `AirlineICAO`.

  15. Ticket Table<br>
  Purpose: Stores information about tickets purchased by passengers for flights.<br>
  Attributes: `ReceiptNumber, ForSeat, ForFlight, InAircraft, BookedBy, FullPrice`<br>
  Constraints: Primary key on `ReceiptNumber`, foreign keys on `ForSeat`, `ForFlight`, and `BookedBy`; unique constraint on `(ForFlight, BookedBy)`.

<strong>Developed By:</strong>
Rayan S. Santana
