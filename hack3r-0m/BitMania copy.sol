// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;
import "hardhat/console.sol";

contract BitMania {
    bool public isSolved;
    bytes public constant encFlag =
        bytes(hex"6e3c5b0f722c430e6d324c0d6f67173d4b1565345915753504211f");

    // following function was used to encrypt the given string
    // when a particular string is passed, encrypted output is `encFlag`
    // reverse `encFlag` to input stirng to solve CTF
    function encryptFlag(string memory stringFlag)
        public
        view
        returns (bytes memory)
    {
        console.log("STRING", stringFlag);
        bytes memory flag = bytes(stringFlag);
        console.logBytes(flag);
        for (uint256 i; i < flag.length; i++) {
            console.log("index", i);
            console.logBytes1(flag[i]);
            if (i > 0) console.logBytes1(flag[i - 1]);
            if (i > 0) console.logBytes1(flag[i] ^ flag[i - 1]);
            if (i > 0) flag[i] = flag[i] ^ flag[i - 1];

            console.log("PRIMER SHIFT");
            console.logBytes1(flag[i]);
            console.logBytes1(flag[i] >> 4);
            console.logBytes1(flag[i] ^ (flag[i] >> 4));
            flag[i] = flag[i] ^ (flag[i] >> 4);

            console.log("SEGUNDO SHIFT");
            console.logBytes1(flag[i]);
            console.logBytes1(flag[i] >> 3);
            console.logBytes1(flag[i] ^ (flag[i] >> 3));
            flag[i] = flag[i] ^ (flag[i] >> 3);

            console.log("TERCER SHIFT");
            console.logBytes1(flag[i]);
            console.logBytes1(flag[i] >> 2);
            console.logBytes1(flag[i] ^ (flag[i] >> 2));
            flag[i] = flag[i] ^ (flag[i] >> 2);

            console.log("CUARTO SHIFT");
            console.logBytes1(flag[i]);
            console.logBytes1(flag[i] >> 1);
            console.logBytes1(flag[i] ^ (flag[i] >> 1));
            console.logBytes1((flag[i] ^ (flag[i] >> 1)) << 1);
            flag[i] = flag[i] ^ (flag[i] >> 1);

            console.log("FINAL");
            console.logBytes1(flag[i]);
        }

        return flag;
    }

    // (a ^ (a / 2)) = 24
    // (a / 2) = 24 ^ a
    // a = 24 ^ (a / 2)

    function decryptFlag(bytes memory flag) public view returns (bytes memory) {
        console.log("FLAG");
        console.logBytes(flag);
        for (uint256 i; i < flag.length; i++) {
            console.log("index", i);
            console.logBytes1(flag[i]);
            if (i > 0) flag[i] ^= flag[i - 1];
            flag[i] ^= flag[i] << 4;
            console.logBytes1(flag[i]);
            flag[i] ^= flag[i] << 3;
            console.logBytes1(flag[i]);
            flag[i] ^= flag[i] << 2;
            console.logBytes1(flag[i]);
            flag[i] ^= flag[i] << 1;
            console.logBytes1(flag[i]);
        }

        return flag;
    }

    // solve the ctf by calling this function
    function solveIt(string memory flag) external {
        bytes memory output = encryptFlag(flag);
        if (keccak256(output) == keccak256(encFlag)) isSolved = true;
    }
}
