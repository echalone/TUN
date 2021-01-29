###
# Name:             TUN.Logging
# Author:           Markus Szumovski
# Creation Date:    2020-06-18
# Purpose/Change:   Logging in files and/or sending log by mail
# This Source Code Form is subject to the terms of the Mozilla Public License, 
# v. 2.0. If a copy of the MPL was not distributed with this file, You can obtain one at https://mozilla.org/MPL/2.0/
###

Set-StrictMode -Version Latest

Import-Module "TUN.Credentials" -Force

$script:CmdletSupport_AddContent_NoNewline = $false             # tells us if the Add-Content cmdlet supports the NoNewline parameter
$script:WhatIfLog = $false                                      # tells us if the -WhatIf switch is set
$script:LogFile = $null                                         # Path to the logfile
$script:LogMailCredentialFile = $null                           # Path to the credential file for smtp server authentication (in case of mail log sending)
$script:LogMailText = ""                                        # The stored text for the mail log
$script:LogRunning = $false                                     # Is logging in process?
$script:LogMailRunning = $false                                 # Is logging to mail log in process?
$script:LogPreference_NoTimestamp = $false                      # Should timestamps for the log-file be omitted?
$script:LogPreference_AsOutput = $false                         # Should the log file contain whatever the output contains (or everything=$false)?
$script:LogPreference_MailAsOutput = $false                     # Should the mail log contain whatever the output contains (or everything=$false)?
$script:LogPreference_FallbackForegroundColor = `               # Fallback color for foreground color if it is not possible to retrieve the information from the console
                                    [ConsoleColor]::Gray
$script:LogPreference_FallbackBackgroundColor = `               # Fallback color for background color if it is not possible to retrieve the information from the console
                                    [ConsoleColor]::Black

[Nullable[bool]] $script:LogPreference_MailError = $null        # Should errors be sent in the log mail? ($null...either always or as output if -AsOutput switch is set)
[Nullable[bool]] $script:LogPreference_MailHost = $null         # Should host messages be sent in the log mail? ($null...either always or as output if -AsOutput switch is set)
[Nullable[bool]] $script:LogPreference_MailOutput = $null       # Should output messages be sent in the log mail? ($null...either always or as output if -AsOutput switch is set)
[Nullable[bool]] $script:LogPreference_MailVerbose = $null      # Should verbose messages be sent in the log mail? ($null...either always or as output if -AsOutput switch is set)
[Nullable[bool]] $script:LogPreference_MailWarning = $null      # Should warnings be sent in the log mail? ($null...either always or as output if -AsOutput switch is set)
[Nullable[bool]] $script:LogPreference_MailDebug = $null        # Should debug messages be sent in the log mail? ($null...either always or as output if -AsOutput switch is set)
[Nullable[bool]] $script:LogPreference_MailInformation = $null  # Should information be sent in the log mail? ($null...either always or as output if -AsOutput switch is set)

[Nullable[bool]] $script:LogPreference_LogError = $null         # Should errors be logged? ($null...either always or as output if -AsOutput switch is set)
[Nullable[bool]] $script:LogPreference_LogHost = $null          # Should host messages be logged? ($null...either always or as output if -AsOutput switch is set)
[Nullable[bool]] $script:LogPreference_LogOutput = $null        # Should output messages be logged? ($null...either always or as output if -AsOutput switch is set)
[Nullable[bool]] $script:LogPreference_LogVerbose = $null       # Should verbose messages be logged? ($null...either always or as output if -AsOutput switch is set)
[Nullable[bool]] $script:LogPreference_LogWarning = $null       # Should warnings be logged? ($null...either always or as output if -AsOutput switch is set)
[Nullable[bool]] $script:LogPreference_LogDebug = $null         # Should debug messages be logged? ($null...either always or as output if -AsOutput switch is set)
[Nullable[bool]] $script:LogPreference_LogInformation = $null   # Should information be logged? ($null...either always or as output if -AsOutput switch is set)

$script:ErrorMailCount = 0                                      # how often has an error been saved for mail log sending?
$script:HostMailCount = 0                                       # how often has a host message been saved for mail log sending?
$script:OutputMailCount = 0                                     # how often has an output message been saved for mail log sending?
$script:VerboseMailCount = 0                                    # how often has a verbose message been saved for mail log sending?
$script:WarningMailCount = 0                                    # how often has a warning been saved for mail log sending?
$script:DebugMailCount = 0                                      # how often has a debug message been saved for mail log sending?
$script:InformationMailCount = 0                                # how often has an information been saved for mail log sending?

$script:ErrorLogCount = 0                                       # how often has an error been logged to the file?
$script:HostLogCount = 0                                        # how often has a host message been logged to the file?
$script:OutputLogCount = 0                                      # how often has an output message been logged to the file?
$script:VerboseLogCount = 0                                     # how often has a verbose message been logged to the file?
$script:WarningLogCount = 0                                     # how often has a warning been logged to the file?
$script:DebugLogCount = 0                                       # how often has a debug message been logged to the file?
$script:InformationLogCount = 0                                 # how often has an information been logged to the file?

$script:ForceLogSend = $false                                   # stores if mail log should be sent forcefully
$script:ForceLogReason = ""                                     # stores a reason for forced mail log sending

$script:ScriptInfo_Retrieved = $false                           # determines if information about the executing main scriptfile has already been retrieved
$script:ScriptInfo_Call = $null                                 # The line with which the executing main scriptfile was called
$script:ScriptInfo_Path = $null                                 # The path to the executing main scriptfile
$script:ScriptInfo_File = $null                                 # The filename of the executing main scriptfile
$script:ScriptInfo_Name = $null                                 # The filename without extension of the executing main scriptfile
$script:ScriptInfo_Version = $null                              # The version of the executing main scriptfile
$script:ScriptInfo_CurrentUser = $null                          # The user context at the start of logging
$script:ScriptInfo_ComputerName = $null                         # The machine name at the start of logging

function Coalesce
{
<#
    .SYNOPSIS
        Does the same as the ?? operator in C# (Null Coalescing Operator)
    .PARAMETER IfNull
        The value to be checked for null. If not null, this value will be returned.
    .PARAMETER InsteadOfNull
        If the value in the IfNull parameter is null, this value will be returned.
    .OUTPUTS
        Value of IfNull parameter if it is not null, otherwise the InsteadOfNull parameter value is returned
#>

    PARAM (
        [Parameter(Position=0)]
        $IfNull,
        [Parameter(Position=1)]
        $InsteadOfNull
    )
    
    if ($null -ne $IfNull) { 
        return $IfNull 
    } 
    else { 
        return $InsteadOfNull 
    }
}

#
function Copy-PreferenceVariable {
<#
    .SYNOPSIS
        Copy the value of one or more variables from the session state to the script scope 
    .PARAMETER Cmdlet
        The $PSCmdlet variable of the caller function
    .PARAMETER VariableName
        The names of the variables to copy the value from
    .OUTPUTS
        None
#>

    [CmdletBinding(SupportsShouldProcess=$true)]
    PARAM (
        [Parameter(Position=0, Mandatory=$true)]
        $Cmdlet,
        [Parameter(Position=1, Mandatory=$true)]
        [string[]] $VariableName
    )

    foreach($varName in $VariableName) {
        try {
            $var = $Cmdlet.SessionState.PSVariable.Get($varName)
            if($var) {
                Set-Variable -Name $var.Name -Value $var.Value -Scope Script -Force -WhatIf:$false -Confirm:$false
            }
            else {
                throw "Variable not found is session state"
            }
        }
        catch {
            $_ | Write-ErrorLog "While trying to copy value of session state variable ""$varName"""
        }
    }
}

function Initialize-PreferenceVariables {
<#
    .SYNOPSIS
        Copies the value of several session state variables to the script scope 
    .PARAMETER Cmdlet
        The $PSCmdlet variable of the caller function
    .PARAMETER OmitWhatIf
        True/Present...Will omit copying the setting of the WhatIf switch
        False/Absent...Will also copy the setting of the WhatIf switch
    .OUTPUTS
        None
#>
    [CmdletBinding(SupportsShouldProcess=$true)]
    PARAM(
        [Parameter(Position=0, Mandatory=$true)]
        $Cmdlet,
        [Parameter(Position=1)]
        [switch] $OmitWhatIf
    )

    $ArrVariables = @("ErrorActionPreference", `
                        "DebugPreference", `
                        "ConfirmPreference", `
                        "VerbosePreference", `
                        "WarningPreference", `
                        "PSEmailServer", `
                        "OutputEncoding")

    if(!$OmitWhatIf.IsPresent) {
        $ArrVariables += "WhatIfPreference"
    }

    Copy-PreferenceVariable $Cmdlet $ArrVariables
}

function RetrieveScriptInfo {
<#
    .SYNOPSIS
        Retrieves information about the calling script (name, path, ...) 
        and stores them in script-scope variables 
        $script:ScriptInfo_File
        $script:ScriptInfo_Name
        $script:ScriptInfo_Path
        $script:ScriptInfo_Call
        $script:ScriptInfo_Version
        for later reuse
    .OUTPUTS
        None
#>

    if(!$script:ScriptInfo_Retrieved) {
        $script:ScriptInfo_ComputerName = Coalesce -IfNull $Env:COMPUTERNAME -InsteadOfNull $Env:NAME
        if([string]::IsNullOrWhiteSpace($script:ScriptInfo_ComputerName)) {
            $script:ScriptInfo_ComputerName = "local"
        }
        
        $UserName = Coalesce -IfNull $Env:UserName -InsteadOfNull $Env:USER

        if($UserName) {
            if($Env:UserDomain) {
                $script:ScriptInfo_CurrentUser = $Env:UserDomain + "\" + $UserName
            }
            else {
                $script:ScriptInfo_CurrentUser = $UserName
            }    
        }

        $arr = @(Get-PSCallStack) 

        $frmScript = $arr | Where-Object { ($null -ne $_) -and ($null -ne $_.InvocationInfo) `
                                    -and ($null -ne $_.InvocationInfo.MyCommand) `
                                    -and ($_.InvocationInfo.MyCommand.CommandType -eq [System.Management.Automation.CommandTypes]::ExternalScript) } `
                                | Select-Object -Last 1 | Select-Object -ExpandProperty InvocationInfo

        if($null -ne $frmScript) {
            if($frmScript.MyCommand.Source -eq "TUN.Logging" -and $frmScript.MyCommand.ModuleName -eq "TUN.Logging") {
                $script:ScriptInfo_File = "console"
                $script:ScriptInfo_Name = "console"
                $script:ScriptInfo_Path = "console"
                $script:ScriptInfo_Call = $frmScript.MyCommand.Name
                $script:ScriptInfo_Version = $null
            }
            else {
                $script:ScriptInfo_File = Coalesce -IfNull (Coalesce -IfNull ($frmScript.MyCommand.Name) -InsteadOfNull ([System.IO.Path]::GetFileName($frmScript.MyCommand.Path))) -InsteadOfNull "unknown"
                $script:ScriptInfo_Name = Coalesce -IfNull ([System.IO.Path]::GetFileNameWithoutExtension($script:ScriptInfo_File)) -InsteadOfNull "unknown"
                $script:ScriptInfo_Path = Coalesce -IfNull (Coalesce -IfNull ($frmScript.MyCommand.Path) -InsteadOfNull ($script:ScriptInfo_Name)) -InsteadOfNull "unknown"
                $script:ScriptInfo_Call = Coalesce -IfNull ($frmScript.Line) -InsteadOfNull "unknown"
                if([bool]($frmScript.MyCommand.PSobject.Properties.name) -match "Version") {
                    $script:ScriptInfo_Version = $frmScript.MyCommand.Version
                }
                else {
                    $script:ScriptInfo_Version = $null
                }
            }
        }
        else {
            # no external script found, try function

            $frmScript = $arr | Where-Object { ($null -ne $_) -and ($null -ne $_.InvocationInfo) `
                                        -and ($null -ne $_.InvocationInfo.MyCommand) `
                                        -and ($_.InvocationInfo.MyCommand.CommandType -eq [System.Management.Automation.CommandTypes]::Function) } `
                                | Select-Object -Last 1 | Select-Object -ExpandProperty InvocationInfo

            if($null -ne $frmScript) {
                # we found function info

                if($frmScript.MyCommand.Source -eq "TUN.Logging" -and $frmScript.MyCommand.ModuleName -eq "TUN.Logging") {
                    $script:ScriptInfo_File = "console"
                    $script:ScriptInfo_Name = "console"
                    $script:ScriptInfo_Path = "console"
                    $script:ScriptInfo_Call = $frmScript.MyCommand.Name
                    $script:ScriptInfo_Version = $null
                }
                else {
                    $script:ScriptInfo_Name = Coalesce -IfNull (Coalesce -IfNull ($frmScript.MyCommand.Name) -InsteadOfNull ([System.IO.Path]::GetFileNameWithoutExtension($frmScript.MyCommand.ScriptBlock.File))) -InsteadOfNull "unknown"
                    $script:ScriptInfo_File = Coalesce -IfNull (Coalesce -IfNull ($frmScript.MyCommand.ScriptBlock.File) -InsteadOfNull ($script:ScriptInfo_Name)) -InsteadOfNull "unknown"
                    $script:ScriptInfo_Path = Coalesce -IfNull (Coalesce -IfNull ($frmScript.MyCommand.ScriptBlock.File) -InsteadOfNull ($script:ScriptInfo_Name)) -InsteadOfNull "unknown"
                    $script:ScriptInfo_Call = Coalesce -IfNull ($frmScript.Line) -InsteadOfNull "unknown"

                    if([bool]($frmScript.MyCommand.PSobject.Properties.name) -match "Version") {
                        $script:ScriptInfo_Version = $frmScript.MyCommand.Version
                    }
                    else {
                        $script:ScriptInfo_Version = $null
                    }
                }
            }
            else {
                # no function found, try script (script block)
                $frmScript = $arr | Where-Object { ($null -ne $_) -and ($null -ne $_.InvocationInfo) `
                                        -and ($null -ne $_.InvocationInfo.MyCommand) `
                                        -and ($_.InvocationInfo.MyCommand.CommandType -eq [System.Management.Automation.CommandTypes]::Script) } `
                                | Select-Object -Last 1 | Select-Object -ExpandProperty InvocationInfo

                if($null -ne $frmScript) {

                    # we found script (script block) info
                    if($frmScript.MyCommand.Source -eq "TUN.Logging" -and $frmScript.MyCommand.ModuleName -eq "TUN.Logging") {
                        $script:ScriptInfo_File = "console"
                        $script:ScriptInfo_Name = "console"
                        $script:ScriptInfo_Path = "console"
                        $script:ScriptInfo_Call = $frmScript.MyCommand.Name
                        $script:ScriptInfo_Version = $null
                    }
                    else {
                        $script:ScriptInfo_Name = Coalesce -IfNull ($frmScript.MyCommand.Definition) -InsteadOfNull "unknown"
                        $script:ScriptInfo_File = Coalesce -IfNull ($frmScript.MyCommand.Definition) -InsteadOfNull "unknown"
                        $script:ScriptInfo_Path = Coalesce -IfNull ($frmScript.MyCommand.Definition) -InsteadOfNull "unknown"
                        $script:ScriptInfo_Call = Coalesce -IfNull ($frmScript.MyCommand.Definition) -InsteadOfNull "unknown"

                        if([bool]($frmScript.MyCommand.PSobject.Properties.name) -match "Version") {
                            $script:ScriptInfo_Version = $frmScript.MyCommand.Version
                        }
                        else {
                            $script:ScriptInfo_Version = $null
                        }
                    }
                }
                else {
                    # we found nada
                    $script:ScriptInfo_Name="unknown"
                    $script:ScriptInfo_File="unknown"
                    $script:ScriptInfo_Path="unknown"
                    $script:ScriptInfo_Call="unknown"
                    $script:ScriptInfo_Version = $null
                }
            }
        }

        $script:ScriptInfo_Retrieved = $true
    }
}

function Get-ConsoleForegroundColor {
<#
    .SYNOPSIS
        Gets current console foreground color,
        or its fallback color if the console
        color could not be determined
    .OUTPUTS
        Foreground color for console as type [ConsoleColor]
#>

    try {
        $Color = $Host.UI.RawUI.ForegroundColor
        if([System.Enum]::IsDefined([System.ConsoleColor] , $Color)) {
            [ConsoleColor] $RetVal = [ConsoleColor]$Color

            return [ConsoleColor] $RetVal
        }
        else {
            return [ConsoleColor] $script:LogPreference_FallbackForegroundColor
        }
    }
    catch {
        return [ConsoleColor] $script:LogPreference_FallbackForegroundColor
    }
}

function Get-ConsoleBackgroundColor {
<#
    .SYNOPSIS
        Gets current console background color,
        or its fallback color if the console
        color could not be determined
    .OUTPUTS
        Background color for console as type [ConsoleColor]
#>

    try {
        $Color = $Host.UI.RawUI.BackgroundColor
        if([System.Enum]::IsDefined([System.ConsoleColor] , $Color)) {
            [ConsoleColor] $RetVal = [ConsoleColor]$Color

            return [ConsoleColor] $RetVal
        }
        else {
            return [ConsoleColor] $script:LogPreference_FallbackBackgroundColor
        }
    }
    catch {
        return [ConsoleColor] $script:LogPreference_FallbackBackgroundColor
    }
}

function Get-ScriptPath {
<#
    .SYNOPSIS
        Retrieves path of executing main script (if this hasn't happened yet) and returns it
    .OUTPUTS
        Path of executing main script
#>

    RetrieveScriptInfo
    return $script:ScriptInfo_Path
}

function Get-ScriptFile {
<#
    .SYNOPSIS
        Retrieves the filename of the executing main script (if this hasn't happened yet) and returns it
    .OUTPUTS
        Filename without extension of the executing main script
#>

    RetrieveScriptInfo
    return $script:ScriptInfo_File
}

function Get-ScriptName {
<#
    .SYNOPSIS
        Retrieves the filename without extension of the executing main script (if this hasn't happened yet) and returns it
    .OUTPUTS
        Filename without extension of executing main script
#>

    RetrieveScriptInfo
    return $script:ScriptInfo_Name
}

function Get-ScriptCall {
<#
    .SYNOPSIS
        Retrieves the line with which the executing main script was called (if this hasn't happened yet) and returns it
    .OUTPUTS
        The line with which the executing main script was called
#>

    RetrieveScriptInfo
    return $script:ScriptInfo_Call
}

function Get-ScriptVersion {
<#
    .SYNOPSIS
        Retrieves the version of the executing main script (if this hasn't happened yet) and returns it
    .OUTPUTS
        Version of executing main script
#>

    RetrieveScriptInfo
    return $script:ScriptInfo_Version
}

function Get-ScriptUser {
<#
    .SYNOPSIS
        Retrieves the user context (if this hasn't happened yet) and returns it
    .OUTPUTS
        Name of current user during log start
#>

    RetrieveScriptInfo
    return $script:ScriptInfo_CurrentUser
}

function Get-ScriptMachine {
<#
    .SYNOPSIS
        Retrieves the machine name (if this hasn't happened yet) and returns it
    .OUTPUTS
        Machine name during log start
#>

    RetrieveScriptInfo
    return $script:ScriptInfo_ComputerName
}

function Get-TUNLoggingVersion {
<#
    .SYNOPSIS
        Returns version of current TUN.Logging module
    .PARAMETER AsString
        True/Present...will return a version string
        False/Absent...will return a version object
    .OUTPUTS
        Version of TUN.Logging module
#>

    [CmdletBinding()]
    PARAM (
        [Parameter(Position=0)]
        [switch] $AsString
    )

    $Version = $MyInvocation.MyCommand.Module.Version

    if($null -ne $Version) {
        if($AsString.IsPresent) {
            return $Version.ToString()
        }
        else {
            return $Version
        }    
    }
    else {
        return $null
    }
}

function Test-VerboseOutput {
<#
    .SYNOPSIS
        Tests if verbose messages are displayed according to the $VerbosePreference environment variable
    .OUTPUTS
        True...Verbose messages are displayed
        False...Verbose messages are not displayed
#>

    [CmdletBinding()]
    PARAM (
    )

    return $VerbosePreference -ne [System.Management.Automation.ActionPreference]::SilentlyContinue    
}

function Test-DebugOutput {
<#
    .SYNOPSIS
        Tests if debug messages are displayed according to the $DebugPreference environment variable
    .OUTPUTS
        True...Debug messages are displayed
        False...Debug messages are not displayed
#>

    [CmdletBinding()]
    PARAM (
    )

    return $DebugPreference -ne [System.Management.Automation.ActionPreference]::SilentlyContinue    
}

function Test-InformationOutput {
<#
    .SYNOPSIS
        Tests if information messages are displayed according to the $InformationPreference environment variable
    .OUTPUTS
        True...Information messages are displayed
        False...Information messages are not displayed
#>

    [CmdletBinding()]
    PARAM (
    )

    return $InformationPreference -ne [System.Management.Automation.ActionPreference]::SilentlyContinue    
}

function Test-WarningOutput {
<#
    .SYNOPSIS
        Tests if warning messages are displayed according to the $WarningPreference environment variable
    .OUTPUTS
        True...Warning messages are displayed
        False...Warning messages are not displayed
#>

    [CmdletBinding()]
    PARAM (
    )

    return $WarningPreference -ne [System.Management.Automation.ActionPreference]::SilentlyContinue    
}

function Test-CmdletSupport {
<#
    .SYNOPSIS
        Tests for support of cmdlets, and stores them in the $script:CmdletSupport_ variables
        (currently checks only for NoNewline parameter in Add-Content)
    .OUTPUTS
        None, stores the results in the $script:CmdletSupport_ variables
#>

[CmdletBinding()]
PARAM (
)

    $CmdLet = Get-Command "Add-Content" -ErrorAction SilentlyContinue
    if($null -ne $CmdLet) {
        $script:CmdletSupport_AddContent_NoNewline = $CmdLet.Parameters.ContainsKey("NoNewline")
    }
}

function Add-Timestamp {
<#
    .SYNOPSIS
        Adds a current timestamp to the beginning of each line of a string/message
    .NOTES
        Can recieve message string through pipe
    .PARAMETER Message
        The string/message to which a timestamp should be added to the beginning of each line
    .OUTPUTS
        The provided string/message with a current timestamp added at the beginning of each line
#>

[CmdletBinding()]
    PARAM (
        [Parameter(Position=0, Mandatory, ValueFromPipeline)]
        [object] $Message
    )

    $TimeStamp = "$((Get-Date).ToUniversalTime().ToString("yyyy-MM-dd\THH:mm:ss"))Z: "
    return $TimeStamp + (($Message -Split "`n", 0, "SimpleMatch") -Join "`n$TimeStamp")
}

function Write-MailLog {
<#
    .SYNOPSIS
        Writes a line to the mail log according to the rules set during the Start-MailLog call
    .NOTES
        Can recieve message string through pipe
    .PARAMETER Message
        String/message that should be written to the mail log
    .PARAMETER NoNewline
        Same as NoNewline switch in Write-Host cmdlet
    .PARAMETER NoMail
        True/Present...This function will not do nothing and not add a line to the mail log
    .PARAMETER IsError
        True/Present...The message is of the type error message
    .PARAMETER IsHost
        True/Present...The message is of the type host message
    .PARAMETER IsOutput
        True/Present...The message is of the type output message
    .PARAMETER IsVerbose
        True/Present...The message is of the type verbose message
    .PARAMETER IsWarning
        True/Present...The message is of the type warning message
    .PARAMETER IsDebug
        True/Present...The message is of the type debug message
    .PARAMETER IsInformation
        True/Present...The message is of the type information message
    .PARAMETER AddTimestamp
        True/Present...A timestamp will be added to the beginning of each line of the message
    .PARAMETER Force
        True/Present...The message will be written to the mail log regardless of the rules set during the Start-MailLog call
#>

    [CmdletBinding()]
    PARAM (
        [Parameter(Position=0, ValueFromPipeline)]
        [string] $Message = "",
        [switch] $NoNewline,
        [switch] $NoMail,
        [switch] $IsError,
        [switch] $IsHost,
        [switch] $IsOutput,
        [switch] $IsVerbose,
        [switch] $IsWarning,
        [switch] $IsDebug,
        [switch] $IsInformation,
        [switch] $AddTimestamp,
        [switch] $Force
    )

    if(!$NoMail.IsPresent -and $script:LogMailRunning) {
        $blWriteMail = $false

        if($IsError.IsPresent) {
            if($Force.IsPresent -or $script:LogPreference_MailError -ne $false) {
                $Message = "ERROR: " + $Message
                $script:ErrorMailCount++
                $blWriteMail = $true
            }
        }
        if($IsHost.IsPresent) {
            if($Force.IsPresent -or $script:LogPreference_MailHost -ne $false) {
                $script:HostMailCount++
                $blWriteMail = $true
            }
        }
        if($IsOutput.IsPresent) {
            if($Force.IsPresent -or $script:LogPreference_MailOutput -ne $false) {
                $script:OutputMailCount++
                $blWriteMail = $true
            }
        }
        if($IsVerbose.IsPresent) {
            if($Force.IsPresent -or `
                    ($script:LogPreference_MailVerbose -eq $true -or `
                        ($script:LogPreference_MailVerbose -ne $false `
                            -and ((Test-VerboseOutput) -or !$script:LogPreference_MailAsOutput)
                        )
                    )
                ) {
                $Message = "VERBOSE: " + $Message
                $script:VerboseMailCount++
                $blWriteMail = $true
            }
        }
        if($IsWarning.IsPresent) {
            if($Force.IsPresent -or `
                    ($script:LogPreference_MailWarning -eq $true -or `
                        ($script:LogPreference_MailWarning -ne $false `
                            -and ((Test-WarningOutput) -or !$script:LogPreference_MailAsOutput)
                        )
                    )
                ) {
                $Message = "WARNING: " + $Message
                $script:WarningMailCount++
                $blWriteMail = $true
            }
        }
        if($IsDebug.IsPresent) {
            if($Force.IsPresent -or `
                    ($script:LogPreference_MailDebug -eq $true -or `
                        ($script:LogPreference_MailDebug -ne $false `
                            -and ((Test-DebugOutput) -or !$script:LogPreference_MailAsOutput)
                        )
                    )
                ) {
                $Message = "DEBUG: " + $Message
                $script:DebugMailCount++
                $blWriteMail = $true
            }
        }
        if($IsInformation.IsPresent) {
            if($Force.IsPresent -or `
                    ($script:LogPreference_MailInformation -eq $true -or `
                        ($script:LogPreference_MailInformation -ne $false `
                            -and ((Test-InformationOutput) -or !$script:LogPreference_MailAsOutput)
                        )
                    )
                ) {
                $Message = "INFO: " + $Message
                $script:InformationMailCount++
                $blWriteMail = $true
            }
        }

        # if no switch is present, add to mail anyway
        if(!($IsError.IsPresent -or $IsHost.IsPresent -or $IsOutput.IsPresent -or $IsVerbose.IsPresent `
                -or $IsWarning.IsPresent -or $IsDebug.IsPresent -or $IsInformation.IsPresent)) {
            $blWriteMail = $true
        }

        if($blWriteMail) {
            if($AddTimestamp.IsPresent) {
                $Message = $Message | Add-Timestamp
            }
            $script:LogMailText += "$Message"
            if(!$NoNewline.IsPresent) {
                $script:LogMailText += "`r`n"
            }
        }
    }
}
    
function Write-Log {
<#
    .SYNOPSIS
        Writes a line to the file log according to the rules set during the Start-Log call
    .NOTES
        Can recieve message string through pipe
    .PARAMETER Message
        String/message that should be written to the file log
    .PARAMETER NoNewline
        Same as NoNewline switch in Write-Host cmdlet
    .PARAMETER NoLog
        True/Present...This function will not do nothing and not add a line to the file log
    .PARAMETER IsError
        True/Present...The message is of the type error message
    .PARAMETER IsHost
        True/Present...The message is of the type host message
    .PARAMETER IsOutput
        True/Present...The message is of the type output message
    .PARAMETER IsVerbose
        True/Present...The message is of the type verbose message
    .PARAMETER IsWarning
        True/Present...The message is of the type warning message
    .PARAMETER IsDebug
        True/Present...The message is of the type debug message
    .PARAMETER IsInformation
        True/Present...The message is of the type information message
    .PARAMETER AddTimestamp
        True/Present...A timestamp will be added to the beginning of each line of the message
    .PARAMETER Force
        True/Present...The message will be written to the file log regardless of the rules set during the Start-Log call
#>

    [CmdletBinding(SupportsShouldProcess=$true)]
    PARAM (
        [Parameter(Position=0, ValueFromPipeline)]
        [string] $Message = "",
        [switch] $NoNewline,
        [switch] $NoLog,
        [switch] $IsError,
        [switch] $IsHost,
        [switch] $IsOutput,
        [switch] $IsVerbose,
        [switch] $IsWarning,
        [switch] $IsDebug,
        [switch] $IsInformation,
        [switch] $AddTimestamp,
        [switch] $Force
    )

    if(!$NoLog.IsPresent -and $script:LogRunning) {
        $blWriteLog = $false

        if($IsError.IsPresent) {
            if($Force.IsPresent -or $script:LogPreference_LogError -ne $false) {
                $Message = "ERROR: " + $Message
                $script:ErrorLogCount++
                $blWriteLog = $true
            }
        }
        if($IsHost.IsPresent) {
            if($Force.IsPresent -or $script:LogPreference_LogHost -ne $false) {
                $script:HostLogCount++
                $blWriteLog = $true
            }
        }
        if($IsOutput.IsPresent) {
            if($Force.IsPresent -or $script:LogPreference_LogOutput -ne $false) {
                $script:OutputLogCount++
                $blWriteLog = $true
            }
        }
        if($IsVerbose.IsPresent) {
            if($Force.IsPresent -or `
                    ($script:LogPreference_LogVerbose -eq $true -or `
                        ($script:LogPreference_LogVerbose -ne $false `
                            -and ((Test-VerboseOutput) -or !$script:LogPreference_AsOutput)
                        )
                    )
                ) {
                $Message = "VERBOSE: " + $Message
                $script:VerboseLogCount++
                $blWriteLog = $true
            }
        }
        if($IsWarning.IsPresent) {
            if($Force.IsPresent -or `
                    ($script:LogPreference_LogWarning -eq $true -or `
                        ($script:LogPreference_LogWarning -ne $false `
                            -and ((Test-WarningOutput) -or !$script:LogPreference_AsOutput)
                        )
                    )
                ) {
                $Message = "WARNING: " + $Message
                $script:WarningLogCount++
                $blWriteLog = $true
            }
        }
        if($IsDebug.IsPresent) {
            if($Force.IsPresent -or `
                    ($script:LogPreference_LogDebug -eq $true -or `
                        ($script:LogPreference_LogDebug -ne $false `
                            -and ((Test-DebugOutput) -or !$script:LogPreference_AsOutput)
                        )
                    )
                ) {
                $Message = "DEBUG: " + $Message
                $script:DebugLogCount++
                $blWriteLog = $true
            }
        }
        if($IsInformation.IsPresent) {
            if($Force.IsPresent -or `
                    ($script:LogPreference_LogInformation -eq $true -or `
                        ($script:LogPreference_LogInformation -ne $false `
                            -and ((Test-InformationOutput) -or !$script:LogPreference_AsOutput)
                        )
                    )
                ) {
                $Message = "INFO: " + $Message
                $script:InformationLogCount++
                $blWriteLog = $true
            }
        }

        # if no switch is present, log anyway
        if(!($IsError.IsPresent -or $IsHost.IsPresent -or $IsOutput.IsPresent -or $IsVerbose.IsPresent `
                -or $IsWarning.IsPresent -or $IsDebug.IsPresent -or $IsInformation.IsPresent)) {
            $blWriteLog = $true
        }

        if(!$script:WhatIfLog -and $blWriteLog) {
            if($AddTimestamp.IsPresent -or !$script:LogPreference_NoTimestamp) {
                $Message = $Message | Add-Timestamp
            }
            if($script:CmdletSupport_AddContent_NoNewline) {
                Add-Content -Path $script:LogFile -Value $Message -NoNewline:$NoNewline
            }
            else {
                Add-Content -Path $script:LogFile -Value $Message
            }
        }
    }
}
    
function Start-MailLog {
<#
    .SYNOPSIS
        Starts logging process for mail log.
    .DESCRIPTION
        Once this function has been called, the Write-ErrorLog etc. functions will add lines to a mail text
        that can later on be sent by mail with the Send-Log command.
    .NOTES
        If the credentials file cannot be found, it will ask the user for the credentials and stores it in
        the credential file. For first use or to change the credentials, use the -InitCredentials switch, which will force storing new credentials
        and exits the script immediately after saving the credentials without executing the rest of the script. This is because the -WhatIf switch 
        cannot be used to make sure the script is not performing its task, because it will also prevent the script from saving the credentials to 
        the credentials file.
    .PARAMETER CredentialsFile
        File to store mailing credentials in and read mailing credentials from (for access to the smtp server).
        Information will be stored in the XML file format.
        If no path for a credentials file was provided, the credentials of the script execution will be used to connect to the smtp server.
    .PARAMETER LogPreference_MailError
        True....Will add error messages to the log mail text (no matter if they are displayed or logged in the file log)
        False...Will not add error messages to the log mail text (no matter if they are displayed or logged in the file log)
        null or not specified...The adding of error messages depends on the AsOutput switch. If the AsOutput switch is present,
                then error messages will only be added if they are displayed, if the AsOutput switch is absent, they will
                always be added.
    .PARAMETER LogPreference_MailHost
        True....Will add host messages to the log mail text (no matter if they are displayed or logged in the file log)
        False...Will not add host messages to the log mail text (no matter if they are displayed or logged in the file log)
        null or not specified...The adding of host messages depends on the AsOutput switch. If the AsOutput switch is present,
                then host messages will only be added if they are displayed, if the AsOutput switch is absent, they will
                always be added.
    .PARAMETER LogPreference_MailOutput
        True....Will add output messages to the log mail text (no matter if they are displayed or logged in the file log)
        False...Will not add output messages to the log mail text (no matter if they are displayed or logged in the file log)
        null or not specified...The adding of output messages depends on the AsOutput switch. If the AsOutput switch is present,
                then output messages will only be added if they are displayed, if the AsOutput switch is absent, they will
                always be added.
    .PARAMETER LogPreference_MailVerbose
        True....Will add verbose messages to the log mail text (no matter if they are displayed or logged in the file log)
        False...Will not add verbose messages to the log mail text (no matter if they are displayed or logged in the file log)
        null or not specified...The adding of verbose messages depends on the AsOutput switch. If the AsOutput switch is present,
                then verbose messages will only be added if they are displayed, if the AsOutput switch is absent, they will
                always be added.
    .PARAMETER LogPreference_MailWarning
        True....Will add warning messages to the log mail text (no matter if they are displayed or logged in the file log)
        False...Will not add warning messages to the log mail text (no matter if they are displayed or logged in the file log)
        null or not specified...The adding of warning messages depends on the AsOutput switch. If the AsOutput switch is present,
                then warning messages will only be added if they are displayed, if the AsOutput switch is absent, they will
                always be added.
    .PARAMETER LogPreference_MailDebug
        True....Will add debug messages to the log mail text (no matter if they are displayed or logged in the file log)
        False...Will not add debug messages to the log mail text (no matter if they are displayed or logged in the file log)
        null or not specified...The adding of debug messages depends on the AsOutput switch. If the AsOutput switch is present,
                then debug messages will only be added if they are displayed, if the AsOutput switch is absent, they will
                always be added.
    .PARAMETER LogPreference_MailInformation
        True....Will add information messages to the log mail text (no matter if they are displayed or logged in the file log)
        False...Will not add information messages to the log mail text (no matter if they are displayed or logged in the file log)
        null or not specified...The adding of information messages depends on the AsOutput switch. If the AsOutput switch is present,
                then information messages will only be added if they are displayed, if the AsOutput switch is absent, they will
                always be added.
    .PARAMETER LogPreference_FallbackForegroundColor
        The fallback foreground color for the console if none was provided and the current foreground color could not be determined from the console.
        The default is Gray.
    .PARAMETER LogPreference_FallbackBackgroundColor
        The fallback background color for the console if none was provided and the current background color could not be determined from the console.
        The default is Black.
    .PARAMETER AsOutput
        True/Present...For all message types for which no LogPreference was set (or for which the LogPreference is null) the 
                        message will only be added if it is displayed to the user (or would be displayed to the user if
                        it is an automatic script) according to its environment variable.
        False/Absent...For all message types for which no LogPreference was set (or for which the LogPreference is null) the 
                        message will always be added regardless if it is displayed to the user (or would be displayed to the 
                        user if it is an automatic script) according to its environment variable.
    .PARAMETER InitCredentials
        True/Present...The script will ask for the credentials to use for mail sending, store them in the credentials file and will then immediatly exit the script.
                        Used to either set up credentials file for the first time, or change/renew the credentials in the credential file, without performing the 
                        actual task by the script. The -WhatIf switch cannot be used to make sure the script is not performing its task, because it will also prevent
                        the script from saving the credentials to the credentials file.
                        This switch is ignored if the CredentialsFile parameter is not provided.
    .PARAMETER Force
        True/Present...Will log regardless of -WhatIf switch of calling script
        False/Absent...Will only log if -WhatIf switch is not present in calling script
    .OUTPUTS
        None
    .EXAMPLE
        # Initialize the log mail sending credentials, used to access the smtp server.
        # The -InitCredentials switch will prompt for credentials, save them in the "C:\MyCredentials.cfg" file and will then immediately exit the script.
        Start-MailLog -InitCredentials -CredentialsFile "C:\MyCredentials.cfg"
    .EXAMPLE
        # Start the mail logging, write everything to the mail that's also written to the console and use the credentials stored in the "C:\MyCredentials.cfg" file to authenticate yourself at the smtp server when sending the mail.
        Start-MailLog -AsOutput -CredentialsFile "C:\MyCredentials.cfg"
#>

    [CmdletBinding(SupportsShouldProcess=$true)]
    PARAM(
        [Parameter(Position=0)]
        [string] $CredentialsFile,
        [Parameter(Position=1)]
        [Nullable[bool]] $LogPreference_MailError,
        [Parameter(Position=2)]
        [Nullable[bool]] $LogPreference_MailHost,
        [Parameter(Position=3)]
        [Nullable[bool]] $LogPreference_MailOutput,
        [Parameter(Position=4)]
        [Nullable[bool]] $LogPreference_MailVerbose,
        [Parameter(Position=5)]
        [Nullable[bool]] $LogPreference_MailWarning,
        [Parameter(Position=6)]
        [Nullable[bool]] $LogPreference_MailDebug,
        [Parameter(Position=7)]
        [Nullable[bool]] $LogPreference_MailInformation,
        [Parameter(Position=8)]
        [ConsoleColor] $LogPreference_FallbackForegroundColor = [ConsoleColor]::Gray,
        [Parameter(Position=9)]
        [ConsoleColor] $LogPreference_FallbackBackgroundColor = [ConsoleColor]::Black,
        [switch] $AsOutput,
        [switch] $InitCredentials,
        [switch] $Force
    )

    #Initialize preference variables
    Initialize-PreferenceVariables -Cmdlet $PSCmdlet -OmitWhatIf:$Force

    Use-PSCredential -File $CredentialsFile -Usage "log mailing" -Message "Please enter credentials for log mailing" `
                        -Init:$InitCredentials -NoUnstored -ErrorOnNone

    $script:LogMailCredentialFile = $CredentialsFile
    $script:LogMailText = ""
    $script:LogMailRunning = $true
    $script:LogPreference_MailAsOutput = $AsOutput.IsPresent

    $script:LogPreference_MailError = $LogPreference_MailError
    $script:LogPreference_MailHost = $LogPreference_MailHost
    $script:LogPreference_MailOutput = $LogPreference_MailOutput
    $script:LogPreference_MailVerbose = $LogPreference_MailVerbose
    $script:LogPreference_MailWarning = $LogPreference_MailWarning
    $script:LogPreference_MailDebug = $LogPreference_MailDebug
    $script:LogPreference_MailInformation = $LogPreference_MailInformation
    $script:LogPreference_FallbackForegroundColor = $LogPreference_FallbackForegroundColor
    $script:LogPreference_FallbackBackgroundColor = $LogPreference_FallbackBackgroundColor

    $script:ForceLogSend = $false
    $script:ForceLogReason = ""

    $UserName = Get-ScriptUser

    $UTCDateTime = (Get-Date).ToUniversalTime()
    Write-MailLog -Message "***************************************************************************************************"
    Write-MailLog -Message "`tPowerShell Version $($PSVersionTable.PSVersion.ToString())"
    Write-MailLog -Message "`tLogging by module $($MyInvocation.MyCommand.Module.Name) Version $((Get-TUNLoggingVersion -AsString))"
    if($UserName) {
        Write-MailLog -Message "`tUser at start of logging: ""$UserName"""
    }
    Write-MailLog -Message "`tStarted script ""$(Get-ScriptPath)"""
    Write-MailLog -Message "`tCalling command ""$(Get-ScriptCall)"""
    
    if(Get-ScriptVersion) {
        Write-MailLog -Message "`t`tversion ""$(Get-ScriptVersion)"""
    }
    Write-MailLog -Message "`t`tat $($UTCDateTime.ToString("yyyy-MM-dd HH:mm:ss"))Z"
    Write-MailLog -Message "***************************************************************************************************"
    Write-MailLog -Message "`tStarting..."
    Write-MailLog -Message "***************************************************************************************************"
    Write-MailLog -Message ""
}

function Send-Log {
<#
    .SYNOPSIS
        Stops logging process for mail log and sends the mail log text as a text mail.
        Optionally attaches the file log as attachment.
    .NOTES
        Once this function has been called, the Write-ErrorLog etc. functions will not add any more lines to the mail log.
    .PARAMETER From
        The from email address.
    .PARAMETER To
        The to email address. Can be one or more email addresses to which the email will be sent.
    .PARAMETER SmtpServer
        The SMTP server to use for sending the email.
        If this parameter is not provided, the default SMTP server as defined in $PSEmailServer will be used.
    .PARAMETER Subject
        The beginning of the subject line of the email. Will interpret $(COMPUTERNAME) and $(SCRIPTNAME) as variables.
        If not provided, will use "Notification from $(COMPUTERNAME)/$(SCRIPTNAME)" as default.
        The reason for the E-Mail sending will be added to the end of the subject line (sepearted by a comma).
    .PARAMETER UseSsl
        True/Present...Will use Ssl to connect to the smtp server
    .PARAMETER AlwaysSend
        True/Present...Will always send the email, no matter what exactly was logged.
    .PARAMETER SendOnError
        True/Present...Will send the email if an error occured and was logged in the mail text.
    .PARAMETER SendOnHost
        True/Present...Will send the email if an error occured and was logged in the mail text.
    .PARAMETER SendOnOutput
        True/Present...Will send the email if an error occured and was logged in the mail text.
    .PARAMETER SendOnVerbose
        True/Present...Will send the email if an error occured and was logged in the mail text.
    .PARAMETER SendOnWarning
        True/Present...Will send the email if an error occured and was logged in the mail text.
    .PARAMETER SendOnDebug
        True/Present...Will send the email if an error occured and was logged in the mail text.
    .PARAMETER SendOnInformation
        True/Present...Will send the email if an error occured and was logged in the mail text.
    .PARAMETER AttachLogfile
        True/Present...Will attach the log file to the log mail if file logging was enabled.
    .OUTPUTS
        None
    .EXAMPLE
        # Send a log mail if any errors or warnings occured. 
        # Send from the address "from.address@yourdomain.com" and smtp server "smtp.yourdomain.com", use a ssl connection and attach the logfile to the mail.
        Send-Log -SendOnWarning -SendOnError -From "from.address@yourdomain.com" -To "your.mail@yourdomain.com" -UseSsl -SmtpServer "smtp.yourdomain.com" -AttachLogfile
#>
    [CmdletBinding(SupportsShouldProcess=$true)]
    PARAM (
        [Parameter(Position=0, Mandatory=$true)]
        [string] $From,
        [Parameter(Position=1, Mandatory=$true)]
        [string[]] $To,
        [Parameter(Position=2)]
        [string] $SmtpServer=$PSEmailServer,
        [Parameter(Position=3)]
        [string] $Subject,
        [switch] $UseSsl,
        [switch] $AlwaysSend,
        [switch] $SendOnError,
        [switch] $SendOnHost,
        [switch] $SendOnOutput,
        [switch] $SendOnVerbose,
        [switch] $SendOnWarning,
        [switch] $SendOnDebug,
        [switch] $SendOnInformation,
        [switch] $AttachLogfile
    )
    
    try {
            
        if($script:LogMailRunning -and $script:LogMailText) {
            $strSendReason = ""
            $blSendMail = $true

            if(($AlwaysSend -or $SendOnError) -and $script:ErrorMailCount -gt 0) {
                $strSendReason = "ERROR count: $script:ErrorMailCount"
            }
            elseIf(($AlwaysSend -or $SendOnWarning) -and $script:WarningMailCount -gt 0) {
                $strSendReason = "Warning count: $script:WarningMailCount"
            }
            elseIf($script:ForceLogSend) {
                if($script:ForceLogReason) {
                    $strSendReason = $script:ForceLogReason
                }
                else {
                    $strSendReason = "forced"
                }
            }
            elseIf($SendOnHost -and $script:HostMailCount -gt 0) {
                $strSendReason = "Host-Output"
            }
            elseIf($SendOnOutput -and $script:OutputMailCount -gt 0) {
                $strSendReason = "Output"
            }
            elseIf($SendOnInformation -and $script:InformationMailCount -gt 0) {
                $strSendReason = "Information-Output"
            }
            elseIf($SendOnVerbose -and $script:VerboseMailCount -gt 0) {
                $strSendReason = "Verbose-Output"
            }
            elseIf($SendOnDebug -and $script:DebugMailCount -gt 0) {
                $strSendReason = "Debug-Output"
            }
            elseIf($AlwaysSend) {
                $strSendReason = "Always send"
            }
            else {
                $blSendMail = $false
            }

            if($blSendMail) {
                if(!$Subject) {
                    $Subject = $("Notification from `$(COMPUTERNAME)/`$(SCRIPTNAME)")
                }
                $Subject = $Subject.Replace("`$(COMPUTERNAME)", (Get-ScriptMachine)).Replace("`$(SCRIPTNAME)", $(Get-ScriptName))
                $Subject += ", Reason: $strSendReason"

                $strTo = $To -Join ","
                Write-OutputLog -Message "---TRYING TO SEND LOG MAIL TO ""$strTo"", SUBJECT: $Subject---"

                $UTCDateTime = (Get-Date).ToUniversalTime()
                Write-MailLog -Message "***************************************************************************************************"
                Write-MailLog -Message "`t...ending!"
                Write-MailLog -Message "***************************************************************************************************"
                Write-MailLog -Message "`tEnded script ""$(Get-ScriptPath)"""
                if(Get-ScriptVersion) {
                    Write-MailLog -Message "`t`tversion ""$(Get-ScriptVersion)"""
                }
                Write-MailLog -Message "`t`tat $($UTCDateTime.ToString("yyyy-MM-dd HH:mm:ss"))"
                if($script:WarningLogCount -gt 0) {
                    Write-MailLog -Message "`t`t`tWarnings encountered: $script:WarningLogCount"
                }
                else {
                    Write-MailLog -Message "`t`t`tNo warnings encountered"
                }
                if($script:ErrorLogCount -gt 0) {
                    Write-MailLog -Message "`t`t`tERRORS encountered: $script:ErrorLogCount"
                }
                else {
                    Write-MailLog -Message "`t`t`tNo errors encountered"
                }
                Write-MailLog -Message "***************************************************************************************************"

                $SmtpClient = $null
                $MailMessage = $null
                $MailAttachment = $null

                try {
                    $SmtpClient = New-Object System.Net.Mail.SmtpClient
                    $MailMessage = New-Object System.Net.Mail.MailMessage

                    $SmtpClient.Host = $SmtpServer
                    $SmtpClient.EnableSsl = $UseSsl.IsPresent

                    $MailMessage.from = $From
                    $To | ForEach-Object { $mailmessage.To.add($_) }                        

                    $MailMessage.Subject = $Subject
                    $MailMessage.IsBodyHtml = $false
                    $MailMessage.Body = $script:LogMailText
                    $strUserName = "$([Environment]::UserDomainName)\$([Environment]::UserName)"

                    $Credentials = Use-NetworkCredential -File $script:LogMailCredentialFile -NoUnstored -ErrorOnNone
                    if($Credentials) {
                        $strUserName = $Credentials.UserName
                        $SmtpClient.Credentials = $Credentials
                    }

                    Write-OutputLog -Message "---SENDING LOG MAIL, USING USER ""$strUserName""---"

                    if($AttachLogfile.IsPresent -and (Test-Path $script:LogFile)) {
                        $FullPath = (Get-Item $script:LogFile).FullName
                        Write-OutputLog -Message "---ATTACHING LOG FILE ""$FullPath"" TO LOG MAIL---"
                        $MailAttachment = New-Object System.Net.Mail.Attachment($FullPath)
                        $MailMessage.Attachments.Add($MailAttachment)
                    }

                    $SmtpClient.Send($MailMessage)

                    # We need this because the smtp-client otherwise does not immediately free the lock to the attached file
                    if($MailAttachment) {
                        $MailAttachment.Dispose()
                    }

                    $MailMessage.Dispose()
                    $SmtpClient.Dispose()

                    $script:LogMailRunning = $false
                    $script:LogMailText = ""

                    Write-OutputLog -Message "---SUCCESFULLY SENT LOG MAIL---"
                }
                catch {
                    # We need this because the smtp-client otherwise does not immediately free the lock to the attached file
                    if($MailAttachment) {
                        $MailAttachment.Dispose()
                    }
                    if($MailMessage) {
                        $MailMessage.Dispose()
                    }
                    if($SmtpClient) {
                        $SmtpClient.Dispose()
                    }

                    $_ | Write-ErrorLog "---ERROR DURING LOG MAIL SENDING---"
                }
            }
            else {
                Write-OutputLog -Message "---NOT SENDING LOG MAIL, NO REASON---"
            }
        }
        else {
            Write-OutputLog -Message "---NOT SENDING LOG MAIL, EMPTY OR MAIL LOGGING NOT RUNNING---"
        }
    }
    catch {
        $_ | Write-ErrorLog -Message "---ERROR SENDING LOG MAIL---" -Force
    }
}
    
    

function Start-Log {
<#
    .SYNOPSIS
        Starts logging process for file log.
    .DESCRIPTION
        Once this function has been called, the Write-ErrorLog etc. functions will add lines to a log file.
    .PARAMETER LogPath
        Path to the logfile directory. 
        The default value is ".\" for the current working directory.
        Will interpret $(COMPUTERNAME) and $(SCRIPTNAME) as variables.
        If the path does not exist yet, it will try to create it.
    .PARAMETER LogName
        Name of the logfile, will be interpreted as a datetime format if NoDateTimeFormat switch is not set.
        Therefore, certain (or optionally all) letters will have to be escaped with a backslash if they should
        not be interpreted as a datetime format character.
        If this parameter is not provided, it will behave as if -UseDefaultName switch is set.
        Will interpret $(COMPUTERNAME) and $(SCRIPTNAME) as variables.
        If a file with this name (or its resulting datetime format name) does not exist yet, it will try to create it.
        If a file with this name (or its resulting datetime format name) already exists, it will by default append
        the log messages at the end of the log file, or delete it if the switch DeleteExisting is present.
    .PARAMETER LogExtension
        Extension of the logfile
        The default value is "log" if not specified otherwise.
    .PARAMETER LogPreference_LogError
        True....Will add error messages to the file log (no matter if they are displayed or logged in the mail log)
        False...Will not add error messages to the file log (no matter if they are displayed or logged in the mail log)
        null or not specified...The adding of error messages depends on the AsOutput switch. If the AsOutput switch is present,
                then error messages will only be added if they are displayed, if the AsOutput switch is absent, they will
                always be added.
    .PARAMETER LogPreference_LogHost
        True....Will add host messages to the file log (no matter if they are displayed or logged in the mail log)
        False...Will not add host messages to the file log (no matter if they are displayed or logged in the mail log)
        null or not specified...The adding of host messages depends on the AsOutput switch. If the AsOutput switch is present,
                then host messages will only be added if they are displayed, if the AsOutput switch is absent, they will
                always be added.
    .PARAMETER LogPreference_LogOutput
        True....Will add output messages to the file log (no matter if they are displayed or logged in the mail log)
        False...Will not add output messages to the file log (no matter if they are displayed or logged in the mail log)
        null or not specified...The adding of output messages depends on the AsOutput switch. If the AsOutput switch is present,
                then output messages will only be added if they are displayed, if the AsOutput switch is absent, they will
                always be added.
    .PARAMETER LogPreference_LogVerbose
        True....Will add verbose messages to the file log (no matter if they are displayed or logged in the mail log)
        False...Will not add verbose messages to the file log (no matter if they are displayed or logged in the mail log)
        null or not specified...The adding of verbose messages depends on the AsOutput switch. If the AsOutput switch is present,
                then verbose messages will only be added if they are displayed, if the AsOutput switch is absent, they will
                always be added.
    .PARAMETER LogPreference_LogWarning
        True....Will add warning messages to the file log (no matter if they are displayed or logged in the mail log)
        False...Will not add warning messages to the file log (no matter if they are displayed or logged in the mail log)
        null or not specified...The adding of warning messages depends on the AsOutput switch. If the AsOutput switch is present,
                then warning messages will only be added if they are displayed, if the AsOutput switch is absent, they will
                always be added.
    .PARAMETER LogPreference_LogDebug
        True....Will add debug messages to the file log (no matter if they are displayed or logged in the mail log)
        False...Will not add debug messages to the file log (no matter if they are displayed or logged in the mail log)
        null or not specified...The adding of debug messages depends on the AsOutput switch. If the AsOutput switch is present,
                then debug messages will only be added if they are displayed, if the AsOutput switch is absent, they will
                always be added.
    .PARAMETER LogPreference_LogInformation
        True....Will add information messages to the file log (no matter if they are displayed or logged in the mail log)
        False...Will not add information messages to the file log (no matter if they are displayed or logged in the mail log)
        null or not specified...The adding of information messages depends on the AsOutput switch. If the AsOutput switch is present,
                then information messages will only be added if they are displayed, if the AsOutput switch is absent, they will
                always be added.
    .PARAMETER LogPreference_FallbackForegroundColor
        The fallback foreground color for the console if none was provided and the current foreground color could not be determined from the console.
        The default is Gray.
    .PARAMETER LogPreference_FallbackBackgroundColor
        The fallback background color for the console if none was provided and the current background color could not be determined from the console.
        The default is Black.
    .PARAMETER NoTimestamp
        True/Present...Will not automatically add a timestamp to the beginning of each line in the log file.
                        If this switch is set, use the -AddTimestamp switch on individual log calls to add a timestamp if needed.
    .PARAMETER UseScriptPrefix
        True/Present...Will add the script name in front of the log file name, followed by an underscore.
    .PARAMETER UseComputerPrefix
        True/Present...Will add the computer name in front of the log file name, followed by an underscore (will also be in front of the script name if UseScriptPrefix switch is set too)
    .PARAMETER UseDefaultName
        True/Present...Will ignore LogName, UseScriptPrefix, UseComputerPrefix and NoDateTimeFormat
                        and use the following name for the logfile:
                        $(COMPUTERNAME)_$(SCRIPTNAME)_yyyy-MM-ddTHHmmss
    .PARAMETER NoDateTimeFormat
        True/Present...Will not interprete LogName as a datetime format (and no letters will have to be escaped with backslashes)
    .PARAMETER DeleteExisting
        True/Present...Deletes an existing log file if it already exists. Otherwise new log messages will be appended at the end of the log file.
    .PARAMETER AsOutput
        True/Present...For all message types for which no LogPreference was set (or for which the LogPreference is null) the 
                        message will only be added if it is displayed to the user (or would be displayed to the user if
                        it is an automatic script) according to its environment variable.
        False/Absent...For all message types for which no LogPreference was set (or for which the LogPreference is null) the 
                        message will always be added regardless if it is displayed to the user (or would be displayed to the 
                        user if it is an automatic script) according to its environment variable.
    .PARAMETER Force
        True/Present...Will log regardless of -WhatIf switch of calling script
        False/Absent...Will only log if -WhatIf switch is not present in calling script
    .OUTPUTS
        None
	.EXAMPLE
		# Will start logging and save logfile in current directory, with computer and script prefix as well as the current date all present in the filename:
		Start-Log -LogPath ".\" -UseComputerPrefix -UseScriptPrefix -LogName "yyyy-MM-dd"
#>
    [CmdletBinding(SupportsShouldProcess=$true)]
    PARAM(
        [Parameter(Position=0)]
        [string] $LogPath = ".\",
        [Parameter(Position=1)]
        [string] $LogName,
        [Parameter(Position=2)]
        [string] $LogExtension = "log",
        [Parameter(Position=3)]
        [Nullable[bool]] $LogPreference_LogError,
        [Parameter(Position=4)]
        [Nullable[bool]] $LogPreference_LogHost,
        [Parameter(Position=5)]
        [Nullable[bool]] $LogPreference_LogOutput,
        [Parameter(Position=6)]
        [Nullable[bool]] $LogPreference_LogVerbose,
        [Parameter(Position=7)]
        [Nullable[bool]] $LogPreference_LogWarning,
        [Parameter(Position=8)]
        [Nullable[bool]] $LogPreference_LogDebug,
        [Parameter(Position=9)]
        [Nullable[bool]] $LogPreference_LogInformation,
        [Parameter(Position=10)]
        [ConsoleColor] $LogPreference_FallbackForegroundColor = [ConsoleColor]::Gray,
        [Parameter(Position=11)]
        [ConsoleColor] $LogPreference_FallbackBackgroundColor = [ConsoleColor]::Black,
        [switch] $NoTimestamp,
        [switch] $UseComputerPrefix,
        [switch] $UseScriptPrefix,
        [switch] $UseDefaultName,
        [switch] $NoDateTimeFormat,
        [switch] $DeleteExisting,
        [switch] $AsOutput,
        [switch] $Force
    )

    #Test for cmdlet support (currently for NoNewline in Add-Content)
    Test-CmdletSupport

    #Initialize preference variables
    Initialize-PreferenceVariables -Cmdlet $PSCmdlet -OmitWhatIf:$Force
    
    if(!$LogName) {
        $UseDefaultName = $true
    }

    if($UseDefaultName.IsPresent) {
        $LogName = "yyyy-MM-dd\THHmmss"
    }

    $LogPath = $LogPath.Replace("`$(COMPUTERNAME)", (Get-ScriptMachine)).Replace("`$(SCRIPTNAME)", $(Get-ScriptName))

    if($UseScriptPrefix.IsPresent -or $UseDefaultName.IsPresent) {
        $LogName =  "`$(SCRIPTNAME)_" + $LogName
    }

    if($UseComputerPrefix.IsPresent -or $UseDefaultName.IsPresent) {
        $LogName =  "`$(COMPUTERNAME)_" + $LogName
    }

    $UTCDateTime = (Get-Date).ToUniversalTime()
    if(!$NoDateTimeFormat.IsPresent) {
        #we now make sure no variable name in LogName gets interpreted as a datetime format by excaping all letters with backslashes
        #(they'll be changed back to SCRIPTNAME and COMPUTERNAME by the datetime format function, so we later again have to
        #check for the string without backslashes)
        $LogName = $LogName.Replace("`$(SCRIPTNAME)", "`$(\S\C\R\I\P\T\N\A\M\E)")
        $LogName = $LogName.Replace("`$(COMPUTERNAME)", "`$(\C\O\M\P\U\T\E\R\N\A\M\E)")

        $LogName = $UTCDateTime.ToString($LogName)
    }

    #the datetime format function has removed all previously added escape backslashes from our variable names, so we can now replace the normal variable name with our values
    $LogName = $LogName.Replace("`$(COMPUTERNAME)", (Get-ScriptMachine)).Replace("`$(SCRIPTNAME)", $(Get-ScriptName))

    $LogName = $LogName + "." + $LogExtension

    if(!(Test-Path -Path $LogPath -IsValid)) {
        throw "Log-Error: Path ""$LogPath"" for logging directory is not valid!"
    }

    if(!(Test-Path -Path $LogPath)) {
        New-Item -ItemType Directory -Force -Path $LogPath | Out-Null
    }

    $script:LogFile = Join-Path $LogPath $LogName

    if(!(Test-Path -Path $script:LogFile -IsValid)) {
        throw "Log-Error: Path ""$script:LogFile"" for log file is not valid! LogName will be interpreted as a DateTime format if -NoDateTimeFormat switch is not set, make sure no colons are generated by escaping certain datetime format letters."
    }

    if($DeleteExisting.IsPresent -and (Test-Path -Path $script:LogFile)) {
        Remove-Item -Path $script:LogFile -Force
    }

    $UserName = Get-ScriptUser

    $script:WhatIfLog = !$PSCmdlet.ShouldProcess("$script:LogFile", "Logging")

    if(!$script:WhatIfLog -and $null -ne $script:LogFile) {
        Add-Content -Path $script:LogFile -Value "***************************************************************************************************"
        Add-Content -Path $script:LogFile -Value "`tPowerShell Version $($PSVersionTable.PSVersion.ToString())"
        Add-Content -Path $script:LogFile -Value "`tLogging by module $($MyInvocation.MyCommand.Module.Name) Version $((Get-TUNLoggingVersion -AsString))"
        if($UserName) {
            Add-Content -Path $script:LogFile -Value "`tUser at start of logging: ""$UserName"""
        }
        Add-Content -Path $script:LogFile -Value "`tStarted script ""$(Get-ScriptPath)"""
        Add-Content -Path $script:LogFile -Value "`tCalling command ""$(Get-ScriptCall)"""
        if(Get-ScriptVersion) {
            Add-Content -Path $script:LogFile -Value "`t`tversion ""$(Get-ScriptVersion)"""
        }
        Add-Content -Path $script:LogFile -Value "`t`tat $($UTCDateTime.ToString("yyyy-MM-dd HH:mm:ss"))Z"
        Add-Content -Path $script:LogFile -Value "***************************************************************************************************"
        Add-Content -Path $script:LogFile -Value "`tStarting..."
        Add-Content -Path $script:LogFile -Value "***************************************************************************************************"
        Add-Content -Path $script:LogFile -Value ""
    }

    $script:LogRunning = $true
    $script:LogPreference_AsOutput = $AsOutput.IsPresent

    $script:LogPreference_NoTimestamp = $NoTimestamp.IsPresent
    $script:LogPreference_LogError = $LogPreference_LogError
    $script:LogPreference_LogHost = $LogPreference_LogHost
    $script:LogPreference_LogOutput = $LogPreference_LogOutput
    $script:LogPreference_LogVerbose = $LogPreference_LogVerbose
    $script:LogPreference_LogWarning = $LogPreference_LogWarning
    $script:LogPreference_LogDebug = $LogPreference_LogDebug
    $script:LogPreference_LogInformation = $LogPreference_LogInformation
    $script:LogPreference_FallbackForegroundColor = $LogPreference_FallbackForegroundColor
    $script:LogPreference_FallbackBackgroundColor = $LogPreference_FallbackBackgroundColor

    $script:ErrorLogCount = 0
    $script:HostLogCount = 0
    $script:OutputLogCount = 0
    $script:VerboseLogCount = 0
    $script:WarningLogCount = 0
    $script:DebugLogCount = 0
    $script:InformationLogCount = 0
}

function Stop-Log {
<#
    .SYNOPSIS
        Stops logging process for log file.
    .NOTES
        Once this function has been called, the Write-ErrorLog etc. functions will not add any more lines to the file log.
    .OUTPUTS
        None
    .EXAMPLE
        # Stop the file logging and close the log file, this should be the last command in a script which uses logs.
        Stop-Log
#>

    [CmdletBinding(SupportsShouldProcess=$true)]
    PARAM (
    )

    $UTCDateTime = (Get-Date).ToUniversalTime()
    if(!$script:WhatIfLog -and $null -ne $script:LogFile) {
        Add-Content -Path $script:LogFile -Value "***************************************************************************************************"
        Add-Content -Path $script:LogFile -Value "`t...ending!"
        Add-Content -Path $script:LogFile -Value "***************************************************************************************************"
        Add-Content -Path $script:LogFile -Value "`tEnded script ""$(Get-ScriptPath)"""
        if(Get-ScriptVersion) {
            Add-Content -Path $script:LogFile -Value "`t`tversion ""$(Get-ScriptVersion)"""
        }
        Add-Content -Path $script:LogFile -Value "`t`tat $($UTCDateTime.ToString("yyyy-MM-dd HH:mm:ss"))"
        if($script:WarningLogCount -gt 0) {
            Add-Content -Path $script:LogFile -Value "`t`t`tWarnings encountered: $script:WarningLogCount"
        }
        else {
            Add-Content -Path $script:LogFile -Value "`t`t`tNo warnings encountered"
        }
        if($script:ErrorLogCount -gt 0) {
            Add-Content -Path $script:LogFile -Value "`t`t`tERRORS encountered: $script:ErrorLogCount"
        }
        else {
            Add-Content -Path $script:LogFile -Value "`t`t`tNo errors encountered"
        }
        Add-Content -Path $script:LogFile -Value "***************************************************************************************************"
    }

    $script:WhatIfLog = $false
    $script:LogRunning = $false
}

function Set-ForceLogSend {
<#
    .SYNOPSIS
        Sets a flag to trigger the sending of the log mail as soon as Send-Log is called (no matter what messages have been logged).
    .PARAMETER Reason
        The reason for force sending of mail log (will be added to subject line).
        If no reason is given here, "forced" will be given as reason in the subject line.
    .OUTPUTS
        None
    .EXAMPLE
        # This call will force a log mail to be sent, giving the reason "Simon said so" in the subject line.
        Set-ForceLogSend "Simon said so"
#>

    PARAM (
        [Parameter(Position=0)]
        [string] $Reason
    )

    $script:ForceLogSend = $true
    $script:ForceLogReason = $Reason
}

function Get-HasLogError {
<#
    .SYNOPSIS
        Determines if errors were logged to the log file (so far).
    .OUTPUTS
        True....There have been errors logged to the log file
        False...No errors have yet been logged to the log file
#>

    if($script:ErrorLogCount -gt 0) { return $true; } else { return $false; }
}
    
function Get-HasMailLogError {
<#
    .SYNOPSIS
        Determines if errors were logged to the mail log (so far).
    .OUTPUTS
        True....There have been errors logged to the mail log
        False...No errors have yet been logged to the mail log
    .EXAMPLE
        # Due to Get-HasMailLogError and Get-HasMailLogWarning, this log mail will only have the log file attached if an error or warning were written to the log mail, but not if the sending was forced via Set-ForceLogSend.
        Send-Log -SendOnWarning -SendOnError -From $LogMailFrom -To $LogMailTo -SmtpServer $LogMailSmtpServer -AttachLogfile:$((Get-HasMailLogError) -or (Get-HasMailLogWarning))
#>

    if($script:ErrorMailCount -gt 0) { return $true; } else { return $false; }
}

function Get-HasLogWarning {
<#
    .SYNOPSIS
        Determines if warnings were logged to the log file (so far).
    .OUTPUTS
        True....There have been warnings logged to the log file
        False...No warnings have yet been logged to the log file
#>

    if($script:WarningLogCount -gt 0) { return $true; } else { return $false; }
}
    
function Get-HasMailLogWarning {
<#
    .SYNOPSIS
        Determines if warnings were logged to the mail log (so far).
    .OUTPUTS
        True....There have been warnings logged to the mail log
        False...No warnings have yet been logged to the mail log
    .EXAMPLE
        # Due to Get-HasMailLogError and Get-HasMailLogWarning, this log mail will only have the log file attached if an error or warning was written to the log mail, but not if the sending was forced via Set-ForceLogSend.
        Send-Log -SendOnWarning -SendOnError -From $LogMailFrom -To $LogMailTo -SmtpServer $LogMailSmtpServer -AttachLogfile:$((Get-HasMailLogError) -or (Get-HasMailLogWarning))
#>

    if($script:WarningMailCount -gt 0) { return $true; } else { return $false; }
}

function Get-HasLogOutput {
<#
    .SYNOPSIS
        Determines if output messages were logged to the log file (so far).
    .OUTPUTS
        True....There have been output messages logged to the log file
        False...No output messages have yet been logged to the log file
#>

    if($script:OutputLogCount -gt 0) { return $true; } else { return $false; }
}
    
function Get-HasMailLogOutput {
<#
    .SYNOPSIS
        Determines if output messages were logged to the mail log (so far).
    .OUTPUTS
        True....There have been output messages logged to the mail log
        False...No output messages have yet been logged to the mail log
    .EXAMPLE
        # Due to Get-HasMailLogOutput, this log mail will only have the log file attached if an output (Write-Output) was written to the log mail.
        Send-Log -SendOnWarning -SendOnError -From $LogMailFrom -To $LogMailTo -SmtpServer $LogMailSmtpServer -AttachLogfile:$(Get-HasMailLogOutput)
#>

    if($script:OutputMailCount -gt 0) { return $true; } else { return $false; }
}

function Get-HasLogHost {
<#
    .SYNOPSIS
        Determines if host messages were logged to the log file (so far).
    .OUTPUTS
        True....There have been host messages logged to the log file
        False...No host messages have yet been logged to the log file
#>

    if($script:HostLogCount -gt 0) { return $true; } else { return $false; }
}
    
function Get-HasMailLogHost {
<#
    .SYNOPSIS
        Determines if host messages were logged to the mail log (so far).
    .OUTPUTS
        True....There have been host messages logged to the mail log
        False...No host messages have yet been logged to the mail log
    .EXAMPLE
        # Due to Get-HasMailLogHost, this log mail will only have the log file attached if a host output was written to the log mail.
        Send-Log -SendOnWarning -SendOnError -From $LogMailFrom -To $LogMailTo -SmtpServer $LogMailSmtpServer -AttachLogfile:$(Get-HasMailLogHost)
#>

    if($script:HostMailCount -gt 0) { return $true; } else { return $false; }
}

function Get-HasLogDebug {
<#
    .SYNOPSIS
        Determines if debug messages were logged to the log file (so far).
    .OUTPUTS
        True....There have been debug messages logged to the log file
        False...No debug messages have yet been logged to the log file
#>

    if($script:DebugLogCount -gt 0) { return $true; } else { return $false; }
}
    
function Get-HasMailLogDebug {
<#
    .SYNOPSIS
        Determines if debug messages were logged to the mail log (so far).
    .OUTPUTS
        True....There have been debug messages logged to the mail log
        False...No debug messages have yet been logged to the mail log
    .EXAMPLE
        # Due to Get-HasMailLogDebug, this log mail will only have the log file attached if a debug output was written to the log mail.
        Send-Log -SendOnWarning -SendOnError -From $LogMailFrom -To $LogMailTo -SmtpServer $LogMailSmtpServer -AttachLogfile:$(Get-HasMailLogDebug)
#>

    if($script:DebugMailCount -gt 0) { return $true; } else { return $false; }
}

function Get-HasLogVerbose {
<#
    .SYNOPSIS
        Determines if verbose messages were logged to the log file (so far).
    .OUTPUTS
        True....There have been verbose messages logged to the log file
        False...No verbose messages have yet been logged to the log file
#>

    if($script:VerboseLogCount -gt 0) { return $true; } else { return $false; }
}
    
function Get-HasMailLogVerbose {
<#
    .SYNOPSIS
        Determines if verbose messages were logged to the mail log (so far).
    .OUTPUTS
        True....There have been verbose messages logged to the mail log
        False...No verbose messages have yet been logged to the mail log
    .EXAMPLE
        # Due to Get-HasMailLogVerbose, this log mail will only have the log file attached if a verbose output was written to the log mail.
        Send-Log -SendOnWarning -SendOnError -From $LogMailFrom -To $LogMailTo -SmtpServer $LogMailSmtpServer -AttachLogfile:$(Get-HasMailLogVerbose)
#>

    if($script:VerboseMailCount -gt 0) { return $true; } else { return $false; }
}

function Get-HasLogInformation {
<#
    .SYNOPSIS
        Determines if information messages were logged to the log file (so far).
    .OUTPUTS
        True....There have been information messages logged to the log file
        False...No information messages have yet been logged to the log file
#>

    if($script:InformationLogCount -gt 0) { return $true; } else { return $false; }
}
    
function Get-HasMailLogInformation {
<#
    .SYNOPSIS
        Determines if information messages were logged to the mail log (so far).
    .OUTPUTS
        True....There have been information messages logged to the mail log
        False...No information messages have yet been logged to the mail log
    .EXAMPLE
        # Due to Get-HasMailLogInformation, this log mail will only have the log file attached if an information output was written to the log mail.
        Send-Log -SendOnWarning -SendOnError -From $LogMailFrom -To $LogMailTo -SmtpServer $LogMailSmtpServer -AttachLogfile:$(Get-HasMailLogInformation)
#>

    if($script:InformationMailCount -gt 0) { return $true; } else { return $false; }
}
                        
                        
function Write-ErrorLog {
<#
    .SYNOPSIS
        Emulates Write-Error but also logs the error in the file and mail log (if applicable)
    .NOTES
        Can recieve error object through pipe, example call in catch block:
        catch
        {
            $_ | Write-ErrorLog "Example error message"
        }
    .PARAMETER Message
        Additional error message
    .PARAMETER Category
        Error category of type [System.Management.Automation.ErrorCategory] (default is NotSpecified)
    .PARAMETER Err
        Error object (as recieved by catch block), can also be recieved through pipe
    .PARAMETER NoOut
        True/Present...Will not print the error message to the console
    .PARAMETER NoLog
        True/Present...Will not log the error message to the log file
    .PARAMETER NoMail
        True/Present...Will not add the error message to the mail log
    .PARAMETER AddTimestamp
        True/Present...Will add a timestamp to each line of the message string, regardless if the -NoTimestamp flag in Start-Log was set
        False/Absent...Will only add a timestamp to each line of the message string if the -NoTimestamp flag in Start-Log was not set (which is the default behaviour)
    .PARAMETER NoErrorDetails
        True/Present...Will not add details of the original error object to the error message
        False/Absent...Will add details of the original error object to the error message
    .PARAMETER Force
        True/Present...Will write the message to the log file, regardless of the rules for error message logging (as set on Start-Log call)
        False/Absent...Will only write the message to the log file if error message logging rules apply (as set on Start-Log call)
    .PARAMETER ForceMail
        True/Present...Will write the message to the mail log, regardless of the rules for error message logging (as set on Start-MailLog call)
        False/Absent...Will only write the message to the mail log if error message logging rules apply (as set on Start-MailLog call)
    .OUTPUTS
        None (Prints error message)
    .EXAMPLE
        # Will write a error message to the console and file/mail log (depending on which of those have been started with their corresponding start logging cmdlet Start-Log and/or Start-MailLog).
        Write-ErrorLog "Error example"
    .EXAMPLE
        # Will write the error message "Critical error" along with all important error information to the console and file/mail log (depending on which of those have been started with their corresponding start logging cmdlet Start-Log and/or Start-MailLog).
        # The Write-ErrorLog cmdlet is a bit more powerfull than the normal Write-Error cmdlet, in that it allows you to pass the error object via pipeline to the cmdlet and it will print out all needed information for you.
        # You can, however, also use the -NoErrorDetails switch of this cmdlet to hide most of the error information to the outside world (you might need to use two seperate calls then, one for the logs with all details, and one for the console with no details).
        try {    
            throw "Some test"
        }
        catch {    
            $_ | Write-ErrorLog "Critical error"
        }
#>

    [CmdletBinding(SupportsShouldProcess=$true)]
    PARAM (
        [Parameter(Position=0)]
        [string] $Message,
        [Parameter(Position=1)]
        [System.Management.Automation.ErrorCategory] $Category = [System.Management.Automation.ErrorCategory]::NotSpecified,
        [Parameter(Position=2, ValueFromPipeline)]
        [System.Management.Automation.ErrorRecord] $Err,
        [switch] $NoOut,
        [switch] $NoLog,
        [switch] $NoMail,
        [switch] $AddTimestamp,
        [switch] $NoErrorDetails,
        [switch] $Force,
        [switch] $ForceMail
    )

    $Exception = $null

    #if no error or message was passed, use the last error
    if(!$Message -and !$Err) {
        if($Error -and $Error.Count -gt 0) {
            $Err = $Error[0]
        }
        else {
            $Message = "Unknown error!"
        }
    }
    
    #now let's build ourself a nice error message
    if($Err) {
        $Exception = $Err.Exception
    }
    $strErrorMessage = ""

    if($Err -and $Err.InvocationInfo -and !$NoErrorDetails.IsPresent) {
        $strErrorMessage += "`r`nScript: $($Err.InvocationInfo.ScriptName), Line: $($Err.InvocationInfo.ScriptLineNumber), Offset: $($Err.InvocationInfo.OffsetInLine)`r`n"
        $strErrorMessage += "`r`n$($Err.InvocationInfo.Line)`r`n"
    }
    $strErrorMessage += $Message

    if($Message -and $Exception) {
        $strErrorMessage += ", "
    }

    if($Exception) {
        $strErrorMessage += "Error-Details: $($Exception.GetType().FullName), $($Exception.Message)" # - CategoryInfo: $($Err.CategoryInfo)"
    }

    #and now let's send the error message to the error stream
    if($Err) {
        if(!$NoOut.IsPresent) {
            Write-Error $strErrorMessage -Category $Category -ErrorId $Err.FullyQualifiedErrorId
        }
        $strErrorMessage = ($strErrorMessage + " (Err-Category: $Category, Err-Id: $($Err.FullyQualifiedErrorId))")
        Write-Log -NoLog:$NoLog -AddTimestamp:$AddTimestamp -Force:$Force -IsError -Message $strErrorMessage
        Write-MailLog -NoMail:$NoMail -Force:$ForceMail -IsError -Message $strErrorMessage
    }
    else {
        if(!$NoOut.IsPresent) {
            Write-Error $strErrorMessage -Category $Category
        }
        $strErrorMessage = ($strErrorMessage + " (Err-Category: $Category)")
        Write-Log -NoLog:$NoLog -AddTimestamp:$AddTimestamp -Force:$Force -IsError -Message $strErrorMessage
        Write-MailLog -NoMail:$NoMail -Force:$ForceMail -IsError -Message $strErrorMessage
    }
}

function Write-HostLog {
<#
    .SYNOPSIS
        Emulates Write-Host but also logs the message in the file and mail log (if applicable)
    .NOTES
        Can recieve the message through pipe
    .PARAMETER Message
        The host message
    .PARAMETER NoNewline
        Same as NoNewline switch in Write-Host cmdlet
    .PARAMETER ForegroundColor
        Same as ForegroundColor parameter in Write-Host cmdlet (only applies to message output to console, not logging)
    .PARAMETER BackgroundColor
        Same as BackgroundColor parameter in Write-Host cmdlet (only applies to message output to console, not logging)
    .PARAMETER NoOut
        True/Present...Will not print the host message to the console
    .PARAMETER NoLog
        True/Present...Will not log the host message to the log file
    .PARAMETER NoMail
        True/Present...Will not add the host message to the mail log
    .PARAMETER AddTimestamp
        True/Present...Will add a timestamp to each line of the message string, regardless if the -NoTimestamp flag in Start-Log was set
        False/Absent...Will only add a timestamp to each line of the message string if the -NoTimestamp flag in Start-Log was not set (which is the default behaviour)
    .PARAMETER Force
        True/Present...Will write the message to the log file, regardless of the rules for host message logging (as set on Start-Log call)
        False/Absent...Will only write the message to the log file if host message logging rules apply (as set on Start-Log call)
    .PARAMETER ForceMail
        True/Present...Will write the message to the mail log, regardless of the rules for host message logging (as set on Start-MailLog call)
        False/Absent...Will only write the message to the mail log if host message logging rules apply (as set on Start-MailLog call)
    .OUTPUTS
        None (Prints host message)
    .EXAMPLE
        # Will write a host message to the console and file/mail log (depending on which of those have been started with their corresponding start logging cmdlet Start-Log and/or Start-MailLog).
        Write-HostLog "Host example"
#>

    [CmdletBinding(SupportsShouldProcess=$true)]
    PARAM (
        [Parameter(Mandatory, ValueFromPipeline)]
        [object] $Message, 
        [switch] $NoNewline,
        [ConsoleColor] $ForegroundColor = (Get-ConsoleForegroundColor),
        [ConsoleColor] $BackgroundColor = (Get-ConsoleBackgroundColor),
        [switch] $NoOut,
        [switch] $NoLog,
        [switch] $NoMail,
        [switch] $AddTimestamp, 
        [switch] $Force, 
        [switch] $ForceMail 
    )
    
    process {
        if($null -ne $Message) {
            $Message = $Message.ToString()
        }
        else {
            $Message = "<null>"
        }

        if(!$NoOut.IsPresent) {
            Write-Host $Message -ForegroundColor $ForegroundColor -BackgroundColor $BackgroundColor -NoNewline:$NoNewline
        }
        Write-Log -NoLog:$NoLog -AddTimestamp:$AddTimestamp -Force:$Force -IsHost -Message $Message -NoNewline:$NoNewline
        Write-MailLog -NoMail:$NoMail -Force:$ForceMail -IsHost -Message $Message -NoNewline:$NoNewline
    }
}

function Write-OutputLog {
<#
    .SYNOPSIS
        Emulates Write-Output but also logs the message in the file and mail log (if applicable)
    .NOTES
        Can recieve the message through pipe
    .PARAMETER Message
        The output message
    .PARAMETER NoOut
        True/Present...Will not print the output message to the console
    .PARAMETER NoLog
        True/Present...Will not log the output message to the log file
    .PARAMETER NoMail
        True/Present...Will not add the output message to the mail log
    .PARAMETER AddTimestamp
        True/Present...Will add a timestamp to each line of the message string, regardless if the -NoTimestamp flag in Start-Log was set
        False/Absent...Will only add a timestamp to each line of the message string if the -NoTimestamp flag in Start-Log was not set (which is the default behaviour)
    .PARAMETER Force
        True/Present...Will write the message to the log file, regardless of the rules for output message logging (as set on Start-Log call)
        False/Absent...Will only write the message to the log file if output message logging rules apply (as set on Start-Log call)
    .PARAMETER ForceMail
        True/Present...Will write the message to the mail log, regardless of the rules for output message logging (as set on Start-MailLog call)
        False/Absent...Will only write the message to the mail log if output message logging rules apply (as set on Start-MailLog call)
    .OUTPUTS
        None (Prints output message)
    .EXAMPLE
        # Will write a output message to the console and file/mail log (depending on which of those have been started with their corresponding start logging cmdlet Start-Log and/or Start-MailLog).
        Write-OutputLog "Output example"
#>

    [CmdletBinding(SupportsShouldProcess=$true)]
    PARAM (
        [Parameter(Mandatory, ValueFromPipeline)]
        [object] $Message,
        [switch] $NoOut,
        [switch] $NoLog,
        [switch] $NoMail,
        [switch] $AddTimestamp, 
        [switch] $Force, 
        [switch] $ForceMail 
    )
    
    process {
        if($null -ne $Message) {
            $Message = $Message.ToString()
        }
        else {
            $Message = "<null>"
        }

        if(!$NoOut.IsPresent) {
            Write-Output $Message
        }
        Write-Log -NoLog:$NoLog -AddTimestamp:$AddTimestamp -Force:$Force -IsOutput -Message $Message
        Write-MailLog -NoMail:$NoMail -Force:$ForceMail -IsOutput -Message $Message
    }
}

function Write-VerboseLog {
<#
    .SYNOPSIS
        Emulates Write-Verbose but also logs the message in the file and mail log (if applicable)
    .NOTES
        Can recieve the message through pipe
    .PARAMETER Message
        The verbose message
    .PARAMETER NoOut
        True/Present...Will not print the verbose message to the console
    .PARAMETER NoLog
        True/Present...Will not log the verbose message to the log file
    .PARAMETER NoMail
        True/Present...Will not add the verbose message to the mail log
    .PARAMETER AddTimestamp
        True/Present...Will add a timestamp to each line of the message string, regardless if the -NoTimestamp flag in Start-Log was set
        False/Absent...Will only add a timestamp to each line of the message string if the -NoTimestamp flag in Start-Log was not set (which is the default behaviour)
    .PARAMETER Force
        True/Present...Will write the message to the log file, regardless of the rules for verbose message logging (as set on Start-Log call)
        False/Absent...Will only write the message to the log file if verbose message logging rules apply (as set on Start-Log call)
    .PARAMETER ForceMail
        True/Present...Will write the message to the mail log, regardless of the rules for verbose message logging (as set on Start-MailLog call)
        False/Absent...Will only write the message to the mail log if verbose message logging rules apply (as set on Start-MailLog call)
    .OUTPUTS
        None (Prints verbose message)
    .EXAMPLE
        # Will write a verbose message to the console and file/mail log (depending on which of those have been started with their corresponding start logging cmdlet Start-Log and/or Start-MailLog).
        Write-VerboseLog "Verbose example"
#>

    [CmdletBinding(SupportsShouldProcess=$true)]
    PARAM (
        [Parameter(Mandatory, ValueFromPipeline)]
        [object] $Message,
        [switch] $NoOut,
        [switch] $NoLog,
        [switch] $NoMail,
        [switch] $AddTimestamp, 
        [switch] $Force, 
        [switch] $ForceMail 
    )

    process {
        if($null -ne $Message) {
            $Message = $Message.ToString()
        }
        else {
            $Message = "<null>"
        }
        
        if(!$NoOut.IsPresent) {
            Write-Verbose $Message
        }
        Write-Log -NoLog:$NoLog -AddTimestamp:$AddTimestamp -Force:$Force -IsVerbose -Message $Message
        Write-MailLog -NoMail:$NoMail -Force:$ForceMail -IsVerbose -Message $Message
    }
}

function Write-WarningLog {
<#
    .SYNOPSIS
        Emulates Write-Warning but also logs the message in the file and mail log (if applicable)
    .NOTES
        Can recieve the message through pipe
    .PARAMETER Message
        The warning message
    .PARAMETER NoOut
        True/Present...Will not print the warning message to the console
    .PARAMETER NoLog
        True/Present...Will not log the warning message to the log file
    .PARAMETER NoMail
        True/Present...Will not add the warning message to the mail log
    .PARAMETER AddTimestamp
        True/Present...Will add a timestamp to each line of the message string, regardless if the -NoTimestamp flag in Start-Log was set
        False/Absent...Will only add a timestamp to each line of the message string if the -NoTimestamp flag in Start-Log was not set (which is the default behaviour)
    .PARAMETER Force
        True/Present...Will write the message to the log file, regardless of the rules for warning message logging (as set on Start-Log call)
        False/Absent...Will only write the message to the log file if warning message logging rules apply (as set on Start-Log call)
    .PARAMETER ForceMail
        True/Present...Will write the message to the mail log, regardless of the rules for warning message logging (as set on Start-MailLog call)
        False/Absent...Will only write the message to the mail log if warning message logging rules apply (as set on Start-MailLog call)
    .OUTPUTS
        None (Prints warning message)
    .EXAMPLE
        # Will write a warning message to the console and file/mail log (depending on which of those have been started with their corresponding start logging cmdlet Start-Log and/or Start-MailLog).
        Write-WarningLog "Warning example"
#>

    [CmdletBinding(SupportsShouldProcess=$true)]
    PARAM (
        [Parameter(Mandatory, ValueFromPipeline)]
        [object] $Message,
        [switch] $NoOut,
        [switch] $NoLog,
        [switch] $NoMail,
        [switch] $AddTimestamp, 
        [switch] $Force, 
        [switch] $ForceMail 
    )

    process {
        if($null -ne $Message) {
            $Message = $Message.ToString()
        }
        else {
            $Message = "<null>"
        }
        
        if(!$NoOut.IsPresent) {
            Write-Warning $Message
        }
        Write-Log -NoLog:$NoLog -AddTimestamp:$AddTimestamp -Force:$Force -IsWarning -Message $Message
        Write-MailLog -NoMail:$NoMail -Force:$ForceMail -IsWarning -Message $Message
    }
}

function Write-DebugLog {
<#
    .SYNOPSIS
        Emulates Write-Debug but also logs the message in the file and mail log (if applicable)
    .NOTES
        Can recieve the message through pipe
    .PARAMETER Message
        The debug message
    .PARAMETER NoOut
        True/Present...Will not print the debug message to the console
    .PARAMETER NoLog
        True/Present...Will not log the debug message to the log file
    .PARAMETER NoMail
        True/Present...Will not add the debug message to the mail log
    .PARAMETER AddTimestamp
        True/Present...Will add a timestamp to each line of the message string, regardless if the -NoTimestamp flag in Start-Log was set
        False/Absent...Will only add a timestamp to each line of the message string if the -NoTimestamp flag in Start-Log was not set (which is the default behaviour)
    .PARAMETER Force
        True/Present...Will write the message to the log file, regardless of the rules for debug message logging (as set on Start-Log call)
        False/Absent...Will only write the message to the log file if debug message logging rules apply (as set on Start-Log call)
    .PARAMETER ForceMail
        True/Present...Will write the message to the mail log, regardless of the rules for debug message logging (as set on Start-MailLog call)
        False/Absent...Will only write the message to the mail log if debug message logging rules apply (as set on Start-MailLog call)
    .OUTPUTS
        None (Prints debug message)
    .EXAMPLE
        # Will write a debug message to the console and file/mail log (depending on which of those have been started with their corresponding start logging cmdlet Start-Log and/or Start-MailLog).
        Write-DebugLog "Debug example"
#>

    [CmdletBinding(SupportsShouldProcess=$true)]
    PARAM (
        [Parameter(Mandatory, ValueFromPipeline)]
        [object] $Message,
        [switch] $NoOut,
        [switch] $NoLog,
        [switch] $NoMail,
        [switch] $AddTimestamp, 
        [switch] $Force, 
        [switch] $ForceMail 
    )
    
    process {
        if($null -ne $Message) {
            $Message = $Message.ToString()
        }
        else {
            $Message = "<null>"
        }
        
        if(!$NoOut.IsPresent) {
            Write-Debug $Message
        }
        Write-Log -NoLog:$NoLog -AddTimestamp:$AddTimestamp -Force:$Force -IsDebug -Message $Message
        Write-MailLog -NoMail:$NoMail -Force:$ForceMail -IsDebug -Message $Message
    }
}

function Write-InformationLog {
<#
    .SYNOPSIS
        Emulates Write-Information but also logs the message in the file and mail log (if applicable)
    .NOTES
        Can recieve the message through pipe
    .PARAMETER Message
        The information message
    .PARAMETER NoOut
        True/Present...Will not print the information message to the console
    .PARAMETER NoLog
        True/Present...Will not log the information message to the log file
    .PARAMETER NoMail
        True/Present...Will not add the information message to the mail log
    .PARAMETER AddTimestamp
        True/Present...Will add a timestamp to each line of the message string, regardless if the -NoTimestamp flag in Start-Log was set
        False/Absent...Will only add a timestamp to each line of the message string if the -NoTimestamp flag in Start-Log was not set (which is the default behaviour)
    .PARAMETER Force
        True/Present...Will write the message to the log file, regardless of the rules for information message logging (as set on Start-Log call)
        False/Absent...Will only write the message to the log file if information message logging rules apply (as set on Start-Log call)
    .PARAMETER ForceMail
        True/Present...Will write the message to the mail log, regardless of the rules for information message logging (as set on Start-MailLog call)
        False/Absent...Will only write the message to the mail log if information message logging rules apply (as set on Start-MailLog call)
    .OUTPUTS
        None (Prints information message)
    .EXAMPLE
        # Will write a information message to the console and file/mail log (depending on which of those have been started with their corresponding start logging cmdlet Start-Log and/or Start-MailLog).
        Write-InformationLog "Information example"
#>

    [CmdletBinding(SupportsShouldProcess=$true)]
    PARAM (
        [Parameter(Mandatory, ValueFromPipeline)]
        [object] $Message,
        [switch] $NoOut,
        [switch] $NoLog,
        [switch] $NoMail,
        [switch] $AddTimestamp, 
        [switch] $Force, 
        [switch] $ForceMail 
    )

    process {
        if($null -ne $Message) {
            $Message = $Message.ToString()
        }
        else {
            $Message = "<null>"
        }
        
        if(!$NoOut.IsPresent) {
            Write-Information $Message
        }
        Write-Log -NoLog:$NoLog -AddTimestamp:$AddTimestamp -Force:$Force -IsInformation -Message $Message
        Write-MailLog -NoMail:$NoMail -Force:$ForceMail -IsInformation -Message $Message
    }
}

