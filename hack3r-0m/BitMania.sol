// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

contract BitMania {
    bool public isSolved;
    bytes public constant encFlag =
        bytes(hex"6e3c5b0f722c430e6d324c0d6f67173d4b1565345915753504211f");

    // following function was used to encrypt the given string
    // when a particular string is passed, encrypted output is `encFlag`
    // reverse `encFlag` to input stirng to solve CTF
    function encryptFlag(string memory stringFlag)
        public
        pure
        returns (bytes memory)
    {
        bytes memory flag = bytes(stringFlag);
        for (uint256 i; i < flag.length; i++) {
            if (i > 0) flag[i] ^= flag[i - 1]; // (b ^ 34) = a
            flag[i] ^= flag[i] >> 4; // /16     a ^ (a / 16) = z
            flag[i] ^= flag[i] >> 3; // /8      z ^ (z / 8) = y
            flag[i] ^= flag[i] >> 2; // /4      y ^ (y / 4) = x
            flag[i] ^= flag[i] >> 1; // /2      x ^ (x / 2) = 7
        }

        // ((b ^ 34) ^ ((b ^ 34) / 16)) = z
        // ((b ^ 34) ^ ((b ^ 34) / 16)) ^ (((b ^ 34) ^ ((b ^ 34) / 16)) / 8) = y
        // y ^ (y / 4) = x
        // x ^ (x / 2) = 7

        return flag;
    }

    // 0x26193407
    // solve the ctf by calling this function
    function solveIt(string memory flag) external {
        bytes memory output = encryptFlag(flag);
        if (keccak256(output) == keccak256(encFlag)) isSolved = true;
    }
}
