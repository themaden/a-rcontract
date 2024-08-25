// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IDID {
    function verifyIdentity(address user) external view returns (bool);
}

contract FlightBookingSystem {
    mapping(address => uint256) private balances;
    mapping(uint256 => Flight) public flights;
    mapping(address => string[]) private carbonOffsetCertificates; // Kullanıcıların karbon dengeleme sertifikalarını saklamak için
    mapping(address => MembershipLevel) private membershipLevels; // Kullanıcıların üyelik seviyelerini saklamak için

    address private owner;
    uint256 private carbonOffsetCostPerTon = 0.005 ether; // Ton başına sabit bir dengeleme ücreti
    uint256 private distanceRatePerKm = 0.01 ether; // Her kilometre başına ücret
    IDID private didContract; // DID kontratı için arayüz

    enum MembershipLevel { Bronze, Silver, Gold }

    struct Flight {
        uint256 flightNumber;
        string airline;
        string aircraftType;
        string departureCity;
        string destinationCity;
        uint256 departureTime;
        uint256 baseTariff;
        uint256 seatsAvailable;
        uint256 distance;  // Uçuş mesafesi
        bool exists;
    }

    event TariffUpdated(uint256 indexed flightNumber, uint256 newTariff);
    event BalanceUpdated(address indexed user, uint256 newBalance);
    event CarbonOffsetCertificateIssued(address indexed user, string certificateId);
    event MembershipLevelUpdated(address indexed user, MembershipLevel level);

    modifier hasSufficientBalance(uint256 amount) {
        require(balances[msg.sender] >= amount, "Insufficient balance");
        _;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the contract owner");
        _;
    }

    modifier identityVerified() {
        require(didContract.verifyIdentity(msg.sender), "Identity not verified");
        _;
    }

    constructor(address _didContract) {
        owner = msg.sender;
        didContract = IDID(_didContract);
    }

    function loadBalance() external payable {
        require(msg.value > 0, "Send ETH to load balance");
        balances[msg.sender] += msg.value;
        emit BalanceUpdated(msg.sender, balances[msg.sender]);
    }

    function addFlight(
        uint256 flightNumber,
        string memory airline,
        string memory aircraftType,
        string memory departureCity,
        string memory destinationCity,
        uint256 departureTime,
        uint256 baseTariff,
        uint256 seatsAvailable,
        uint256 distance
    ) external onlyOwner {
        require(!flights[flightNumber].exists, "Flight already exists");
        flights[flightNumber] = Flight(
            flightNumber,
            airline,
            aircraftType,
            departureCity,
            destinationCity,
            departureTime,
            baseTariff,
            seatsAvailable,
            distance,
            true
        );
    }

    function updateFlight(
        uint256 flightNumber,
        string memory airline,
        string memory aircraftType,
        string memory departureCity,
        string memory destinationCity,
        uint256 departureTime,
        uint256 baseTariff,
        uint256 seatsAvailable,
        uint256 distance
    ) external onlyOwner {
        Flight storage flight = flights[flightNumber];
        require(flight.exists, "Flight does not exist");

        flight.airline = airline;
        flight.aircraftType = aircraftType;
        flight.departureCity = departureCity;
        flight.destinationCity = destinationCity;
        flight.departureTime = departureTime;
        flight.baseTariff = baseTariff;
        flight.seatsAvailable = seatsAvailable;
        flight.distance = distance;

        // Mesafeye göre tarifeyi güncelle
        updateTariffBasedOnDistance(flightNumber);

        // Talebe göre tarifeyi güncelle
        updateTariffBasedOnDemand(flightNumber);

        emit TariffUpdated(flightNumber, flight.baseTariff);
    }

    function checkBalance() external view returns (uint256) {
        return balances[msg.sender];
    }

    function calculateCarbonFootprint(uint256 flightNumber) public view returns (uint256) {
        Flight storage flight = flights[flightNumber];
        require(flight.exists, "Flight does not exist");

        uint256 emissionsPerMile = 53; // Örneğin, her mil başına 53 gram CO2 salınımı
        uint256 totalEmissions = flight.distance * emissionsPerMile;

        return totalEmissions; // Gram cinsinden CO2 miktarı
    }

    function updateTariffBasedOnDemand(uint256 flightNumber) internal {
        Flight storage flight = flights[flightNumber];
        uint256 timeRemaining = flight.departureTime - block.timestamp;

        if (flight.seatsAvailable < 10 || timeRemaining < 1 days) {
            flight.baseTariff = flight.baseTariff * 110 / 100; // Tarife %10 artar
            emit TariffUpdated(flightNumber, flight.baseTariff);
        }
        if (timeRemaining < 12 hours) {
            flight.baseTariff = flight.baseTariff * 125 / 100; // Tarife %25 artar
            emit TariffUpdated(flightNumber, flight.baseTariff);
        }
    }

    function updateTariffBasedOnDistance(uint256 flightNumber) internal {
        Flight storage flight = flights[flightNumber];
        uint256 distanceBasedTariff = flight.distance * distanceRatePerKm;
        flight.baseTariff += distanceBasedTariff;

        emit TariffUpdated(flightNumber, flight.baseTariff);
    }

    function issueCarbonOffsetCertificate(address user, string memory certificateId) internal {
        carbonOffsetCertificates[user].push(certificateId);
        emit CarbonOffsetCertificateIssued(user, certificateId);
    }

    function withdrawFunds(uint256 amount) external onlyOwner {
        require(amount <= address(this).balance, "Insufficient contract balance");
        payable(owner).transfer(amount);
    }

    function _calculateDiscount(address user, uint256 flightNumber) internal view returns (uint256) {
        MembershipLevel level = membershipLevels[user];
        if (level == MembershipLevel.Silver) {
            return flights[flightNumber].baseTariff * 5 / 100; // %5 indirim
        } else if (level == MembershipLevel.Gold) {
            return flights[flightNumber].baseTariff * 10 / 100; // %10 indirim
        }
        return 0; // Bronz üyeler için indirim yok
    }

    function getMembershipLevel(address user) external view returns (MembershipLevel) {
        return membershipLevels[user];
    }
}
