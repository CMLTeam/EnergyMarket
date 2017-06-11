pragma solidity ^0.4.11;

contract EnergyMarketContract {
    mapping(address => uint64) consumersBalances;

    mapping(address => mapping(uint8 => MonthEnergyProposal)) proposalsByProducer;

    event ErrorLog(address actor, string errorMsg);

    struct MonthEnergyProposal {
        uint8 month;
        uint128 volume;
        uint32 price;
    }

    function EnergyMarketContract() {
    }

    function refillConsumerBalance() payable {

    }

    function addEnergyProposal(uint8 month, uint128 volume, uint32 price) returns (bool success) {
        address producer = msg.sender;

        MonthEnergyProposal memory proposal;
        proposal.month = month;
        proposal.volume = volume;
        proposal.price = price;

        MonthEnergyProposal memory current = proposalsByProducer[producer][month];

        // if this month was already submitted
        if (current.month != 0) {
            ErrorLog(producer, "Alredy has proposal for month");
            return false;
        }

        proposalsByProducer[producer][month] = proposal;
        return true;
    }

    function prepayConsumedEnergy(address producerToBuyFrom, uint8 month, uint128 requestedVolume) returns (bool success) {
        address consumer = msg.sender;
        MonthEnergyProposal memory proposal = proposalsByProducer[producerToBuyFrom][month];

        if (proposal.month == 0) {
            ErrorLog(consumer, "No energy proposals for given month");
            return false;
        }

        if (proposal.volume < requestedVolume) {
            ErrorLog(consumer, "Not enough energy for given month");
            return false;
        }

        proposal.volume -= requestedVolume;
        proposalsByProducer[producerToBuyFrom][month] = proposal;
        return true;
    } 
}