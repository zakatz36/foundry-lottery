// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {Raffle} from "src/Raffle.sol";
import {DeployRaffle} from "script/DeployRaffle.s.sol";
import {FundSubscription, CreateSubscription, AddConsumer} from "script/Interactions.s.sol";
import {VRFCoordinatorV2_5Mock} from "@chainlink/contracts/src/v0.8/vrf/mocks/VRFCoordinatorV2_5Mock.sol";

contract InteractionsTest is Test {
    event SubscriptionConsumerAdded(uint256 indexed subId, address consumer);

    Raffle raffle;

    function setUp() external {
        DeployRaffle deployRaffle = new DeployRaffle();
        (raffle,) = deployRaffle.deployContract();
    }

    // testCreateSubscription
    // testFundSubscription
    // testAddConsumer

    function testSubscriptionCreated() public {
        CreateSubscription createSubscription = new CreateSubscription();
        (uint256 subId, address vrfCoordinator,) = createSubscription.createSubscriptionUsingConfig();
        assert(subId > 0);
        assert(vrfCoordinator != address(0));
    }

    function testConsumerAdded() public {
        CreateSubscription createSubscription = new CreateSubscription();
        (uint256 subId, address vrfCoordinator, address account) = createSubscription.createSubscriptionUsingConfig();
        AddConsumer addConsumer = new AddConsumer();
        addConsumer.addConsumer(address(raffle), vrfCoordinator, subId, address(account));
        assertTrue(addConsumer.consumerAddedForTesting());
    }

    function testSubscriptionFunded() public {
        CreateSubscription createSubscription = new CreateSubscription();
        (uint256 subId, address vrfCoordinator, address account) = createSubscription.createSubscriptionUsingConfig();
        FundSubscription fundSubscription = new FundSubscription();
        fundSubscription.fundSubscription(vrfCoordinator, subId, address(0), account);
        assertTrue(fundSubscription.subscriptionFundedForTesting());
    }
}
