# E-Invoice-June
# ERP E-Invoice & Accounting Transactions View – Oracle SQL

## 🧾 Overview

This project provides a consolidated **Oracle SQL View** named `VIEW_ACC_TRAN`, developed to analyze and monitor accounting transactions, e-invoice data, and tax-related entries in an ERP system. It integrates account master metadata, transaction narration, TDS, GST, allocation tracking, and approval workflows.

---

## 📄 Files Included

| File Name           | Description                                                  |
|--------------------|--------------------------------------------------------------|
| `VIEW_ACC_TRAN.sql` | SQL View for accounting, tax, and e-invoice financial data    |

---

## 🔍 Key Features

- **E-Invoice Integration**
  - Series and transaction type mapped (`TCODE`, `SERIES`)
  - Monthly invoice grouping via `VRMONTH`
  - E-invoice relevant fields like `TDS_CODE`, `ETAX_CODE`, `GST_CODE`, `PARTYBILLNO`, `CHQNO`

- **TDS & Tax Deduction**
  - TDS rate, challan details, deduction amounts
  - Mapped to party types (supplier, broker, etc.)

- **Bank & Payment Tracking**
  - Tracks `BANKID`, `BANKDATE`, `CHQNO`, IFSC, branch details
  - Payment type (RTGS, NEFT, HUNDI, etc.) via `PAYMENT_NATURE`

- **Allocation Metrics**
  - Total and "as-on-date" allocations using `LHS_ACC.GET_ALLOC_AMT()`
  - Allocation summary for both debit and credit transactions

- **Approval Workflow**
  - Tracks `APPROVEDBY`, `APPROVEDDATE`, and manual flags
  - Narration pulled from `ACCNARR_TRAN`

- **Master Data Enrichment**
  - Joins with `view_acc_mast` for name, type, schedule, class
  - Joins with `config_mast` for financial year, t-nature, and heading

---

## 🧑‍💻 Use Cases

- GST return preparation and reconciliation
- TDS deduction and vendor tax summary reporting
- Payment voucher audits (bank & invoice mapping)
- Power BI dashboards for accounting insights
- E-invoice registry validation

---

## 🛠️ Technologies Used

- **Oracle PL/SQL**
- **ERP Views**: `ACC_TRAN`, `view_acc_mast`, `config_mast`
- **Functions**: `LHS_ACC.GET_ALLOC_AMT`, `LHS_UTILITY.GET_TO_DATE`

---

## 📌 Sample Logic Snippets

### Allocation Calculation
```sql
NVL(LHS_ACC.GET_ALLOC_AMT(A.ENTITY_CODE, NULL, A.TCODE, A.VRNO, A.SLNO, 'DR', NULL), 0)
+ NVL(LHS_ACC.GET_ALLOC_AMT(..., 'CR', ...), 0) AS ALLOC_AMT
