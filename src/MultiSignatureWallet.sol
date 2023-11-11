// SPDX-License-Identifier: MIT
    ///////////
    // Pragma//
    ///////////
pragma solidity ^0.8.18;

/**
 *@title Multi-Signature Wallet
 *@author Francis Baah
 */
contract MultiSignatureWallet {
    //////////
    //Errors//
    //////////
    error MultiSignatureWallet__NotOwner();

    ///////////////////
    //State variables//
    ///////////////////

    //The wallet owner is the account that deploys the contract.
    address public immutable i_owner;

    //The wallet should be initialized with a list of authorized signers (addresses)
    mapping(address => bool) public authorizedSigners;

    //and a required quorum (minimum number of signatures required for a transaction to be executed).
    uint256 private immutable i_quorun;

    uint256 public transactionCount;

    struct transactionParameters {
        address destination;
        uint256 value;
        address sender;
        string data;
        uint numberOfApprovals;
        bool executed;
    }

    transactionParameters[] public transactionList;

    /////////
    //Event//
    /////////
    event TransactionExecuted(
        uint256 transactionID,
        address destination,
        uint256 value,
        address sender
    );
    event TransactionsApproved(uint256 transactionID, address approver);

    //Modifiers
    modifier onlyOwner() {
        if (msg.sender != i_owner) revert MultiSignatureWallet__NotOwner();
        _;
    }
    modifier onlyAuthorizedSigner() {
        require(authorizedSigners[msg.sender], "Not authorized signer");
        _;
    }

    ///////////////////
    //Functions Order//
    //Constructor /////
    //other functons///
    ///////////////////

    constructor(address[] memory _authorizedSigners, uint256 quorun) {
        i_owner = msg.sender;
        i_quorun = quorun;
        for (uint256 i = 0; i < _authorizedSigners.length; i++) {
            authorizedSigners[_authorizedSigners[i]] = true;
        }
    }

    //Anyone can propose a transaction by calling a function proposeTransaction.
    //The function should take parameters such as the destination address, value, and data.
    function proposeTransaction(
        uint256 transactionID,
        address destination,
        uint256 value,
        string memory data
    ) public {
        transactionCount += 1;
        transactionList.push(
            transactionParameters(
                destination,
                value,
                msg.sender,
                data,
                0,
                false
            )
        );
        emit TransactionExecuted(transactionID, destination, value, msg.sender);
    }

    //Authorized signers can approve a proposed transaction by calling a function approveTransaction.
    function approveTransaction(
        uint256 transactionID
    ) public onlyAuthorizedSigner {
        require(
            transactionID < transactionList.length,
            "Invalide transactionID"
        );
        require(
            !transactionList[transactionID].executed,
            "Transaction already executed"
        );
        require(
            transactionList[transactionID].numberOfApprovals < i_quorun,
            "quorun reached"
        );

        transactionList[transactionID].numberOfApprovals += 1;

        //The transaction should only be executed if the number of approvals equals or exceeds the required quorum.
        if (transactionList[transactionID].numberOfApprovals >= i_quorun) {
            executeTransaction(transactionID);
        }
        emit TransactionsApproved(transactionID, msg.sender);
    }

    function executeTransaction(uint256 transactionID) public onlyOwner {
        require(
            transactionID < transactionList.length,
            "Invalide transactionID"
        );
        require(
            !transactionList[transactionID].executed,
            "Transaction already executed"
        );
        require(
            transactionList[transactionID].numberOfApprovals >= i_quorun,
            "quorun not reached"
        );
        transactionList[transactionID].executed = true;

        //Ensure that the contract emits an event (TransactionExecuted). when a transaction is successfully executed,
        //containing details like the transaction ID, destination, value, and the address that executed the transaction.
        if (transactionList[transactionID].executed) {
            emit TransactionExecuted(
                transactionID,
                transactionList[transactionID].destination,
                transactionList[transactionID].value,
                transactionList[transactionID].sender
            );
        }
    }
}
