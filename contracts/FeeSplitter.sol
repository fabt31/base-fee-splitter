// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract FeeSplitter is Ownable, ReentrancyGuard {
    using SafeERC20 for IERC20;

    struct Allocation {
        address recipient;
        uint256 bps; // basis points, sum must = 10000
    }

    Allocation[] public allocations;
    uint256 public totalBps;

    event FeesDistributed(address indexed token, uint256 total);
    event AllocationUpdated(address indexed recipient, uint256 bps);

    constructor(Allocation[] memory allocs) Ownable(msg.sender) {
        _setAllocations(allocs);
    }

    function distribute(address token) external nonReentrant {
        uint256 balance = token == address(0)
            ? address(this).balance
            : IERC20(token).balanceOf(address(this));
        require(balance > 0, "No balance");

        for (uint256 i = 0; i < allocations.length; i++) {
            uint256 amount = (balance * allocations[i].bps) / 10000;
            if (amount == 0) continue;
            if (token == address(0)) {
                payable(allocations[i].recipient).transfer(amount);
            } else {
                IERC20(token).safeTransfer(allocations[i].recipient, amount);
            }
        }
        emit FeesDistributed(token, balance);
    }

    function setAllocations(Allocation[] calldata allocs) external onlyOwner {
        _setAllocations(allocs);
    }

    function _setAllocations(Allocation[] memory allocs) internal {
        delete allocations;
        totalBps = 0;
        for (uint256 i = 0; i < allocs.length; i++) {
            require(allocs[i].recipient != address(0), "Zero addr");
            allocations.push(allocs[i]);
            totalBps += allocs[i].bps;
            emit AllocationUpdated(allocs[i].recipient, allocs[i].bps);
        }
        require(totalBps == 10000, "Must sum to 10000");
    }

    function getAllocations() external view returns (Allocation[] memory) { return allocations; }
    receive() external payable {}
}