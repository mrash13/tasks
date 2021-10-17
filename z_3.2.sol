pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

contract TaskList {

    constructor() public {
		// check that contract's public key is set
		require(tvm.pubkey() != 0, 101);
		// Check that message has signature (msg.pubkey() is not zero) and message is signed with the owner's private key
		require(msg.pubkey() == tvm.pubkey(), 102);
		tvm.accept();
	}

    // Modifier that allows to accept some external messages
	modifier checkOwnerAndAccept {
		// Check that message was signed with contracts key.
		require(msg.pubkey() == tvm.pubkey(), 102);
		tvm.accept();
		_;
	}

    struct task {
        string taskName;
        uint32 addTime;
        bool isDone;
    }

    uint8 taskCount;
    mapping(uint8 => task) taskList;
    string[] taskArray;

    function addTask(string name) public checkOwnerAndAccept {
        taskList[taskCount] = task(name, now, false);
        taskCount++;
        taskArray.push(name);
    }

    function getTaskCount() public checkOwnerAndAccept view returns (uint8 count) {
        return taskCount;
    }

    function removeTask(uint8 id) public checkOwnerAndAccept {
        require(taskList.exists(id-1), 101, "This task does not exist");
        delete taskList[id-1];
        taskCount--;
    }

    function getTaskName(uint8 id) public checkOwnerAndAccept view returns (string taskName) {
        require(taskList.exists(id-1), 101, "This task does not exist");
        return taskList[id-1].taskName;
    }
    
    function getTaskArray() public checkOwnerAndAccept view returns (string[]) {
        return taskArray;
    }

    function setDone(uint8 id) public checkOwnerAndAccept {
        require(taskList.exists(id-1), 101, "This task does not exist");
        taskList[id-1].isDone = true;
    }
}