// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract HeavenToken is ERC20, Ownable, AccessControl {
    // 角色定义
    bytes32 public constant MANAGER_ROLE = keccak256("MANAGER_ROLE");
    bytes32 public constant MINTER_ROLE  = keccak256("MINTER_ROLE");

    constructor() ERC20("Heaven Token", "HVN") Ownable(msg.sender) {
        _mint(msg.sender, 1_000_000 ether);
        
        // 设置角色管理员
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(MANAGER_ROLE, msg.sender);
        _grantRole(MINTER_ROLE, msg.sender);

        // 角色层级
        _setRoleAdmin(MINTER_ROLE, MANAGER_ROLE);
        _setRoleAdmin(MANAGER_ROLE, DEFAULT_ADMIN_ROLE);
    }

    /**
     * @dev 铸造函数
     * 只有 MINTER 或 MANAGER 才能调用
     */
    function mint(address to, uint256 amount) external onlyRole(MINTER_ROLE) {
        _mint(to, amount);
    }
}

