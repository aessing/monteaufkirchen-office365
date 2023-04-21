# =============================================================================
# TEAMS FÜR PRÜFUNGEN
# Montessori-Schule Aufkirchen
# https://github.com/aessing/montessori-aufkirchen
# -----------------------------------------------------------------------------
# Developer.......: Andre Essing (https://www.andre-essing.de/)
#                                (https://github.com/aessing)
#                                (https://twitter.com/aessing)
#                                (https://www.linkedin.com/in/aessing/)
# -----------------------------------------------------------------------------
# THIS CODE AND INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND,
# EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR PURPOSE.
# =============================================================================

[CmdletBinding()]
param (
    [Parameter(Mandatory=$true)]
    [string]$Name,

    [Parameter(Mandatory=$true)]
    [string]$Beschreibung,

    [Parameter(Mandatory=$true)]
    [string]$LehrerCSV,

    [Parameter(Mandatory=$true)]
    [string]$SchuelerCSV
)

Import-Module MicrosoftTeams -RequiredVersion "5.1.0"

###############################################################################
#
# Ausgabe eines Header
#
Write-Host ""
Write-Host ""
Write-Host "==============================================================================="
Write-Host "| Team für Prüfungen wird erstellt"
Write-Host "|"
Write-Host "| Team Name:         " -NoNewline
Write-Host $Name -ForegroundColor Cyan
Write-Host "| Team Beschreibung: " -NoNewline
Write-Host $Beschreibung -ForegroundColor Cyan
Write-Host "| Lehrer CSV-Datei:  " -NoNewline
Write-Host $LehrerCSV -ForegroundColor Cyan
Write-Host "| Schüler CSV-Datei: " -NoNewline
Write-Host $SchuelerCSV -ForegroundColor Cyan
Write-Host "==============================================================================="

###############################################################################
#
# Login
#
Write-Host ""
Write-Host " - Anmeldung bei Teams " -NoNewline
Write-Host "(Anmeldung im Browser)" -ForegroundColor Yellow
Connect-MicrosoftTeams | Out-Null

###############################################################################
#
# Erstelle das Prüfungs Team
#
$Name = $Name.Trim()
$Beschreibung = $Beschreibung.Trim()

$MailNickName = $Name -creplace "ü","ue" -creplace "ä","ae" -creplace "ö","oe" `
                      -creplace "Ü","Ue" -creplace "Ä","Ae" -creplace "Ö","Oe" `
                      -replace "ß","ss" `
                      -replace "[^a-zA-Z0-9]", ""

Write-Host ""
Write-Host " - Erstelle Team "  -NoNewline
Write-Host $Name  -NoNewline  -ForegroundColor Cyan
Write-Host " mit Mail-Nickname " -NoNewline
Write-Host "$MailNickName"  -ForegroundColor Cyan
$GroupId = New-Team -DisplayName $Name -Description $Beschreibung -Visibility Private `
                    -MailNickName $MailNickName `
                    -AllowGiphy $true -GiphyContentRating Moderate `
                    -AllowStickersAndMemes $true -AllowCustomMemes $false `
                    -AllowChannelMentions $true -AllowTeamMentions $true `
                    -AllowCreateUpdateChannels $false -AllowDeleteChannels $false -AllowCreateUpdateRemoveTabs $false `
                    -AllowGuestCreateUpdateChannels $false -AllowGuestDeleteChannels $false `
                    -AllowAddRemoveApps $false -AllowCreateUpdateRemoveConnectors $false  `
                    -AllowUserEditMessages $true -AllowUserDeleteMessages $true -AllowOwnerDeleteMessages $true `
                    -ShowInTeamsSearchAndSuggestions $false

###############################################################################
#
# Füge LehrerInnen als Owner zum Team hinzu
#
Write-Host ""
Write-Host " - Berechtige LehrerInnen als Owner im Team"
Import-Csv -Path $LehrerCSV | ForEach-Object{ 
    $TeacherName = $_.upn
    $TeacherName = $TeacherName.Trim()
    Write-Host "     - Berechtige LehrerIn: " -NoNewline
    Write-Host $TeacherName -ForegroundColor Cyan
    Add-TeamUser -GroupId $GroupId.GroupId -user $TeacherName -Role Owner
}

###############################################################################
#
# Erstelle die Kanäle für die SchülerInnen
#
Write-Host ""
Write-Host " - Erstelle Kanäle für die Prüfungen der SchülerInnen"
Import-Csv -Path $SchuelerCSV | ForEach-Object{
    $ChannelName = $_.channel
    $ChannelName = $ChannelName.Trim()
    Write-Host "     - Erstelle Kanal: " -NoNewline
    Write-Host $ChannelName -ForegroundColor Cyan
    New-TeamChannel -GroupId $GroupId.GroupId -DisplayName $ChannelName -MembershipType Private | Out-Null
}

###############################################################################
#
# Füge LehrerInnen als Owner zu jedem Kanal hinzu
#
Write-Host ""
Write-Host " - Berechtige LehrerInnen als Owner in den Kanälen der SchülerInnen"
Get-TeamChannel -GroupId $GroupId.GroupId -MembershipType Private | ForEach-Object {
    $TeamChannel = $_
    $TeamChannelName = $TeamChannel.DisplayName
    $TeamChannelName = $TeamChannelName.Trim()
    Write-Host ""
    Write-Host "     - Berechtige LehrerInnen im Kanal: " -NoNewline
    Write-Host $TeamChannelName -ForegroundColor Cyan

    Import-Csv -Path $LehrerCSV | ForEach-Object{ 
        $Teacher = $_
        $TeacherName = $Teacher.upn
        $TeacherName = $TeacherName.Trim()
        Write-Host "         - Berechtige LehrerIn: " -NoNewline
        Write-Host $TeacherName  -ForegroundColor Cyan

        $MemberExist = Get-TeamChannelUser -GroupId $GroupId.GroupId -DisplayName $TeamChannelName | Where-Object {$_.User -eq $TeacherName}
        if ( -not $MemberExist ) {
            Add-TeamChannelUser -GroupId $GroupId.GroupId -DisplayName $TeamChannelName -User $_.upn
        }

        $OwnerExist = Get-TeamChannelUser -GroupId $GroupId.GroupId -DisplayName $TeamChannelName -Role Owner | Where-Object {$_.User -eq $TeacherName}
        if ( -not $OwnerExist ) {
            Add-TeamChannelUser -GroupId $GroupId.GroupId -DisplayName $TeamChannelName -User $_.upn -Role Owner
        }
    }
}

###############################################################################
#
# Füge SchülerInnen als Mitglieder zum Team hinzu
#
Write-Host ""
Write-Host " - Berechtige SchülerInnen als Member im Team"
Import-Csv -Path $SchuelerCSV | ForEach-Object{ 
    $StudentName = $_.upn
    $StudentName = $StudentName.Trim()
    Write-Host "     - Berechtige SchülerIn: " -NoNewline
    Write-Host $StudentName  -ForegroundColor Cyan
    Add-TeamUser -GroupId $GroupId.GroupId -user $StudentName -Role Member
}

###############################################################################
#
# Fertig
#
Write-Host ""
Write-Host " - fertig!"
Write-Host ""
Write-Host ""
    
###############################################################################
# EOF