// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

contract HeavenTokenUpgradeable is Initializable, ERC20Upgradeable, OwnableUpgradeable, AccessControlUpgradeable, UUPSUpgradeable {
    // 角色定义
    bytes32 public constant MANAGER_ROLE = keccak256("MANAGER_ROLE");
    bytes32 public constant MINTER_ROLE  = keccak256("MINTER_ROLE");

    constructor() {
        _disableInitializers(); // 防止逻辑合约被初始化
    }

    /**
     * @dev 初始化函数（代替 constructor）
     */
    function initialize(address owner_) public initializer {
        __ERC20_init("Heaven Token", "HVN");
        __Ownable_init(owner_);
        __AccessControl_init();
        __UUPSUpgradeable_init();

        // 初始铸造
        _mint(owner_, 1_000_000 ether);

        // 初始化角色
        _grantRole(DEFAULT_ADMIN_ROLE, owner_);
        _grantRole(MANAGER_ROLE, owner_);
        _grantRole(MINTER_ROLE, owner_);

        // 角色层级
        _setRoleAdmin(MINTER_ROLE, MANAGER_ROLE);
        _setRoleAdmin(MANAGER_ROLE, DEFAULT_ADMIN_ROLE);
    }

    /**
     * @dev UUPS 升级授权
     * ⚠️ 这是审计重点
     */
    function _authorizeUpgrade(address newImplementation) internal override onlyRole(DEFAULT_ADMIN_ROLE){
        
    }

    /**
     * @dev 铸造函数
     * 只有 MINTER 或 MANAGER 才能调用
     */
    function mint(address to, uint256 amount) external onlyRole(MINTER_ROLE) {
        _mint(to, amount);
    }
}

