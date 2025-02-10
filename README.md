# **Enterprise Application Group & Principal Mapping Script (Version 1.0)**

## **Table of Contents**
1. [Overview](#overview)
2. [Use Cases](#use-cases)
3. [Features](#features)
4. [Prerequisites](#prerequisites)
5. [How to Use](#how-to-use)
6. [Example Output (CSV)](#example-output-csv)
7. [Limitations](#limitations)
8. [Security Considerations](#security-considerations)
9. [Future Enhancements](#future-enhancements)
10. [Contributors](#contributors)
11. [License](#license)

---

## **Overview**
This **PowerShell script** retrieves **all Enterprise Applications (Service Principals)** in **Microsoft Entra ID (Azure AD)** and maps their **associated Groups, Users, and Service Principals**. The script helps **security teams, IAM engineers, and IT administrators** gain visibility into application assignments and enhances security posture.

---

## **Use Cases**
This script is ideal for:
- 🔎 **Security Audits**: Identify **all groups, users, and service principals assigned** to enterprise applications.
- 🛑 **Cleaning Up Inactive Applications**: Detect and remove **Enterprise Applications that are no longer in use**.
- 🚀 **Reviewing Privileged Access**: Highlight **service principals or privileged groups** assigned to sensitive applications.
- ❌ **Removing Misconfigured Consents**: Helps mitigate risks from **users consenting to apps without proper oversight**.
- 📊 **Compliance Reporting**: Export assignments and details to **CSV for audit purposes**.

---

## **Features**
✔ **Retrieve and map all Enterprise Applications** (Service Principals).  
✔ **Export detailed group and principal assignments**, including:
  - **Groups** (Security, M365, Dynamic, or Assigned).
  - **Users** (Direct Assignments).
  - **Service Principals** (App-to-App permissions).  
✔ **Extract critical attributes**, such as:
  - `GroupDisplayName`, `Description`, `MembershipType` (Assigned/Dynamic).
  - `SecurityEnabled`, `OnPremisesSyncEnabled`, `Mail`, and `CreatedDateTime`.
  - `TotalUsers` in each group, `UserCount`, and `ServicePrincipalCount`.  
✔ **Intermediate CSV saving** for **data persistence** in long-running environments.
✔ **Handles API throttling gracefully** and reconnects automatically.

---

## **Prerequisites**
Ensure the following before running the script:
- **Microsoft Graph PowerShell Module**:  
  Install it with:
  ```powershell
  Install-Module Microsoft.Graph -Scope CurrentUser
  ```
- **Administrator permissions** in Microsoft Entra ID (Azure AD).  
- **PowerShell 5.1 or later** installed.  
- **Permissions**:  
  - `Application.Read.All`
  - `Group.Read.All`
  - `User.Read.All`

---

## **How to Use**
1. **Download the Script**:
   Clone this repository or download the script file:
   ```bash
   git clone https://github.com/Zishan-Ul-Haque/EntraID-EnterpriseApp-Mapping.git
   ```
2. **Run PowerShell as Administrator**:
   - Open **PowerShell** with elevated privileges.
3. **Execute the Script**:
   ```powershell
   .\EnterpriseApps_Groups-Users-ServicePrincipals.ps1
   ```
4. **View Results**:
   - Intermediate results are saved to:  
     `C:\Temp\EnterpriseApps_Groups_Details_Partial.csv`.  
   - Final results are exported to:  
     `C:\Temp\EnterpriseApps_Groups_Details.csv`.

---

## **Example Output (CSV)**
The exported CSV will look like this:

| **ApplicationName** | **AppClientId** | **GroupDisplayName**       | **MembershipType** | **UserCount** | **ServicePrincipalCount** |
|---------------------|----------------|---------------------------|--------------------|--------------|--------------------------|
| Microsoft Teams     | xxxxxxxx-xxxx | IT Security Group         | Assigned           | 50           | 2                        |
| Salesforce          | xxxxxxxx-xxxx | Sales Team               | Dynamic            | 150          | 0                        |
| ServiceNow          | xxxxxxxx-xxxx | **Direct Assignment**     | Direct             | 0            | 3                        |

---

## **Limitations**
⚠ **Large Environments**:  
Processing can take time in environments with **thousands of applications**.  

⚠ **Microsoft API Rate Limits**:  
While the script handles rate limits, excessive API calls may cause throttling.  

⚠ **Permissions Issues**:  
Without sufficient permissions, the script may not retrieve all data.  

---

## **Security Considerations**
- Limit who can run this script (only IAM/security admins).  
- Do not expose raw CSV output (contains sensitive data).  
- Apply **Role-Based Access Control (RBAC)** to enforce **least privilege**.  
- Disable default app consent to prevent unauthorized applications.  

---

## **Future Enhancements**
- 🛠️ Add support for **filtering inactive applications** based on activity logs.  
- 📊 Enable integration with **Power BI** for advanced visualizations.  
- 🏷️ Add tagging for **high-risk applications** (e.g., privileged access).

---

## **Contributors**
**Author**: Zishan Haque (IAM & Cybersecurity Specialist).  
🔗 **LinkedIn**: [Zishan Haque](https://www.linkedin.com/in/zishan-ul-haque-5683a3143/)  

---

## **License**
This script is released under the **MIT License**. Feel free to modify and improve it! 🚀  

---

## **Feedback & Contributions**
Found a bug? Have suggestions?  
Feel free to open issues or submit pull requests!

