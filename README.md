# **Enterprise Application Group & Principal Mapping Script (Version 1.0)**  

## **Overview**
This **PowerShell script** retrieves **all Enterprise Applications (Service Principals)** in **Microsoft Entra ID (Azure AD)** and maps their **associated Groups, Users, and Service Principals**. The script helps **security teams, IAM engineers, and IT administrators** gain visibility into application assignments.

## **Use Cases**
This script is particularly useful for **cybersecurity, identity governance, and access management** in **Microsoft Entra ID (Azure AD)** environments.  
It can be used for:
- 🔎 **Security Audits**: Identify **all groups, users, and service principals assigned** to enterprise applications.
- 🛑 **Cleaning Up Inactive Applications**: Detect **Enterprise Applications that are no longer in use** and safely remove them.
- 🚀 **Reviewing Privileged Access**: Identify if **service principals** or **privileged groups** are assigned to applications that they should not have access to.
- ❌ **Removing Misconfigured Consents**: Microsoft **by default allows users to consent to their own apps**. This script helps track **which apps have been wrongly assigned to groups or users**.
- 📊 **Generating Reports for Compliance**: Export results to **CSV** for further review, audits, or governance processes.

---

## **Features**
✔ **Retrieves all Enterprise Applications** (Service Principals)  
✔ **Maps and exports assigned principals**:  
  - **Groups** (Security, M365, Dynamic & Assigned)  
  - **Users** (Direct Assignments)  
  - **Service Principals** (App-to-App permissions)  
✔ **Extracts critical group attributes**:
  - `DisplayName`, `Description`, `CreatedDateTime`, `SecurityEnabled`
  - `Mail`, `MembershipType` (Assigned/Dynamic), `OnPremisesSyncEnabled`
  - `TotalUsers` count per group  
✔ **Tracks direct assignments** for users & service principals  
✔ **Handles API rate limits & reconnects automatically**  
✔ **Saves results to CSV (`C:\Temp\EnterpriseApps_Groups_Details.csv`)**  
✔ **Periodic intermediate saving every 10 applications**  

---

## **Prerequisites**
To run this script, ensure:
- You have **Microsoft Graph PowerShell Module** installed (`Install-Module Microsoft.Graph -Scope CurrentUser`)
- You have **Administrator permissions** in Microsoft Entra ID  
- You have **PowerShell 5.1 or later**  
- You have **Application.Read.All, Group.Read.All, and User.Read.All** permissions assigned  

---

## **How to Use**
1. **Open PowerShell as Administrator**  
2. **Run the script**  
   ```powershell
   .\EnterpriseApps_Groups.ps1
   ```
3. **Wait for processing** (This may take several minutes depending on the number of applications)  
4. **Find the exported CSV file at:**
   ```
   C:\Temp\EnterpriseApps_Groups_Details.csv
   ```

---

## **Example Output (CSV)**
| ApplicationName | AppClientId | GroupDisplayName | MembershipType | UserCount | ServicePrincipalCount |
|----------------|------------|------------------|----------------|-----------|-----------------------|
| Microsoft Teams | xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx | IT Security Group | Assigned | 50 | 2 |
| Salesforce | xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx | Sales Team | Dynamic | 150 | 0 |
| ServiceNow | xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx | **Direct Assignment** (Users & SPs) | Direct | 0 | 3 |

---

## **Limitations**
⚠ **Large Environments**: If you have **thousands of applications**, execution time may be long.  
⚠ **Microsoft API Rate Limits**: The script handles **Microsoft Graph API rate limits**, but excessive use may result in throttling.  
⚠ **Missing Permissions**: If you don’t have **sufficient permissions**, the script will not retrieve all data.  

---

## **Security Considerations**
- **Limit who can run this script** (Only IAM/security admins should have access).  
- **Never expose or share raw CSV output** (It contains sensitive security group assignments).  
- **Use Role-Based Access Control (RBAC)** to enforce **least privilege access**.  
- **Disable default app consent for users** to prevent **unwanted application assignments**.  

---

## **Future Enhancements** 
- 🛠️ **Filter for inactive applications** based on last activity logs  
- 📊 **Power BI Dashboard Support** for easier visualization  
- 🏷️ **Tagging High-Risk Applications** (e.g., applications with privileged access)  

---

## **Contributors**
**Author**: Zishan Haque (IAM & Cybersecurity Specialist)   
🔗 **LinkedIn**: [Zishan Haque]([https://www.linkedin.com/in/zishanhaque](https://www.linkedin.com/in/zishan-ul-haque-5683a3143/))  

---

## **License**
This script is released under the **MIT License**. Feel free to **modify and improve** it! 🚀

---

**📢 Found an issue? Want to contribute?**  
**Pull requests are welcome!** 🎉  

