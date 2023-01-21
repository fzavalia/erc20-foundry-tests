// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Token.sol";

contract TokenTest is Test {
    Token public token;

    function setUp() public {
        token = new Token("Token", "TKN");
    }

    function testNameAndSymbolSetUp() public {
        assertEq(token.name(), "Token");
        assertEq(token.symbol(), "TKN");
    }
}
