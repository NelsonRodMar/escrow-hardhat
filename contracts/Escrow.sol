// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

contract Escrow {

	event Approved(uint);
	event Rejected(uint);

	address public arbiter;
	address public beneficiary;
	address public depositor;
	bool public isApproved;

	modifier onlyArbiter {
		require(msg.sender == arbiter, "Only arbiter can call this.");
		_;
	}

	constructor(address _arbiter, address _beneficiary) payable {
		arbiter = _arbiter;
		beneficiary = _beneficiary;
		depositor = msg.sender;
	}


	function approve() external onlyArbiter {
		require(!isApproved, "Escrow: already approved");
		uint balance = address(this).balance;
		(bool sent, ) = payable(beneficiary).call{value: balance}("");
 		require(sent, "Failed to send Ether");
		emit Approved(balance);
		isApproved = true;
	}

	function reject() external onlyArbiter {
		require(!isApproved, "Escrow: already approved");
		uint balance = address(this).balance;
		require(balance > 0, "Escrow: no balance");
		(bool sent, ) = payable(depositor).call{value: balance}("");
 		require(sent, "Failed to send Ether");
		emit Rejected(balance);
	}

	function changeArbiter(address _arbiter) external onlyArbiter {
		require(!isApproved, "Escrow: already approved");
		arbiter = _arbiter;
	}

	function changeBeneficiary(address _beneficiary) external onlyArbiter {
		require(!isApproved, "Escrow: already approved");
		beneficiary = _beneficiary;
	}
}
