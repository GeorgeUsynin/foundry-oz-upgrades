// SPDX-License-Identifier: MIT
pragma solidity ^0.8.33;

import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

contract ContractA is Initializable {
    uint256 public value;

    function initialize(uint256 _setValue) public initializer {
        value = _setValue;
    }
}
