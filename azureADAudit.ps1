#Azure Active Directory Auditing
#Deploy Azure Powershell modules to the current user

#warning you can't run Az and AzureRM modules at the same time :S

$mydomain = "@xservus.com"

if($PSVersionTable.PSEdition -eq 'Desktop' -and (Get-Module -Name AzureRM -ListAvailable)) {
    Write-Warning -Message ('Az module not installed. Having both the AzureRM and ' +
      'Az modules installed at the same time is not supported.')
} else {
    Install-Module -Name Az -AllowClobber -Scope CurrentUser
}


######
#PROXY CONFIG
######
# if the proxy bocks this set the proxy (this config uses local creds)
#$webClient = New-Object System.Net.WebClient
#$webClient.Proxy.Credentials = [System.Net.CredentialCache]::DefaultNetworkCredentials


# ALL  USERS IF U LIKE THAT KIND OF THING :)
#if ($PSVersionTable.PSEdition -eq 'Desktop' -and (Get-Module -Name AzureRM -ListAvailable)) {
#    Write-Warning -Message ('Az module not installed. Having both the AzureRM and ' +
#      'Az modules installed at the same time is not supported.')
#} else {
#    Install-Module -Name Az -AllowClobber -Scope AllUsers
#}

#Connect to Azure # different methods need to check on the differences
Connect-AzAccount -Tenant XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
#Add-AzAccount
#Get-AzADALAuthenticationContext -Login "https://login.microsoftonline.com"

#$AzureConnect = Connect-AzureAD -TenantId XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

write-host "TenantID = " $AzureConnect.TenantId
write-host "TenantAccount = " $AzureConnect.Account
write-host "TenantDomain = " $AzureConnect.TenantDomain

#This will list all the directories you are ascocaited with
$Azdirectories = Get-AzTenant -TenantId XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
foreach($directory in $Azdirectories){
write-host $directory.
write-host $directory.Id
write-host $directory.TenantId
write-host $directory.ExtendedProperties

}

Get-AzADUser

$AzureUsers = Get-AzADUser
clear-variable countEnabled
clear-Variable countEnabledMyDomain
clear-variable percent
clear-Variable mydomainpercent

foreach($username in $AzureUsers){
write-host $username.UsageLocation
write-host $username.UserPrincipalName

write-host $username.ObjectType
write-host $username.AccountEnabled
if ($username.AccountEnabled -eq "True"){
#are the accounts enabled?
$countEnabled = $countEnabled + 1
#what domain are they in? because azure include guests
            if ($username.UserPrincipalName -notlike "#EXT#"){
            write-host "INTERNAL USER FOUND" -ForegroundColor Yellow
            $countEnabledMyDomain = $countEnabledMyDomain + 1
            }


}

}

write-host "Number of enabled accounts =  " $countEnabled

#how many users do we have?
write-host "Identified " $AzureUsers.count 
#how many users are enabled?


#Get Azure AD Roles
Get-AzureADDirectoryRole
#Get all the members of each role
Get-AzureADDirectoryRole |Get-AzureADDirectoryRoleMember

$AZroles = Get-AzureADDirectoryRole
foreach($role in $AZroles){
write-host "######################################ROLE" -ForegroundColor Cyan
write-host "Name" $role.DisplayName
write-host "Description" $role.Description
write-host "DeletionTimeStamp" $role.DeletionTimestamp
write-host "SYSTEM" $role.IsSystem
write-host "DISABLED" $role.RoleDisabled
write-host "TEMPLATEID" $role.RoleTemplateId
write-host "ObjectID" $role.ObjectId
write-host "ObjectTYPE" $role.ObjectType

write-host "#######################MEMBER" -ForegroundColor DarkCyan
$AzRoleMembers = $role |Get-AzureADDirectoryRoleMember
write-host "Identified " $AzRoleMembers.Count " number of Members" -ForegroundColor Red



if($AzRoleMembers.Count -gt 0){
write-host "Number of Members vs Size of EnabledUsers = " $AzRoleMembers.Count / $countEnabled -ForegroundColor Green
$percent = $AzRoleMembers.Count / $countEnabled
write-host "Number of Members vs Size of EnabledUsers = " $percent -ForegroundColor DarkGreen
if($countEnabledMyDomain -gt 0){
$mydomainpercent = $AzRoleMembers.Count / $countEnabledMyDomain
write-host "Number of Members vs Size of EnabledUsers in My Domain = " $mydomainpercent -ForegroundColor Green
}
}


foreach($RoleMember in $AzRoleMembers){
write-host "Enabled" $RoleMember.AccountEnabled
write-host "UPN" $RoleMember.UserPrincipalName
write-host "DIRSYNC" $RoleMember.DirSyncEnabled
write-host "SYNCTIME" $RoleMember.LastDirSyncTime
write-host "Forename" $RoleMember.GivenName
write-host "Surname" $RoleMember.Surname
write-host "DisaplyName" $RoleMember.DisplayName
write-host "Password Policy" $RoleMember.PasswordPolicies


}
}


#WOW THat's just for roles etc. need to go into the actual groups next


#Get all the AzureADUsers
#Get-AzADUser | select -Property *

#Get all the AzureADgroups
#Get-AzADGroup | select -Property *


#Get all the members of each group
#Get-AzADGroup | Get-AzADGroupMember


