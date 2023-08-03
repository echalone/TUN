---
Module Name: TUN.Logging
Module Guid: eeac1534-25a5-4429-a073-17ec769525f5
Module Version: 1.1.4
Locale: en-US
---

# TUN.Logging Module

## Description
Logging in files and/or sending log by mail.
Provides easy to use file and mail logging. Documentation of module at https://github.com/echalone/TUN/blob/master/PowerShell/Modules/TUN.Logging/TUN.Logging.md

## License
This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0. If a copy of the MPL was not distributed with this file, You can obtain one at https://mozilla.org/MPL/2.0/

## Module Metadata
* Module version: 1.1.4
* Module GUID: eeac1534-25a5-4429-a073-17ec769525f5
* Author: Markus Szumovski
* Company: ThingsUNeed
* Copyright: (c) 2020 - Markus Szumovski (ThingsUNeed)
* Tags: Core, Linux, Log-File, Log-Files, Log-Mail, Log-Mails, LogFile, LogFiles, Logging, LogMail, LogMails, Logs, Mailing, Mails, Powershell-Core, PowershellCore, PS3, PS4, PS5, PS6, PS7, Windows
* License Uri: https://github.com/echalone/TUN/blob/master/PowerShell/Modules/LICENSE
* Project Uri: https://github.com/echalone/TUN

### Release Notes
V 1.0.0: Initial version<br/>
V 1.0.1: Updated module information<br/>
V 1.0.2: Moved markdown link from HelpInfoUri to description<br/>
V 1.0.3: Fixed icon link<br/>
V 1.0.4: Bumped required module version<br/>
V 1.0.5: Bugfixes for logging from console or function, added logging of user<br/>
V 1.1.0: Bugfixes for Linux, now compatible with Linux Powershell Core<br/>
V 1.1.1: Bugfixing fallback color<br/>
V 1.1.2: Updated markdown help and added examples<br/>
V 1.1.3: Changed output of error messages slightly to show more error details<br/>
V 1.1.4: Bumped version number in markdown readme<br/>
V 1.1.7: Only initialize script-wide logging variables if they haven''t already been initialized by another logging module import from a parent script/call<br/>

### Required Modules
* TUN.Credentials (1.1.0)

## Content
* [Description](#description)
* [License](#license)
* [Module Metadata](#module-metadata)
  * [Release Notes](#release-notes)
  * [Required Modules](#required-modules)
* [Content](#content)
* [How to use](#how-to-use)
  * [Usage example](#usage-example)
    * [Usage example code](#usage-example-code)
    * [Usage example output](#usage-example-output)
* [TUN.Logging Cmdlets](#tun.logging-cmdlets)
  * [Get-HasLogDebug](#get-haslogdebug)
    * [SYNOPSIS](#synopsis)
    * [SYNTAX](#syntax)
    * [OUTPUTS](#outputs)
  * [Get-HasLogError](#get-haslogerror)
    * [SYNOPSIS](#synopsis-1)
    * [SYNTAX](#syntax-1)
    * [OUTPUTS](#outputs-1)
  * [Get-HasLogHost](#get-hasloghost)
    * [SYNOPSIS](#synopsis-2)
    * [SYNTAX](#syntax-2)
    * [OUTPUTS](#outputs-2)
  * [Get-HasLogInformation](#get-hasloginformation)
    * [SYNOPSIS](#synopsis-3)
    * [SYNTAX](#syntax-3)
    * [OUTPUTS](#outputs-3)
  * [Get-HasLogOutput](#get-haslogoutput)
    * [SYNOPSIS](#synopsis-4)
    * [SYNTAX](#syntax-4)
    * [OUTPUTS](#outputs-4)
  * [Get-HasLogVerbose](#get-haslogverbose)
    * [SYNOPSIS](#synopsis-5)
    * [SYNTAX](#syntax-5)
    * [OUTPUTS](#outputs-5)
  * [Get-HasLogWarning](#get-haslogwarning)
    * [SYNOPSIS](#synopsis-6)
    * [SYNTAX](#syntax-6)
    * [OUTPUTS](#outputs-6)
  * [Get-HasMailLogDebug](#get-hasmaillogdebug)
    * [SYNOPSIS](#synopsis-7)
    * [SYNTAX](#syntax-7)
    * [EXAMPLES](#examples)
      * [EXAMPLE 1](#example-1)
    * [OUTPUTS](#outputs-7)
  * [Get-HasMailLogError](#get-hasmaillogerror)
    * [SYNOPSIS](#synopsis-8)
    * [SYNTAX](#syntax-8)
    * [EXAMPLES](#examples-1)
      * [EXAMPLE 1](#example-1-1)
    * [OUTPUTS](#outputs-8)
  * [Get-HasMailLogHost](#get-hasmailloghost)
    * [SYNOPSIS](#synopsis-9)
    * [SYNTAX](#syntax-9)
    * [EXAMPLES](#examples-2)
      * [EXAMPLE 1](#example-1-2)
    * [OUTPUTS](#outputs-9)
  * [Get-HasMailLogInformation](#get-hasmailloginformation)
    * [SYNOPSIS](#synopsis-10)
    * [SYNTAX](#syntax-10)
    * [EXAMPLES](#examples-3)
      * [EXAMPLE 1](#example-1-3)
    * [OUTPUTS](#outputs-10)
  * [Get-HasMailLogOutput](#get-hasmaillogoutput)
    * [SYNOPSIS](#synopsis-11)
    * [SYNTAX](#syntax-11)
    * [EXAMPLES](#examples-4)
      * [EXAMPLE 1](#example-1-4)
    * [OUTPUTS](#outputs-11)
  * [Get-HasMailLogVerbose](#get-hasmaillogverbose)
    * [SYNOPSIS](#synopsis-12)
    * [SYNTAX](#syntax-12)
    * [EXAMPLES](#examples-5)
      * [EXAMPLE 1](#example-1-5)
    * [OUTPUTS](#outputs-12)
  * [Get-HasMailLogWarning](#get-hasmaillogwarning)
    * [SYNOPSIS](#synopsis-13)
    * [SYNTAX](#syntax-13)
    * [EXAMPLES](#examples-6)
      * [EXAMPLE 1](#example-1-6)
    * [OUTPUTS](#outputs-13)
  * [Get-TUNLoggingVersion](#get-tunloggingversion)
    * [SYNOPSIS](#synopsis-14)
    * [SYNTAX](#syntax-14)
    * [PARAMETERS](#parameters)
      * [-AsString](#-asstring)
      * [CommonParameters](#commonparameters)
    * [OUTPUTS](#outputs-14)
  * [Send-Log](#send-log)
    * [SYNOPSIS](#synopsis-15)
    * [SYNTAX](#syntax-15)
    * [EXAMPLES](#examples-7)
      * [EXAMPLE 1](#example-1-7)
    * [PARAMETERS](#parameters-1)
      * [-From](#-from)
      * [-To](#-to)
      * [-SmtpServer](#-smtpserver)
      * [-Subject](#-subject)
      * [-UseSsl](#-usessl)
      * [-AlwaysSend](#-alwayssend)
      * [-SendOnError](#-sendonerror)
      * [-SendOnHost](#-sendonhost)
      * [-SendOnOutput](#-sendonoutput)
      * [-SendOnVerbose](#-sendonverbose)
      * [-SendOnWarning](#-sendonwarning)
      * [-SendOnDebug](#-sendondebug)
      * [-SendOnInformation](#-sendoninformation)
      * [-AttachLogfile](#-attachlogfile)
      * [-WhatIf](#-whatif)
      * [-Confirm](#-confirm)
      * [CommonParameters](#commonparameters-1)
    * [OUTPUTS](#outputs-15)
    * [NOTES](#notes)
  * [Set-ForceLogSend](#set-forcelogsend)
    * [SYNOPSIS](#synopsis-16)
    * [SYNTAX](#syntax-16)
    * [EXAMPLES](#examples-8)
      * [EXAMPLE 1](#example-1-8)
    * [PARAMETERS](#parameters-2)
      * [-Reason](#-reason)
      * [CommonParameters](#commonparameters-2)
    * [OUTPUTS](#outputs-16)
  * [Start-Log](#start-log)
    * [SYNOPSIS](#synopsis-17)
    * [SYNTAX](#syntax-17)
    * [DESCRIPTION](#description-1)
    * [EXAMPLES](#examples-9)
      * [EXAMPLE 1](#example-1-9)
    * [PARAMETERS](#parameters-3)
      * [-LogPath](#-logpath)
      * [-LogName](#-logname)
      * [-LogExtension](#-logextension)
      * [-LogPreference_LogError](#-logpreference_logerror)
      * [-LogPreference_LogHost](#-logpreference_loghost)
      * [-LogPreference_LogOutput](#-logpreference_logoutput)
      * [-LogPreference_LogVerbose](#-logpreference_logverbose)
      * [-LogPreference_LogWarning](#-logpreference_logwarning)
      * [-LogPreference_LogDebug](#-logpreference_logdebug)
      * [-LogPreference_LogInformation](#-logpreference_loginformation)
      * [-LogPreference_FallbackForegroundColor](#-logpreference_fallbackforegroundcolor)
      * [-LogPreference_FallbackBackgroundColor](#-logpreference_fallbackbackgroundcolor)
      * [-NoTimestamp](#-notimestamp)
      * [-UseComputerPrefix](#-usecomputerprefix)
      * [-UseScriptPrefix](#-usescriptprefix)
      * [-UseDefaultName](#-usedefaultname)
      * [-NoDateTimeFormat](#-nodatetimeformat)
      * [-DeleteExisting](#-deleteexisting)
      * [-AsOutput](#-asoutput)
      * [-Force](#-force)
      * [-WhatIf](#-whatif-1)
      * [-Confirm](#-confirm-1)
      * [CommonParameters](#commonparameters-3)
    * [OUTPUTS](#outputs-17)
  * [Start-MailLog](#start-maillog)
    * [SYNOPSIS](#synopsis-18)
    * [SYNTAX](#syntax-18)
    * [DESCRIPTION](#description-2)
    * [EXAMPLES](#examples-10)
      * [EXAMPLE 1](#example-1-10)
      * [EXAMPLE 2](#example-2)
    * [PARAMETERS](#parameters-4)
      * [-CredentialsFile](#-credentialsfile)
      * [-LogPreference_MailError](#-logpreference_mailerror)
      * [-LogPreference_MailHost](#-logpreference_mailhost)
      * [-LogPreference_MailOutput](#-logpreference_mailoutput)
      * [-LogPreference_MailVerbose](#-logpreference_mailverbose)
      * [-LogPreference_MailWarning](#-logpreference_mailwarning)
      * [-LogPreference_MailDebug](#-logpreference_maildebug)
      * [-LogPreference_MailInformation](#-logpreference_mailinformation)
      * [-LogPreference_FallbackForegroundColor](#-logpreference_fallbackforegroundcolor-1)
      * [-LogPreference_FallbackBackgroundColor](#-logpreference_fallbackbackgroundcolor-1)
      * [-AsOutput](#-asoutput-1)
      * [-InitCredentials](#-initcredentials)
      * [-Force](#-force-1)
      * [-WhatIf](#-whatif-2)
      * [-Confirm](#-confirm-2)
      * [CommonParameters](#commonparameters-4)
    * [OUTPUTS](#outputs-18)
    * [NOTES](#notes-1)
  * [Stop-Log](#stop-log)
    * [SYNOPSIS](#synopsis-19)
    * [SYNTAX](#syntax-19)
    * [EXAMPLES](#examples-11)
      * [EXAMPLE 1](#example-1-11)
    * [PARAMETERS](#parameters-5)
      * [-WhatIf](#-whatif-3)
      * [-Confirm](#-confirm-3)
      * [CommonParameters](#commonparameters-5)
    * [OUTPUTS](#outputs-19)
    * [NOTES](#notes-2)
  * [Write-DebugLog](#write-debuglog)
    * [SYNOPSIS](#synopsis-20)
    * [SYNTAX](#syntax-20)
    * [EXAMPLES](#examples-12)
      * [EXAMPLE 1](#example-1-12)
    * [PARAMETERS](#parameters-6)
      * [-Message](#-message)
      * [-NoOut](#-noout)
      * [-NoLog](#-nolog)
      * [-NoMail](#-nomail)
      * [-AddTimestamp](#-addtimestamp)
      * [-Force](#-force-2)
      * [-ForceMail](#-forcemail)
      * [-WhatIf](#-whatif-4)
      * [-Confirm](#-confirm-4)
      * [CommonParameters](#commonparameters-6)
    * [OUTPUTS](#outputs-20)
    * [NOTES](#notes-3)
  * [Write-ErrorLog](#write-errorlog)
    * [SYNOPSIS](#synopsis-21)
    * [SYNTAX](#syntax-21)
    * [EXAMPLES](#examples-13)
      * [EXAMPLE 1](#example-1-13)
      * [EXAMPLE 2](#example-2-1)
    * [PARAMETERS](#parameters-7)
      * [-Message](#-message-1)
      * [-Category](#-category)
      * [-Err](#-err)
      * [-NoOut](#-noout-1)
      * [-NoLog](#-nolog-1)
      * [-NoMail](#-nomail-1)
      * [-AddTimestamp](#-addtimestamp-1)
      * [-NoErrorDetails](#-noerrordetails)
      * [-Force](#-force-3)
      * [-ForceMail](#-forcemail-1)
      * [-WhatIf](#-whatif-5)
      * [-Confirm](#-confirm-5)
      * [CommonParameters](#commonparameters-7)
    * [OUTPUTS](#outputs-21)
    * [NOTES](#notes-4)
  * [Write-HostLog](#write-hostlog)
    * [SYNOPSIS](#synopsis-22)
    * [SYNTAX](#syntax-22)
    * [EXAMPLES](#examples-14)
      * [EXAMPLE 1](#example-1-14)
    * [PARAMETERS](#parameters-8)
      * [-Message](#-message-2)
      * [-NoNewline](#-nonewline)
      * [-ForegroundColor](#-foregroundcolor)
      * [-BackgroundColor](#-backgroundcolor)
      * [-NoOut](#-noout-2)
      * [-NoLog](#-nolog-2)
      * [-NoMail](#-nomail-2)
      * [-AddTimestamp](#-addtimestamp-2)
      * [-Force](#-force-4)
      * [-ForceMail](#-forcemail-2)
      * [-WhatIf](#-whatif-6)
      * [-Confirm](#-confirm-6)
      * [CommonParameters](#commonparameters-8)
    * [OUTPUTS](#outputs-22)
    * [NOTES](#notes-5)
  * [Write-InformationLog](#write-informationlog)
    * [SYNOPSIS](#synopsis-23)
    * [SYNTAX](#syntax-23)
    * [EXAMPLES](#examples-15)
      * [EXAMPLE 1](#example-1-15)
    * [PARAMETERS](#parameters-9)
      * [-Message](#-message-3)
      * [-NoOut](#-noout-3)
      * [-NoLog](#-nolog-3)
      * [-NoMail](#-nomail-3)
      * [-AddTimestamp](#-addtimestamp-3)
      * [-Force](#-force-5)
      * [-ForceMail](#-forcemail-3)
      * [-WhatIf](#-whatif-7)
      * [-Confirm](#-confirm-7)
      * [CommonParameters](#commonparameters-9)
    * [OUTPUTS](#outputs-23)
    * [NOTES](#notes-6)
  * [Write-OutputLog](#write-outputlog)
    * [SYNOPSIS](#synopsis-24)
    * [SYNTAX](#syntax-24)
    * [EXAMPLES](#examples-16)
      * [EXAMPLE 1](#example-1-16)
    * [PARAMETERS](#parameters-10)
      * [-Message](#-message-4)
      * [-NoOut](#-noout-4)
      * [-NoLog](#-nolog-4)
      * [-NoMail](#-nomail-4)
      * [-AddTimestamp](#-addtimestamp-4)
      * [-Force](#-force-6)
      * [-ForceMail](#-forcemail-4)
      * [-WhatIf](#-whatif-8)
      * [-Confirm](#-confirm-8)
      * [CommonParameters](#commonparameters-10)
    * [OUTPUTS](#outputs-24)
    * [NOTES](#notes-7)
  * [Write-VerboseLog](#write-verboselog)
    * [SYNOPSIS](#synopsis-25)
    * [SYNTAX](#syntax-25)
    * [EXAMPLES](#examples-17)
      * [EXAMPLE 1](#example-1-17)
    * [PARAMETERS](#parameters-11)
      * [-Message](#-message-5)
      * [-NoOut](#-noout-5)
      * [-NoLog](#-nolog-5)
      * [-NoMail](#-nomail-5)
      * [-AddTimestamp](#-addtimestamp-5)
      * [-Force](#-force-7)
      * [-ForceMail](#-forcemail-5)
      * [-WhatIf](#-whatif-9)
      * [-Confirm](#-confirm-9)
      * [CommonParameters](#commonparameters-11)
    * [OUTPUTS](#outputs-25)
    * [NOTES](#notes-8)
  * [Write-WarningLog](#write-warninglog)
    * [SYNOPSIS](#synopsis-26)
    * [SYNTAX](#syntax-26)
    * [EXAMPLES](#examples-18)
      * [EXAMPLE 1](#example-1-18)
    * [PARAMETERS](#parameters-12)
      * [-Message](#-message-6)
      * [-NoOut](#-noout-6)
      * [-NoLog](#-nolog-6)
      * [-NoMail](#-nomail-6)
      * [-AddTimestamp](#-addtimestamp-6)
      * [-Force](#-force-8)
      * [-ForceMail](#-forcemail-6)
      * [-WhatIf](#-whatif-10)
      * [-Confirm](#-confirm-10)
      * [CommonParameters](#commonparameters-12)
    * [OUTPUTS](#outputs-26)
    * [NOTES](#notes-9)

## How to use
1. Start logging by using the Start-Log and/or Start-MailLog cmdlets
2. Use the Write-*Log cmdlets to write to the console and the log/mail
3. Use the Send-Log command to send log mails (if you used Start-MailLog as well)
4. Use the Stop-Log command to stop logging to the file (if you used Start-Log as well)

Many options and cmdlets to adapt the logging behaviour exist. Look at the documentation of each cmdlet to get a more detailed overview.

### Usage example
In the following example, we start logging in files and mail and will send a mail if an error or a warning was encountered (via Write-ErrorLog or Write-WarningLog).
The mail will contain our output and will have the current log file attached as well as the subject line "Notification from <Computername>/<ScriptName>, Reason: <Reason>".
The example output will show the "Test error" exception which is in the comments of the example code.

#### Usage example code

```powershell
# The LogCredentialsFile parameter can be used to store credentials for the smtp access in a file.
# If the InitLogCredentials switch is present, powershell will prompt you for the credentials to store in the credentials file and then exit the script immediately 
#		(these credentials will then be used on the next call without this switch present).
PARAM
(
    [Parameter(Position=0)]
    [string] $LogCredentialsFile = $null,
    [Parameter(Position=1)]
    [switch] $InitLogCredentials

)

# Import the logging module
Import-Module "TUN.Logging"

try {
	# Start the file logging in the current directory, with computer name, script name and current date all present in the log-filename
	Start-Log -LogPath ".\" -UseComputerPrefix -UseScriptPrefix -LogName "yyyy-MM-dd"
	
	# Now start the mail logging, write everything to the mail that's also written to the console and use the credentials file to authenticate yourself at the smtp server, if the credentials file was provided
	Start-MailLog -AsOutput -InitCredentials:$InitLogCredentials -CredentialsFile $LogCredentialsFile

	# Emulate Write-Host and also write to the log file and log mail
	Write-HostLog "--- Script started ---" -ForegroundColor DarkGreen
	<#
	 ...some code...
	#>
	
	# throw "Test error"
}
catch {
	# If an error occured, write it to the error stream and the log file and log mail
    $_ | Write-ErrorLog "Encountered critical error"
}
finally {
	Write-HostLog "`r`n`r`n--- Script ended ---" -ForegroundColor DarkGreen
	
	# Now first send the mail (make sure you don't call Stop-Log before Send-Log) if any warning or error occured.
	# Send the mail from the address "from.address@yourdomain.com" and smtp server "smtp.yourdomain.com", use a ssl connection and attach the logfile to the mail
	Send-Log -SendOnWarning -SendOnError -From "from.address@yourdomain.com" -To "your.mail@yourdomain.com" -UseSsl -SmtpServer "smtp.yourdomain.com" -AttachLogfile
	
	# Now stop the file logging and close the log file, this should be the last command
	Stop-Log
}
```

#### Usage example output

```
***************************************************************************************************
	PowerShell Version 5.1.18362.752
	Logging by module TUN.Logging Version 1.0.0
	Started script "C:\<path>\test.ps1"
	Calling command ".\test.ps1"
		at 2020-06-18 12:01:10Z
***************************************************************************************************
	Starting...
***************************************************************************************************

2020-06-18T11:44:12Z: --- Script started ---
2020-06-18T11:44:12Z: ERROR: 
2020-06-18T11:44:12Z: Script: C:\<path>\test.ps1, Line: 28, Offset: 2
2020-06-18T11:44:12Z: 
2020-06-18T11:44:12Z: 	throw "Test error"
2020-06-18T11:44:12Z: 
2020-06-18T11:44:12Z: Encountered critical error, Error-Details: System.Management.Automation.RuntimeException, Test error (Err-Category: NotSpecified, Err-Id: Test error)
2020-06-18T11:44:12Z: 
2020-06-18T11:44:12Z: 
2020-06-18T11:44:12Z: --- Script ended ---
2020-06-18T11:44:12Z: ---TRYING TO SEND LOG MAIL TO "your.mail@yourdomain.com", SUBJECT: Notification from <ComputerName>/test, Reason: ERROR count: 1---
2020-06-18T11:44:12Z: ---SENDING LOG MAIL, USING USER "<YourUser>"---
2020-06-18T11:44:12Z: ---ATTACHING LOG FILE "C:\<path>\<ComputerName>_test_2020-06-18.log" TO LOG MAIL---
2020-06-18T11:44:12Z: ---SUCCESFULLY SENT LOG MAIL---
***************************************************************************************************
	...ending!
***************************************************************************************************
	Ended script "D:\<path>\test.ps1"
		at 2020-06-18 12:01:15
			No warnings encountered
			ERRORS encountered: 1
***************************************************************************************************
```

## TUN.Logging Cmdlets
### Get-HasLogDebug

#### SYNOPSIS
Determines if debug messages were logged to the log file (so far).

#### SYNTAX

```
Get-HasLogDebug
```

#### OUTPUTS

True....There have been debug messages logged to the log file

False...No debug messages have yet been logged to the log file



### Get-HasLogError

#### SYNOPSIS
Determines if errors were logged to the log file (so far).

#### SYNTAX

```
Get-HasLogError
```

#### OUTPUTS

True....There have been errors logged to the log file

False...No errors have yet been logged to the log file



### Get-HasLogHost

#### SYNOPSIS
Determines if host messages were logged to the log file (so far).

#### SYNTAX

```
Get-HasLogHost
```

#### OUTPUTS

True....There have been host messages logged to the log file

False...No host messages have yet been logged to the log file



### Get-HasLogInformation

#### SYNOPSIS
Determines if information messages were logged to the log file (so far).

#### SYNTAX

```
Get-HasLogInformation
```

#### OUTPUTS

True....There have been information messages logged to the log file

False...No information messages have yet been logged to the log file



### Get-HasLogOutput

#### SYNOPSIS
Determines if output messages were logged to the log file (so far).

#### SYNTAX

```
Get-HasLogOutput
```

#### OUTPUTS

True....There have been output messages logged to the log file

False...No output messages have yet been logged to the log file



### Get-HasLogVerbose

#### SYNOPSIS
Determines if verbose messages were logged to the log file (so far).

#### SYNTAX

```
Get-HasLogVerbose
```

#### OUTPUTS

True....There have been verbose messages logged to the log file

False...No verbose messages have yet been logged to the log file



### Get-HasLogWarning

#### SYNOPSIS
Determines if warnings were logged to the log file (so far).

#### SYNTAX

```
Get-HasLogWarning
```

#### OUTPUTS

True....There have been warnings logged to the log file

False...No warnings have yet been logged to the log file



### Get-HasMailLogDebug

#### SYNOPSIS
Determines if debug messages were logged to the mail log (so far).

#### SYNTAX

```
Get-HasMailLogDebug
```

#### EXAMPLES

##### EXAMPLE 1
```
# Due to Get-HasMailLogDebug, this log mail will only have the log file attached if a debug output was written to the log mail.
Send-Log -SendOnWarning -SendOnError -From $LogMailFrom -To $LogMailTo -SmtpServer $LogMailSmtpServer -AttachLogfile:$(Get-HasMailLogDebug)
```

#### OUTPUTS

True....There have been debug messages logged to the mail log

False...No debug messages have yet been logged to the mail log



### Get-HasMailLogError

#### SYNOPSIS
Determines if errors were logged to the mail log (so far).

#### SYNTAX

```
Get-HasMailLogError
```

#### EXAMPLES

##### EXAMPLE 1
```
# Due to Get-HasMailLogError and Get-HasMailLogWarning, this log mail will only have the log file attached if an error or warning were written to the log mail, but not if the sending was forced via Set-ForceLogSend.
Send-Log -SendOnWarning -SendOnError -From $LogMailFrom -To $LogMailTo -SmtpServer $LogMailSmtpServer -AttachLogfile:$((Get-HasMailLogError) -or (Get-HasMailLogWarning))
```

#### OUTPUTS

True....There have been errors logged to the mail log

False...No errors have yet been logged to the mail log



### Get-HasMailLogHost

#### SYNOPSIS
Determines if host messages were logged to the mail log (so far).

#### SYNTAX

```
Get-HasMailLogHost
```

#### EXAMPLES

##### EXAMPLE 1
```
# Due to Get-HasMailLogHost, this log mail will only have the log file attached if a host output was written to the log mail.
Send-Log -SendOnWarning -SendOnError -From $LogMailFrom -To $LogMailTo -SmtpServer $LogMailSmtpServer -AttachLogfile:$(Get-HasMailLogHost)
```

#### OUTPUTS

True....There have been host messages logged to the mail log

False...No host messages have yet been logged to the mail log



### Get-HasMailLogInformation

#### SYNOPSIS
Determines if information messages were logged to the mail log (so far).

#### SYNTAX

```
Get-HasMailLogInformation
```

#### EXAMPLES

##### EXAMPLE 1
```
# Due to Get-HasMailLogInformation, this log mail will only have the log file attached if an information output was written to the log mail.
Send-Log -SendOnWarning -SendOnError -From $LogMailFrom -To $LogMailTo -SmtpServer $LogMailSmtpServer -AttachLogfile:$(Get-HasMailLogInformation)
```

#### OUTPUTS

True....There have been information messages logged to the mail log

False...No information messages have yet been logged to the mail log



### Get-HasMailLogOutput

#### SYNOPSIS
Determines if output messages were logged to the mail log (so far).

#### SYNTAX

```
Get-HasMailLogOutput
```

#### EXAMPLES

##### EXAMPLE 1
```
# Due to Get-HasMailLogOutput, this log mail will only have the log file attached if an output (Write-Output) was written to the log mail.
Send-Log -SendOnWarning -SendOnError -From $LogMailFrom -To $LogMailTo -SmtpServer $LogMailSmtpServer -AttachLogfile:$(Get-HasMailLogOutput)
```

#### OUTPUTS

True....There have been output messages logged to the mail log

False...No output messages have yet been logged to the mail log



### Get-HasMailLogVerbose

#### SYNOPSIS
Determines if verbose messages were logged to the mail log (so far).

#### SYNTAX

```
Get-HasMailLogVerbose
```

#### EXAMPLES

##### EXAMPLE 1
```
# Due to Get-HasMailLogVerbose, this log mail will only have the log file attached if a verbose output was written to the log mail.
Send-Log -SendOnWarning -SendOnError -From $LogMailFrom -To $LogMailTo -SmtpServer $LogMailSmtpServer -AttachLogfile:$(Get-HasMailLogVerbose)
```

#### OUTPUTS

True....There have been verbose messages logged to the mail log

False...No verbose messages have yet been logged to the mail log



### Get-HasMailLogWarning

#### SYNOPSIS
Determines if warnings were logged to the mail log (so far).

#### SYNTAX

```
Get-HasMailLogWarning
```

#### EXAMPLES

##### EXAMPLE 1
```
# Due to Get-HasMailLogError and Get-HasMailLogWarning, this log mail will only have the log file attached if an error or warning was written to the log mail, but not if the sending was forced via Set-ForceLogSend.
Send-Log -SendOnWarning -SendOnError -From $LogMailFrom -To $LogMailTo -SmtpServer $LogMailSmtpServer -AttachLogfile:$((Get-HasMailLogError) -or (Get-HasMailLogWarning))
```

#### OUTPUTS

True....There have been warnings logged to the mail log

False...No warnings have yet been logged to the mail log



### Get-TUNLoggingVersion

#### SYNOPSIS
Returns version of current TUN.Logging module

#### SYNTAX

```
Get-TUNLoggingVersion [-AsString] [<CommonParameters>]
```

#### PARAMETERS

##### -AsString
True/Present...will return a version string
False/Absent...will return a version object

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

##### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

#### OUTPUTS

Version of TUN.Logging module



### Send-Log

#### SYNOPSIS
Stops logging process for mail log and sends the mail log text as a text mail.
Optionally attaches the file log as attachment.

#### SYNTAX

```
Send-Log [-From] <String> [-To] <String[]> [[-SmtpServer] <String>] [[-Subject] <String>] [-UseSsl]
 [-AlwaysSend] [-SendOnError] [-SendOnHost] [-SendOnOutput] [-SendOnVerbose] [-SendOnWarning] [-SendOnDebug]
 [-SendOnInformation] [-AttachLogfile] [-WhatIf] [-Confirm] [<CommonParameters>]
```

#### EXAMPLES

##### EXAMPLE 1
```
# Send a log mail if any errors or warnings occured. 
# Send from the address "from.address@yourdomain.com" and smtp server "smtp.yourdomain.com", use a ssl connection and attach the logfile to the mail.
Send-Log -SendOnWarning -SendOnError -From "from.address@yourdomain.com" -To "your.mail@yourdomain.com" -UseSsl -SmtpServer "smtp.yourdomain.com" -AttachLogfile
```

#### PARAMETERS

##### -From
The from email address.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

##### -To
The to email address.
Can be one or more email addresses to which the email will be sent.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

##### -SmtpServer
The SMTP server to use for sending the email.
If this parameter is not provided, the default SMTP server as defined in $PSEmailServer will be used.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: $PSEmailServer
Accept pipeline input: False
Accept wildcard characters: False
```

##### -Subject
The beginning of the subject line of the email.
Will interpret $(COMPUTERNAME) and $(SCRIPTNAME) as variables.
If not provided, will use "Notification from $(COMPUTERNAME)/$(SCRIPTNAME)" as default.
The reason for the E-Mail sending will be added to the end of the subject line (sepearted by a comma).

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

##### -UseSsl
True/Present...Will use Ssl to connect to the smtp server

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

##### -AlwaysSend
True/Present...Will always send the email, no matter what exactly was logged.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

##### -SendOnError
True/Present...Will send the email if an error occured and was logged in the mail text.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

##### -SendOnHost
True/Present...Will send the email if an error occured and was logged in the mail text.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

##### -SendOnOutput
True/Present...Will send the email if an error occured and was logged in the mail text.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

##### -SendOnVerbose
True/Present...Will send the email if an error occured and was logged in the mail text.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

##### -SendOnWarning
True/Present...Will send the email if an error occured and was logged in the mail text.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

##### -SendOnDebug
True/Present...Will send the email if an error occured and was logged in the mail text.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

##### -SendOnInformation
True/Present...Will send the email if an error occured and was logged in the mail text.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

##### -AttachLogfile
True/Present...Will attach the log file to the log mail if file logging was enabled.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

##### -WhatIf
```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

##### -Confirm
```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

##### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

#### OUTPUTS

None

#### NOTES
Once this function has been called, the Write-ErrorLog etc.
functions will not add any more lines to the mail log.



### Set-ForceLogSend

#### SYNOPSIS
Sets a flag to trigger the sending of the log mail as soon as Send-Log is called (no matter what messages have been logged).

#### SYNTAX

```
Set-ForceLogSend [[-Reason] <String>] [<CommonParameters>]
```

#### EXAMPLES

##### EXAMPLE 1
```
# This call will force a log mail to be sent, giving the reason "Simon said so" in the subject line.
Set-ForceLogSend "Simon said so"
```

#### PARAMETERS

##### -Reason
The reason for force sending of mail log (will be added to subject line).
If no reason is given here, "forced" will be given as reason in the subject line.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

##### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

#### OUTPUTS

None



### Start-Log

#### SYNOPSIS
Starts logging process for file log.

#### SYNTAX

```
Start-Log [[-LogPath] <String>] [[-LogName] <String>] [[-LogExtension] <String>]
 [[-LogPreference_LogError] <Boolean>] [[-LogPreference_LogHost] <Boolean>]
 [[-LogPreference_LogOutput] <Boolean>] [[-LogPreference_LogVerbose] <Boolean>]
 [[-LogPreference_LogWarning] <Boolean>] [[-LogPreference_LogDebug] <Boolean>]
 [[-LogPreference_LogInformation] <Boolean>] [[-LogPreference_FallbackForegroundColor] <ConsoleColor>]
 [[-LogPreference_FallbackBackgroundColor] <ConsoleColor>] [-NoTimestamp] [-UseComputerPrefix]
 [-UseScriptPrefix] [-UseDefaultName] [-NoDateTimeFormat] [-DeleteExisting] [-AsOutput] [-Force] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

#### DESCRIPTION
Once this function has been called, the Write-ErrorLog etc.
functions will add lines to a log file.

#### EXAMPLES

##### EXAMPLE 1
```
# Will start logging and save logfile in current directory, with computer and script prefix as well as the current date all present in the filename:
Start-Log -LogPath ".\" -UseComputerPrefix -UseScriptPrefix -LogName "yyyy-MM-dd"
```

#### PARAMETERS

##### -LogPath
Path to the logfile directory. 
The default value is ".\" for the current working directory.
Will interpret $(COMPUTERNAME) and $(SCRIPTNAME) as variables.
If the path does not exist yet, it will try to create it.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: .\
Accept pipeline input: False
Accept wildcard characters: False
```

##### -LogName
Name of the logfile, will be interpreted as a datetime format if NoDateTimeFormat switch is not set.
Therefore, certain (or optionally all) letters will have to be escaped with a backslash if they should
not be interpreted as a datetime format character.
If this parameter is not provided, it will behave as if -UseDefaultName switch is set.
Will interpret $(COMPUTERNAME) and $(SCRIPTNAME) as variables.
If a file with this name (or its resulting datetime format name) does not exist yet, it will try to create it.
If a file with this name (or its resulting datetime format name) already exists, it will by default append
the log messages at the end of the log file, or delete it if the switch DeleteExisting is present.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

##### -LogExtension
Extension of the logfile
The default value is "log" if not specified otherwise.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: Log
Accept pipeline input: False
Accept wildcard characters: False
```

##### -LogPreference_LogError
True....Will add error messages to the file log (no matter if they are displayed or logged in the mail log)
False...Will not add error messages to the file log (no matter if they are displayed or logged in the mail log)
null or not specified...The adding of error messages depends on the AsOutput switch.
If the AsOutput switch is present,
        then error messages will only be added if they are displayed, if the AsOutput switch is absent, they will
        always be added.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

##### -LogPreference_LogHost
True....Will add host messages to the file log (no matter if they are displayed or logged in the mail log)
False...Will not add host messages to the file log (no matter if they are displayed or logged in the mail log)
null or not specified...The adding of host messages depends on the AsOutput switch.
If the AsOutput switch is present,
        then host messages will only be added if they are displayed, if the AsOutput switch is absent, they will
        always be added.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

##### -LogPreference_LogOutput
True....Will add output messages to the file log (no matter if they are displayed or logged in the mail log)
False...Will not add output messages to the file log (no matter if they are displayed or logged in the mail log)
null or not specified...The adding of output messages depends on the AsOutput switch.
If the AsOutput switch is present,
        then output messages will only be added if they are displayed, if the AsOutput switch is absent, they will
        always be added.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

##### -LogPreference_LogVerbose
True....Will add verbose messages to the file log (no matter if they are displayed or logged in the mail log)
False...Will not add verbose messages to the file log (no matter if they are displayed or logged in the mail log)
null or not specified...The adding of verbose messages depends on the AsOutput switch.
If the AsOutput switch is present,
        then verbose messages will only be added if they are displayed, if the AsOutput switch is absent, they will
        always be added.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

##### -LogPreference_LogWarning
True....Will add warning messages to the file log (no matter if they are displayed or logged in the mail log)
False...Will not add warning messages to the file log (no matter if they are displayed or logged in the mail log)
null or not specified...The adding of warning messages depends on the AsOutput switch.
If the AsOutput switch is present,
        then warning messages will only be added if they are displayed, if the AsOutput switch is absent, they will
        always be added.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

##### -LogPreference_LogDebug
True....Will add debug messages to the file log (no matter if they are displayed or logged in the mail log)
False...Will not add debug messages to the file log (no matter if they are displayed or logged in the mail log)
null or not specified...The adding of debug messages depends on the AsOutput switch.
If the AsOutput switch is present,
        then debug messages will only be added if they are displayed, if the AsOutput switch is absent, they will
        always be added.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 9
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

##### -LogPreference_LogInformation
True....Will add information messages to the file log (no matter if they are displayed or logged in the mail log)
False...Will not add information messages to the file log (no matter if they are displayed or logged in the mail log)
null or not specified...The adding of information messages depends on the AsOutput switch.
If the AsOutput switch is present,
        then information messages will only be added if they are displayed, if the AsOutput switch is absent, they will
        always be added.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 10
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

##### -LogPreference_FallbackForegroundColor
The fallback foreground color for the console if none was provided and the current foreground color could not be determined from the console.
The default is Gray.

```yaml
Type: ConsoleColor
Parameter Sets: (All)
Aliases:
Accepted values: Black, DarkBlue, DarkGreen, DarkCyan, DarkRed, DarkMagenta, DarkYellow, Gray, DarkGray, Blue, Green, Cyan, Red, Magenta, Yellow, White

Required: False
Position: 11
Default value: Gray
Accept pipeline input: False
Accept wildcard characters: False
```

##### -LogPreference_FallbackBackgroundColor
The fallback background color for the console if none was provided and the current background color could not be determined from the console.
The default is Black.

```yaml
Type: ConsoleColor
Parameter Sets: (All)
Aliases:
Accepted values: Black, DarkBlue, DarkGreen, DarkCyan, DarkRed, DarkMagenta, DarkYellow, Gray, DarkGray, Blue, Green, Cyan, Red, Magenta, Yellow, White

Required: False
Position: 12
Default value: Black
Accept pipeline input: False
Accept wildcard characters: False
```

##### -NoTimestamp
True/Present...Will not automatically add a timestamp to the beginning of each line in the log file.
                If this switch is set, use the -AddTimestamp switch on individual log calls to add a timestamp if needed.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

##### -UseComputerPrefix
True/Present...Will add the computer name in front of the log file name, followed by an underscore (will also be in front of the script name if UseScriptPrefix switch is set too)

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

##### -UseScriptPrefix
True/Present...Will add the script name in front of the log file name, followed by an underscore.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

##### -UseDefaultName
True/Present...Will ignore LogName, UseScriptPrefix, UseComputerPrefix and NoDateTimeFormat
                and use the following name for the logfile:
                $(COMPUTERNAME)_$(SCRIPTNAME)_yyyy-MM-ddTHHmmss

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

##### -NoDateTimeFormat
True/Present...Will not interprete LogName as a datetime format (and no letters will have to be escaped with backslashes)

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

##### -DeleteExisting
True/Present...Deletes an existing log file if it already exists.
Otherwise new log messages will be appended at the end of the log file.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

##### -AsOutput
True/Present...For all message types for which no LogPreference was set (or for which the LogPreference is null) the 
                message will only be added if it is displayed to the user (or would be displayed to the user if
                it is an automatic script) according to its environment variable.
False/Absent...For all message types for which no LogPreference was set (or for which the LogPreference is null) the 
                message will always be added regardless if it is displayed to the user (or would be displayed to the 
                user if it is an automatic script) according to its environment variable.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

##### -Force
True/Present...Will log regardless of -WhatIf switch of calling script
False/Absent...Will only log if -WhatIf switch is not present in calling script

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

##### -WhatIf
```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

##### -Confirm
```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

##### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

#### OUTPUTS

None



### Start-MailLog

#### SYNOPSIS
Starts logging process for mail log.

#### SYNTAX

```
Start-MailLog [[-CredentialsFile] <String>] [[-LogPreference_MailError] <Boolean>]
 [[-LogPreference_MailHost] <Boolean>] [[-LogPreference_MailOutput] <Boolean>]
 [[-LogPreference_MailVerbose] <Boolean>] [[-LogPreference_MailWarning] <Boolean>]
 [[-LogPreference_MailDebug] <Boolean>] [[-LogPreference_MailInformation] <Boolean>]
 [[-LogPreference_FallbackForegroundColor] <ConsoleColor>]
 [[-LogPreference_FallbackBackgroundColor] <ConsoleColor>] [-AsOutput] [-InitCredentials] [-Force] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

#### DESCRIPTION
Once this function has been called, the Write-ErrorLog etc.
functions will add lines to a mail text
that can later on be sent by mail with the Send-Log command.

#### EXAMPLES

##### EXAMPLE 1
```
# Initialize the log mail sending credentials, used to access the smtp server.
# The -InitCredentials switch will prompt for credentials, save them in the "C:\MyCredentials.cfg" file and will then immediately exit the script.
Start-MailLog -InitCredentials -CredentialsFile "C:\MyCredentials.cfg"
```

##### EXAMPLE 2
```
# Start the mail logging, write everything to the mail that's also written to the console and use the credentials stored in the "C:\MyCredentials.cfg" file to authenticate yourself at the smtp server when sending the mail.
Start-MailLog -AsOutput -CredentialsFile "C:\MyCredentials.cfg"
```

#### PARAMETERS

##### -CredentialsFile
File to store mailing credentials in and read mailing credentials from (for access to the smtp server).
Information will be stored in the XML file format.
If no path for a credentials file was provided, the credentials of the script execution will be used to connect to the smtp server.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

##### -LogPreference_MailError
True....Will add error messages to the log mail text (no matter if they are displayed or logged in the file log)
False...Will not add error messages to the log mail text (no matter if they are displayed or logged in the file log)
null or not specified...The adding of error messages depends on the AsOutput switch.
If the AsOutput switch is present,
        then error messages will only be added if they are displayed, if the AsOutput switch is absent, they will
        always be added.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

##### -LogPreference_MailHost
True....Will add host messages to the log mail text (no matter if they are displayed or logged in the file log)
False...Will not add host messages to the log mail text (no matter if they are displayed or logged in the file log)
null or not specified...The adding of host messages depends on the AsOutput switch.
If the AsOutput switch is present,
        then host messages will only be added if they are displayed, if the AsOutput switch is absent, they will
        always be added.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

##### -LogPreference_MailOutput
True....Will add output messages to the log mail text (no matter if they are displayed or logged in the file log)
False...Will not add output messages to the log mail text (no matter if they are displayed or logged in the file log)
null or not specified...The adding of output messages depends on the AsOutput switch.
If the AsOutput switch is present,
        then output messages will only be added if they are displayed, if the AsOutput switch is absent, they will
        always be added.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

##### -LogPreference_MailVerbose
True....Will add verbose messages to the log mail text (no matter if they are displayed or logged in the file log)
False...Will not add verbose messages to the log mail text (no matter if they are displayed or logged in the file log)
null or not specified...The adding of verbose messages depends on the AsOutput switch.
If the AsOutput switch is present,
        then verbose messages will only be added if they are displayed, if the AsOutput switch is absent, they will
        always be added.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

##### -LogPreference_MailWarning
True....Will add warning messages to the log mail text (no matter if they are displayed or logged in the file log)
False...Will not add warning messages to the log mail text (no matter if they are displayed or logged in the file log)
null or not specified...The adding of warning messages depends on the AsOutput switch.
If the AsOutput switch is present,
        then warning messages will only be added if they are displayed, if the AsOutput switch is absent, they will
        always be added.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

##### -LogPreference_MailDebug
True....Will add debug messages to the log mail text (no matter if they are displayed or logged in the file log)
False...Will not add debug messages to the log mail text (no matter if they are displayed or logged in the file log)
null or not specified...The adding of debug messages depends on the AsOutput switch.
If the AsOutput switch is present,
        then debug messages will only be added if they are displayed, if the AsOutput switch is absent, they will
        always be added.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

##### -LogPreference_MailInformation
True....Will add information messages to the log mail text (no matter if they are displayed or logged in the file log)
False...Will not add information messages to the log mail text (no matter if they are displayed or logged in the file log)
null or not specified...The adding of information messages depends on the AsOutput switch.
If the AsOutput switch is present,
        then information messages will only be added if they are displayed, if the AsOutput switch is absent, they will
        always be added.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

##### -LogPreference_FallbackForegroundColor
The fallback foreground color for the console if none was provided and the current foreground color could not be determined from the console.
The default is Gray.

```yaml
Type: ConsoleColor
Parameter Sets: (All)
Aliases:
Accepted values: Black, DarkBlue, DarkGreen, DarkCyan, DarkRed, DarkMagenta, DarkYellow, Gray, DarkGray, Blue, Green, Cyan, Red, Magenta, Yellow, White

Required: False
Position: 9
Default value: Gray
Accept pipeline input: False
Accept wildcard characters: False
```

##### -LogPreference_FallbackBackgroundColor
The fallback background color for the console if none was provided and the current background color could not be determined from the console.
The default is Black.

```yaml
Type: ConsoleColor
Parameter Sets: (All)
Aliases:
Accepted values: Black, DarkBlue, DarkGreen, DarkCyan, DarkRed, DarkMagenta, DarkYellow, Gray, DarkGray, Blue, Green, Cyan, Red, Magenta, Yellow, White

Required: False
Position: 10
Default value: Black
Accept pipeline input: False
Accept wildcard characters: False
```

##### -AsOutput
True/Present...For all message types for which no LogPreference was set (or for which the LogPreference is null) the 
                message will only be added if it is displayed to the user (or would be displayed to the user if
                it is an automatic script) according to its environment variable.
False/Absent...For all message types for which no LogPreference was set (or for which the LogPreference is null) the 
                message will always be added regardless if it is displayed to the user (or would be displayed to the 
                user if it is an automatic script) according to its environment variable.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

##### -InitCredentials
True/Present...The script will ask for the credentials to use for mail sending, store them in the credentials file and will then immediatly exit the script.
                Used to either set up credentials file for the first time, or change/renew the credentials in the credential file, without performing the 
                actual task by the script.
The -WhatIf switch cannot be used to make sure the script is not performing its task, because it will also prevent
                the script from saving the credentials to the credentials file.
                This switch is ignored if the CredentialsFile parameter is not provided.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

##### -Force
True/Present...Will log regardless of -WhatIf switch of calling script
False/Absent...Will only log if -WhatIf switch is not present in calling script

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

##### -WhatIf
```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

##### -Confirm
```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

##### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

#### OUTPUTS

None

#### NOTES
If the credentials file cannot be found, it will ask the user for the credentials and stores it in
the credential file.
For first use or to change the credentials, use the -InitCredentials switch, which will force storing new credentials
and exits the script immediately after saving the credentials without executing the rest of the script.
This is because the -WhatIf switch 
cannot be used to make sure the script is not performing its task, because it will also prevent the script from saving the credentials to 
the credentials file.



### Stop-Log

#### SYNOPSIS
Stops logging process for log file.

#### SYNTAX

```
Stop-Log [-WhatIf] [-Confirm] [<CommonParameters>]
```

#### EXAMPLES

##### EXAMPLE 1
```
# Stop the file logging and close the log file, this should be the last command in a script which uses logs.
Stop-Log
```

#### PARAMETERS

##### -WhatIf
```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

##### -Confirm
```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

##### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

#### OUTPUTS

None

#### NOTES
Once this function has been called, the Write-ErrorLog etc.
functions will not add any more lines to the file log.



### Write-DebugLog

#### SYNOPSIS
Emulates Write-Debug but also logs the message in the file and mail log (if applicable)

#### SYNTAX

```
Write-DebugLog [-Message] <Object> [-NoOut] [-NoLog] [-NoMail] [-AddTimestamp] [-Force] [-ForceMail] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

#### EXAMPLES

##### EXAMPLE 1
```
# Will write a debug message to the console and file/mail log (depending on which of those have been started with their corresponding start logging cmdlet Start-Log and/or Start-MailLog).
Write-DebugLog "Debug example"
```

#### PARAMETERS

##### -Message
The debug message

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

##### -NoOut
True/Present...Will not print the debug message to the console

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

##### -NoLog
True/Present...Will not log the debug message to the log file

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

##### -NoMail
True/Present...Will not add the debug message to the mail log

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

##### -AddTimestamp
True/Present...Will add a timestamp to each line of the message string, regardless if the -NoTimestamp flag in Start-Log was set
False/Absent...Will only add a timestamp to each line of the message string if the -NoTimestamp flag in Start-Log was not set (which is the default behaviour)

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

##### -Force
True/Present...Will write the message to the log file, regardless of the rules for debug message logging (as set on Start-Log call)
False/Absent...Will only write the message to the log file if debug message logging rules apply (as set on Start-Log call)

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

##### -ForceMail
True/Present...Will write the message to the mail log, regardless of the rules for debug message logging (as set on Start-MailLog call)
False/Absent...Will only write the message to the mail log if debug message logging rules apply (as set on Start-MailLog call)

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

##### -WhatIf
```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

##### -Confirm
```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

##### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

#### OUTPUTS

None (Prints debug message)

#### NOTES
Can recieve the message through pipe



### Write-ErrorLog

#### SYNOPSIS
Emulates Write-Error but also logs the error in the file and mail log (if applicable)

#### SYNTAX

```
Write-ErrorLog [[-Message] <String>] [[-Category] <ErrorCategory>] [[-Err] <ErrorRecord>] [-NoOut] [-NoLog]
 [-NoMail] [-AddTimestamp] [-NoErrorDetails] [-Force] [-ForceMail] [-WhatIf] [-Confirm] [<CommonParameters>]
```

#### EXAMPLES

##### EXAMPLE 1
```
# Will write a error message to the console and file/mail log (depending on which of those have been started with their corresponding start logging cmdlet Start-Log and/or Start-MailLog).
Write-ErrorLog "Error example"
```

##### EXAMPLE 2
```
# Will write the error message "Critical error" along with all important error information to the console and file/mail log (depending on which of those have been started with their corresponding start logging cmdlet Start-Log and/or Start-MailLog).
# The Write-ErrorLog cmdlet is a bit more powerfull than the normal Write-Error cmdlet, in that it allows you to pass the error object via pipeline to the cmdlet and it will print out all needed information for you.
# You can, however, also use the -NoErrorDetails switch of this cmdlet to hide most of the error information to the outside world (you might need to use two seperate calls then, one for the logs with all details, and one for the console with no details).
try {    
    throw "Some test"
}
catch {    
    $_ | Write-ErrorLog "Critical error"
}
```

#### PARAMETERS

##### -Message
Additional error message

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

##### -Category
Error category of type \[System.Management.Automation.ErrorCategory\] (default is NotSpecified)

```yaml
Type: ErrorCategory
Parameter Sets: (All)
Aliases:
Accepted values: NotSpecified, OpenError, CloseError, DeviceError, DeadlockDetected, InvalidArgument, InvalidData, InvalidOperation, InvalidResult, InvalidType, MetadataError, NotImplemented, NotInstalled, ObjectNotFound, OperationStopped, OperationTimeout, SyntaxError, ParserError, PermissionDenied, ResourceBusy, ResourceExists, ResourceUnavailable, ReadError, WriteError, FromStdErr, SecurityError, ProtocolError, ConnectionError, AuthenticationError, LimitsExceeded, QuotaExceeded, NotEnabled

Required: False
Position: 2
Default value: NotSpecified
Accept pipeline input: False
Accept wildcard characters: False
```

##### -Err
Error object (as recieved by catch block), can also be recieved through pipe

```yaml
Type: ErrorRecord
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

##### -NoOut
True/Present...Will not print the error message to the console

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

##### -NoLog
True/Present...Will not log the error message to the log file

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

##### -NoMail
True/Present...Will not add the error message to the mail log

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

##### -AddTimestamp
True/Present...Will add a timestamp to each line of the message string, regardless if the -NoTimestamp flag in Start-Log was set
False/Absent...Will only add a timestamp to each line of the message string if the -NoTimestamp flag in Start-Log was not set (which is the default behaviour)

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

##### -NoErrorDetails
True/Present...Will not add details of the original error object to the error message
False/Absent...Will add details of the original error object to the error message

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

##### -Force
True/Present...Will write the message to the log file, regardless of the rules for error message logging (as set on Start-Log call)
False/Absent...Will only write the message to the log file if error message logging rules apply (as set on Start-Log call)

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

##### -ForceMail
True/Present...Will write the message to the mail log, regardless of the rules for error message logging (as set on Start-MailLog call)
False/Absent...Will only write the message to the mail log if error message logging rules apply (as set on Start-MailLog call)

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

##### -WhatIf
```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

##### -Confirm
```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

##### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

#### OUTPUTS

None (Prints error message)

#### NOTES
Can recieve error object through pipe, example call in catch block:
catch
{
    $_ | Write-ErrorLog "Example error message"
}



### Write-HostLog

#### SYNOPSIS
Emulates Write-Host but also logs the message in the file and mail log (if applicable)

#### SYNTAX

```
Write-HostLog [-Message] <Object> [-NoNewline] [[-ForegroundColor] <ConsoleColor>]
 [[-BackgroundColor] <ConsoleColor>] [-NoOut] [-NoLog] [-NoMail] [-AddTimestamp] [-Force] [-ForceMail]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

#### EXAMPLES

##### EXAMPLE 1
```
# Will write a host message to the console and file/mail log (depending on which of those have been started with their corresponding start logging cmdlet Start-Log and/or Start-MailLog).
Write-HostLog "Host example"
```

#### PARAMETERS

##### -Message
The host message

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

##### -NoNewline
Same as NoNewline switch in Write-Host cmdlet

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

##### -ForegroundColor
Same as ForegroundColor parameter in Write-Host cmdlet (only applies to message output to console, not logging)

```yaml
Type: ConsoleColor
Parameter Sets: (All)
Aliases:
Accepted values: Black, DarkBlue, DarkGreen, DarkCyan, DarkRed, DarkMagenta, DarkYellow, Gray, DarkGray, Blue, Green, Cyan, Red, Magenta, Yellow, White

Required: False
Position: 2
Default value: (Get-ConsoleForegroundColor)
Accept pipeline input: False
Accept wildcard characters: False
```

##### -BackgroundColor
Same as BackgroundColor parameter in Write-Host cmdlet (only applies to message output to console, not logging)

```yaml
Type: ConsoleColor
Parameter Sets: (All)
Aliases:
Accepted values: Black, DarkBlue, DarkGreen, DarkCyan, DarkRed, DarkMagenta, DarkYellow, Gray, DarkGray, Blue, Green, Cyan, Red, Magenta, Yellow, White

Required: False
Position: 3
Default value: (Get-ConsoleBackgroundColor)
Accept pipeline input: False
Accept wildcard characters: False
```

##### -NoOut
True/Present...Will not print the host message to the console

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

##### -NoLog
True/Present...Will not log the host message to the log file

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

##### -NoMail
True/Present...Will not add the host message to the mail log

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

##### -AddTimestamp
True/Present...Will add a timestamp to each line of the message string, regardless if the -NoTimestamp flag in Start-Log was set
False/Absent...Will only add a timestamp to each line of the message string if the -NoTimestamp flag in Start-Log was not set (which is the default behaviour)

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

##### -Force
True/Present...Will write the message to the log file, regardless of the rules for host message logging (as set on Start-Log call)
False/Absent...Will only write the message to the log file if host message logging rules apply (as set on Start-Log call)

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

##### -ForceMail
True/Present...Will write the message to the mail log, regardless of the rules for host message logging (as set on Start-MailLog call)
False/Absent...Will only write the message to the mail log if host message logging rules apply (as set on Start-MailLog call)

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

##### -WhatIf
```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

##### -Confirm
```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

##### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

#### OUTPUTS

None (Prints host message)

#### NOTES
Can recieve the message through pipe



### Write-InformationLog

#### SYNOPSIS
Emulates Write-Information but also logs the message in the file and mail log (if applicable)

#### SYNTAX

```
Write-InformationLog [-Message] <Object> [-NoOut] [-NoLog] [-NoMail] [-AddTimestamp] [-Force] [-ForceMail]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

#### EXAMPLES

##### EXAMPLE 1
```
# Will write a information message to the console and file/mail log (depending on which of those have been started with their corresponding start logging cmdlet Start-Log and/or Start-MailLog).
Write-InformationLog "Information example"
```

#### PARAMETERS

##### -Message
The information message

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

##### -NoOut
True/Present...Will not print the information message to the console

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

##### -NoLog
True/Present...Will not log the information message to the log file

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

##### -NoMail
True/Present...Will not add the information message to the mail log

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

##### -AddTimestamp
True/Present...Will add a timestamp to each line of the message string, regardless if the -NoTimestamp flag in Start-Log was set
False/Absent...Will only add a timestamp to each line of the message string if the -NoTimestamp flag in Start-Log was not set (which is the default behaviour)

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

##### -Force
True/Present...Will write the message to the log file, regardless of the rules for information message logging (as set on Start-Log call)
False/Absent...Will only write the message to the log file if information message logging rules apply (as set on Start-Log call)

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

##### -ForceMail
True/Present...Will write the message to the mail log, regardless of the rules for information message logging (as set on Start-MailLog call)
False/Absent...Will only write the message to the mail log if information message logging rules apply (as set on Start-MailLog call)

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

##### -WhatIf
```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

##### -Confirm
```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

##### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

#### OUTPUTS

None (Prints information message)

#### NOTES
Can recieve the message through pipe



### Write-OutputLog

#### SYNOPSIS
Emulates Write-Output but also logs the message in the file and mail log (if applicable)

#### SYNTAX

```
Write-OutputLog [-Message] <Object> [-NoOut] [-NoLog] [-NoMail] [-AddTimestamp] [-Force] [-ForceMail] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

#### EXAMPLES

##### EXAMPLE 1
```
# Will write a output message to the console and file/mail log (depending on which of those have been started with their corresponding start logging cmdlet Start-Log and/or Start-MailLog).
Write-OutputLog "Output example"
```

#### PARAMETERS

##### -Message
The output message

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

##### -NoOut
True/Present...Will not print the output message to the console

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

##### -NoLog
True/Present...Will not log the output message to the log file

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

##### -NoMail
True/Present...Will not add the output message to the mail log

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

##### -AddTimestamp
True/Present...Will add a timestamp to each line of the message string, regardless if the -NoTimestamp flag in Start-Log was set
False/Absent...Will only add a timestamp to each line of the message string if the -NoTimestamp flag in Start-Log was not set (which is the default behaviour)

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

##### -Force
True/Present...Will write the message to the log file, regardless of the rules for output message logging (as set on Start-Log call)
False/Absent...Will only write the message to the log file if output message logging rules apply (as set on Start-Log call)

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

##### -ForceMail
True/Present...Will write the message to the mail log, regardless of the rules for output message logging (as set on Start-MailLog call)
False/Absent...Will only write the message to the mail log if output message logging rules apply (as set on Start-MailLog call)

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

##### -WhatIf
```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

##### -Confirm
```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

##### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

#### OUTPUTS

None (Prints output message)

#### NOTES
Can recieve the message through pipe



### Write-VerboseLog

#### SYNOPSIS
Emulates Write-Verbose but also logs the message in the file and mail log (if applicable)

#### SYNTAX

```
Write-VerboseLog [-Message] <Object> [-NoOut] [-NoLog] [-NoMail] [-AddTimestamp] [-Force] [-ForceMail]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

#### EXAMPLES

##### EXAMPLE 1
```
# Will write a verbose message to the console and file/mail log (depending on which of those have been started with their corresponding start logging cmdlet Start-Log and/or Start-MailLog).
Write-VerboseLog "Verbose example"
```

#### PARAMETERS

##### -Message
The verbose message

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

##### -NoOut
True/Present...Will not print the verbose message to the console

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

##### -NoLog
True/Present...Will not log the verbose message to the log file

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

##### -NoMail
True/Present...Will not add the verbose message to the mail log

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

##### -AddTimestamp
True/Present...Will add a timestamp to each line of the message string, regardless if the -NoTimestamp flag in Start-Log was set
False/Absent...Will only add a timestamp to each line of the message string if the -NoTimestamp flag in Start-Log was not set (which is the default behaviour)

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

##### -Force
True/Present...Will write the message to the log file, regardless of the rules for verbose message logging (as set on Start-Log call)
False/Absent...Will only write the message to the log file if verbose message logging rules apply (as set on Start-Log call)

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

##### -ForceMail
True/Present...Will write the message to the mail log, regardless of the rules for verbose message logging (as set on Start-MailLog call)
False/Absent...Will only write the message to the mail log if verbose message logging rules apply (as set on Start-MailLog call)

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

##### -WhatIf
```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

##### -Confirm
```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

##### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

#### OUTPUTS

None (Prints verbose message)

#### NOTES
Can recieve the message through pipe



### Write-WarningLog

#### SYNOPSIS
Emulates Write-Warning but also logs the message in the file and mail log (if applicable)

#### SYNTAX

```
Write-WarningLog [-Message] <Object> [-NoOut] [-NoLog] [-NoMail] [-AddTimestamp] [-Force] [-ForceMail]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

#### EXAMPLES

##### EXAMPLE 1
```
# Will write a warning message to the console and file/mail log (depending on which of those have been started with their corresponding start logging cmdlet Start-Log and/or Start-MailLog).
Write-WarningLog "Warning example"
```

#### PARAMETERS

##### -Message
The warning message

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

##### -NoOut
True/Present...Will not print the warning message to the console

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

##### -NoLog
True/Present...Will not log the warning message to the log file

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

##### -NoMail
True/Present...Will not add the warning message to the mail log

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

##### -AddTimestamp
True/Present...Will add a timestamp to each line of the message string, regardless if the -NoTimestamp flag in Start-Log was set
False/Absent...Will only add a timestamp to each line of the message string if the -NoTimestamp flag in Start-Log was not set (which is the default behaviour)

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

##### -Force
True/Present...Will write the message to the log file, regardless of the rules for warning message logging (as set on Start-Log call)
False/Absent...Will only write the message to the log file if warning message logging rules apply (as set on Start-Log call)

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

##### -ForceMail
True/Present...Will write the message to the mail log, regardless of the rules for warning message logging (as set on Start-MailLog call)
False/Absent...Will only write the message to the mail log if warning message logging rules apply (as set on Start-MailLog call)

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

##### -WhatIf
```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

##### -Confirm
```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

##### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

#### OUTPUTS

None (Prints warning message)

#### NOTES
Can recieve the message through pipe



