// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "../contracts/mycontract.sol";

contract SplitWiseTest is Test {
    Splitwise splitwise;
    
    // Diferentes endereços para testar
    address alice = address(0x1);
    address bob = address(0x2);
    address charlie = address(0x3);

    function setUp() public {
        splitwise = new Splitwise();
    }

    // Teste com prank: muda msg.sender apenas para a próxima chamada
    function testAddIOUWithPrank() public {
        vm.prank(alice);
        splitwise.addIOU(bob, 100);
        
        uint32 debt = splitwise.lookup(alice, bob);
        assertEq(debt, 100, "Alice deveria estar devendo 100 para Bob");
    }

    // Teste com múltiplas contas usando prank
    function testMultipleAccounts() public {
        // Alice manda mensagem
        vm.prank(alice);
        splitwise.addIOU(bob, 100);
        
        // Bob manda mensagem
        vm.prank(bob);
        splitwise.addIOU(charlie, 50);
        
        // Charlie manda mensagem
        vm.prank(charlie);
        splitwise.addIOU(alice, 30);
        
        // Verifica as dívidas
        assertEq(splitwise.lookup(alice, bob), 100);
        assertEq(splitwise.lookup(bob, charlie), 50);
        assertEq(splitwise.lookup(charlie, alice), 30);
    }

    // Teste com startPrank: muda msg.sender para múltiplas chamadas
    function testWithStartPrank() public {
        vm.startPrank(alice);
        
        // Todas essas chamadas serão feitas como alice
        splitwise.addIOU(bob, 100);
        splitwise.addIOU(charlie, 50);
        
        vm.stopPrank();
        
        assertEq(splitwise.lookup(alice, bob), 100);
        assertEq(splitwise.lookup(alice, charlie), 50);
    }

    // Teste combinando startPrank e prank
    function testStartPrankAndPrank() public {
        vm.startPrank(alice);
        splitwise.addIOU(bob, 100);
        vm.stopPrank();
        
        vm.prank(bob);
        splitwise.addIOU(alice, 75);
        
        assertEq(splitwise.lookup(alice, bob), 100);
        assertEq(splitwise.lookup(bob, alice), 75);
    }
}
