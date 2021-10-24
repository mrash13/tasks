pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

// This is class that describes you smart contract.
contract SimpleToken {

    struct PlayerToken {
        string nickname;
        string teamName;
        string position;
        uint   tokenOwner;
    }

    mapping(string => PlayerToken) players;
    mapping(string => uint) tokenPrices;

    constructor() public {
        // check that contract's public key is set
        require(tvm.pubkey() != 0, 101);
        // Check that message has signature (msg.pubkey() is not zero) and message is signed with the owner's private key
        require(msg.pubkey() == tvm.pubkey(), 102);
        tvm.accept();
    }

    modifier onlyByTokenOwner(uint _owner) {
        require(msg.pubkey() == _owner, 103);
        _;
    }

    function createPlayerToken(string _nickname, string _teamName, string _position) public {
        require(!players.exists(_nickname), 104);
        tvm.accept();
        players[_nickname].nickname = _nickname;
        players[_nickname].teamName = _teamName;
        players[_nickname].position = _position;
        players[_nickname].tokenOwner = msg.pubkey();
    }

    function putOnSale(string _nickname, uint price) public onlyByTokenOwner(players[_nickname].tokenOwner){
        tvm.accept();
        tokenPrices[_nickname] = price;
    }
}
