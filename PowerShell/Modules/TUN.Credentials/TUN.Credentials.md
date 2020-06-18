# TUN.Credentials Module

## Content
  * [Content](#content)
  * [Description](#description)
  * [License](#license)
  * [TUN.Credentials Cmdlets](#tuncredentials-cmdlets)
    + [Clear-CredentialCache](#clear-credentialcache)
      - [SYNOPSIS](#synopsis)
      - [SYNTAX](#syntax)
      - [EXAMPLES](#examples)
        * [Example 1](#example-1)
      - [PARAMETERS](#parameters)
        * [-Name](#-name)
        * [-NoOutput](#-nooutput)
        * [CommonParameters](#commonparameters)
      - [OUTPUTS](#outputs)
    + [Use-NetworkCredential](#use-networkcredential)
      - [SYNOPSIS](#synopsis-1)
      - [SYNTAX](#syntax-1)
      - [EXAMPLES](#examples-1)
        * [Example 1](#example-1-1)
        * [Example 2](#example-2)
      - [PARAMETERS](#parameters-1)
        * [-Name](#-name-1)
        * [-File](#-file)
        * [-Message](#-message)
        * [-Usage](#-usage)
        * [-ErrorOnNone](#-erroronnone)
        * [-NoInput](#-noinput)
        * [-NoUnstored](#-nounstored)
        * [-Init](#-init)
        * [-NoOutput](#-nooutput-1)
        * [CommonParameters](#commonparameters-1)
      - [OUTPUTS](#outputs-1)
    + [Use-PSCredential](#use-pscredential)
      - [SYNOPSIS](#synopsis-2)
      - [SYNTAX](#syntax-2)
      - [EXAMPLES](#examples-2)
          + [Example 1](#example-1-2)
          + [Example 2](#example-2-1)
      - [PARAMETERS](#parameters-2)
        * [-Name](#-name-2)
        * [-File](#-file-1)
        * [-Message](#-message-1)
        * [-Usage](#-usage-1)
        * [-ErrorOnNone](#-erroronnone-1)
        * [-NoInput](#-noinput-1)
        * [-NoUnstored](#-nounstored-1)
        * [-Init](#-init-1)
        * [-NoOutput](#-nooutput-2)
        * [CommonParameters](#commonparameters-2)
      - [OUTPUTS](#outputs-2)

## Description
Methods to easily manage and use credentials

## License
This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0. If a copy of the MPL was not distributed with this file, You can obtain one at https://mozilla.org/MPL/2.0/

## TUN.Credentials Cmdlets

### Clear-CredentialCache

#### SYNOPSIS
Clears the credential cache (of all or one specific credential).
Needed at the beginning of a script, if the credentials should be entered again for each execution of the script, 
even if the script is still in the same scope (PS window).

#### SYNTAX

```
Clear-CredentialCache [[-Name] <String>] [-NoOutput] [<CommonParameters>]
```

#### EXAMPLES

##### Example 1
```powershell
Clear-CredentialCache -Name "TestExample"
```

Clears the cache with name "TestExample"

#### PARAMETERS

##### -Name
Name of the credentials to remove from cache, or empty if the whole cache should be cleared

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

##### -NoOutput
True/Present...Will not display any messages to the host

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

##### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

#### OUTPUTS
Nothing

### Use-NetworkCredential

#### SYNOPSIS
Gets Network credentials from a cache, file or user input (in that order) and save it to a file and cache.
If file and/or cache will be used to store the credentials can be configured.
The credentials will be cached and/or saved to a file as PS credentials.
So this method can also be used
to retrieve these credentials as PS credentials later, or retrieve the network credentials of previously
stored PS credentials.

#### SYNTAX

```
Use-NetworkCredential [[-Name] <String>] [[-File] <String>] [[-Message] <String>] [[-Usage] <String>]
 [-ErrorOnNone] [-NoInput] [-NoUnstored] [-Init] [-NoOutput] [<CommonParameters>]
```

#### EXAMPLES

##### Example 1
```powershell
Use-NetworkCredential -File ".\MyCredentials.cfg" -Init
```

Will store network credentials initialy in the MyCredentials.cfg file and immediatly end execution of script afterwards.

##### Example 2
```powershell
Use-NetworkCredential -File ".\MyCredentials.cfg"
```

Will read previously stored network credentials from MyCredentials.cfg file

#### PARAMETERS

##### -Name
Unique cache name for the credentials.
If no cache name is provided, the credentials will not be cached.

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

##### -File
File to store credentials in and read credentials from.
Information will be stored in the XML file format.
If no path for a credentials file was provided this method will not save the credentials to a file.

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

##### -Message
Message to prompt for credential input.
Default is "Please enter credentials"

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: Please enter credentials
Accept pipeline input: False
Accept wildcard characters: False
```

##### -Usage
Optional string describing the usage for the credentials (will be appended to "Initializing credentials for \<$Usage\>").
This will be ignored if the -NoOuptut switch was provided.

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

##### -ErrorOnNone
True/Present...Will throw an error if no credentials were found (even though File or Name was given in case of NoUnstored switch present)

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

##### -NoInput
True/Present...Will expect a name or file path to be provided and for there to already be a stored credential (exception: Init switch)

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

##### -NoUnstored
True/Present...Will not ask for credentials if no file path or cache name was provided

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

##### -Init
True/Present...If the File parameter was provided:
                The script will ask for the credentials to use, store them in a credentials file and will then immediatly exit the script.
                Used to either set up credentials file for the first time, or change/renew the credentials in the credential file, without performing the 
                actual task by the script.
The -WhatIf switch cannot be used to make sure the script is not performing its task, because it will also prevent
                the script from saving the credentials to the credentials file.
                This switch is ignored if the CredentialsFile parameter is not provided.
                If the Name parameter was provided:
                Will clear the cache of these credentials and ask for a user input of credentials.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

##### -NoOutput
True/Present...Will not display any messages to the host (except if canceling execution due to Init switch being present)

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: 9
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

##### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

#### OUTPUTS
Retrieved network credentials object or null

### Use-PSCredential

#### SYNOPSIS
Gets PS credentials from a cache, file or user input (in that order) and save it to a file and cache.
If file and/or cache will be used to store the credentials can be configured.

#### SYNTAX

```
Use-PSCredential [[-Name] <String>] [[-File] <String>] [[-Message] <String>] [[-Usage] <String>] [-ErrorOnNone]
 [-NoInput] [-NoUnstored] [-Init] [-NoOutput] [<CommonParameters>]
```

#### EXAMPLES

###### Example 1
```powershell
Use-PSCredential -File ".\MyCredentials.cfg" -Init
```

Will store powershell credentials initialy in the MyCredentials.cfg file and immediatly end execution of script afterwards.

###### Example 2
```powershell
Use-PSCredential -File ".\MyCredentials.cfg"
```

Will read previously stored powershell credentials from MyCredentials.cfg file

#### PARAMETERS

##### -Name
Unique cache name for the credentials.
If no cache name is provided, the credentials will not be cached.

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

##### -File
File to store credentials in and read credentials from.
Information will be stored in the XML file format.
If no path for a credentials file was provided this method will not save the credentials to a file.

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

##### -Message
Message to prompt for credential input.
Default is "Please enter credentials"

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: Please enter credentials
Accept pipeline input: False
Accept wildcard characters: False
```

##### -Usage
Optional string describing the usage for the credentials (will be appended to "Initializing credentials for \<$Usage\>").
This will be ignored if the -NoOuptut switch was provided.

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

##### -ErrorOnNone
True/Present...Will throw an error if no credentials were found (even though File or Name was given in case of NoUnstored switch present)

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

##### -NoInput
True/Present...Will expect a name or file path to be provided and for there to already be a stored credential (exception: Init switch)

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

##### -NoUnstored
True/Present...Will not ask for credentials if no file path or cache name was provided

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

##### -Init
True/Present...If the File parameter was provided:
                The script will ask for the credentials to use, store them in a credentials file and will then immediatly exit the script.
                Used to either set up credentials file for the first time, or change/renew the credentials in the credential file, without performing the 
                actual task by the script.
The -WhatIf switch cannot be used to make sure the script is not performing its task, because it will also prevent
                the script from saving the credentials to the credentials file.
                This switch is ignored if the CredentialsFile parameter is not provided.
                If the Name parameter was provided:
                Will clear the cache of these credentials and ask for a user input of credentials.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

##### -NoOutput
True/Present...Will not display any messages to the host (except if canceling execution due to Init switch being present)

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: 9
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

##### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

#### OUTPUTS
Retrieved PSCredential object or null


