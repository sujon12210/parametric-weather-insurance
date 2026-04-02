# Parametric Weather Insurance

A professional-grade insurance primitive for agricultural and climate risk. Unlike traditional insurance, which requires long manual assessments, this "Parametric" model pays out instantly if a specific data point (verified by an Oracle) hits a predefined threshold. 

## Core Features
* **Oracle-Driven Payouts:** Uses the Chainlink Weather Feed to verify environmental conditions.
* **Non-Custodial Escrow:** Premiums are held in the contract and only released to the "Farmer" or returned to the "Underwriter" based on data.
* **Zero-Knowledge Claims:** No paperwork; the contract executes the payout as soon as the threshold is breached.
* **Flat Architecture:** Single-directory layout for the Policy Logic, Oracle Consumer, and Fund Manager.

## Workflow
1. **Policy Creation:** Farmer pays a premium for "Drought Protection."
2. **Monitoring:** The contract checks the Rainfall Index via the Oracle.
3. **Trigger:** If Rainfall < 10mm for 30 days, the payout is triggered.
4. **Settlement:** Funds are transferred to the Farmer's wallet immediately.

## Setup
1. `npm install`
2. Deploy `WeatherInsurance.sol` with the Chainlink Oracle address.
