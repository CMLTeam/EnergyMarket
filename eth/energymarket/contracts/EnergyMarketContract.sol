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
    // TODO: configurable
    uint32 ALLOWENCE_INTERVAL_KWH = 10;

    struct MonthEnergyProposal {
        uint8 month;
        uint128 volume;
        uint32 price;
        uint32 priceBeyondInterval;
    }

    struct MonthEnergyCommitment {
        uint8 month;
        address consumer;
        address producer;
        uint128 commitedVolume;
    }

    function EnergyMarketContract() {
        owner = msg.sender;
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
            ErrorLog(producer, "Already has proposal for month");
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
        commitment.producer = producerToBuyFrom;
        commitsByConsumer[consumer][month] = commitment;

        proposal.volume -= commitedVolume;
        proposalsByProducer[producerToBuyFrom][month] = proposal;
        return true;
    }

    // - Executed at the end of month
    // - Charges the consumer's balance based on real usage
    // - Pays producer in Eth for consumed amount
    function closeMonth(address consumer, uint8 month, uint128 realConsumedVolume) payable returns (bool sucess) {
        MonthEnergyCommitment memory commitment = commitsByConsumer[consumer][month];
        address producer = commitment.producer;
        MonthEnergyProposal memory proposal = proposalsByProducer[producer][month];

        uint256 consumerToPay;

        if (realConsumedVolume < commitment.commitedVolume - ALLOWENCE_INTERVAL_KWH) {
            consumerToPay = proposal.priceBeyondInterval * realConsumedVolume;
        } else if (realConsumedVolume > commitment.commitedVolume - ALLOWENCE_INTERVAL_KWH) {
            uint256 fee = proposal.priceBeyondInterval * (realConsumedVolume - commitment.commitedVolume);
            consumerToPay = proposal.price * realConsumedVolume + fee;
        }

        consumersBalances[consumer] -= consumerToPay;
    
        // transfer Eth to producer
        // TODO usage fee
        if (producer.send(consumerToPay / CONVERSION_RATE)) {
            return true;
        } else {
            ErrorLog(producer, "Can't process transaction");
            return false;
        }
    }

    // Refill with Eth
    function refillConsumerBalance() payable returns (bool sucess) {
        address consumer = msg.sender;

        if(owner.send(msg.value)) {
            consumersBalances[consumer] += CONVERSION_RATE * msg.value;
            return true;
        } else {
            ErrorLog(consumer, "Can't refill");
            return false;
        }
    }
}