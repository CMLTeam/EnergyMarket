pragma solidity ^0.4.11;

//
// Smart contract for simplifying the P2P contracts
// between energy consumers & producers
//
contract EnergyMarketContract {
    mapping(address => uint256) consumersBalances;

    mapping(address => mapping(uint8 => MonthEnergyProposal)) proposalsByProducer;
    mapping(address => mapping(uint8 => MonthEnergyCommitment)) commitsByConsumer;

    address owner;

    event ErrorLog(address actor, string errorMsg);

    // TODO: conversion rate Eth -> EnergyMarket
    uint32 CONVERSION_RATE = 1;

    struct MonthEnergyProposal {
        uint8 month;
        uint128 volume;
        uint32 price;
        uint32 priceBeyondInterval;
    }

    struct MonthEnergyCommitment {
        uint8 month;
        address consumer;
        uint128 commitedVolume;
    }

    function EnergyMarketContract() {
        owner = msg.sender;
    }

    // refill with Eth
    function refillConsumerBalance() payable returns (bool sucess) {
        address consumer = msg.sender;

        if(owner.send(msg.value)) {
            consumersBalances[consumer] += CONVERSION_RATE * msg.value;
            return true;
        } else {
            ErrorLog(consumer, "Alredy has proposal for month");
        }
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

    // Consumer in advance commits to consume (& so pay afterwards) specifies amount of energy (in interval).
    // If he violates this commitment - he will be suject to additional fee as set by producer
    function commitToConsumeEnergy(address producerToBuyFrom, uint8 month, uint128 commitedVolume) returns (bool success) {
        address consumer = msg.sender;
        MonthEnergyProposal memory proposal = proposalsByProducer[producerToBuyFrom][month];

        if (proposal.month == 0) {
            ErrorLog(consumer, "No energy proposals for given month");
            return false;
        }

        if (proposal.volume < commitedVolume) {
            ErrorLog(consumer, "Not enough energy for given month");
            return false;
        }

        MonthEnergyCommitment memory commitment;
        commitment.month = month;
        commitment.consumer = consumer;
        commitment.commitedVolume = commitedVolume;
        commitsByConsumer[consumer][month] = commitment;

        proposal.volume -= commitedVolume;
        proposalsByProducer[producerToBuyFrom][month] = proposal;
        return true;
    } 
}