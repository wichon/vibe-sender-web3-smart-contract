// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract VibeSender {
    mapping(address => uint256) public goodVibesBalance;
    mapping(address => uint256) public badVibesBalance;
    mapping(address => uint256) public lastWavedAt;

    event NewVibe(address indexed from, uint256 timestamp, bool _isGood, string message);

    struct Vibe {
        address viber; // The address of the user who vibed.
        bool isGood; // Is a good or bad vibe?
        string message; // The message the user sent.
        uint256 timestamp; // The timestamp when the user vibed.
    }

    Vibe[] vibes;
    uint256 totalGoodVibes;
    uint256 totalBadVibes;

    uint256 private seed;

    constructor() payable {
        console.log("VibeSender Contract!");

        /*
         * Set the initial seed
         */
        seed = (block.timestamp + block.difficulty) % 100;
    }

    function sendVibe(string memory _message, bool _isGood) public {
        require(
            lastWavedAt[msg.sender] + 3 minutes < block.timestamp,
            "Wait 3m"
        );
        lastWavedAt[msg.sender] = block.timestamp;

        if (_isGood) {
            goodVibesBalance[msg.sender] = goodVibesBalance[msg.sender] + 1;
            totalGoodVibes += 1;
        }
        else {
            badVibesBalance[msg.sender] = badVibesBalance[msg.sender] + 1;
            totalBadVibes += 1;
        }

        console.log("%s vibe received with message %s", _isGood ? "Good": "Bad", _message);

        vibes.push(Vibe(msg.sender, _isGood, _message, block.timestamp));

        /*
         * Generate a new seed for the next user that sends a wave
         */
        seed = (block.difficulty + block.timestamp + seed) % 100;

        console.log("Random # generated: %d", seed);

        emit NewVibe(msg.sender, block.timestamp, _isGood, _message);

        if (seed <= 20) {
            uint256 prizeAmount = _isGood ? 0.0002 ether : 0.0001 ether;
            require(
                prizeAmount <= address(this).balance,
                "Yikes, this is unfortunate we don't have any more ether to give :')."
            );
            (bool success, ) = (msg.sender).call{value: prizeAmount}("");
            require(success, "Oops!, Failed to withdraw money from contract.");
            if (success) {
                console.log("Lucky you!, you recieved %d ether as a reward for your vibe (Good vibes get more, wink, wink!)", prizeAmount);
            }
        }
    }

    function getAllVibes() public view returns (Vibe[] memory) {
        return vibes;
    }

    function getMyVibesCountByType(bool _good) public view returns (uint256) {
        uint256 myTotalVibes;
        if (_good)
            myTotalVibes = goodVibesBalance[msg.sender];
        else
            myTotalVibes = badVibesBalance[msg.sender];

        console.log("You sent %d %s vibes!", myTotalVibes, _good ? "Good": "Bad");
        return myTotalVibes;
    }

    function getMyVibesCount() public view returns (uint256) {
        uint256 myTotalVibes;
        myTotalVibes = goodVibesBalance[msg.sender] + badVibesBalance[msg.sender];

        console.log("You sent %d vibes!", myTotalVibes);
        return myTotalVibes;
    }

    function getTotalVibes() public view returns (uint256) {
        uint256 totalVibes = totalGoodVibes + totalBadVibes;
        console.log("A total %d vibes have been sent!", totalVibes);
        return totalVibes;
    }

    function getTotalVibesByType(bool _good) public view returns (uint256) {
        uint256 totalVibes = _good ? totalGoodVibes : totalBadVibes;
        console.log("A total of %d %s vibes have been sent!", totalVibes, _good ? "Good": "Bad");
        return totalVibes;
    }

    function getMyVibeScore() public view returns (int256) {
        console.log("Calculating the vibe score for: %s ...", msg.sender);
        int256 vibeScore = int256(goodVibesBalance[msg.sender]) - int256(badVibesBalance[msg.sender]);
        if (vibeScore > 0)
            console.log("--- You are definitely a nice person, plz dont change :') !");
        else if (vibeScore < 0)
            console.log("--- Yooo chill, nobody is going to like you with that attitude :@ !");
        else
            console.log("--- I am not sure about you!");
        console.log("--- Vibe Score: %s", vibeScore < 0 ? "Bad" : "Good");
        return vibeScore;
    }
}