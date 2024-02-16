// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;
 
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

/*
 * @dev Day3 - DataFeeds - Chainlink Bootcamp 
 */
contract Token is ERC20, AccessControl {
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
 
    constructor() ERC20("BCUSTToken", "UBC") {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(MINTER_ROLE, msg.sender);
    }
 
    function mint(address to, uint256 amount) public onlyRole(MINTER_ROLE) {
        _mint(to, amount);
    }
 
    function decimals() public pure override returns (uint8) {
        return 2;
    }    
}