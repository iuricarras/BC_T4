// SPDX-License-Identifier: UNLICENSED

// DO NOT MODIFY BELOW THIS
pragma solidity ^0.8.17;

import "forge-std/console.sol";

contract Splitwise {
// DO NOT MODIFY ABOVE THIS

// ADD YOUR CONTRACT CODE BELOW

    mapping(address => mapping(address => uint32)) private dividas;

    function lookup(address debtor, address creditor) public view returns (uint32 ret) {
        // Returns the amount that the debtor owes the creditor
        ret = dividas[debtor][creditor];
        return ret;
    }

    function addIOU(address creditor, uint32 amount, address debtor) public {
        // Informs the contract that msg.sender now owes amount more dollars to creditor

        vm.prank(debtor);

        require(amount >= 0, "Amount can't be negative");                          
        dividas[msg.sender][creditor] = amount;
    }
}
