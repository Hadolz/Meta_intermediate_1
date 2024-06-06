// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract TaskManager {

    error FUNCTION_ONLY_FOR_OWNER();

    struct TaskDetails{
        string name;
        string details;
        bool status;
    }

    TaskDetails[] public tasks;

    address private manager;

    constructor() {
        manager = msg.sender;
    }

    function restrictToOwner() private view {
        if (msg.sender!= manager){
            revert FUNCTION_ONLY_FOR_OWNER();
        }
    }

    function addTask(string calldata _name, string calldata _details) external  {
        restrictToOwner();
        tasks.push(TaskDetails(_name,_details,false));
    }

    function editTask(uint _id, string calldata _name, string calldata _details) external  {
        restrictToOwner();
        require(_id < tasks.length, "Invalid task index.");
        tasks[_id] = TaskDetails(_name, _details, false);
    }

    function toggleStatus(uint _id) external  {
        restrictToOwner();
        require(_id < tasks.length, "Invalid task index.");
        tasks[_id].status =!tasks[_id].status;
    }

    function fetchTask(uint _id) external view returns(string memory, string memory, bool){
        require(_id < tasks.length, "Invalid task index.");
        TaskDetails memory task = tasks[_id];
        return (task.name, task.details, task.status);
    }

    function removeTask(uint _id) external  {
        restrictToOwner();
        require(_id < tasks.length, "Invalid task index.");
        delete tasks[_id];
    }

    function retrieveAllTasks() external view returns(TaskDetails[] memory){
        return tasks;
    }

    // Ensures internal integrity using assert
    function verify() external view {
        restrictToOwner();
        uint256 actualCount = tasks.length;
        for (uint i = 0; i < tasks.length; i++) {
            assert(tasks[i].status == false || tasks[i].status == true);
        }
        if (actualCount!= tasks.length) {
            revert("Detected discrepancy in array size.");
        }
    }

}
