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
    [string]$Name
)

Import-Module MicrosoftTeams -RequiredVersion "1.1.9"

###############################################################################
#
# Ausgabe eines Header
#
Write-Host ""
Write-Host ""
Write-Host "==============================================================================="
Write-Host "| SchülerInnen werden aus Ihren Kanälen entfernt"
Write-Host "| " -NoNewline
Write-Host "Zugriff wird verweigert" -ForegroundColor Red
Write-Host "|"
Write-Host "| Team Name: " -NoNewline
Write-Host $Name -ForegroundColor Cyan
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
# Entferne SchülerInnen aus den Kanälen
#
$GroupId = Get-Team -DisplayName $Name

Get-TeamChannel -GroupId $GroupId.GroupId -MembershipType Private | ForEach-Object {
    $TeamChannel = $_
    $TeamChannelName = $TeamChannel.DisplayName
    Write-Host ""
    Write-Host " - Entferne SchülerInnen aus dem Kanal: " -NoNewline
    Write-Host $TeamChannelName -ForegroundColor Cyan

    Import-Csv -Path "schueler.csv" | ForEach-Object{ 
        $Student = $_
        $StudentName = $Student.upn

        if ($Student.channel -eq $TeamChannel.DisplayName) {
            Write-Host "     - SchülerIn: " -NoNewline
            Write-Host $StudentName -ForegroundColor Cyan
            $MemberExist = Get-TeamChannelUser -GroupId $GroupId.GroupId -DisplayName $TeamChannel.DisplayName | Where-Object {$_.User -eq $Student.upn}
            if ( $MemberExist ) {
                Remove-TeamChannelUser -GroupId $GroupId.GroupId -DisplayName $TeamChannel.DisplayName -User $_.upn
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