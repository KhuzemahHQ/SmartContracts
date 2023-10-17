// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.7.0 <0.9.0;

contract BankingSystem {
    // DECLARATIONS
    uint reserve;
    // CODE
    struct Account{
        string first;
        string last;
        uint loan;
        uint bal;
        bool exist;
    }

    address public owner;
    mapping(address => Account) public accounts;

    // Constructor
    constructor() {
        owner = tx.origin;
        reserve = 0;
    }

    // In this part, we  set up a structure that stores the account details of each user that comes to
    // we bank. The user details would be limited to the first name, last name, loan amount and the balance
    // of their account.
    function openAccount(string memory firstName, string memory lastName) public {
        // Code Here!!
        require(tx.origin != owner, "Error, Owner Prohibited");
        require(accounts[tx.origin].exist != true, "Account already exists");
        Account memory newAccount;
        newAccount.first = firstName;
        newAccount.last = lastName;
        newAccount.loan = 0;
        newAccount.bal = 0;
        newAccount.exist = true;
        accounts[tx.origin] = newAccount;

    }

    
    // In this part we create a getter function to access the bank account details of the callee and
    // return them accordingly.
    function getDetails() public view returns (uint balance, string memory first_name, string memory last_name, uint loanAmount) {   
        // Code Here!!
        require(accounts[tx.origin].exist == true, "No Account");
        return (accounts[tx.origin].bal, accounts[tx.origin].first, accounts[tx.origin].last, accounts[tx.origin].loan);
    }

    // In this section, the users deposit ether from their wallet to their bank account.
    // minimum deposit of 1 ether.
    // 1 ether = 10^18 Wei.   
    function depositAmount() public payable {    
        // Code Here!!
        require(accounts[tx.origin].exist == true, "No Account");
        require(msg.value > 1000000000000000000,"Low Deposit" );
        accounts[tx.origin].bal += msg.value;
    }

    
    // In this part, the user calling this function withdraws the desired amount of ether tokens from the bank
    // to his/her wallet.
    function withDraw(uint withdrawalAmount) public {                
        // Code Here!!
        require(tx.origin != owner, "Error, Owner Prohibited");
        require(accounts[tx.origin].exist == true, "No Account");
        require(withdrawalAmount <= accounts[tx.origin].bal, "Insufficient Funds");
        accounts[tx.origin].bal -= withdrawalAmount;
        payable(tx.origin).transfer(withdrawalAmount);
    }
    
        
    // In this part, the user is provided with the functionality to transfer desired amount of ether tokens from
    his/her bank account to another bank account.
    function TransferEth(address payable reciepent, uint transferAmount) public {
        // Code Here!!
        require(tx.origin != owner, "Error, Owner Prohibited");
        require(accounts[tx.origin].exist == true, "No Account");
        require(transferAmount <= accounts[tx.origin].bal, "Insufficient Funds");
        accounts[tx.origin].bal -= transferAmount;
        accounts[reciepent].bal += transferAmount;
    }

    // In this section we setup a system which gives out loans to the users from the bank’s reserve. We
    // also need to store a record of loans given to each user.
    function depositTopUp() public payable {
        // Code Here!!
        require(tx.origin == owner, "Only owner can call this function");
        reserve += msg.value;
    }
    function TakeLoan(uint loanAmount) public {
        // Code Here!!
        require(tx.origin != owner, "Error,Owner Prohibited");
        require(accounts[tx.origin].exist == true, "No Account");
        require(loanAmount < reserve, "Insufficent Loan Funds");
        require(loanAmount < 2*accounts[tx.origin].bal, "Loan Limit Exceeded");
        accounts[tx.origin].loan += loanAmount;
        payable(tx.origin).transfer(loanAmount);
        reserve -= loanAmount;
    }
    function InquireLoan() public view returns (uint loanValue) {
        // Code Here!!
        require(accounts[tx.origin].exist == true, "No Account");
        return accounts[tx.origin].loan;
    }

    // In this part the user returns the loan amount to the bank.
    function returnLoan() public payable  {
        // Code Here!!
        require(accounts[tx.origin].exist == true, "No Account");
        require(accounts[tx.origin].loan > 0, "No Loan");
        require(msg.value <= accounts[tx.origin].loan, "Owed Amount Exceeded");
        accounts[tx.origin].loan -= msg.value;
        reserve += msg.value;
    }

    function AmountInBank() public view returns(uint) {
            return address(this).balance;
    }
     

    
}   
