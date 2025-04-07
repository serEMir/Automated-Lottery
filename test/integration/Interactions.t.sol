// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {Test} from "forge-std/Test.sol";
import {Raffle} from "src/Raffle.sol";
import {VRFCoordinatorV2_5Mock} from "@chainlink/contracts/src/v0.8/vrf/mocks/VRFCoordinatorV2_5Mock.sol";
import {HelperConfig, CodeConstants} from "script/HelperConfig.s.sol";
import {DeployRaffle} from "script/DeployRaffle.s.sol";
import {Vm} from "forge-std/Vm.sol";

contract InteractionsTest is Test, CodeConstants {
    Raffle private raffle;
    HelperConfig private helperConfig;

    event RaffleEntered(address indexed player);
    event WinnerPicked(address indexed winner);

    uint256 minEntranceFee;
    uint256 interval;
    address vrfCoordinator;
    bytes32 gasLane;
    uint256 subscriptionId;
    uint32 callbackGasLimit;

    address public PLAYER1 = makeAddr("player1");
    address public PLAYER2 = makeAddr("player2");
    address public PLAYER3 = makeAddr("player3");
    uint256 public constant STARTING_PLAYER_BALANCE = 10 ether;

    function setUp() public {
        DeployRaffle deployer = new DeployRaffle();
        (raffle, helperConfig) = deployer.deployContract();
        HelperConfig.NetworkConfig memory config = helperConfig.getConfig();
        minEntranceFee = config.minEntranceFee;
        interval = config.interval;
        vrfCoordinator = config.vrfCoordinator;
        gasLane = config.gasLane;
        subscriptionId = config.subscriptionId;
        callbackGasLimit = config.callbackGasLimit;

        vm.deal(PLAYER1, STARTING_PLAYER_BALANCE);
        vm.deal(PLAYER2, STARTING_PLAYER_BALANCE);
        vm.deal(PLAYER3, STARTING_PLAYER_BALANCE);
    }

    modifier skipFork() {
        if (block.chainid != LOCAL_CHAIN_ID) {
            return;
        }
        _;
    }

    function testEntireRaffleFlow() public skipFork {
        vm.prank(PLAYER1);
        vm.expectEmit(true, false, false, false, address(raffle));
        emit RaffleEntered(PLAYER1);
        raffle.enterRaffle{value: minEntranceFee}();

        vm.prank(PLAYER2);
        vm.expectEmit(true, false, false, false, address(raffle));
        emit RaffleEntered(PLAYER2);
        raffle.enterRaffle{value: minEntranceFee}();

        vm.prank(PLAYER3);
        vm.expectEmit(true, false, false, false, address(raffle));
        emit RaffleEntered(PLAYER3);
        raffle.enterRaffle{value: minEntranceFee}();

        vm.warp(block.timestamp + interval + 1);
        vm.roll(block.number + 1);

        vm.recordLogs();
        raffle.performUpkeep("");
        Vm.Log[] memory entries = vm.getRecordedLogs();
        bytes32 requestId = entries[1].topics[1];

        vm.expectEmit(true, false, false, false, address(raffle));
        emit WinnerPicked(address(PLAYER3)); //already comfirmed PLAYER3 wins, this is just a formality to see that it properly emits
        VRFCoordinatorV2_5Mock(vrfCoordinator).fulfillRandomWords(
            uint256(requestId),
            address(raffle)
        );

        address recentWinner = raffle.getRecentWinner();
        assert(
            recentWinner == PLAYER1 ||
                recentWinner == PLAYER2 ||
                recentWinner == PLAYER3
        );

        assert(raffle.getRaffleState() == Raffle.RaffleState.OPEN);
    }
}
