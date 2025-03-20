pragma solidity 0.8.20; //Do not change the solidity version as it negatively impacts submission grading
// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/access/Ownable.sol";
import "./YourToken.sol";

contract Vendor is Ownable{
    event BuyTokens(address buyer, uint256 amountOfETH, uint256 amountOfTokens);
    event SellTokens(address seller, uint256 amountOfTokens, uint256 amountOfETH);

    uint256 public constant tokensPerEth = 100;

    YourToken public yourToken;

    constructor(address tokenAddress) Ownable(msg.sender) {
        yourToken = YourToken(tokenAddress);
    }

    function buyTokens() public payable {
        require(msg.value > 0, "Vendor: no ETH sent");
        uint256 _amountOfTokens = msg.value * tokensPerEth;
        yourToken.transfer(msg.sender, _amountOfTokens);
        emit BuyTokens(msg.sender, msg.value, _amountOfTokens);
    }


    function withdraw() public onlyOwner {
        require(address(this).balance > 0, "Vendor: no balance to withdraw");
        payable(owner()).transfer(address(this).balance);
    }

    function sellTokens(uint256 _amount) public {
        require(_amount > 0, "Vendor: amount must be greater than 0");
        require(yourToken.balanceOf(msg.sender) >= _amount, "Vendor: insufficient balance");
        require(yourToken.allowance(msg.sender, address(this)) >= _amount, "Vendor: insufficient allowance");
        yourToken.transferFrom(msg.sender, address(this), _amount);
        payable(msg.sender).transfer(_amount / tokensPerEth);

        emit SellTokens(msg.sender, _amount, _amount / tokensPerEth);
    }
    // ToDo: create a payable buyTokens() function:

    // ToDo: create a withdraw() function that lets the owner withdraw ETH

    // ToDo: create a sellTokens(uint256 _amount) function:
}
