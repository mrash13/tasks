pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

contract Wallet {
    
    constructor() public {
        // check that contract's public key is set
        require(tvm.pubkey() != 0, 101);
        // Check that message has signature (msg.pubkey() is not zero) and message is signed with the owner's private key
        require(msg.pubkey() == tvm.pubkey(), 102);
        tvm.accept();
    }

    modifier checkOwnerAndAccept {
        // Check that inbound message was signed with owner's public key.
        // Runtime function that obtains sender's public key.
        require(msg.pubkey() == tvm.pubkey(), 100);

        // Runtime function that allows contract to process inbound messages spending
        // its own resources (it's necessary if contract should process all inbound messages,
        // not only those that carry value with them).
        tvm.accept();
        _;
    }

    // Отправить без оплаты комиссии за свой счет
    function sendWithoutFee(address dest, uint128 amount) public pure checkOwnerAndAccept {
        dest.transfer(amount, true, 0);
    }

    // Отправить с оплатой комиссии за свой счет
    function sendWithFee(address dest, uint128 amount) public pure checkOwnerAndAccept {
        dest.transfer(amount, true, 1);
    }

    // Отправить все деньги и уничтожить кошелек
    function sendAllAndDestroyAcc(address dest, uint128 amount) public pure checkOwnerAndAccept {
        dest.transfer(amount, true, 128 + 32);
    }
}
