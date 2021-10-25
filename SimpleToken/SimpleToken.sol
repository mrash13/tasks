pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

contract SimpleToken {

    /* Exit коды:
        103 - не владелец токена
        104 - токена с таким именем не существует
        105 - токен с таким именем уже существует
    */
    
    struct PlayerToken {
        string nickname;
        string teamName;
        string position;
        uint   tokenOwner;
        uint   price;
    }

    mapping(string => PlayerToken) players;
    uint tOwner;

    constructor() public {
        // check that contract's public key is set
        require(tvm.pubkey() != 0, 101);
        // Check that message has signature (msg.pubkey() is not zero) and message is signed with the owner's private key
        require(msg.pubkey() == tvm.pubkey(), 102);
        tvm.accept();
    }

    modifier onlyByTokenOwner(uint _tOwner) {
        require(msg.pubkey() == _tOwner, 103);
        _;
    }

    modifier onlyIfTokenExists(string _tName) {
        require(players.exists(_tName), 104);
        _;
    }

    function createPlayerToken(string _nickname, string _teamName, string _position) public {
        require(!players.exists(_nickname), 105);
        tvm.accept();
        players[_nickname].nickname = _nickname;
        players[_nickname].teamName = _teamName;
        players[_nickname].position = _position;
        players[_nickname].tokenOwner = msg.pubkey();
        tOwner = players[_nickname].tokenOwner;
    }

    function putOnSale(string _nickname, uint _price) public onlyByTokenOwner(tOwner) onlyIfTokenExists(_nickname) {
        tvm.accept();
        players[_nickname].price = _price;
    }

    function getTokenPrice(string _nickname) public onlyIfTokenExists(_nickname) view returns(uint) {
        tvm.accept();
        return players[_nickname].price;
    }
}