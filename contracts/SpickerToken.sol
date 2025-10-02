//SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract SpickerToken is ERC20Capped, Ownable {
    uint public blockReward;

    constructor(
        uint cap,
        uint256 reward
    )
        ERC20("Spicker", "SPK")
        ERC20Capped(cap * (10 ** decimals()))
        Ownable(msg.sender)
    {
        //* 70% of total supply can be owned by owner
        _mint(msg.sender, 70000000 * (10 ** decimals()));
        blockReward = reward * (10 ** decimals());
    }

    //? block.coinbase is miner 's address
    function _mintMinerRewards() internal {
        if (block.coinbase != address(0) && totalSupply() + blockReward <= cap()) {
            _mint(block.coinbase, blockReward);
        }
    }
    function _update(address from, address to, uint256 value) internal virtual override {
        if (!(from == address(0) && to == block.coinbase)) {
            _mintMinerRewards();
        }
        super._update(from, to, value);
    }

    //* set BlockRewards and check that owner is setting the value or not
    function setBlockRewards(uint rewards) public onlyOwner {
        blockReward = rewards * (10 ** decimals());
    }

    function destroy() public onlyOwner {
        selfdestruct(payable(owner()));
    }
}