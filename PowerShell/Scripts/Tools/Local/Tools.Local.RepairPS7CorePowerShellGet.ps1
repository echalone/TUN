
<#PSScriptInfo

.VERSION 1.0.0

.GUID ee961589-818a-419a-932d-f761939dc76c

.AUTHOR Markus Szumovski

.COMPANYNAME -

.COPYRIGHT 2021

.TAGS 

.LICENSEURI 

.PROJECTURI 

.ICONURI 

.EXTERNALMODULEDEPENDENCIES 

.REQUIREDSCRIPTS 

.EXTERNALSCRIPTDEPENDENCIES 

.RELEASENOTES
V 1.0.0: Initial version

#> 

<# 

.SYNOPSIS
    Will fix the PowerShell 7 Core Module PowerShellGet Version 2.
.DESCRIPTION 
    Will fix the PowerShell 7 Core Module PowerShellGet Version 2.
    Currently PowerShell 7 Core is delivered with the PowerShellGet Module Version 2 while Version 3 is still under development.
    However, PowerShellGet Module Version 2 has a bug in PowerShell 7 that (it seems) will not be fixed by Microsoft.
    If you have installed a powershell script via Install-Script into the AllUsers scope and are then updating the script
    via Update-Script it will (in PowerShell 7) be installed into the CurrentUser scope instead into the AllUsers scope again.
    This is due to an erroneous if-condition which results in the PowerShellGet Module Version 2 ALWAYS reinstalling scripts
    into the CurrentUser scope IF you are in PowerShell Core.
    Since Microsoft is not accepting pull requests for PowerShellGet Module Version 2 and Version 3 is still not out, I've
    instead written this script which will simply fix this issue after you (re)installed PowerShellCore.
    Simply execute this script AFTER an installation or update of PowerShell 7 Core on the same machine.
.PARAMETER PowerShellCorePath
    The path to the directory into which PowerShell 7 Core was installed (directory with pwsh.exe in it).
    This parameter is optional. If it was not provided the script will try to search for the PowerShell 7 Core installation directory.
.PARAMETER NoConfirm
    True/Present...Will not ask for confirmation before applying fix
    False/Absent...Will ask for confirmation before applying fix
.OUTPUTS
    Status of fixing
.NOTES
  
.EXAMPLE
  .\Tools.Local.RepairPS7CorePowerShellGet -PowerShellCorePath "C:\Program Files\PowerShell\7" -NoConfirm
#> 
[CmdletBinding(SupportsShouldProcess=$True)]
Param
(
    [Parameter(Position=0, Mandatory=$false)]
    [string] $PowerShellCorePath = $null,
    [Parameter(Position=1)]
    [switch] $NoConfirm
)

### --- START --- variables

[string] $RegExPattern_ReplaceLine = "(?<before>(\s|\r|\n|`)+if(\s|\r|\n|`)*\((\s|\r|\n|`)*\-not(\s|\r|\n|`)+\`$PreviousInstallLocation\.ToString\((\s|\r|\n|`)*\)\.StartsWith\((\s|\r|\n|`)*\`$currentUserPath(\s|\r|\n|`)*,(\s|\r|\n|`)*\[System\.StringComparison\]::OrdinalIgnoreCase(\s|\r|\n|`)*\))(?<remove>(\s|\r|\n|`)+\-and(\s|\r|\n|`)+\-not(\s|\r|\n|`)+\`$script:IsCoreCLR)(?<after>(\s|\r|\n|`)+\-and(\s|\r|\n|`)+\((\s|\r|\n|`)*Test\-RunningAsElevated(\s|\r|\n|`)*\)(\s|\r|\n|`)*\)(\s|\r|\n|`)*\{)"

### --- END --- variables

### --- START --- functions
function Test-PSCoreVersion {
    <#
        .SYNOPSIS
            Checks for correct powershell version (7)
        .PARAMETER PSPath
            Path to pwsh.exe for which to check version.
        .OUTPUTS
            true....PowerShell Core Version = 7 and exit code = 0
            false...PowerShell Core Version != 7 or exit code != 0
    #>
    
    [CmdletBinding()]
    PARAM (
        [Parameter(Position=0)]
        [string] $PSPath
    )

    $Version = &$PSPath "--version"
    $ExitCode = $LastExitCode

    if($ExitCode -eq 0) {
        return $Version -match "^PowerShell 7"
    }
    else {
        return $false
    }
}

function Write-ErrorExt {
    <#
        .SYNOPSIS
            Uses Write-Error to display information of an error object
        .NOTES
            Can recieve error object through pipe, example call in catch block:
            catch
            {
                $_ | Write-ErrorExt "Example error message"
            }
        .PARAMETER Message
            Additional error message
        .PARAMETER Category
            Error category of type [System.Management.Automation.ErrorCategory] (default is NotSpecified)
        .PARAMETER Err
            Error object (as recieved by catch block), can also be recieved through pipe
        .OUTPUTS
            None (Prints error message)
    #>
    
    [CmdletBinding()]
    PARAM (
        [Parameter(Position=0)]
        [string] $Message,
        [Parameter(Position=1)]
        [System.Management.Automation.ErrorCategory] $Category = [System.Management.Automation.ErrorCategory]::NotSpecified,
        [Parameter(Position=2, ValueFromPipeline)]
        [System.Management.Automation.ErrorRecord] $Err
    )

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
    $Exception = $Err.Exception
    $strErrorMessage = "!ERROR!`r`n$Message"

    if($Err -and $Err.InvocationInfo) {
        $strErrorMessage += "`r`nScript: $($Err.InvocationInfo.ScriptName), Line: $($Err.InvocationInfo.ScriptLineNumber), Offset: $($Err.InvocationInfo.OffsetInLine)`r`n"
        $strErrorMessage += "`r`n$($Err.InvocationInfo.Line)"
    }

    for($i=0;$null -ne $Exception;$i++) {
        if($i -eq 0) {
            $strErrorMessage += "`r`nError-Details: $($Exception.GetType().FullName), $($Exception.Message)"
        }
        else {
            $strErrorMessage += "`r`nError-Details (Inner-Exception $i): $($Exception.GetType().FullName), $($Exception.Message)"
        }
        $Exception = $Exception.InnerException
    }

    #and now let's send the error message to the error stream
    if($Err) {
        Write-Error $strErrorMessage -Category $Category -ErrorId $Err.FullyQualifiedErrorId
    }
    else {
        Write-Error $strErrorMessage -Category $Category
    }
}

### --- END --- functions

### --- START --- main script ###

try {
    Write-Host "--- 'PowerShell 7 Core PowerShellGet Module' fixing script started ---`r`n`r`n" -ForegroundColor DarkGreen

    if([string]::IsNullOrWhiteSpace($PowerShellCorePath)) {
        Write-Host "Searching for PowerShell 7 Core..." -NoNewline
        $PSPath = $null

        if(Test-Path -Path "$Env:ProgramFiles\PowerShell\7\pwsh.exe") {
            $PwshExePath = "$Env:ProgramFiles\PowerShell\7\pwsh.exe"

            if(Test-PSCoreVersion -PSPath $PwshExePath) {
                $PSPath = $PwshExePath
            }
        }

        if($null -eq $PSPath -and (Test-Path -Path "${Env:ProgramFiles(x86)}\PowerShell\7\pwsh.exe")) {
            $PwshExePath = "${Env:ProgramFiles(x86)}\PowerShell\7\pwsh.exe"

            if(Test-PSCoreVersion -PSPath $PwshExePath) {
                $PSPath = $PwshExePath
            }
        }

        if($null -eq $PSPath) {
            $FoundPwsh = @(Get-ChildItem -Path $Env:ProgramFiles -Recurse -Filter "pwsh.exe" -ErrorAction Ignore)

            foreach($SinglePwsh in $FoundPwsh) {
                $PwshExePath = $SinglePwsh.FullName
                if(Test-PSCoreVersion -PSPath $PwshExePath) {
                    $PSPath = $PwshExePath
                    break;
                }
            }
        }

        if($null -eq $PSPath) {
            $FoundPwsh = @(Get-ChildItem -Path ${Env:ProgramFiles(x86)} -Recurse -Filter "pwsh.exe" -ErrorAction Ignore)

            foreach($SinglePwsh in $FoundPwsh) {
                $PwshExePath = $SinglePwsh.FullName
                if(Test-PSCoreVersion -PSPath  $PwshExePath) {
                    $PSPath = $PwshExePath
                    break;
                }
            }
        }

        if([string]::IsNullOrWhiteSpace($PSPath)) {
            Write-Host "not found" -ForegroundColor Red
            Write-Warning "PowerShell Core 7 not found, please use parameter PowerShellCorePath to provide PowerShell 7 Core installation directory with pwsh.exe in it"
        }
        else {
            Write-Host "found" -ForegroundColor Green
        }
    }
    else {
        Write-Host "Testing PowerShell 7 Core path..." -NoNewline

        $PwshExePath = "$PowerShellCorePath\pwsh.exe"

        if(Test-Path -Path $PwshExePath) {
            if(Test-PSCoreVersion -PSPath $PwshExePath) {
                Write-Host "ok" -ForegroundColor Green
                $PSPath = $PwshExePath
            }
            else {
                Write-Host "wrong version" -ForegroundColor Red
            }
        }
        else {
            Write-Host "missing pwsh.exe" -ForegroundColor Red
            Write-Warning "pwsh.exe not found in provided directory ""$PowerShellCorePath"""
        }
    }

    if(![string]::IsNullOrWhiteSpace($PSPath)) {
        $PSRoot = Split-Path -Path $PSPath -Parent
        $PSGModuleFile = "$PSRoot\Modules\PowerShellGet\PSModule.psm1"

        Write-Host "Found PowerShell 7 Core at: ""$PSRoot"""

        Write-Host "Testing for PowerShellGet module file..." -NoNewline
        if(Test-Path -Path $PSGModuleFile) {
            Write-Host "found" -ForegroundColor Green

            Write-Host "Reading in content of module file..." -NoNewline
            $ModuleFileContent = Get-Content -Path $PSGModuleFile -Force -Raw
            Write-Host "done" -ForegroundColor Green

            Write-Host "Checking for line to fix..." -NoNewline
            if($ModuleFileContent -match $RegExPattern_ReplaceLine) {
                Write-Host "found" -ForegroundColor Green

                Write-Host "Fixing bug in PowerShellGet Module Version 2 now..." -NoNewline
                $NewModuleFileContent = $ModuleFileContent -replace $RegExPattern_ReplaceLine, "`${before}`${after}"
                if($NewModuleFileContent -ne $ModuleFileContent -and !($NewModuleFileContent -match $RegExPattern_ReplaceLine)) {
                    Write-Host "done" -ForegroundColor Green

                    $Continue = $false
                    if(!$NoConfirm.IsPresent) {
                        do {
                            $Feedback = Read-Host -Prompt "Do you want to write the fix back to the PowerShellGet Version 2 module now? (y/n)"
                        }
                        while([string]::IsNullOrWhiteSpace($Feedback))
                        $Continue = $Feedback -eq "y"
                    }
                    else {
                        $Continue = $true
                    }

                    if($Continue) {
                        Write-Host "Writing back changes to PowerShellGet Version 2 file..." -NoNewline
                        Set-Content -Path $PSGModuleFile -Value $NewModuleFileContent -Force -ErrorAction Stop
                        Write-Host "done" -ForegroundColor Green    
                    }
                    else {
                        Write-Warning "Skipping writing back of changes, fix has not been applied. Rerun this script again to apply fix."
                    }
                }
                else {
                    Write-Host "unable" -ForegroundColor Red
                    Write-Warning "It seams the content of the file before and after editing were the same, or the line wasn't fixed"
                }
            }
            else {
                Write-Host "not found" -ForegroundColor Yellow
                Write-Warning "The line to fix wasn't found in the module file, this could mean the module was already fixed"
            }
        }
        else {
            Write-Host "missing" -ForegroundColor Red
            Write-Warning "Didn't find PowerShellGet module file at ""$PSGModuleFile"""
        }
    }
}
catch {
    #Unexpected or really critical error occured (which wasn't handled anywhere else)
    Write-Host "failed" -ForegroundColor Red
    $_ | Write-ErrorExt "Critical error occured"
}
finally {

    Write-Host "`r`n`r`n--- 'PowerShell 7 Core PowerShellGet Module' fixing script ended ---" -ForegroundColor DarkGreen
}

#and we're at the end

### --- END --- main script ###
