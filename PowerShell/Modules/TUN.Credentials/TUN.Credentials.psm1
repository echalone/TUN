###
# Name:             TUN.Credentials
# Author:           Markus Szumovski
# Creation Date:    2020-06-18
# Purpose/Change:   Methods to easily manage and use credentials
# This Source Code Form is subject to the terms of the Mozilla Public License, 
# v. 2.0. If a copy of the MPL was not distributed with this file, You can obtain one at https://mozilla.org/MPL/2.0/
###

Set-StrictMode -Version Latest

[hashtable] $script:CachedCredentials = @{}                     # Cached credentials by name

function Get-CredentialInternal {
    <#
        .SYNOPSIS
            Retrieves credentials from user
        .PARAMETER Message
            Message to prompt for credential input.
            Default is "Please enter credentials"
        .PARAMETER Usage
            Optional string describing the usage for the credentials (will be appended to "Initializing credentials for <$Usage>").
        .PARAMETER NoOutput
            True/Present...Will not display any messages to the host
        .OUTPUTS
            Retrieved PSCredential object or null
    #>
    
    [CmdletBinding()]
    PARAM (
        [Parameter(Position=0)]
        [string] $Message,
        [Parameter(Position=1)]
        [string] $Usage,
        [Parameter(Position=2)]
        [switch] $NoOutput
    )
    
    if(!$NoOutput.IsPresent) {
        if($Usage) {
            Write-Host "Initializing credentials for $Usage..."
        }
        else {
            Write-Host "Initializing credentials..."
        }
    }
    $Credential = Get-Credential -Message $Message

    if(!$NoOutput.IsPresent) {
        if(!$Credential) {
            if($Usage) {
                Write-Host "Credentials input canceled for $Usage"
            }
            else {
                Write-Host "Credentials input canceled"
            }
        }
    }

    return $Credential
}

function Get-PSCredential {
    <#
        .SYNOPSIS
            Gets PS credentials from a cache or user name/password combination (in that order) and save it to the cache.
            If cache will be used to store the credentials can be configured.
        .PARAMETER Name
            Unique cache name for the credentials.
            If no cache name is provided, the credentials will not be cached.
        .PARAMETER UserName
            Username for credentials.
            This parameter is mandatory.
        .PARAMETER Password
            The password for credentials.
        .PARAMETER Init
            True/Present...If the Name parameter was provided:
                            Will clear the cache of these credentials and ask for a user input of credentials.
        .PARAMETER NoOutput
            True/Present...Will not display any messages to the host (except if canceling execution due to Init switch being present)
        .OUTPUTS
            Retrieved PSCredential object or null
    #>

    [CmdletBinding()]
    PARAM (
        [Parameter(Position=0)]
        [string] $Name = $null,
        [Parameter(Position=1, Mandatory=$true)]
        [string] $UserName,
        [Parameter(Position=2)]
        [SecureString] $Password,
        [Parameter(Position=3)]
        [switch] $Init,
        [Parameter(Position=4)]
        [switch] $NoOutput
    )

    [PSCredential] $Credential = $null

    if($Name -and $script:CachedCredentials.ContainsKey($Name)) {
        If($Init.IsPresent) {
            Clear-CredentialCache -Name $Name -NoOutput:$NoOutput
        }
        else {
            $Credential = $script:CachedCredentials[$Name]
        }
    }

    #check for credential file
    if(!$Credential) {
        $Credential = New-Object -TypeName PSCredential -ArgumentList $UserName, $Password
    }
        
    #check if we should cache if it's not yet cached
    If($Name -and !$script:CachedCredentials.ContainsKey($Name)) {
        if($Credential) {
            $script:CachedCredentials[$Name] = $Credential
        }
    }

    return $Credential
}

function Use-PSCredential {
    <#
        .SYNOPSIS
            Gets PS credentials from a cache, file or user input (in that order) and save it to a file and cache.
            If file and/or cache will be used to store the credentials can be configured.
        .PARAMETER Name
            Unique cache name for the credentials.
            If no cache name is provided, the credentials will not be cached.
        .PARAMETER File
            File to store credentials in and read credentials from.
            Information will be stored in the XML file format.
            If no path for a credentials file was provided this method will not save the credentials to a file.
        .PARAMETER Message
            Message to prompt for credential input.
            Default is "Please enter credentials"
        .PARAMETER Usage
            Optional string describing the usage for the credentials (will be appended to "Initializing credentials for <$Usage>").
            This will be ignored if the -NoOuptut switch was provided.
        .PARAMETER ErrorOnNone
            True/Present...Will throw an error if no credentials were found (even though File or Name was given in case of NoUnstored switch present)
        .PARAMETER NoInput
            True/Present...Will expect a name or file path to be provided and for there to already be a stored credential (exception: Init switch)
        .PARAMETER NoUnstored
            True/Present...Will not ask for credentials if no file path or cache name was provided
        .PARAMETER Init
            True/Present...If the File parameter was provided:
                            The script will ask for the credentials to use, store them in a credentials file and will then immediatly exit the script.
                            Used to either set up credentials file for the first time, or change/renew the credentials in the credential file, without performing the 
                            actual task by the script. The -WhatIf switch cannot be used to make sure the script is not performing its task, because it will also prevent
                            the script from saving the credentials to the credentials file.
                            This switch is ignored if the CredentialsFile parameter is not provided.
                            If the Name parameter was provided:
                            Will clear the cache of these credentials and ask for a user input of credentials.
        .PARAMETER NoOutput
            True/Present...Will not display any messages to the host (except if canceling execution due to Init switch being present)
        .OUTPUTS
            Retrieved PSCredential object or null
    #>

    [CmdletBinding()]
    PARAM (
        [Parameter(Position=0)]
        [string] $Name = $null,
        [Parameter(Position=1)]
        [string] $File = $null,
        [Parameter(Position=2)]
        [string] $Message = "Please enter credentials",
        [Parameter(Position=3)]
        [string] $Usage = $null,
        [Parameter(Position=4)]
        [switch] $ErrorOnNone,
        [Parameter(Position=5)]
        [switch] $NoInput,
        [Parameter(Position=6)]
        [switch] $NoUnstored,
        [Parameter(Position=7)]
        [switch] $Init,
        [Parameter(Position=8)]
        [switch] $NoOutput
    )

    [bool] $ShowedCredentialDialog = $false
    [PSCredential] $Credential = $null

    if($Name -and $script:CachedCredentials.ContainsKey($Name)) {
        If($Init.IsPresent) {
            Clear-CredentialCache -Name $Name -NoOutput:$NoOutput
        }
        else {
            $Credential = $script:CachedCredentials[$Name]
        }
    }

    #check for credential file
    if($File) {
        If($Init.IsPresent -or !(Test-Path $File)) {
            if(!$ShowedCredentialDialog -and !$Credential) {
                if(!$NoInput.IsPresent -or $Init.IsPresent) {
                    $Credential = Get-CredentialInternal -Message $Message -Usage $Usage -NoOutput:$NoOutput
                }
                $ShowedCredentialDialog = $true
            }

            if($Credential) {
                if(!$NoOutput.IsPresent) {
                    Write-Host "Saving credentials to file..."
                }
                $Credential | Export-Clixml -Path $File
            }   

            if($Init.IsPresent) {
                Write-Host "Ending script since the 'initialize credentials' switch was present!"
                exit
            }
        }
        else {
            $Credential = Import-CliXml -Path $File
        }
    }
        
    #check if we should cache if it's not yet cached
    If($Name -and !$script:CachedCredentials.ContainsKey($Name)) {
        if(!$ShowedCredentialDialog -and !$Credential) {
            if(!$NoInput.IsPresent -or $Init.IsPresent) {
                $Credential = Get-CredentialInternal -Message $Message -Usage $Usage -NoOutput:$NoOutput
            }
            $ShowedCredentialDialog = $true
        }

        if($Credential) {
            $script:CachedCredentials[$Name] = $Credential
        }
    }

    #now if no file or cache name was given, this will finally prompt us to enter credentials
    if(!$NoUnstored.IsPresent -and !$Credential -and !$NoInput.IsPresent -and !$ShowedCredentialDialog) {
        $Credential = Get-CredentialInternal -Message $Message -Usage $Usage -NoOutput:$NoOutput
        $ShowedCredentialDialog = $true
    }

    if($ErrorOnNone.IsPresent -and !$Credential) {
        if(!$NoUnstored.IsPresent -or $File -or $Name) {
            $strMessage = "Credentials could not be initialized or retrieved"
            if($Usage) {
                $strMessage = "Credentials for $Usage could not be initialized or retrieved"
            }
			throw $strMessage            
        }
    }

    return $Credential
}

function Get-NetworkCredential {
    <#
        .SYNOPSIS
            Gets network credentials from a cache or user name/password combination (in that order) and save it to the cache.
            If cache will be used to store the credentials can be configured.
        .PARAMETER Name
            Unique cache name for the credentials.
            If no cache name is provided, the credentials will not be cached.
        .PARAMETER UserName
            Username for credentials.
            This parameter is mandatory.
        .PARAMETER Password
            The password for credentials.
        .PARAMETER Init
            True/Present...If the Name parameter was provided:
                            Will clear the cache of these credentials and ask for a user input of credentials.
        .PARAMETER NoOutput
            True/Present...Will not display any messages to the host (except if canceling execution due to Init switch being present)
        .OUTPUTS
            Retrieved PSCredential object or null
    #>

    [CmdletBinding()]
    PARAM (
        [Parameter(Position=0)]
        [string] $Name = $null,
        [Parameter(Position=1, Mandatory=$true)]
        [string] $UserName,
        [Parameter(Position=2)]
        [SecureString] $Password,
        [Parameter(Position=3)]
        [switch] $Init,
        [Parameter(Position=4)]
        [switch] $NoOutput
    )

    $PSCredential = Get-PSCredential -Name $Name -UserName $UserName -Password $Password -Init:$Init -NoOutput:$NoOutput

    if($PSCredential) {
        return [System.Net.NetworkCredential] $PSCredential
    }
    else {
        return $null
    }
}

function Use-NetworkCredential {
    <#
        .SYNOPSIS
            Gets Network credentials from a cache, file or user input (in that order) and save it to a file and cache.
            If file and/or cache will be used to store the credentials can be configured.
            The credentials will be cached and/or saved to a file as PS credentials. So this method can also be used
            to retrieve these credentials as PS credentials later, or retrieve the network credentials of previously
            stored PS credentials.
        .PARAMETER Name
            Unique cache name for the credentials.
            If no cache name is provided, the credentials will not be cached.
        .PARAMETER File
            File to store credentials in and read credentials from.
            Information will be stored in the XML file format.
            If no path for a credentials file was provided this method will not save the credentials to a file.
        .PARAMETER Message
            Message to prompt for credential input.
            Default is "Please enter credentials"
        .PARAMETER Usage
            Optional string describing the usage for the credentials (will be appended to "Initializing credentials for <$Usage>").
            This will be ignored if the -NoOuptut switch was provided.
        .PARAMETER ErrorOnNone
            True/Present...Will throw an error if no credentials were found (even though File or Name was given in case of NoUnstored switch present)
        .PARAMETER NoInput
            True/Present...Will expect a name or file path to be provided and for there to already be a stored credential (exception: Init switch)
        .PARAMETER NoUnstored
            True/Present...Will not ask for credentials if no file path or cache name was provided
        .PARAMETER Init
            True/Present...If the File parameter was provided:
                            The script will ask for the credentials to use, store them in a credentials file and will then immediatly exit the script.
                            Used to either set up credentials file for the first time, or change/renew the credentials in the credential file, without performing the 
                            actual task by the script. The -WhatIf switch cannot be used to make sure the script is not performing its task, because it will also prevent
                            the script from saving the credentials to the credentials file.
                            This switch is ignored if the CredentialsFile parameter is not provided.
                            If the Name parameter was provided:
                            Will clear the cache of these credentials and ask for a user input of credentials.
        .PARAMETER NoOutput
            True/Present...Will not display any messages to the host (except if canceling execution due to Init switch being present)
        .OUTPUTS
            Retrieved network credentials object or null
    #>

    [CmdletBinding()]
    PARAM (
        [Parameter(Position=0)]
        [string] $Name = $null,
        [Parameter(Position=1)]
        [string] $File = $null,
        [Parameter(Position=2)]
        [string] $Message = "Please enter credentials",
        [Parameter(Position=3)]
        [string] $Usage = $null,
        [Parameter(Position=4)]
        [switch] $ErrorOnNone,
        [Parameter(Position=5)]
        [switch] $NoInput,
        [Parameter(Position=6)]
        [switch] $NoUnstored,
        [Parameter(Position=7)]
        [switch] $Init,
        [Parameter(Position=8)]
        [switch] $NoOutput
    )

    $PSCredential = Use-PSCredential -Name $Name -File $File -Message $Message -Usage $Usage -ErrorOnNone:$ErrorOnNone -NoInput:$NoInput -NoUnstored:$NoUnstored -Init:$Init -NoOutput:$NoOutput

    if($PSCredential) {
        return [System.Net.NetworkCredential] $PSCredential
    }
    else {
        return $null
    }
}

function Clear-CredentialCache {
    <#
        .SYNOPSIS
            Clears the credential cache (of all or one specific credential).
            Needed at the beginning of a script, if the credentials should be entered again for each execution of the script, 
            even if the script is still in the same scope (PS window).
        .PARAMETER Name
            Name of the credentials to remove from cache, or empty if the whole cache should be cleared
        .PARAMETER NoOutput
            True/Present...Will not display any messages to the host
        .OUTPUTS
            Nothing
    #>
    
    [CmdletBinding()]
    PARAM (
        [Parameter(Position=0)]
        [string] $Name,
        [Parameter(Position=1)]
        [switch] $NoOutput
    )
    
    if($Name) {
        if($script:CachedCredentials.ContainsKey($Name)) {
            if(!$NoOutput.IsPresent) {
                Write-Host "Clearing cache of credentials ""$Name""..."
            }
            $script:CachedCredentials.Remove($Name)
            [System.GC]::Collect()
        }
    }
    else {
        if(!$NoOutput.IsPresent) {
            Write-Host "Clearing credentials cache..."
        }
        $script:CachedCredentials = @{}
        [System.GC]::Collect()
    }
}

