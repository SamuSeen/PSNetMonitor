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

# Set up command line switches/parameters and what variables they map to.
[CmdletBinding()]
Param(
    [Parameter(Mandatory = $True)]
    [Alias("List")]
    [ValidateScript({ Test-Path -Path $_ -PathType Leaf })]
    [string]$DeviceFile)

# Report in the console that monitor mode is enabled.
If ($RefreshTime -ne 0) {
    Write-Host "Monitor mode: Enabled"
}

Else {
    Write-Host "Monitor mode: Disabled"
}

# Begining of the loop. At the bottom of the script the loop is broken if the refresh option is not configured.
Do {
    ## Clear variables if they are set, otherwise data becomes corrupted.
    If ($Device) { Clear-Variable Device }
    If ($DeviceList) { Clear-Variable DeviceList }
    If ($DeviceListSorted) { Clear-Variable DeviceList }
    If ($DeviceListFinal) { Clear-Variable DeviceListFinal }
    If ($DevicesOffline) { Clear-Variable DevicesOffline }
    If ($DevicesOnline) { Clear-Variable DevicesOnline }
    If ($PingStatus) { Clear-Variable PingStatus }
    If ($ResponseTime) { Clear-Variable ResponseTime }

    # Import the CSV file data.
    $DeviceList = Import-Csv -Path $DeviceFile

    # Creating Result array.
    $ResultArr = @()

    # Sort devices in the device list alphabetically based on Name.
    $DeviceListSorted = $DeviceList | Sort-Object -Property Name

    # This loop sorts the devices by their offline/online status.
    ForEach ($Device in $DeviceListSorted) {
        $PingStatus = Test-Connection -ComputerName $Device.IP -Count 1 -Quiet

        If ($PingStatus -eq $False) {
            $DevicesOffline += @($Device)
        }

        Else {
            $DevicesOnline += @($Device)
        }
    }

    # If there are online devices then put the final list together.
    If ($DevicesOnline.Count -ne 0) {
        $DeviceListFinal = $DevicesOffline + $DevicesOnline
    }

    # If there are no online devices create the final list. This prevents the 'phantom device' bug when all devices are offline.
    Else {
        $DeviceListFinal = $DevicesOffline
    }

    # Ping the devices in the final device list generated above.
    ForEach ($Device in $DeviceListFinal) {
        $PingStatus = Test-Connection -ComputerName $Device.IP -Count 1 -Quiet

        # If the device responds, get the response time.
        If ($PingStatus -eq $True) {
            $ResponseTime = Test-Connection -ComputerName $Device.IP -Count 1 | Select-Object -ExpandProperty ResponseTime
        }

        # Put the results together in the array.
        $ResultArr += New-Object PSObject -Property @{
            Status       = $PingStatus
            DeviceName   = $Device.Name
            DeviceIP     = $Device.IP
            ResponseTime = $ResponseTime
        }
        
    }


    # If the result is not empty, put the report file together.
    If ($Null -ne $ResultArr) {

    }
}

# If the refresh time option is not configured, stop the loop.
Until ($True)

# End
