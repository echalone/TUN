###
# Name:             TUN.Environment
# Author:           Markus Szumovski
# Creation Date:    2020-06-18
# Purpose/Change:   Sets up environemnt variables if not set up correctly (i.e. Scheduled Tasks without logged in user)
# This Source Code Form is subject to the terms of the Mozilla Public License, 
# v. 2.0. If a copy of the MPL was not distributed with this file, You can obtain one at https://mozilla.org/MPL/2.0/
###

Set-StrictMode -Version Latest

Import-Module "TUN.Logging" -Force

function New-EVLookup {
    <#
        .SYNOPSIS
            Creates an environment variable lookup for registry
        .PARAMETER KeyPath
            The path of the registry key to retrieve value from
        .PARAMETER ValueName
            The name of the registry value to retrieve value from
        .OUTPUTS
            Lookup object for registry search
    #>

    [CmdletBinding()]
    PARAM (
        [Parameter(Position=0, Mandatory=$true)]
        [string] $KeyPath,
        [Parameter(Position=1, Mandatory=$true)]
        [string] $ValueName
    )

    $Lookup = New-Object PSObject
    $Lookup | Add-Member -Type NoteProperty -Name KeyPath -Value $KeyPath
    $Lookup | Add-Member -Type NoteProperty -Name ValueName -Value $ValueName

    return $Lookup
}

function Get-EnvironmentVariable {
    <#
        .SYNOPSIS
            Gets and possibly initializes environment variable value
        .PARAMETER Name
            Name of the environment variable
        .PARAMETER Lookups
            Lookup paths created with New-EVLookup
        .PARAMETER Target
            Target to store environment value in (default is process)
        .PARAMETER ForceValue
            Value to force on environment variable if no value was found
        .OUTPUTS
            Retrieved value of environment variable or first found registry key
    #>

    [CmdletBinding()]
    PARAM (
        [Parameter(Position=0, Mandatory=$true)]
        [string] $Name,
        [Parameter(Position=1, Mandatory=$true)]
        [PSObject[]] $Lookups,
        [Parameter(Position=2)]
        [System.EnvironmentVariableTarget] $Target = [System.EnvironmentVariableTarget]::Process,
        [Parameter(Position=3)]
        [string] $ForceValue = $null
    )

    try {
        Write-VerboseLog "Checking environment variable ""$Name""..."

        $EnvVal = [System.Environment]::GetEnvironmentVariable($Name, [System.EnvironmentVariableTarget]::Process)

        if($null -eq $EnvVal) {
            $EnvVal = [System.Environment]::GetEnvironmentVariable($Name, [System.EnvironmentVariableTarget]::User)

            if($null -eq $EnvVal) {
                $EnvVal = [System.Environment]::GetEnvironmentVariable($Name, [System.EnvironmentVariableTarget]::Machine)
            
                if($null -eq $EnvVal) {
                
                    Write-VerboseLog "Environment variable ""$Name"" not found, searching in registry..."

                    foreach($Lookup in $Lookups) {
                        try {
                            Write-VerboseLog "Looking in registry key ""$($Lookup.KeyPath)"" value ""$($Lookup.ValueName)""..."

                            $RegKey = Get-ItemProperty -Path $Lookup.KeyPath -Name $Lookup.ValueName -ErrorAction SilentlyContinue
                            if($null -ne $RegKey) {
                                $EnvVal = $RegKey.($Lookup.ValueName)
                    
                                if($null -ne $EnvVal) {
                                    Write-VerboseLog "Found in registry key ""$($Lookup.KeyPath)"" value ""$($Lookup.ValueName)"" with value ""$EnvVal"""
                                    break;
                                }
                                else {
                                    Write-VerboseLog "No registry value found in registry key ""$($Lookup.KeyPath)"" value ""$($Lookup.ValueName)"""
                                }
                            }
                            else {
                                Write-VerboseLog "No registry key or value found in registry key ""$($Lookup.KeyPath)"" value ""$($Lookup.ValueName)"""
                            }
                        }
                        catch {
                            $_ | Write-ErrorLog "While trying to look in registry key ""$($Lookup.KeyPath)"" value ""$($Lookup.ValueName)"" to initialize enviornment variable ""$Name"""
                        }
                    }
                                
                }    
                else {
                    Write-VerboseLog "Environment variable ""$Name"" exists in machine"
                }
            }
            else {
                Write-VerboseLog "Environment variable ""$Name"" exists in user"
            }

            if($null -eq $EnvVal -and $null -ne $ForceValue) {
                Write-VerboseLog "Environment variable ""$Name"" not found, enforcing value ""$ForceValue""..."
                $EnvVal = $ForceValue
            }

            if($null -ne $EnvVal) {
                [System.Environment]::SetEnvironmentVariable($Name, $EnvVal, $Target)
            }
        }
        else {
            Write-VerboseLog "Environment variable ""$Name"" exists in process"
        }

        if($null -eq $EnvVal) {
            Write-VerboseLog "No value found for environment variable ""$Name"""
        }
        else {
            Write-VerboseLog "Value for environment variable ""$Name"": ""$EnvVal"""
        }

        return $EnvVal
    }
    catch {
        $_ | Write-ErrorLog "While trying to initialize enviornment variable ""$Name"""
    }
}

function Initialize-Environment {
    <#
        .SYNOPSIS
            Sets up environemnt variables (from registry)
        .OUTPUTS
            Nothing
    #>
    
    [CmdletBinding()]
    PARAM (
    )

    try {

        Write-VerboseLog "Initializing environment variables..."
        
        $Env_HomeDrive = `
            Get-EnvironmentVariable -Name "HOMEDRIVE" `
                                    -Lookups @( `
                                        (New-EVLookup -KeyPath "HKCU:\Volatile Environment" -ValueName "HOMEDRIVE") `
                                        ) `
                                    -ForceValue "C:"

        $Env_UserName = `
            Get-EnvironmentVariable -Name "USERNAME" `
                                    -Lookups @( `
                                        (New-EVLookup -KeyPath "HKCU:\Volatile Environment" -ValueName "USERNAME") `
                                        ) `
                                    -ForceValue [Environment]::UserName

        $Env_HomePath = `
            Get-EnvironmentVariable -Name "HOMEPATH" `
                                    -Lookups @( `
                                        (New-EVLookup -KeyPath "HKCU:\Volatile Environment" -ValueName "HOMEPATH") `
                                        ) `
                                    -ForceValue "\Users\$Env_UserName"

        $Env_UserProfile = `
            Get-EnvironmentVariable -Name "USERPROFILE" `
                                    -Lookups @( `
                                        (New-EVLookup -KeyPath "HKCU:\Volatile Environment" -ValueName "USERPROFILE") `
                                        ) `
                                    -ForceValue "$Env_HomeDrive$Env_HomePath"

        $Env_AppData = `
            Get-EnvironmentVariable -Name "APPDATA" `
                                -Lookups @( `
                                    (New-EVLookup -KeyPath "HKCU:\Volatile Environment" -ValueName "APPDATA"), `
                                    (New-EVLookup -KeyPath "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" -ValueName "AppData"), `
                                    (New-EVLookup -KeyPath "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -ValueName "AppData"), `
                                    (New-EVLookup -KeyPath "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders\Backup" -ValueName "AppData") `
                                    ) `
                                -ForceValue "$Env_UserProfile\AppData\Roaming"

        $Env_LocalAppData = `
            Get-EnvironmentVariable -Name "LOCALAPPDATA" `
                                -Lookups @( `
                                    (New-EVLookup -KeyPath "HKCU:\Volatile Environment" -ValueName "LOCALAPPDATA"), `
                                    (New-EVLookup -KeyPath "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" -ValueName "Local AppData"), `
                                    (New-EVLookup -KeyPath "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -ValueName "Local AppData"), `
                                    (New-EVLookup -KeyPath "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders\Backup" -ValueName "Local AppData") `
                                    ) `
                                -ForceValue "$Env_UserProfile\AppData\Local"

        $Env_UserDNSDomain = `
            Get-EnvironmentVariable -Name "USERDNSDOMAIN" `
                                -Lookups @( `
                                    (New-EVLookup -KeyPath "HKCU:\Volatile Environment" -ValueName "USERDNSDOMAIN"), `
                                    (New-EVLookup -KeyPath "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" -ValueName "Local AppData"), `
                                    (New-EVLookup -KeyPath "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -ValueName "Local AppData"), `
                                    (New-EVLookup -KeyPath "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders\Backup" -ValueName "Local AppData") `
                                    )

        $Env_UserDomain = `
            Get-EnvironmentVariable -Name "USERDOMAIN" `
                                -Lookups @( `
                                    (New-EVLookup -KeyPath "HKCU:\Volatile Environment" -ValueName "USERDOMAIN") `
                                    )

        $Env_UserDomainRoamingProfile = `
            Get-EnvironmentVariable -Name "USERDOMAIN_ROAMINGPROFILE" `
                                -Lookups @( `
                                    (New-EVLookup -KeyPath "HKCU:\Volatile Environment" -ValueName "USERDOMAIN_ROAMINGPROFILE") `
                                    ) `
                                -ForceValue $Env_UserDomain


        $Env_ProgramFiles = `
            Get-EnvironmentVariable -Name "ProgramFiles" `
                                    -Lookups @( `
                                        (New-EVLookup -KeyPath "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion" -ValueName "ProgramFilesDir"), `
                                        (New-EVLookup -KeyPath "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion" -ValueName "ProgramFilesDir")
                                        ) `
                                    -ForceValue "$Env_HomeDrive\Program Files"

        $Env_ProgramFilesX86 = `
            Get-EnvironmentVariable -Name "ProgramFiles(x86)" `
                                -Lookups @( `
                                    (New-EVLookup -KeyPath "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion" -ValueName "ProgramFilesDir (x86)"), `
                                    (New-EVLookup -KeyPath "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion" -ValueName "ProgramFilesDir (x86)")
                                    ) `
                                -ForceValue "$Env_ProgramFiles (x86)"

        Write-VerboseLog "Environment variables initialized"
    }
    catch {
        $_ | Write-ErrorLog "While trying to initialize environment variables"
    }
}

