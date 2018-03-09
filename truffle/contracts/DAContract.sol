pragma solidity ^0.4.18;

contract DAContract {

    //STRUCTS
    struct FileAttachment {
        string[] ipfsHash;
        string fileName;
        string fileType;
        address uploadedBy;
    }

    struct EventLog {
        string eventString;
    }

    // EVENTS
    event StateChanged(ContractStates newState);
    // ... all the state changes ...


    // FIELDS
    
    string public daid;
    uint public dateLodged;
    uint public dateApproved;
    //...
    // parcels {LotId, SectionId, PlanId, PlanType};
    string public description;
    uint public estimatedCost;
    string public lga;
    
    address public applicant;
    
    // construction certificate lodge date
    uint public ccDateLodged;
   
    // construction certificate approved date
    uint public ccDateApproved;
    
    // construction certificate description
    string public ccDescription;

    // Sub division certificate lodge date
    uint public sdcDateLodged;
    
    // Sub division certificate approved date
    uint public sdcDateApproved;
   
   // sub division certificate description
    string public sdcDescription;

    // Plan approve certificate lodge date
    uint public planApproveDateLodged;

    // Plan registered certificate approved date
    uint public planRegisteredDateApproved;

    // Plan registered certificate description
    string public planRegisteredDescription;

    // status: DALodged, DApproval
    string[] public fileNames; 
    mapping (string => FileAttachment) attachments;

    string[] public eventLogIds;
    mapping (string => EventLog) eventLogs;

    // contract states
    enum ContractStates {DALodged, DAApproved, CCLodged, CCApproved, SCLodged, SCApproved, PlanLodged, PlanRegistered }
    ContractStates public State;


    // statechangedevents[]


    // CONSTRUCTOR
    function DAContract (string _daId, uint _dateLodged, string _description, string _lga, uint _estimatedCost) public {
        applicant = msg.sender;
        daid = _daId;
        dateLodged = _dateLodged;
        description = _description;
        lga = _lga;
        estimatedCost = _estimatedCost;
        ChangeState(ContractStates.DALodged);
    }

    // METHODS
    // function change the state
	function ChangeState(ContractStates newState) public {
		State = newState;
		StateChanged(newState);
	}

   // function returns the current state 
    function getCurrentState() public view returns (ContractStates) {
       return State;
    }


    // function changes the state to DA lodged 
    function DALodge (address _applicant, string _daid, uint _dateLodged, string _description, string _lga, uint _estimatedcost, uint _dateApproved) public {
        applicant = msg.sender;
        daid = _daid;
        dateLodged = _dateLodged;
        description = _description;
        lga = _lga;
        estimatedCost = _estimatedcost;
        dateApproved = _dateApproved;
        ChangeState(ContractStates.DALodged);
    }


     // function changes the state to DA Approved if current contract state is DA Lodged
    function DAApprove(bool DAApproveResult) public returns (bool) {
		require(State == ContractStates.DALodged);
		
		if(DAApproveResult) {
			ChangeState(ContractStates.DAApproved);
		} 

    return true;
	}

     // function changes the state to construction (CC) lodged if current contract state is DAApproved approved
    function CCLodge (uint _ccDateLodged, string _ccDescription, uint _ccDateApproved) public {      
        require(State == ContractStates.DAApproved);   
       
        ccDateLodged = _ccDateLodged;
        ccDescription = _ccDescription;
        ccDateApproved = _ccDateApproved;

        ChangeState(ContractStates.CCLodged);
    }


    // function changes the state to construction (CC) approved if current contract state is construction (CC) lodged
    function CCApprove(bool CCApproveResult) public returns (bool) {
		require(State == ContractStates.CCLodged);
		
		if(CCApproveResult) {
			ChangeState(ContractStates.CCApproved);
		} 

	return true;
	}


    // function changes the state to sub division (SC) lodged if current contract state is construction (CC) approved
     function SCLodge (uint _sdcDateLodged, string _sdcDescription, uint _sdcDateApproved) public {
        require(State == ContractStates.CCApproved);
        
        sdcDateLodged = _sdcDateLodged;
        sdcDescription = _sdcDescription;
        sdcDateApproved = _sdcDateApproved;

        ChangeState(ContractStates.SCLodged);
    }

   // function changes the state to sub division (SC) approved if current contract state is sub division (SC) lodged
    function SCApprove(bool SCApproveResult) public returns (bool) {
		require(State == ContractStates.SCLodged);
		
		if(SCApproveResult) {
			ChangeState(ContractStates.SCApproved);
		} 

	    return true;
	}


    // function changes the state to Plan lodged if current contract state is sub divison approved
     function PlanApprove (uint _planApproveDateLodged, string _planRegisteredDescription, uint _planRegisteredDateApproved) public {
        require(State == ContractStates.SCApproved);

        planApproveDateLodged = _planApproveDateLodged;
        planRegisteredDateApproved = _planRegisteredDateApproved;
        planRegisteredDescription = _planRegisteredDescription;

        ChangeState(ContractStates.PlanLodged);
    }

    // function changes the state to PlanRegistered if current contract state is Plan Lodged
     function PlanRegister(bool PlanRegisteredResult) public returns (bool) {
		require(State == ContractStates.PlanLodged);
		
		if (PlanRegisteredResult) {
			ChangeState(ContractStates.PlanRegistered);
		} 
	    return true;
	}


    // get the hash of all the geographic files associated with this contract
    function getGeoFiles() public view returns(string) {
        return "[]";
    }

    function addAttachment(string fileName, string fileType, address uploadedBy, string ipfsHash) public returns(bool) {
        // look for the file name in the contract already
        var attachment = attachments[fileName];
        // if it's there, simply add the ipfs hash to the array of hashes, update the filetype and uploadedby
        // if it's not, we get a blank one back, so this will fill it in.
        if (attachment.uploadedBy == 0x00) {
            fileNames.push(fileName);
        }
        attachment.ipfsHash.push(ipfsHash);
        attachment.fileType = fileType;
        attachment.uploadedBy = uploadedBy;
        attachment.fileName = fileName;
        attachments[fileName] = attachment;
    }

    function getFileNamesCount() public view returns(uint256) {
        return fileNames.length;
    }

    function getFileName(uint256 index) public view returns(string) {
        return fileNames[index];
    }

    function getFileType(string fileName) public view returns(string) {
        var attachment = attachments[fileName];
        return attachment.fileType;
    } 

    function getLatestIpfsHash(string fileName) public view returns(string) {
        var attachment = attachments[fileName];
        if (attachment.uploadedBy == 0x00) {
            return "";
        } else {
            return attachment.ipfsHash[attachment.ipfsHash.length - 1];
        }
    }

    function getAttachmentVersionCount(string fileName) public view returns(uint256) {
        var attachment = attachments[fileName];
        if (attachment.uploadedBy == 0x00) {
            return 0;
        } else {
            return attachment.ipfsHash.length;
        }
    }

    function getAttachmentVersionByIndex(string fileName, uint256 index) public view returns(string) {
        var attachment = attachments[fileName];
        if (attachment.uploadedBy == 0x00) {
            return "";
        } else if (attachment.ipfsHash.length < index + 1) {
            return "";
        } else {
            return attachment.ipfsHash[index];
        }
    }

    function getUploadedBy(string fileName) public view returns(address) {
        var attachment = attachments[fileName];
        return attachment.uploadedBy;
    }

    // convert a bytes32 into a string
    function bytes32ToString (bytes32 data) returns (string) {
        bytes memory bytesString = new bytes(32);
        for (uint j=0; j<32; j++) {
            byte char = byte(bytes32(uint(data) * 2 ** (8 * j)));
            if (char != 0) {
                bytesString[j] = char;
            }
        }
        return string(bytesString);
    }

    // convert uint to Bytes
    function uintToBytes(uint v) constant returns (bytes32 ret) {
        if (v == 0) {
            ret = "0";
        } else {
            while (v > 0) {
                ret = bytes32(uint(ret) / (2 ** 8));
                ret |= bytes32(((v % 10) + 48) * 2 ** (8 * 31));
                v /= 10;
            }
        }
        return ret;
    }

    // Concate string
    function strConcat(string _a, string _b, string _c) internal returns (string) {
        bytes memory _ba = bytes(_a);
        bytes memory _bb = bytes(_b);
        bytes memory _bc = bytes(_c);
        string memory abcde = new string(_ba.length + _bb.length + _bc.length);
        bytes memory babcde = bytes(abcde);
        uint k = 0;
        for (uint i = 0; i < _ba.length; i++) {
            babcde[k++] = _ba[i];
        }
        for (i = 0; i < _bb.length; i++) {
            babcde[k++] = _bb[i];
        }
        for (i = 0; i < _bc.length; i++) {
            babcde[k++] = _bc[i];
        }
        return string(babcde);
    }


    function addEventLog(string logString) public returns (string) {
        // bytes32ToString(bytes32(eventLogIds.length))
        //var eventLogId = bytes32ToString(uintToBytes(eventLogIds.length));
        var eventLogId = strConcat(daid, "_", bytes32ToString(uintToBytes(eventLogIds.length)));
        eventLogIds.push(eventLogId);
        eventLogs[eventLogId] = EventLog(logString);
        return string(eventLogId);
    }

    function getEventLogById(string eventLogId) public view returns(EventLog) {
        return eventLogs[eventLogId];
    }

    function getEventLogId(uint256 index) public view returns(string) {
        return eventLogIds[index];
    }

    function getEventLogsCount() public view returns (uint256) {
        return eventLogIds.length;
    }

    function getEventString(uint256 index) public view returns(string) {
        var eventLog = eventLogs[eventLogIds[index]];
        return eventLog.eventString;
    } 
}