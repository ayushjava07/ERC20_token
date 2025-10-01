//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {ERC20Capped} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract SpickerToken is ERC20Capped, Ownable {
    uint public blockReward;

    constructor(
        uint cap,
        uint256 reward   )
        ERC20("Spicker", "SPK")
        Ownable(msg.sender)
        ERC20Capped(cap * (10 ** decimals()))
        {
        //* 70% of total supply can be owned by owner

        _mint(msg.sender, 70000000 * (10 ** decimals()));
        blockReward = reward * (10 ** decimals());
        }

        //* set BlockRewards and check that owner is setting the value or not
    function setBlockRewards(uint rewards) public onlyOwner {
        blockReward = rewards * (10 ** decimals());
    }
}
