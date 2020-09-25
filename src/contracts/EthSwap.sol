pragma solidity ^0.5.0;
import "./Token.sol";

contract EthSwap {
    string public name = "EthSwap Exchange";
    Token public token;
    uint public rate = 100;

    event TokensPurchased(
        address account,
        address token,
        uint amount,
        uint rate
    );

    event TokensSold(
        address account,
        address token,
        uint amount,
        uint rate
    );

    constructor(Token _token) public {
        token = _token;
    }


    function buyTokens() public payable {
        // Calculate the number of token to buy
        uint tokenAmount = msg.value * rate; 

        // Require that EthSwap has enough ETH
        require(token.balanceOf(address(this)) >= tokenAmount);

        // Tansfer token to  the user
        token.transfer(msg.sender, tokenAmount);

        //  Emit an event
        emit TokensPurchased(msg.sender, address(token), tokenAmount, rate);
    }

    function sellTokens(uint _amount) public {
        // User can't sell moretokens than they have
        require(token.balanceOf(msg.sender) >= _amount);
        
        // Calculate the amount of ETH to reedeem
        uint etherAmount = _amount / rate;

        // Require that EthSwap has enough ETH
        require(address(this).balance >= etherAmount);
        
        // Perform sale
        token.transferFrom(msg.sender, address(this), _amount);
        msg.sender.transfer(etherAmount);

        //  Emit an event
         emit TokensSold(msg.sender, address(token), _amount, rate);
    }

}