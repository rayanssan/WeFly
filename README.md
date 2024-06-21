<h1>WeFly</h1>

<strong>WeFly</strong> is a database schema designed to manage data related to flights such as airlines, employees, flight information, 
aircraft, airports, and more.

- Tables:

  1. Airline Table
  Purpose: Stores information about airlines.
  Attributes: ICAO (3-character code), IATA (2-character code), Name, CountryOfOrigin.
  Constraints: Primary key on ICAO.

  2. Employee Table
  Purpose: Stores information about airline employees.
  Attributes: ID, NIF, Name, Gender, DateOfBirth, EmployedBy (references Airline.ICAO), EmployedSince, Role.
  Constraints: Primary key on ID, foreign key on EmployedBy.

  3. Pilot Table
  Purpose: Extends Employee for pilots and stores additional pilot-specific information.
  Attributes: ID (foreign key to Employee), IsTrainingPilotUntil (date).
  Constraints: Primary key on ID, foreign key on ID referencing Employee.

  4. PilotQualifications Table
  Purpose: Tracks qualifications of pilots.
  Attributes: ID (foreign key to Pilot), Manufacturer, PlaneModelCode, Since, HoursOfFlight.
  Constraints: Composite primary key on ID, Manufacturer, PlaneModelCode; foreign key on ID.

  5. TechnicianQualifications Table
  Purpose: Tracks qualifications of technicians.
  Attributes: ID (foreign key to Employee), QualificationType.
  Constraints: Foreign key on ID, allowing only technicians to be added.

  6. Country Table
  Purpose: Stores information about countries.
  Attributes: CountryCode, Name.
  Constraints: Primary key on CountryCode.
  Usage Example: Provides details about countries like Portugal, United States, etc.

  7. Airport Table
  Purpose: Stores information about airports.
  Attributes: ICAO, IATA, Name, CountryCode, City, Coordinates, OpeningHour, ClosingHour, MinimumTransferTime, MaximumSupportedPlaneSize.
  Constraints: Primary key on ICAO, check constraint on MaximumSupportedPlaneSize.

  8. Aircraft Table
  Purpose: Stores information about aircraft.
  Attributes: TailNumber, ModelCode, Manufacturer, ManufactureYear, MinimumFlightHours, RequiredNumberOfFlightAttendants, AircraftSize, OwnedBy (references Airline.ICAO).
  Constraints: Composite primary key on TailNumber, OwnedBy; foreign key on OwnedBy.

  9. Flight Table
  Purpose: Stores information about flights.
  Attributes: FlightIdentifier, OperatedBy (references Airline.ICAO), FlightCode, BasePrice, AssignedToAircraft, Origin, Destination, Distance, EstimatedDepartureTime, RealDepartureTime, EstimatedArrivalTime, RealArrivalTime, IsCancelled, IsPartOfNonDirectFlight, NonDirectFlightRoutingCode, ConnectsFromFlightCode, ConnectsToFlightCode.
  Constraints: Composite primary key on FlightCode, EstimatedDepartureTime, EstimatedArrivalTime; various foreign keys and check constraints.

  10. FlightEmployees Table
  Purpose: Tracks employees assigned to flights.
  Attributes: ID (references Employee.ID), AssignedToFlight (references Flight.FlightCode), Role.
  Constraints: Composite primary key on ID, AssignedToFlight; various triggers enforce business rules.

  11. Seat Table
  Purpose: Stores information about seats in aircraft.
  Attributes: SeatID, InAircraft (references Aircraft.TailNumber), Class, SeatPrice.
  Constraints: Composite primary key on SeatID, InAircraft; triggers enforce data integrity.
