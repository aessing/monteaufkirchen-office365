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
Write-Host "| SchülerInnen werden zu Ihren Kanälen hinzugefügt"
Write-Host "| " -NoNewline
Write-Host "Zugriff wird erlaubt" -ForegroundColor Green
Write-Host "|"
Write-Host "| Team Name:         " -NoNewline
Write-Host $Name -ForegroundColor Cyan
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
# Füge SchülerInnen als Member zu jedem Kanal hinzu
#
$GroupId = Get-Team -DisplayName $Name.Trim() | Where-Object Displayname -eq $Name.Trim()

Get-TeamChannel -GroupId $GroupId.GroupId -MembershipType Private | ForEach-Object {
    $TeamChannel = $_
    $TeamChannelName = $TeamChannel.DisplayName
    $TeamChannelName = $TeamChannelName.Trim()
    Write-Host ""
    Write-Host " - Füge SchülerInnen zum Kanal hinzu: " -NoNewline
    Write-Host $TeamChannelName -ForegroundColor Cyan

    Import-Csv -Path $SchuelerCSV | ForEach-Object{ 
        $Student = $_
        $StudentName = $Student.upn
        $StudentName = $StudentName.Trim()

        if ($Student.channel -eq $TeamChannelName) {
            Write-Host "     - SchülerIn: " -NoNewline
            Write-Host $StudentName -ForegroundColor Cyan
            $MemberExist = Get-TeamChannelUser -GroupId $GroupId.GroupId -DisplayName $TeamChannelName | Where-Object {$_.User -eq $StudentName}
            if ( -not $MemberExist ) {
                Add-TeamChannelUser -GroupId $GroupId.GroupId -DisplayName $TeamChannelName -User $_.upn
            }
        }
    }
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