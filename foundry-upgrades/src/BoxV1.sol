// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {UUPSUpgradeable} from "lib/openzeppelin-contracts-upgradeable/contracts/proxy/utils/UUPSUpgradeable.sol";
import {OwnableUpgradeable} from "lib/openzeppelin-contracts-upgradeable/contracts/access/OwnableUpgradeable.sol";

contract BoxV1 is UUPSUpgradeable, OwnableUpgradeable {
    uint256 internal number;

    constructor() {
        _disableInitializers();
    }

    function initialize(address initialOwner) public initializer {
        __Ownable_init(initialOwner); // set owner to initialOwner
        __UUPSUpgradeable_init(); // set UUPSUpgradeable
    }

    function getNumber() external view returns (uint256) {
        return number;
    }
    
    function version() internal pure returns(uint256) {
        return 1;
    }

    function _authorizeUpgrade(address newImplementation) internal override onlyOwner {}
}