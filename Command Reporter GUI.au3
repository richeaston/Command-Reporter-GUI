#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.10.2
 Author:         Richard Easton

 Script Function:
	Command Reporter GUI.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>

;declare any file locations here.
$details = @scriptdir & "\settings.ini"
$cmdrptr = "commandreporter.exe"

#cs
;check for commandreporter executable.
if not FileExists(@scriptdir & "\" & $cmdrptr) Then
	msgbox(48,"Warning!", "The CommandReporter.exe was not found in the directory, " & @CR _
	& "Please put the GUI into the same directory")
	Exit
EndIf
#ce

if FileExists($details) Then
	$import = IniReadSection($details, "Settings")
EndIf

$CRG = GUICreate("Command Reporter GUI", 385, 437, -1, -1)
GUICtrlCreateGroup("", 8, 8, 369, 385)

;Labels
GUICtrlCreateLabel("USERname", 16, 24, 60, 17)
GUICtrlCreateLabel("PASSWORD", 16, 48, 67, 17)
GUICtrlCreateLabel("SERVERNAME", 16, 72, 79, 17)
GUICtrlCreateLabel("DATABASENAME", 16, 96, 92, 17)
GUICtrlCreateLabel("REPORT name", 16, 152, 67, 17)
GUICtrlCreateLabel("PARAMeterS", 16, 176, 67, 17)
GUICtrlCreateLabel("OUTPUT", 16, 200, 49, 17)
GUICtrlCreateLabel("PARAMeters DEFs", 16, 224, 94, 17)
GUICtrlCreateLabel("PARAMeters FILE", 16, 248, 90, 17)
GUICtrlCreateLabel("BatchFile Name", 16, 336, 79, 17)
GUICtrlCreateLabel("Task Name", 16, 360, 59, 17)

;inputs (and fill them in if settings.ini is present)
$usr = GUICtrlCreateInput("", 121, 20, 249, 21)
guictrlsettip(-1, "ABCD is the SIMS user name (not the SQL Server user name)", "/USER:ABCD", 1,1)
if not $import[1][1] = "" Then
	guictrlsetdata($usr, $import[1][1], "")
EndIf

$pwd = GUICtrlCreateInput("", 121, 43, 249, 21, $ES_PASSWORD)
guictrlsettip(-1, "ABCD is the SIMS password (not the SQL Server password)", "/PASSWORD:ABCD", 1,1)
if not $import[2][1] = "" Then
	guictrlsetdata($pwd, $import[2][1], "")
EndIf

$sname = GUICtrlCreateInput("", 121, 65, 249, 21)
guictrlsettip(-1, "The name of the SQL Server to connect to.", "/SERVERNAME:ABCD", 1,1)
if not $import[3][1] = "" Then
	guictrlsetdata($sname, $import[3][1], "")
EndIf

$dname = GUICtrlCreateInput("", 121, 89, 249, 21)
guictrlsettip(-1, "The name of the SIMS database to run the report against.", "/DATABASENAME:ABCD", 1,1)
if not $import[4][1] = "" Then
	guictrlsetdata($dname, $import[4][1], "")
EndIf

$TRUSTED = GUICtrlCreateCheckbox("Trusted", 16, 120, 97, 17)
guictrlsettip(-1, "Use the current Windows user to connect to the SIMS system." & @CR & "(not to be used with /USER or /PASSWORD)", "/TRUSTED", 1,1)
$rname = GUICtrlCreateInput("", 121, 148, 249, 21)
guictrlsettip(-1, "ABCD (quotes optional) is the name of the report seen in this users My Reports screen in SIMS.net", '/REPORT:"ABCD"', 1,1)
$params = GUICtrlCreateInput("", 121, 172, 249, 21)
guictrlsettip(-1, "ABCD (quotes optional) is a string containing xml which defintes the parameters for the report." & @CR & "See the Third Party Access to SIMS.net SDK for details on the format of this xml string.", '/PARAMS:"ABCD"', 1,1)
$output = GUICtrlCreateInput("", 121, 195, 249, 21)
guictrlsettip(-1, "ABCD (quotes optional) is the name of the output file to write the report contents or parameter definitions to." & @CR & "The OUTPUT Parameter is optional, if left out the system will output the results in " & @CR & "standard xml to the console.", '/OUTPUT:"ABCD"', 1,1)
$paramdef = GUICtrlCreateInput("", 121, 218, 249, 21)
guictrlsettip(-1, "Output the parameter list for the specified report." & @CR & "If OUTPUT is not provided the results will be written in standard xml to the console." & @CR & "See the Third Party Access to SIMS.net SDK for details on the format of this xml string.", "/PARAMDEF", 1,1)
$paramfile = GUICtrlCreateInput("", 121, 242, 249, 21)
guictrlsettip(-1, "ABCD (quotes optional) is the filename of an xml file which contains the parameters for the report." & @CR & "See the Third Party Access to SIMS.net SDK for details on the format of this xml string.", '/PARAMFILE:"ABCD"', 1,1)
$QUIET = GUICtrlCreateCheckbox("QUIET", 16, 272, 97, 17)

;export inputs
$batchname = GUICtrlCreateInput("", 121, 331, 223, 21)
guictrlsettip(-1, "Location of the generated batchfile", "Command Reporter GUI", 1,1)
$batloc = GUICtrlCreateButton("...", 347, 330, 25, 23)
$taskname = GUICtrlCreateInput("", 121, 356, 249, 21)
guictrlsettip(-1, "Name of scheduled task to be created (Must be Unique without spaces)", "Command Reporter GUI", 1,1)
;$taskloc = GUICtrlCreateButton("...", 347, 355, 25, 23)
GUICtrlCreateGroup("", -99, -99, 1, 1)

;controls
$save_btn = GUICtrlCreateButton("Save Details", 8, 400, 75, 25)
guictrlsettip(-1, "Only saves Username,Password,Servername and Database name", "Command Reporter GUI", 1,1)

$genbat_btn = GUICtrlCreateButton("Generate Batchfile", 88, 400, 115, 25)
guictrlsetstate(-1, $GUI_DISABLE)
$gentask_btn = GUICtrlCreateButton("Generate Scheduled Task", 208, 400, 171, 25)
guictrlsetstate(-1, $GUI_DISABLE)

GUISetState(@SW_SHOW)

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		case $save_btn
			$usr = GUICtrlRead($usr)
			$pwd = GUICtrlRead($pwd)
			$sname = GUICtrlRead($sname)
			$dname = GUICtrlRead($dname)
			if $usr ="" or $pwd ="" or $sname ="" or $dname = "" Then
				msgbox(48, "Command Reporter GUI", "one or more of the required details is missing!", 5)
			Else
				local $data[5][2] = [[4, ""],["username", $usr],["password", $pwd],["Server", $sname],["database", $dname]]
				IniWriteSection($details, "Settings", $data)
			endif
		case $batloc
			$path = FileSaveDialog("Batch File Location", @MyDocumentsDir, "Batch File (*.bat)", 2+16)
			guictrlsetdata($batchname, $path, "")
			guictrlsetstate($genbat_btn, $GUI_ENABLE)
		case $taskname
			$state = GUICtrlread($taskname)
			if not $state = "" Then
				guictrlsetstate($gentask_btn, $GUI_ENABLE)
			else
				guictrlsetstate($gentask_btn, $GUI_DISABLE)
			EndIf
		case $genbat_btn

		case $gentask_btn

		case $TRUSTED
			$tcheck = guictrlread($TRUSTED)
			if $tcheck = 1 Then
				msgbox(48, "Warning!", "The TRUSTED option can not be used with a usernam/password" & @CR & @CR & _
				"You will need to re-enter them if you do not use TRUSTED", 10)
				guictrlsetdata($usr, "", "")
				guictrlsetdata($pwd, "", "")
				guictrlsetstate($usr, $GUI_DISABLE)
				guictrlsetstate($pwd, $GUI_DISABLE)
			Else
				msgbox(48, "Warning!", "You will need to re-enter them if you do not use TRUSTED", 10)
				guictrlsetstate($usr, $GUI_ENABLE)
				guictrlsetstate($pwd, $GUI_ENABLE)
				guictrlsetstate($usr, $GUI_FOCUS)
			EndIf



	EndSwitch
WEnd
