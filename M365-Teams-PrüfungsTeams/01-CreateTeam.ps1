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

#
# EIN TEAM MUSS NATÜRLICH NUR EINMAL ERSTELLT WERDEN.
#

[CmdletBinding()]
param (
    [Parameter(Mandatory=$true)]
    [string]$Name,

    [Parameter(Mandatory=$true)]
    [string]$Beschreibung
)

Import-Module MicrosoftTeams -RequiredVersion "1.1.9"

###############################################################################
#
# Ausgabe eines Header
#
Write-Host ""
Write-Host ""
Write-Host "==============================================================================="
Write-Host "| Teams für Prüfungen wird erstellt"
Write-Host "|"
Write-Host "| Teams Name:         " -NoNewline
Write-Host $Name -ForegroundColor Cyan
Write-Host "| Teams Beschreibung: " -NoNewline
Write-Host $Beschreibung -ForegroundColor Cyan
Write-Host "==============================================================================="

###############################################################################
#
# Login
#
# Connect to Microsoft Teams - the old way
Write-Host ""
Write-Host " - Anmeldung bei Teams " -NoNewline
Write-Host "(Anmeldung im Browser)" -ForegroundColor Yellow
Connect-MicrosoftTeams | Out-Null

###############################################################################
#
# Erstelle das Prüfungs Team
#
$MailNickName = $Name -creplace "ü","ue" -creplace "ä","ae" -creplace "ö","oe" `
                      -creplace "Ü","Ue" -creplace "Ä","Ae" -creplace "Ö","Oe" `
                      -replace "ß","ss" `
                      -replace "[^a-zA-Z0-9]", ""

Write-Host ""
Write-Host " - Erstelle Team "  -NoNewline
Write-Host $Name  -NoNewline  -ForegroundColor Cyan
Write-Host " mit Mail-Addresse " -NoNewline
Write-Host "$MailNickName@monteaufkirchen.com"  -ForegroundColor Cyan
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
# Erstelle die Kanäle für die Schüler
#
Write-Host ""
Write-Host " - Erstelle Kanäle für die Prüfungen der SchülerInnen"
Import-Csv -Path "schueler.csv" | ForEach-Object{
    $ChannelName = $_.channel
    Write-Host "     - Erstelle Kanal: " -NoNewline
    Write-Host $ChannelName -ForegroundColor Cyan
    New-TeamChannel -GroupId $GroupId.GroupId -DisplayName $_.channel -MembershipType Private | Out-Null
}

###############################################################################
#
# Füge Lehrer als Owner zum Team hinzu
#
Write-Host ""
Write-Host " - Berechtige LehrerInnen als Owner im Team"
Import-Csv -Path "lehrer.csv" | ForEach-Object{ 
    $TeacherName = $_.upn
    Write-Host "     - Berechtige LehrerIn: " -NoNewline
    Write-Host $TeacherName -ForegroundColor Cyan
    Add-TeamUser -GroupId $GroupId.GroupId -user $_.upn -Role Owner
}

###############################################################################
#
# Füge Lehrer als Owner zu jedem Kanal hinzu
#
Write-Host ""
Write-Host " - Berechtige LehrerInnen als Owner in den Kanälen der Schüler"
Get-TeamChannel -GroupId $GroupId.GroupId -MembershipType Private | ForEach-Object {
    $TeamChannel = $_
    $TeamChannelName = $TeamChannel.DisplayName
    Write-Host ""
    Write-Host "     - Berechtige LehrerInnen im Kanal: " -NoNewline
    Write-Host $TeamChannelName -ForegroundColor Cyan

    Import-Csv -Path "lehrer.csv" | ForEach-Object{ 
        $Teacher = $_
        $TeacherName = $Teacher.upn
        Write-Host "         - Berechtige LehrerIn: " -NoNewline
        Write-Host $TeacherName  -ForegroundColor Cyan

        $MemberExist = Get-TeamChannelUser -GroupId $GroupId.GroupId -DisplayName $TeamChannel.DisplayName | Where-Object {$_.User -eq $Teacher.upn}
        if ( -not $MemberExist ) {
            Add-TeamChannelUser -GroupId $GroupId.GroupId -DisplayName $TeamChannel.DisplayName -User $_.upn
        }

        $OwnerExist = Get-TeamChannelUser -GroupId $GroupId.GroupId -DisplayName $TeamChannel.DisplayName -Role Owner | Where-Object {$_.User -eq $Teacher.upn}
        if ( -not $OwnerExist ) {
            Add-TeamChannelUser -GroupId $GroupId.GroupId -DisplayName $TeamChannel.DisplayName -User $_.upn -Role Owner
        }
    }
}

###############################################################################
#
# Füge Schüler als Mitglieder zum Team hinzu
#
Write-Host ""
Write-Host " - Berechtige SchülerInnen als Member im Team"
Import-Csv -Path "schueler.csv" | ForEach-Object{ 
    $StudentName = $_.upn
    Write-Host "     - Berechtige SchülerIn: " -NoNewline
    Write-Host $StudentName  -ForegroundColor Cyan
    Add-TeamUser -GroupId $GroupId.GroupId -user $_.upn -Role Member
}

###############################################################################
#
# Fertig
#
Write-Host ""
Write-Host " - done!"
Write-Host ""
Write-Host ""
    
###############################################################################
# EOF