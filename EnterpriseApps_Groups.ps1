# Enterprise Application Group & Principal Mapping Script (Version 1.0)
# Author: Zishan Haque (IAM & Cybersecurity Specialist)
# Description: This script retrieves all Enterprise Applications in Microsoft Entra ID (Azure AD) 
# and maps their associated Groups, Users, and Service Principals. 
# The output is saved in a CSV file for further security auditing and access control analysis.

# Import Microsoft Graph PowerShell Module
Import-Module Microsoft.Graph.Applications -ErrorAction Stop

# Function to ensure connectivity
function Ensure-Connectivity {
    if (!(Get-MgContext).Account) {
        Write-Host "Reconnecting to Microsoft Graph..."
        Connect-MgGraph -Scopes "Application.Read.All", "Group.Read.All", "User.Read.All" -ErrorAction Stop
    }
}

# Connect to Microsoft Graph
Ensure-Connectivity

# Retrieve all Enterprise Applications (Service Principals)
Write-Host "Retrieving all enterprise applications..."
$allEnterpriseApps = Get-MgServicePrincipal -All

# Check if applications exist
if (-not $allEnterpriseApps) {
    Write-Host "No Enterprise Applications found! Exiting script."
    exit
}

# Initialize results array
$results = @()

# Initialize Progress Bar
$totalApps = $allEnterpriseApps.Count
$currentApp = 0
Write-Host "Total Enterprise Applications to process: $totalApps"

foreach ($enterpriseApp in $allEnterpriseApps) {
    $currentApp++
    Write-Host "Processing application: $($enterpriseApp.DisplayName) (ID: $($enterpriseApp.Id))"

    # Ensure connectivity for each application
    Ensure-Connectivity

    # Retrieve assigned principals (Groups, Users, Service Principals)
    try {
        $assignedPrincipals = Get-MgServicePrincipalAppRoleAssignedTo -ServicePrincipalId $enterpriseApp.Id
        Write-Host "Found $($assignedPrincipals.Count) assigned principals for application: $($enterpriseApp.DisplayName)"
    } catch {
        Write-Host "Error retrieving assigned principals for application: $($enterpriseApp.DisplayName). Error: $_"
        continue
    }

    # Initialize counts for different principal types
    $userCount = 0
    $servicePrincipalCount = 0
    $groupCount = 0

    if ($assignedPrincipals) {
        foreach ($principal in $assignedPrincipals) {
            switch ($principal.PrincipalType) {
                'User' { $userCount++ }
                'ServicePrincipal' { $servicePrincipalCount++ }
                'Group' {
                    $groupCount++
                    $groupDetails = $null
                    $totalUsers = 0

                    try {
                        Ensure-Connectivity
                        $groupDetails = Get-MgGroup -GroupId $principal.PrincipalId -ErrorAction Stop
                        # Count total users in the group
                        $totalUsers = (Get-MgGroupMember -GroupId $principal.PrincipalId -All).Count
                        Write-Host "Group: $($groupDetails.DisplayName) (ID: $($groupDetails.Id)) has $totalUsers users."

                        # Add to results
                        $results += [PSCustomObject]@{
                            ApplicationId               = $enterpriseApp.Id
                            ApplicationName             = $enterpriseApp.DisplayName
                            AppClientId                 = $enterpriseApp.AppId
                            GroupId                     = $principal.PrincipalId
                            GroupDisplayName            = $groupDetails.DisplayName
                            GroupDescription            = $groupDetails.Description
                            GroupCreatedDateTime        = $groupDetails.CreatedDateTime
                            IsAssignableToRole          = $groupDetails.IsAssignableToRole
                            Mail                        = $groupDetails.Mail
                            MailEnabled                 = $groupDetails.MailEnabled
                            OnPremisesSyncEnabled       = $groupDetails.OnPremisesSyncEnabled
                            SecurityEnabled             = $groupDetails.SecurityEnabled
                            MembershipRule              = $groupDetails.MembershipRule
                            MembershipRuleProcessingState = $groupDetails.MembershipRuleProcessingState
                            MembershipType              = if ($groupDetails.MembershipRule) { "Dynamic" } else { "Assigned" }
                            TotalUsers                  = $totalUsers
                            UserCount                   = $userCount
                            ServicePrincipalCount       = $servicePrincipalCount
                        }
                    } catch {
                        Write-Host "Skipping: Assigned object '$($principal.PrincipalId)' is not a valid group. Error: $_"
                    }
                }
                default {
                    Write-Host "Unknown Principal Type: $($principal.PrincipalType) for ID: $($principal.PrincipalId)"
                }
            }
        }

        # Add an entry summarizing non-group principal counts (Users and Service Principals)
        if ($userCount -gt 0 -or $servicePrincipalCount -gt 0) {
            $results += [PSCustomObject]@{
                ApplicationId               = $enterpriseApp.Id
                ApplicationName             = $enterpriseApp.DisplayName
                AppClientId                 = $enterpriseApp.AppId
                GroupId                     = "N/A"
                GroupDisplayName            = "Non-Group Principals Summary"
                GroupDescription            = "N/A"
                GroupCreatedDateTime        = "N/A"
                IsAssignableToRole          = "N/A"
                Mail                        = "N/A"
                MailEnabled                 = "N/A"
                OnPremisesSyncEnabled       = "N/A"
                SecurityEnabled             = "N/A"
                MembershipRule              = "N/A"
                MembershipRuleProcessingState = "N/A"
                MembershipType              = "N/A"
                TotalUsers                  = "N/A"
                UserCount                   = $userCount
                ServicePrincipalCount       = $servicePrincipalCount
            }
        }
    } else {
        Write-Host "No principals assigned to application: $($enterpriseApp.DisplayName)."
    }

    # Save intermediate results every 10 applications to prevent data loss in long runs
    if ($currentApp % 10 -eq 0) {
        $csvPathIntermediate = "C:\Temp\EnterpriseApps_Groups_Details_Partial.csv"
        $results | Export-Csv -Path $csvPathIntermediate -NoTypeInformation
        Write-Host "Intermediate results saved to: $csvPathIntermediate"
    }
}

# Export final results to CSV
$csvPath = "C:\Temp\EnterpriseApps_Groups_Details.csv"
$results | Export-Csv -Path $csvPath -NoTypeInformation
Write-Host "Final results exported to: $csvPath"

Write-Host "Script execution completed."
