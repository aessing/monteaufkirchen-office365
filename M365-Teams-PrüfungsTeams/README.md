![Montessori Erding Logo](../docs/images/banner.jpg)

# Teams für Prüfungen

[Montessori-Schule Aufkirchen - http://www.montessori-erding.de/schule](http://www.montessori-erding.de/schule/)  
[GitHub Repository - https://github.com/aessing/montessori-aufkirchen](https://github.com/aessing/montessori-aufkirchen)

Die Skripte dieses Projektes sind dazu gedacht SchülerInnen ein Teams mit privaten Kanälen bereit zustellen, damit Sie an Ihren Prüfungen arbeiten können. Dazu wird ein Team erstellt und jeweiles ein privater Kanal pro SchülerIn. SchülerInnen können dabei nur auf den eigenen Teams-Kanal zugreifen.

# Developer

### Andre Essing
[<img alt="Link to Andres website" src="https://img.shields.io/static/v1?label=My%20website&message=Visit%20me&labelColor=56B7E6&logoColor=ffffff&style=for-the-badge&logo=microsoft-edge" />](https://www.andre-essing.de)
[<img alt="Link to the GitHub profile of Andre" src="https://img.shields.io/static/v1?label=GitHub&message=Follow%20me&labelColor=181717&logoColor=ffffff&style=for-the-badge&logo=GitHub" />](https://github.com/aessing) 
[<img alt="Link to the LinkedIn profile of Andre" src="https://img.shields.io/static/v1?label=LinkedIn&message=Follow%20me&labelColor=0077B5&logoColor=ffffff&style=for-the-badge&logo=linkedin" />](https://www.linkedin.com/in/aessing/)
[<img alt="Link to the Twitter profile of Andre" src="https://img.shields.io/static/v1?label=Twitter&message=Follow%20me&labelColor=1DA1F2&logoColor=ffffff&style=for-the-badge&logo=twitter" />](https://twitter.com/aessing)

# Skripte

- __01-CreateTeam.ps1__  
Mit diesem Skript kann ein Team für Prüfungen erstellt werden. Dabei werden LehrerInnen und SchülerInnen aus der jeweiligen CSV-Datei hinzugefügt und pro SchülerIn ein Kanal erzeugt. Nach Ausführen des Skriptes können die Schüler noch nicht auf Ihren Kanal zugreifen. Dazu muss erst das Skript _02-AddStudentsToChannels.ps1_ ausgeführt werden.  
Das Skript muss mit zwei Parametern aufgerufen werden:  
  - Name  
  - Beschreibung  
  ```PowerShell
  .\01-CreateTeam.ps1 -Name "Prüfung 2020-21" -Beschreibung "Prüfungen im Jahrgang 2020/21"
  ```
> :exclamation: Pro Team können maximal 30 private Kanäle angelegt werden. Somit können maximal 30 SchülerInnen pro Team die Prüfung durchführen. Bei mehr Schülern müssen evtl. mehrere Teams erstellt werden.

- __02-AddStudentsToChannels.ps1__  
Dieses Skript fügt jeden SchülerIn mithilfe der _schueler.csv_ als Member zu seinem Kanal hinzu und erlaubt damit das arbeiten an der Prüfung.  
Das Skript muss mit einem Parameter aufgerufen werden:  
  - Name  
  ```PowerShell
  .\02-AddStudentsToChannels.ps1 -Name "Prüfung 2020-21"
  ```

- __03-RemoveStudentsFromChannels.ps1__  
Dieses Skript entfernt jeden SchülerIn mithilfe der _schueler.csv_ aus seinem Kanal und verhindert damit das arbeiten an der Prüfung.  
Das Skript muss mit einem Parameter aufgerufen werden:  
  - Name  
  ```PowerShell
  .\03-RemoveStudentsFromChannels.ps1 -Name "Prüfung 2020-21"
  ```

- __04-ArchiveTeam.ps1__  
Nach Beendigung der Prüfung kann das Prüfungs-Team archiviert werden. Damit wird das Team in einen Lese-Modus versetzt in dem keine Änderungen mehr am Team erlaubt sind. [https://docs.microsoft.com/de-de/microsoftteams/archive-or-delete-a-team](https://docs.microsoft.com/de-de/microsoftteams/archive-or-delete-a-team)
Das Skript muss mit einem Parameter aufgerufen werden:  
  - Name
  ```PowerShell
  .\04-ArchiveTeam.ps1 -Name "Prüfung 2020-21"
  ```

### Unterstützende Dateien

- __lehrer.csv__  
Im _lehrer.csv_ müssen die UPNS (Office 365 Mail-Adressen) aller LehrerInnen gelistet werden, die an der Prüfung mitarbeiten.  
```
upn
lehrer01@domäne.de
lehrer02@domäne.de
lehrer03@domäne.de
```
> :exclamation: Die erste Zeile im CSV (Header) darf nicht entfernt werden.


- __schueler.csv__  
Im _schueler.csv_ müssen die UPNS (Office 365 Mail-Adressen) aller SchülerInnen gelistet werden, die Ihre Prüfung ablegen. Auch muss der Name des Kanals angegeben werden, in dem der jeweilige SchülerIn arbeiten soll.  
```
upn,channel
schueler01@domäne.de,Prüfung - Schüler 01
schueler02@domäne.de,Prüfung - Schüler 02
schueler03@domäne.de,Prüfung - Schüler 03
schueler04@domäne.de,Prüfung - Schüler 04
schueler05@domäne.de,Prüfung - Schüler 05
```
> :exclamation: Die erste Zeile im CSV (Header) darf nicht entfernt werden.

---
> THIS CODE AND INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR PURPOSE.
---

# Installation

Die Installation von PowerShell und des Teams-PowerShell-Moduls muss auf jedem Computer vor dem ausführen der Skripte durchgeführt werden.

## 1. PowerShell Installation

Zuerst muss PowerShell auf dem Computer installiert werden

:computer: Bei einem Windows 10 PC kann PowerShell über den [Microsoft Store](https://www.microsoft.com/de-de/p/powershell/9mz1snwt0n5d?activetab=pivot:overviewtab) installiert werden. __(empfohlene Methode)__  
Alternativ geht dieses auch mittels der [Anleitung für die manuelle Installation unter Windows](https://docs.microsoft.com/de-de/powershell/scripting/install/installing-powershell-core-on-windows?view=powershell-7.1)

:apple: Solltest Du einen Apple Mac besitzen, bitte die Schritte in der [Anleitung für macOS](https://docs.microsoft.com/de-de/powershell/scripting/install/installing-powershell-core-on-macos?view=powershell-7.1) durchführen.

:penguin: Auch unter [Linux ist das Installieren der PowerShell](https://docs.microsoft.com/de-de/powershell/scripting/install/installing-powershell-core-on-linux?view=powershell-7.1) möglich.

## 2. Installation des Teams-PowerShell-Moduls
Um nun Teams aus der PowerShell verwalten zu können, [benötigen wir das Teams-PowerShell-Modul](https://docs.microsoft.com/de-de/MicrosoftTeams/teams-powershell-install). Dazu muss der folgende Befehl in der gerade installierten PowerShell ausgeführt werden.

```Powershell
Install-Module MicrosoftTeams -AllowPrerelease -RequiredVersion "1.1.9-preview" -Scope CurrentUser
```
