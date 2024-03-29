#
# Module manifest for module 'TUN.Logging'
#
# Generated by: Markus Szumovski
#
# Generated on: 01.08.2023
#

@{

# Script module or binary module file associated with this manifest.
RootModule = 'TUN.Logging.psm1'

# Version number of this module.
ModuleVersion = '1.1.8'

# Supported PSEditions
# CompatiblePSEditions = @()

# ID used to uniquely identify this module
GUID = 'eeac1534-25a5-4429-a073-17ec769525f5'

# Author of this module
Author = 'Markus Szumovski'

# Company or vendor of this module
CompanyName = 'ThingsUNeed'

# Copyright statement for this module
Copyright = '(c) 2020 - Markus Szumovski (ThingsUNeed)'

# Description of the functionality provided by this module
Description = 'Provides easy to use file and mail logging. Documentation of module at https://github.com/echalone/TUN/blob/master/PowerShell/Modules/TUN.Logging/TUN.Logging.md'

# Minimum version of the PowerShell engine required by this module
# PowerShellVersion = ''

# Name of the PowerShell host required by this module
# PowerShellHostName = ''

# Minimum version of the PowerShell host required by this module
# PowerShellHostVersion = ''

# Minimum version of Microsoft .NET Framework required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
# DotNetFrameworkVersion = ''

# Minimum version of the common language runtime (CLR) required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
# ClrVersion = ''

# Processor architecture (None, X86, Amd64) required by this module
# ProcessorArchitecture = ''

# Modules that must be imported into the global environment prior to importing this module
RequiredModules = @(@{ModuleName = 'TUN.Credentials'; ModuleVersion = '1.0.7'; })

# Assemblies that must be loaded prior to importing this module
# RequiredAssemblies = @()

# Script files (.ps1) that are run in the caller's environment prior to importing this module.
# ScriptsToProcess = @()

# Type files (.ps1xml) to be loaded when importing this module
# TypesToProcess = @()

# Format files (.ps1xml) to be loaded when importing this module
# FormatsToProcess = @()

# Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
# NestedModules = @()

# Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
FunctionsToExport = 'Get-HasLogDebug', 'Get-HasLogError', 'Get-HasLogHost', 
               'Get-HasLogInformation', 'Get-HasLogOutput', 'Get-HasLogVerbose', 
               'Get-HasLogWarning', 'Get-HasMailLogDebug', 'Get-HasMailLogError', 
               'Get-HasMailLogHost', 'Get-HasMailLogInformation', 
               'Get-HasMailLogOutput', 'Get-HasMailLogVerbose', 
               'Get-HasMailLogWarning', 'Get-TUNLoggingVersion', 'Send-Log', 
               'Set-ForceLogSend', 'Start-Log', 'Start-MailLog', 'Stop-Log', 
               'Write-DebugLog', 'Write-ErrorLog', 'Write-HostLog', 
               'Write-InformationLog', 'Write-OutputLog', 'Write-VerboseLog', 
               'Write-WarningLog'

# Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
CmdletsToExport = @()

# Variables to export from this module
# VariablesToExport = @()

# Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
AliasesToExport = @()

# DSC resources to export from this module
# DscResourcesToExport = @()

# List of all modules packaged with this module
# ModuleList = @()

# List of all files packaged with this module
# FileList = @()

# Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
PrivateData = @{

    PSData = @{

        # Tags applied to this module. These help with module discovery in online galleries.
        Tags = 'Logging','Logs','LogFile','LogFiles','Log-File','Log-Files','Mailing','Mails','Log-Mail','LogMails','LogMail','Log-Mails','Linux','Windows','Core','PowershellCore','Powershell-Core','PS3','PS4','PS5','PS6','PS7'

        # A URL to the license for this module.
        LicenseUri = 'https://github.com/echalone/TUN/blob/master/PowerShell/Modules/LICENSE'

        # A URL to the main website for this project.
        ProjectUri = 'https://github.com/echalone/TUN'

        # A URL to an icon representing this module.
        IconUri = 'https://raw.githubusercontent.com/echalone/TUN/master/Media/Icons/ThingsUNeed.ico'

        # ReleaseNotes of this module
        ReleaseNotes = 'V 1.0.0: Initial version
V 1.0.1: Updated module information
V 1.0.2: Moved markdown link from HelpInfoUri to description
V 1.0.3: Fixed icon link
V 1.0.4: Bumped required module version
V 1.0.5: Bugfixes for logging from console or function, added logging of user
V 1.1.0: Bugfixes for Linux, now compatible with Linux Powershell Core
V 1.1.1: Bugfixing fallback color
V 1.1.2: Updated markdown help and added examples
V 1.1.3: Changed output of error messages slightly to show more error details
V 1.1.4: Bumped version number in markdown readme
V 1.1.7: Only initialize script-wide logging variables if they haven''''t already been initialized by another logging module import from a parent script/call
V 1.1.8: Removed -Force switch from import example'

        # Prerelease string of this module
        # Prerelease = ''

        # Flag to indicate whether the module requires explicit user acceptance for install/update/save
        # RequireLicenseAcceptance = $false

        # External dependent modules of this module
        # ExternalModuleDependencies = @()

    } # End of PSData hashtable

 } # End of PrivateData hashtable

# HelpInfo URI of this module
# HelpInfoURI = ''

# Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
# DefaultCommandPrefix = ''

}

