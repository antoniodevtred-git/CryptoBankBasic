// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.24;

contract CryptoBank {
    
    uint256 public maxBalance;
    address public admin;

    mapping (address => uint256) public userBalance; 
    mapping(address => uint256) public userLoan;

    uint256 public loanPercent = 10; // 10%
    uint256 public feePercent  = 6;  // 6%


    event EtherDeposit(address indexed user, uint256 amount);
    event EtherWithdraw(address indexed user, uint256 amount);
    event LoanTaken(address indexed user, uint256 loanAmount);
    event LoanPaid(address indexed user, uint256 principal, uint256 fee);


    modifier onlyAdmin() {
        require(msg.sender == admin, "01"); 
        _;
    }


    constructor(uint256 maxBalance_, address admin_) {
        maxBalance = maxBalance_;
        admin = admin_;
    }

    // Deposit
    function depositEther() external payable {
        require(userBalance[msg.sender] + msg.value <= maxBalance, "02"); 

        userBalance[msg.sender] += msg.value;
        emit EtherDeposit(msg.sender, msg.value);
    }

    // WithdrawEther
    function withdrawEther(uint256 amount_) external {
        require(userLoan[msg.sender] == 0, "05"); 
        require(amount_ <= userBalance[msg.sender], "03"); 
        userBalance[msg.sender] -= amount_;

        (bool success, ) = msg.sender.call{value: amount_}("");
        require(success, "04");
        emit EtherWithdraw(msg.sender, amount_);
    }

    // Check how much loan the user *could* receive
    function previewLoan(address user) public view returns (uint256) {
        return (userBalance[user] * loanPercent) / 100;
    }

    // TAKE LOAN (10% of user balance)
    function takeLoan() external {
        require(userLoan[msg.sender] == 0, "07"); 

        uint256 deposit = userBalance[msg.sender];
        require(deposit > 0, "06"); 

        uint256 loanAmount = previewLoan(msg.sender);
        userLoan[msg.sender] = loanAmount;

        (bool success, ) = msg.sender.call{value: loanAmount}("");
        require(success, "09"); 

        emit LoanTaken(msg.sender, loanAmount);
    }

    // PAY LOAN (principal + 6% fee)
    function payLoan() external payable {
        uint256 principal = userLoan[msg.sender];
        require(principal > 0, "07"); 

        uint256 fee = (principal * feePercent) / 100;
        uint256 totalToPay = principal + fee;

        require(msg.value == totalToPay, "08");

        userLoan[msg.sender] = 0;

        emit LoanPaid(msg.sender, principal, fee);
    }

    // Get full debt: principal + fee
    function getUserDebt(address user) 
        external 
        view 
        returns (uint256 principal, uint256 fee, uint256 totalToPay) 
    {
        principal = userLoan[user];
        fee = (principal * feePercent) / 100;
        totalToPay = principal + fee;
    }

    // ModifyMaxBalance ADMIN
    function modifyMaxBalance(uint256 newMaxBalance_) external onlyAdmin {
        maxBalance = newMaxBalance_;
    }
}
