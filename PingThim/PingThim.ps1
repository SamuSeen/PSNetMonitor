<#PSScriptInfo

.VERSION 0.1

.GUID 

.AUTHOR Bartlomiej Patyna

.COMPANYNAME Bartlomiej Patyna

.COPYRIGHT (C) Bartlomiej Patyna. All rights reserved.

.TAGS Network Device Status Report Monitor CSV

.ICONURI

.EXTERNALMODULEDEPENDENCIES

.REQUIREDSCRIPTS

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES

#>

<#
    .SYNOPSIS
    Monitors avaibility of multiple network devices.

    .DESCRIPTION
    This script will allow to monitor multiple network devices using interface.
    
    The command is as follows:

    $creds = Get-Credential
    $creds.Password | ConvertFrom-SecureString | Set-Content c:\foo\ps-script-pwd.txt
    
    .PARAMETER List
    The path to a CSV file with a list of IP addresses and device names to monitor separated by a comma.
    Please see the networkdevices-example.csv file for how to structure your own file.

    .EXAMPLE
    NetDev-Status.ps1 -List C:\foo\networkdevices.csv -O C:\foo -Refresh 300
    Using the above command the script will execute using the list of network devices and output a html report called NetDev-Status-Report.htm to C:\foo.
    The status of the network devices will refresh every 5 minutes and the web page will have the default dark theme.
#>
