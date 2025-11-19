📘 CryptoBank

CryptoBank is a simple decentralized ETH banking smart contract built in Solidity 0.8.24.
It supports ETH deposits and withdrawals, and includes a loan system where users can borrow 10% of their balance and must repay it with a 6% fee.
Users cannot withdraw while having an active loan, ensuring safe and consistent financial behavior.

The contract uses the CEI (Checks–Effects–Interactions) pattern and secure native ETH transfers via call.

🧱 Error Codes (RequiresContent.txt)

This project uses numeric short error codes such as "01", "02", "03", instead of long string messages.

✅ Why?

Because short error strings reduce gas cost.

🏗️ Architecture

      ┌────────────────────────────┐
      │         CryptoBank         │
      ├────────────────────────────┤
      │ Storage:                   │
      │  - userBalance[user]       │
      │  - userLoan[user]          │
      │  - maxBalance              │
      │  - admin                   │
      │  - loanPercent (10%)       │
      │  - feePercent (6%)         │
      ├────────────────────────────┤
      │ Functions:                 │
      │  depositEther()            │
      │  withdrawEther()           │
      │  takeLoan()                │
      │  payLoan()                 │
      │  previewLoan(user)         │
      │  getUserDebt(user)         │
      │  modifyMaxBalance()        │
      └────────────────────────────┘
                 ▲
                 │ msg.sender
                 │
       ┌──────────────────────┐
       │        Users         │
       └──────────────────────┘
