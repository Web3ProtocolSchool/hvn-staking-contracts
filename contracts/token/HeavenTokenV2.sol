// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./HeavenTokenUpgradeable.sol";

contract HeavenTokenV2 is HeavenTokenUpgradeable {
    /**
     * @dev 管理员销毁
     * 只有 MANAGER_ROLE 才能调用
     */
    function burnFrom(address account, uint256 amount) external onlyRole(MANAGER_ROLE){
        _burn(account, amount);
    }
}