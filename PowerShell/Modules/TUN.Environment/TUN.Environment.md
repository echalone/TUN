# TUN.Environment Module

## Content
  * [Content](#content)
  * [Description](#description)
  * [License](#license)
  * [TUN.Environment Cmdlets](#tunenvironment-cmdlets)
    + [Initialize-Environment](#initialize-environment)
      - [SYNOPSIS](#synopsis)
      - [SYNTAX](#syntax)
      - [EXAMPLES](#examples)
        * [Example 1](#example-1)
      - [PARAMETERS](#parameters)
        * [CommonParameters](#commonparameters)
      - [OUTPUTS](#outputs)

## Description
Sets up environment variables if not set up correctly (i.e. Scheduled Tasks without logged in user)

## License
This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0. If a copy of the MPL was not distributed with this file, You can obtain one at https://mozilla.org/MPL/2.0/

## TUN.Environment Cmdlets

### Initialize-Environment

#### SYNOPSIS
Sets up environment variables (from registry)

#### SYNTAX

```
Initialize-Environment [<CommonParameters>]
```

#### EXAMPLES

##### Example 1
```powershell
Initialize-Environment
```

Initializes environment variables

#### PARAMETERS

##### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

#### OUTPUTS
Nothing
