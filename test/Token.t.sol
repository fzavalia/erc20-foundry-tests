// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Token.sol";

contract TokenTest is Test {
    Token public token;

    event Approval(address indexed owner, address indexed spender, uint256 value);
    event Transfer(address indexed from, address indexed to, uint256 value);

    function setUp() public {
        token = new Token("Token", "TKN");
    }

    function test_constructor_NameAndSymbolSetUp() public {
        assertEq(token.name(), "Token");
        assertEq(token.symbol(), "TKN");
    }

    function test_constructor_MintToSender() public {
        assertEq(token.balanceOf(address(this)), 21_000_000 ether);
    }

    function test_transfer_UpdatesBalance() public {
        uint256 fromBalance = token.balanceOf(address(this));
        uint256 amount = 1 ether;
        address to = address(1);

        token.transfer(to, amount);

        assertEq(token.balanceOf(to), amount);
        assertEq(token.balanceOf(address(this)), fromBalance - amount);
    }

    function test_transfer_EmitsTransferEvent() public {
        address to = address(1);
        uint256 amount = 1 ether;

        vm.expectEmit(true, true, true, true);

        emit Transfer(address(this), to, amount);

        token.transfer(to, amount);
    }

    function test_transfer_RevertWhen_FromInsufficientBalance() public {
        uint256 fromBalance = token.balanceOf(address(this));
        uint256 amount = fromBalance + 1 ether;
        address to = address(1);

        vm.expectRevert("ERC20: transfer amount exceeds balance");

        token.transfer(to, amount);
    }

    function test_approve_UpdatesAllowance() public {
        address spender = address(1);
        uint256 amount = 1 ether;

        token.approve(spender, amount);

        assertEq(token.allowance(address(this), spender), amount);
    }

    function test_approve_EmitsApprovalEvent() public {
        address spender = address(1);
        uint256 amount = 1 ether;

        vm.expectEmit(true, true, true, true);

        emit Approval(address(this), spender, amount);

        token.approve(spender, amount);
    }

    function test_approve_RevertWhen_OwnerIsZeroAddress() public {
        vm.prank(address(0));

        vm.expectRevert("ERC20: approve from the zero address");

        token.approve(address(1), 1 ether);
    }

    function test_approve_RevertWhen_SpenderIsZeroAddress() public {
        vm.expectRevert("ERC20: approve to the zero address");

        token.approve(address(0), 1 ether);
    }

    function test_transferFrom_UpdatesBalance() public {
        address spender = address(1);
        uint256 amount = 1 ether;
        address owner = address(this);
        uint256 ownerInitBalance = token.balanceOf(owner);
        address to = address(2);

        token.approve(spender, amount);

        vm.prank(spender);

        token.transferFrom(owner, to, amount);

        assertEq(token.balanceOf(owner), ownerInitBalance - amount);
        assertEq(token.balanceOf(to), amount);
    }

    function test_transferFrom_UpdatesAllowance() public {
        address spender = address(1);
        uint256 amount = 1 ether;
        address owner = address(this);
        address to = address(2);

        assertEq(token.allowance(owner, spender), 0);

        token.approve(spender, amount);

        assertEq(token.allowance(owner, spender), amount);

        vm.prank(spender);

        token.transferFrom(owner, to, amount);

        assertEq(token.allowance(owner, spender), 0);
    }

    function test_transferFrom_EmitsTransferEvent() public {
        address spender = address(1);
        uint256 amount = 1 ether;
        address owner = address(this);
        address to = address(2);

        token.approve(spender, amount);

        vm.prank(spender);

        vm.expectEmit(true, true, true, true);

        emit Transfer(owner, to, amount);

        token.transferFrom(owner, to, amount);
    }

    function test_transferFrom_RevertWhen_InsufficientApprove() public {
        address from = address(1);
        uint256 amount = 1 ether;

        token.transfer(from, amount);

        vm.expectRevert("ERC20: insufficient allowance");

        token.transferFrom(from, address(this), amount + 1 ether);
    }
}
