<# 
ScriptFunction: Gather information regarding a particular computer object's network settings﻿
Author: Josh Kennedy
Date: 2020/01/20
#>

$DPs = Get-Content "C:\TEMP\DPs.txt"
$DPStatus = New-Object -TypeName psobject

foreach ($DP in $DPs){

    if (Test-Connection -ComputerName $DP -Count 1 -ErrorAction SilentlyContinue){
        $Gateway = gwmi -computername $DP win32_networkadapterconfiguration -ErrorAction SilentlyContinue | ?{$_.ipenabled} | select defaultipgateway
        $Gateway = $Gateway.defaultipgateway | Out-String
        $Ping = Test-Connection -ComputerName $DP -Count 1 -ErrorAction SilentlyContinue
        $DPStatus | Add-Member -MemberType NoteProperty -Name Pingable -Value "Yes" -Force
        $DPStatus | Add-Member -MemberType NoteProperty -Name HostName -Value $DP -Force
        $DPStatus | Add-Member -MemberType NoteProperty -Name IPAddress -Value $Ping.IPV4Address -Force
        $DPStatus | Add-Member -MemberType NoteProperty -Name Gateway -Value $Gateway -Force
        $DPStatus | Export-Csv -NoTypeInformation -Append -Path "C:\temp\DPStatus.csv"   
    
    
    }
    else {
        $Gateway = gwmi -computername $DP win32_networkadapterconfiguration -ErrorAction SilentlyContinue | ?{$_.ipenabled} | select defaultipgateway
        $Gateway = $Gateway.defaultipgateway | Out-String
        $Ping = Test-Connection -ComputerName $DP -Count 1 -ErrorAction SilentlyContinue
        $DPStatus | Add-Member -MemberType NoteProperty -Name Pingable -Value "No" -Force
        $DPStatus | Add-Member -MemberType NoteProperty -Name HostName -Value $DP -Force
        $DPStatus | Add-Member -MemberType NoteProperty -Name IPAddress -Value "Null" -Force
        $DPStatus | Add-Member -MemberType NoteProperty -Name Gateway -Value "Null" -Force
        $DPStatus | Export-Csv -NoTypeInformation -Append -Path "C:\temp\DPStatus.csv"    
    
    }

    
}
