// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title IOwnableUpgradeable
/// @author Amor Inksmith
interface IOwnableUpgradeable {
    /// 自定义错误 ///

    /// @notice 调用者不是合约的所有者
    error OwnableUpgradeable__NotOwner(address owner, address caller);

    error OwnableUpgradeable__OwnerZeroAddress();

    event TransferOwnership(address indexed oldOwner, address indexed newOwner);

    /// 函数 ///
    function owner() external view returns (address);

    /// @notice Leaves the contract without an owner, so it will not be possible to call `onlyOwner`
    /// functions anymore.
    ///
    /// WARNING: Doing this will leave the contract without an owner, thereby removing any
    /// functionality that is only available to the owner.
    ///
    /// Requirements:
    ///
    /// - The caller must be the owner.
    function _renounceOwnership() external;

    /// @notice Transfers the owner of the contract to a new account (`newOwner`). Can only be
    /// called by the current owner.
    /// @param newOwner The account of the new owner.
    function _transferOwnership(address newOwner) external;

}
