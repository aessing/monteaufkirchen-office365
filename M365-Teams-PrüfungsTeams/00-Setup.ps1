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
# DIESES INSTALLATION DER POWERSHELL UND DES TEAMS POWERSHELL MODULS MUSS AUF
# JEDEM PC NUR BEIM ERSTEN MAL DURCHGEFÜHRT WERDEN.
#

###############################################################################
#
# Zuerst muss Powershell auf dem Computer Installiert werden
#
# Bei einem Windows 10 PC kann PowerShell über den Microsoft Store installiert
# werden (empfohlene Methode):
# https://www.microsoft.com/de-de/p/powershell/9mz1snwt0n5d?activetab=pivot:overviewtab
# Alternativ geht dieses auch mittels der folgenden Anleitung:
# https://docs.microsoft.com/de-de/powershell/scripting/install/installing-powershell-core-on-windows?view=powershell-7.1
#
# Solltest DU einen Apple Mac besitzen, bitte die Schritte in der folgenden
# Anleitung durchführen:
# https://docs.microsoft.com/de-de/powershell/scripting/install/installing-powershell-core-on-macos?view=powershell-7.1 
#
# Auch unter Linux ist das installieren der PowerShell möglich:
# https://docs.microsoft.com/de-de/powershell/scripting/install/installing-powershell-core-on-linux?view=powershell-7.1
#

###############################################################################
#
# Um nun Teams aus der PowerShell zu administrieren, benötigen wir das 
# Teams PowerShell Modul. Dazu muss der folgende Befehl in der gerade
# installierten PowerShell installiert werden.
# 
# https://docs.microsoft.com/de-de/MicrosoftTeams/teams-powershell-install
#
Install-Module MicrosoftTeams -AllowPrerelease -RequiredVersion "1.1.9-preview" -Scope CurrentUser

###############################################################################
# EOF