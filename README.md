# Disk-Space-Out-Of-Threshold

This script will fetch the number of disks available in system and  (if it crosses the mentioned threshold in code) with its Total space (in GigaByte), Free space (in GigaByte) as well as in (%). For each server provided in server list it will create a table and insert in final table. The html file be created as well as an E-Mail will be send to given E-Mail id with details in body of the Email.

# Prerequisites

Windows OS - Powershell

# Note

Server Name - Machine Name<br>
Drive Name - Disk Name<br>
Total Size (GB) - Total size of the Drive in GigaByte<br>
Free Space (GB) - Free Space of the respective Drive in GigaByte<br>
Free Space (%) - Free Space of the respective Drive in Ratio (%)<br>

# Use

Open Powershell<br>
run "C:\Top10_CPU_Memory.ps1"

# Input
Server list file path to (example) {$path = "C:\server_list.txt"}<br>
The output file path to (example) {$outpath = "C:\disk_status_htm.html"}<br>
Give Disk Space threshold in % (0 to 100) (example) {$DiskThreshold = 50}<br>
Set Email From (example) {$EmailFrom = “example@outlook.com”}<br>
Set Email To (example) {$EmailTo = “example@outlook.com"}<br>
Set Email Subject (example) {$Subject = “Disk Space Status”}<br>
Set SMTP Server Details (example) {<br> 
$SMTPServer = “smtp.outlook.com” <br>
$SMTPClient = New-Object Net.Mail.SmtpClient($SmtpServer, 587)<br>
$SMTPClient.Credentials = New-Object System.Net.NetworkCredential(“example@outlook.com”, “Password”);}


# Example O/P
![alt text](https://github.com/Sahista-Patel/Disk-Space-Out-Of-Threshold/blob/Powershell/disk_space.PNG)


# License
Copyright 2020 Harsh & Sahista

# Contribution
[Harsh Parecha] (https://github.com/TheLastJediCoder)
[Sahista Patel] (https://github.com/Sahista-Patel)<br>
We love contributions, please comment to contribute!

# Code of Conduct
Contributors have adopted the Covenant as its Code of Conduct. Please understand copyright and what actions will not be abided.
