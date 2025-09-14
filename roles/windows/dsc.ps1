Write-Output "Applying DSC configuration..."

$DomainName = "lab.local"
$SafeModePassword = ConvertTo-SecureString "P@ssw0rd!" -AsPlainText -Force
$DomainAdminCred = New-Object System.Management.Automation.PSCredential("Administrator", $SafeModePassword)

Configuration SimpleAD {

    Import-DscResource -ModuleName xActiveDirectory

    Node "localhost" {

        # Install AD DS role
        WindowsFeature ADDSInstall {
            Name   = "AD-Domain-Services"
            Ensure = "Present"
        }

        # Promote DC only on winserver1
        if ($env:COMPUTERNAME -eq "winserver1") {

            xADDomain FirstDC {
                DomainName = $DomainName
                PsDscRunAsCredential = $DomainAdminCred
                SafemodeAdministratorPassword = $SafeModePassword
                DependsOn = "[WindowsFeature]ADDSInstall"
            }

            xADOrganizationalUnit MyOU {
                Name      = "TestOU"
                Path      = "DC=lab,DC=local"
                Ensure    = "Present"
                DependsOn = "[xADDomain]FirstDC"
            }

            xADUser User1 {
                UserName   = "TestUser1"
                Path       = "OU=TestOU,DC=lab,DC=local"
                Password   = $SafeModePassword
                Ensure     = "Present"
                DependsOn  = "[xADOrganizationalUnit]MyOU"
                PsDscRunAsCredential = $DomainAdminCred
            }

            xADUser User2 {
                UserName   = "TestUser2"
                Path       = "OU=TestOU,DC=lab,DC=local"
                Password   = $SafeModePassword
                Ensure     = "Present"
                DependsOn  = "[xADOrganizationalUnit]MyOU"
                PsDscRunAsCredential = $DomainAdminCred
            }

        } else {
            # Join other servers to the domain
            xComputer JoinDomain {
                Name       = $env:COMPUTERNAME
                DomainName = $DomainName
                Credential = $DomainAdminCred
                JoinDomain = $true
                DependsOn  = "[WindowsFeature]ADDSInstall"
            }
        }
    }
}

# Compile and apply
SimpleAD
Start-DscConfiguration -Path ./SimpleAD -Wait -Verbose -Force


# Write-Output "Applying DSC configuration..."

# $DomainName = "lab.local"
# $SafeModePassword = ConvertTo-SecureString "P@ssw0rd!" -AsPlainText -Force
# $DomainAdminPassword = ConvertTo-SecureString "P@ssw0rd!" -AsPlainText -Force

# Configuration SimpleAD {

#     Import-DscResource -ModuleName xActiveDirectory
#     Import-DscResource -ModuleName PSDesiredStateConfiguration

#     Node "localhost" {

#         $DomainAdminCred = New-Object System.Management.Automation.PSCredential(
#             "Administrator",
#             (ConvertTo-SecureString "P@ssw0rd!" -AsPlainText -Force)
#         )

#         WindowsFeature ADDSInstall {
#             Name   = "AD-Domain-Services"
#             Ensure = "Present"
#         }

#         xADDomain FirstDC {
#             DomainName                    = "lab.local"
#             DomainAdministratorCredential = $DomainAdminCred
#             SafemodeAdministratorPassword = (ConvertTo-SecureString "P@ssw0rd!" -AsPlainText -Force)
#             DependsOn                     = "[WindowsFeature]ADDSInstall"
#         }

#         xADOrganizationalUnit MyOU {
#             Name       = "TestOU"
#             Path       = "DC=lab,DC=local"
#             Ensure     = "Present"
#             DependsOn  = "[xADDomain]FirstDC"
#         }

#         xADUser User1 {
#             UserName   = "TestUser1"
#             DomainName = "lab.local"
#             Path       = "OU=TestOU,DC=lab,DC=local"
#             Password   = (ConvertTo-SecureString "P@ssw0rd!" -AsPlainText -Force)
#             Ensure     = "Present"
#             DependsOn  = "[xADOrganizationalUnit]MyOU"
#             PsDscRunAsCredential = $DomainAdminCred
#         }

#         xADUser User2 {
#             UserName   = "TestUser2"
#             DomainName = "lab.local"
#             Path       = "OU=TestOU,DC=lab,DC=local"
#             Password   = (ConvertTo-SecureString "P@ssw0rd!" -AsPlainText -Force)
#             Ensure     = "Present"
#             DependsOn  = "[xADOrganizationalUnit]MyOU"
#             PsDscRunAsCredential = $DomainAdminCred
#         }

#     }
# }


