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

Import-Module MicrosoftTeams -RequiredVersion "1.1.11"

###############################################################################
#
# Ausgabe eines Header
#
Write-Host ""
Write-Host ""
Write-Host "==============================================================================="
Write-Host "| Team für Prüfungen wird archiviert"
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
# Archiviere Team
#
$GroupId = Get-Team -DisplayName $Name

Write-Host ""
Write-Host " - Archiviere das Team: " -NoNewline
Write-Host $Name -ForegroundColor Cyan
Set-TeamArchivedState -GroupId $GroupId.GroupId -Archived:$true -SetSpoSiteReadOnlyForMembers:$true | Out-Null

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