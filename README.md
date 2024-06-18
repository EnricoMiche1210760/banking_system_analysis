# Banking System Analysis
## Overview
The purpose of this project is to create a denormalized table containing behavioral indicators about the customer, calculated on the basis of transactions and possession produced so as to obtain features for a possible supervised machine learning model.
The table should contain the following indicators:
- Age
- Number of outgoing transactions on all accounts
- Number of incoming transactions on all accounts
- Amount transacted outgoing on all accounts
- Amount transacted inbound on all accounts
- Total number of accounts held
- Number of accounts held by type (one indicator per type)
- Number of outgoing transactions by type (one indicator per type)
- Number of incoming transactions by type (one indicator per type)
- Amount transacted outbound by account type (one indicator per type)
- Amount transacted inbound by account type (one indicator per type)

## Execution
To run the project, you need to have the following installed:
- MySQL Server 8.0
- MySQL Workbench 8.0
- You can also automatically run the project but you need to have the following installed:
  - Python 3.8+
- install the required packages by running the following command:
```bash
pip install -r requirements.txt
```
- Run the following command:
```bash
python run_project.py
```

## Output
The output of the project is a csv file representing the denormalized table containing the behavioral indicators about the customer.