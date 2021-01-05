<#
.SYNOPSIS
    This script will fetch the number of disks available in system with its Total space (in GigaByte), Free space (in GigaByte) as well as in (%).
    For each server provided in server list it will create a table and insert in final table. 
    The html file be created as well as an E-Mail will be send to given E-Mail id with details in body of the Email.

.DESCRIPTION
    The total Disk Space, and Free Space with its Ratio. As many number of servers provided in ServerList.
    It will send an email, if scheduled then it is monitoring technique for the Disk Space issues.

.INPUTS
    Server List - txt file with the name of the machines/servers which to examine.
    Please set varibles like server list path, output file path, E-Mail id and password as and when guided by comment through code.
.EXAMPLE
    .\Disk-Space.ps1
    This will execute the script and gives HTML file and email with the details in body.
.NOTES
    PUBLIC
.AUTHOR
    Harsh Parecha
    Sahista Patel
#>



#Set the input server list file path
$path = "C:\server_list.txt"
#Set the output file path
$outpath = "C:\disk_status_htm.html"
#Give Disk Space threshold in % (0 to 100)
$DiskThreshold = 50
#Set Email From
$EmailFrom = “example@outlook.com”
#Set Email To
$EmailTo = “example@outlook.com"
#Set Email Subject
$Subject = “Disk Space Status”
#Set SMTP Server Details
$SMTPServer = “smtp.outlook.com”
$SMTPClient = New-Object Net.Mail.SmtpClient($SmtpServer, 587)
$SMTPClient.Credentials = New-Object System.Net.NetworkCredential(“example@outlook.com”, “Password”);

$Row = @()
$count = 0
$alertcount =0
$sttab = "<table>
        <tr>
            <th>Drive</th>
            <th>Total Size (GB)</th>
            <th>Free Space (GB)</th>
            <th>Free Space (%)</th>
        </tr>"
$tab = $sttab

$Row = "<html><head><style>
               table {
                        font-family: arial, sans-serif;
                        border: 1px solid #1C6EA4;
                        background-color: #AED6F1;
                        border-collapse: collapse;
                        width: auto;
                     }
               th {
                        font-size: 13px;
                        border: 2px solid #D0E4F5;
                   }
               td {
                        font-size: 13px;
                        border: 1px solid #D0E4F5;
                        width: auto;
                  }
              }
    </style>
    <title>Disk Space</title>
    </head>
    <h2>Disk Space Status</h2>

    <body>
<table>"

[System.IO.File]::ReadLines($path) | ForEach-Object {
       
       $computername = $_
      try{
        $disks = Get-WmiObject -ComputerName $computername -Class Win32_LogicalDisk -Filter "DriveType < 6";

        foreach($disk in $disks)
        {
            $deviceID = $disk.DeviceID;
            [float]$size = $disk.Size;
            [float]$freespace = $disk.FreeSpace;
            
            if($size -ne 0){     
                $percentFree = [Math]::Round(($freespace / $size) * 100, 2);
                $sizeGB = [Math]::Round($size / 1073741824, 2);
                $freeSpaceGB = [Math]::Round($freespace / 1073741824, 2);
 
                if($percentFree -lt $DiskThreshold)
                {
                    $tab += "<tr><td>$deviceID</td><td>$sizeGB</td><td>$freeSpaceGB</td><td>$percentFree</td></tr>"
                    $count += 1;
                }
            }
        }
        if($count-ne 0){
               $alertcount += 1
               $tab += "</table>"
               $Row += "<tr><td style='font-size: 15px; font-weight: bold; color:#FDFEFE' bgcolor='#2471A3'>Alert: $alertcount</td></tr><tr><td style='font-size: 15px; font-weight: bold;'>Server Name: $computername</td></tr>"
               $Row += "<tr><td style='width: auto; word-break:keep-all;'>$tab</td></tr>"
               $tab = $sttab
               $count = 0
        }
      }
      catch {
           $computername + " Not available."
        }         
     
    }

if ($alertcount -ne 0){
    $Row += "</table></body></html>"
}
else{
    $Row += "</table><h4>No disk space issue encountered for all the listed servers.</h4></body></html>"
}

Set-Content $outpath $Row
$Body = $Row

$SMTPClient.EnableSsl = $true
# Create the message
$mail = New-Object System.Net.Mail.Mailmessage $EmailFrom, $EmailTo, $Subject, $Body
$mail.IsBodyHTML=$true
$SMTPClient.Send($mail)
