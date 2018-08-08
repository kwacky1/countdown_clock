#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=\\corp\file\Software\Utilities\AutoIT\Testlab Created Scripts\Simon\Icons\clock2.ico
#AutoIt3Wrapper_Outfile=bin\countdown.scr
#AutoIt3Wrapper_Res_Comment=http://www.hiddensoft.com/autoit3/compiled.html
#AutoIt3Wrapper_Res_Description=The Dennis Smith Memorial Countdown Clock
#AutoIt3Wrapper_Res_Fileversion=4.2.0.2
#AutoIt3Wrapper_Res_Fileversion_AutoIncrement=y
#AutoIt3Wrapper_Res_LegalCopyright=SOE Integration Centre 2005-2018
#AutoIt3Wrapper_Run_AU3Check=n
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#Region converted Directives from \\corp\file\Software\Utilities\AutoIT\Testlab Created Scripts\Simon\Complete\Countdown\countdown3.au3.ini
#EndRegion converted Directives from \\corp\file\Software\Utilities\AutoIT\Testlab Created Scripts\Simon\Complete\Countdown\countdown3.au3.ini
;
#include <Date.au3>
#include <GUIConstants.au3>
#include <ColorConstants.au3>
#include <GDIPlus.au3>
#include <Array.au3>
#include <..\Includes\_SS_UDF.au3>

;Opt ("GUICoordMode", 2)

Dim $g_szVersion = "v4.2.0.0"

Dim $Months = 0, $Days, $Hours, $Minutes, $Seconds, $sNewDate
Dim $lm = -1, $ld = -1, $lh = -1, $ln = -1, $ls = -1, $ml = -1, $dl = -1, $x1 = -1, $x2 = -1, $ontop
Dim $wh[2], $ws[2], $pos[4], $pillick = 0
Dim $totalpos = 6, $maxdates = 9, $updatenow = 0, $cdateitem, $begin, $maximized = 0, $showpillick
Dim $ontopitem, $changedate, $title, $number, $a, $b, $ml, $c, $d, $dl, $e, $f, $x1, $g, $h, $x2, $i, $j, $x3, $cdWin, $dateitem[10], $datemenu, $lastImageupdate, $cdImage, $k
Dim $qrRed = 0x00C4262E
Dim $settings = @ScriptDir & "\countdown.ini"
; Initialize GDI+ library
_GDIPlus_Startup()
;~ $sCLSID = _GDIPlus_EncodersGetCLSID("JPG")
$zeroHour = IniRead( $settings, "Options", "Deadline", @YEAR & "/12/31 23:59:59" )
ConsoleWrite( "$zeroHour: " & $zeroHour & @CRLF )
$imageInterval = 20
;~ $imageInterval = 5
;~ $imagePath = "\\corp\corp\Strategic Projects\2018 Commonwealth Games\07_Kiosk\PICTURES\"
$imagePath = IniRead( $settings, "Options", "Images", "r:\Workspace\Scratch\Images\")

Func HowLong()
;~ 	ConsoleWrite( "$zeroHour: " & $zeroHour & @CRLF )
	if $zerohour < _NowCalc() Then
;~ 		$Months = 0
		$Hours = 0
		$Days = 0
		$Minutes = 0
		$Seconds = 0
		TrayTip( "Error", "The Date/Time chosen is in the Past.", 5 )
		if $pillick = 0 Then
			ConsoleWrite( "Setting $pillick to 1 because $zeroHour (" & $zeroHour & ") is less then _NowCalc() (" & _NowCalc() & ")" & @CRLF )
			$pillick = 1
		EndIf
	Else
		$skipWeekends = IniRead( $settings, "Options", "SkipWeekends", 0)
		$skipHolidays = IniRead( $settings, "Options", "SkipHolidays", 0)
;~ 		$Months =  _DateDiff( 'M',_NowCalc(), $zerohour )
;~ 		$sNewDate = _DateAdd( 'm', $Months, _NowCalc())

		$Days =    _DateDiff( 'D', _NowCalc(), $zerohour )
		ConsoleWrite( "Days: " & $Days & @CRLF )
		$sNewDate = _DateAdd( 'D', $Days, _NowCalc())
		ConsoleWrite( "sNewDate: " & $sNewDate & @CRLF )

		$Hours =   _DateDiff( 'h', $sNewDate, $zerohour )
		$sNewDate = _DateAdd( 'h', $Hours, $sNewDate)
		ConsoleWrite( "sNewDate: " & $sNewDate & @CRLF )

		$Minutes = _DateDiff( 'n', $sNewDate, $zerohour )
		$sNewDate = _DateAdd( 'n', $Minutes, $sNewDate)
		ConsoleWrite( "sNewDate: " & $sNewDate & @CRLF )

		$Seconds = _DateDiff( 's', $sNewDate, $zerohour )
		$sNewDate = _DateAdd( 's', $Seconds, $sNewDate)
		ConsoleWrite( "sNewDate: " & $sNewDate & @CRLF )

		If $skipWeekends Then
			$weeks = Int($days / 7)
			ConsoleWrite( "Weeks: " & $weeks & @CRLF )
			if ( 7 - (Mod($days,7)) = 1 ) Then $Days -= 1 ;Is today Sunday?
			if ( 7 - (Mod($days,7)) = 7 ) Then $Days -= 1 ;Is today Saturday?
			ConsoleWrite( "Days: " & $Days & @CRLF )
			ConsoleWrite( "Weekends: " & $weeks * 2 & @CRLF )
			$Days -= $weeks * 2
		EndIf
		If $skipHolidays Then
			$holidays = IniReadSection( $settings, "Holidays" )
			For $h = 1 To $holidays[0][0]
				ConsoleWrite( "Holiday " & $holidays[$h][0] & " is on " & $holidays[$h][1] & @CRLF )
				If _DateDiff( 'D', _NowCalc(), $holidays[$h][1]) > 0 Then $Days -= 1
			Next
		EndIf
		$sNewDate = _DateAdd( 'D', $Days, _NowCalc())
		ConsoleWrite( "sNewDate: " & $sNewDate & @CRLF )
	EndIf
EndFunc

Func CreateDateMenu()
	$datemenu = GUICtrlCreateMenu ( "Date" )
	$changedate = GUICtrlCreateMenuitem ( "Change", $datemenu )
	For $item = 1 to $maxdates
		$recentdates = RegRead( "HKEY_CURRENT_USER\Software\Dennis Smith\Countdown Clock", $item )
		if @error then ExitLoop
		If $item = 1 then GUICtrlCreateMenuitem( "", $datemenu )
		$dateitem[$item] = GUICtrlCreateMenuitem( $recentdates, $datemenu )
		$cdateitem = $item
	Next
EndFunc

Func UpdateCountdown()
;~ 	$totalpos = 6
	$columns = 4
	HowLong()
	$title = IniRead( $settings, "Options", "Title", "Countdown to the New Year" )
	ConsoleWrite( "$title: " & $title & @CRLF )
;~ 	$cdWin = GUICreate( $title, $pos[2], $pos[3], $pos[0], $pos[1], $WS_MINIMIZEBOX+$WS_MAXIMIZEBOX+$WS_SIZEBOX+$WS_EX_TOPMOST )
	$cdWin = _SS_GUICreate()
	GUISetBkColor( 0x00FFFFFF )
;~ 	ConsoleWrite( "w: " & 200 & ", h: " & ($totalpos + 2) * 20 & ", l: " & (@DesktopWidth - 200) / 2 & ", h: " & (@DesktopHeight - ($totalpos + 2) * 20) / 2 & @CRLF )
;~ 	ConsoleWrite( "w: " & $pos[2] & ", h: " & $pos[3] & ", l: " & (@DesktopWidth - $pos[2]) / 2 & ", h: " & (@DesktopHeight - $pos[3]) / 2 & @CRLF )
#cs - Disable menu for Screen Saver
	CreateDateMenu()
	$viewmenu = GUICtrlCreateMenu ( "View" )
	$ontopitem = GUICtrlCreateMenuitem ( "Always On Top", $viewmenu )
#ce

	if $pillick = 1 Then
	GUISetCoord( 0, 0 )
;~ 	$showpillick = GUICtrlCreatePic("\\bnedevweb01\WWWDEVL\isd\images\people\andrew_kane.jpg",0,0, $pos[2], $pos[3])
	Else

	$number = 0

;~ 	GUISetState( @SW_SHOW )
;~ 	WinMove( $title, "", $pos[0], $pos[1], $pos[2], $pos[3] )
;~ 	if $maximized = 1 then GUISetState( @SW_MAXIMIZE );WinSetState( $title, "", @SW_MAXIMIZE )
;~ 	$wh = WinGetClientSize( $title )
;~ 	ConsoleWrite( "ww: " & $wh[0] & ", wh: " & $wh[1] & @CRLF )

;~ 	$cellHeight = $wh[1] * 0.3
	$cellHeight = $_SS_WinHeight * 0.3
	$cellLeft = 0
	$cellWidth = $_SS_WinWidth/$columns
	$cellTop = $_SS_WinHeight-$cellHeight
	$row1 = $cellHeight / 2
	$row2 = ($cellHeight - $row1) / 2
	$row3 = $cellHeight - ($row1 + $row2)
	ConsoleWrite( "cellTop: " & $cellTop & ", H: " & $cellHeight & ", 1: " & $row1 & ", 2: " & $row2 & ", 3: " & $row3 & @CRLF )

	$cdImage = GUICtrlCreatePic( "", 0, 0, $_SS_WinWidth, $cellTop )
	$k = GUICtrlCreateLabel( $title, $cellLeft, $cellTop+($row1+$row2), $_SS_WinWidth, $row3, $SS_CENTER )
	GUICtrlSetBkColor( -1, $qrRed )
	GUICtrlSetColor( -1, 0x00FFFFFF )
;~ 	$a	= GUICtrlCreateLabel( $Months, $cellLeft, $cellTop, $cellWidth, $row1, $SS_CENTER )
;~ 	GUICtrlSetColor( -1, $qrRed )
;~ 	$b	= GUICtrlCreateLabel( "Months", $cellLeft, $cellTop+$row1, $cellWidth, $row2, $SS_CENTER )
;~ 	$cellLeft += $cellWidth
	$c	= GUICtrlCreateLabel( $Days, $cellLeft, $cellTop, $cellWidth, $row1, $SS_CENTER )
	GUICtrlSetColor( -1, $qrRed )
	$d	= GUICtrlCreateLabel( "Days", $cellLeft, $cellTop+$row1, $cellWidth, $row2, $SS_CENTER )
	$cellLeft += $cellWidth
	$e	= GUICtrlCreateLabel( $Hours, $cellLeft, $cellTop, $cellWidth, $row1, $SS_CENTER )
	GUICtrlSetColor( -1, $qrRed )
	$f	= GUICtrlCreateLabel( "Hours", $cellLeft, $cellTop+$row1, $cellWidth, $row2, $SS_CENTER )
	$cellLeft += $cellWidth
	$g	= GUICtrlCreateLabel( $Minutes, $cellLeft, $cellTop, $cellWidth, $row1, $SS_CENTER )
	GUICtrlSetColor( -1, $qrRed )
	$h	= GUICtrlCreateLabel( "Minutes", $cellLeft, $cellTop+$row1, $cellWidth, $row2, $SS_CENTER )
	$cellLeft += $cellWidth
	$i	= GUICtrlCreateLabel( $Seconds, $cellLeft, $cellTop, $cellWidth, $row1, $SS_CENTER )
	GUICtrlSetColor( -1, $qrRed )
	$j	= GUICtrlCreateLabel( "Seconds", $cellLeft, $cellTop+$row1, $cellWidth, $row2, $SS_CENTER )

	EndIf
	DisplayImage( $_SS_WinWidth, $cellTop )
	_SS_SetMainLoop( "Main" )
	_SS_Start()
EndFunc

Func DisplayImage( $maxWidth, $maxHeight )
	Local $iX, $iY, $images, $selected, $hImage, $xScale = 1, $yScale = 1
	ConsoleWrite( "DisplayImage: Loop" & @CRLF  )
	$images = GetImages()
	$selected = Random( 1, UBound( $images ), 1 ) - 1
    $hImage = _GDIPlus_ImageLoadFromFile( $imagePath & $images[$selected] )
	ConsoleWrite( $imagePath & $images[$selected] & @CRLF )
	$iX = _GDIPlus_ImageGetWidth($hImage)
	$iY = _GDIPlus_ImageGetHeight($hImage)

	ConsoleWrite( "max x: " & $maxWidth & ", x: " & $iX & @CRLF )

	If $iX > $maxWidth Then
		Local $xScale = $maxWidth / $iX
		$iX *= $xScale
		$iY *= $xScale
	EndIf

	ConsoleWrite( "max y: " & $maxHeight & ", y: " & $iY & @CRLF )
	If $iY > $maxHeight Then
		Local $yScale = $maxHeight / $iY
		$iX *= $yScale
		$iY *= $yScale
	EndIf

	ConsoleWrite( "x: " & $iX & ", y: " & $iY & @CRLF )

	Local $hBitmap_Scaled = _GDIPlus_ImageScale( $hImage, $xScale, $yScale )
	_GDIPlus_ImageSaveToFile( $hBitmap_Scaled, @TempDir & "\countdown.jpg" )
	ConsoleWriteError( @TempDir & "\countdown.jpg( " & @error & " )" & @CRLF )
;~ 	GUICtrlDelete( $cdImage )
;~ 	$cdImage = GUICtrlCreatePic( @TempDir & "\countdown.jpg", ($maxWidth-$iX)/2, 0, $iX, $iY )
	GUICtrlSetImage( $cdImage, @TempDir & "\countdown.jpg" )
	GUICtrlSetPos( $cdImage, ($maxWidth-$iX)/2, 0, $iX, $iY )
	_GDIPlus_ImageDispose( $hImage )
	_GDIPlus_BitmapDispose( $hBitmap_Scaled )

	$lastImageupdate = TimerInit()
EndFunc

Func GetImages()
	Local $hSearch = FileFindFirstFile($imagePath & "*.*")
	Local $files[0]
	If $hSearch = -1 Then
		ConsoleWriteError( "No Files Found in " & $imagePath & " (" & @error & ")" & @CRLF )
		Return False
	EndIf
	Local $sFileName = ""
	While 1
		$sFileName = FileFindNextFile($hSearch)
		If @error Then ExitLoop
		if $sFileName <> "Thumbs.db" Then _ArrayAdd( $files, $sFileName )
	WEnd
	FileClose($hSearch)
	Return $files
EndFunc   ;==>Example

Func OnTop()
	If $ontop = 1 Then
		$ontop = 0
		GUICtrlSetState( $ontopitem, $GUI_UNCHECKED )
	Else
		$ontop = 1
		GUICtrlSetState( $ontopitem, $GUI_CHECKED )
	EndIf
	WinSetOnTop( $title, "", $ontop )
EndFunc

Func DisplayNumber( $number, $position )
	$begin = TimerInit()
	$wh = WinGetClientSize( $title )
	Select
	Case $position = "a"
		GUICtrlSetData( $a, $number )
	Case $position = "c"
		GUICtrlSetData( $c, $number )
	Case $position = "e"
		GUICtrlSetData( $e, $number )
	Case $position = "g"
		GUICtrlSetData( $g, $number )
	Case $position = "i"
		GUICtrlSetData( $i, $number )
	EndSelect
	If TimerDiff($lastImageupdate) > ($imageInterval * 1000) Then
		$cellHeight = $_SS_WinHeight * 0.3
		$cellTop = $_SS_WinHeight-$cellHeight
		DisplayImage( $_SS_WinWidth, $cellTop )
		$lastImageupdate = TimerInit()
	EndIf
	If ($_SS_WinHeight <> $ws[0]) or ($_SS_WinHeight <> $ws[1]) or $updatenow Then
		$updatenow = 0
		$cellHeight = $_SS_WinHeight * 0.3
		$cellTop = $_SS_WinHeight-$cellHeight
		DisplayImage( $_SS_WinWidth, $cellTop )
;~ 		$fontmodifer = (($wh[1] + $wh[0])/2) * 0.09
		$fontmodifer = $cellHeight * 0.4
;- Months
;~ 		If ($Months = 0) and (GUICtrlGetState( $a ) = 80) Then
;~ 			GUICtrlSetState( $a, $GUI_HIDE)
;~ 			GUICtrlSetState( $b, $GUI_HIDE)
;~ 		Elseif GUICtrlGetState( $a ) = 80 Then
;~ 			GUICtrlSetFont( $a, 	$fontmodifer )
;~ 			GUICtrlSetFont( $b, 	$fontmodifer / 3 )
;~ 			ConsoleWrite( "Font: " & $fontmodifer & @CRLF )
;~ 		EndIf
;- Days
		If ($Months = 0) and ($Days = 0) and (GUICtrlGetState( $c ) = 80) Then
			GUICtrlSetState( $c, $GUI_HIDE)
			GUICtrlSetState( $d, $GUI_HIDE)
		Elseif GUICtrlGetState( $c ) = 80 Then
			GUICtrlSetFont( $c, 	$fontmodifer )
			GUICtrlSetFont( $d, 	$fontmodifer / 3 )
		EndIf
;- Hours
		If ($Months = 0) and ($Days = 0) and ($Hours = 0) and (GUICtrlGetState( $e ) = 80) Then
			GUICtrlSetState( $e, $GUI_HIDE)
			GUICtrlSetState( $f, $GUI_HIDE)
		Elseif GUICtrlGetState( $e ) = 80 Then
			GUICtrlSetFont( $e, 	$fontmodifer )
			GUICtrlSetFont( $f, 	$fontmodifer / 3 )
		EndIf
;- Minutes
		If ($Months = 0) and ($Days = 0) and ($Hours = 0) and ($Minutes = 0) and (GUICtrlGetState( $g ) = 80) Then
			GUICtrlSetState( $g, $GUI_HIDE)
			GUICtrlSetState( $h, $GUI_HIDE)
		Elseif GUICtrlGetState( $g ) = 80 Then
			GUICtrlSetFont( $g, 	$fontmodifer )
			GUICtrlSetFont( $h, 	$fontmodifer / 3 )
		EndIf
;- Seconds
		If ($Months = 0) and ($Days = 0) and ($Hours = 0) and ($Minutes = 0) and ($Seconds = 0) and (GUICtrlGetState( $i ) = 80) Then
			GUICtrlSetState( $i, $GUI_HIDE)
			GUICtrlSetState( $j, $GUI_HIDE)
		Elseif GUICtrlGetState( $i ) = 80 Then
			GUICtrlSetFont( $i, 	$fontmodifer )
			GUICtrlSetFont( $j, 	$fontmodifer / 3 )
		EndIf
;~ Message
		GUICtrlSetFont( $k, 	$fontmodifer / 3 )
		$ws[0] = $_SS_WinHeight
		$ws[1] = $_SS_WinHeight
	EndIf
EndFunc

Func DisplayCountdown()
;~ 	ConsoleWrite( "Entering DisplayCountdown()" & @CRLF )
	HowLong()
;~ 	If BitAND(WinGetState( $title ), 2 ) and $pillick = 0 Then
	If $pillick = 0 Then
;~ 		If $lm <> $Months Then
;~ 			DisplayNumber( $Months, "a" )
;~ 			$lm = $Months
;~ 		EndIf
		If $ld <> $Days Then
			DisplayNumber( $Days, "c" )
			$ld = $Days
		EndIf
		If $lh <> $Hours Then
			DisplayNumber( $Hours, "e" )
			$lh = $Hours
		EndIf
		If $ln <> $Minutes Then
			DisplayNumber( $Minutes, "g" )
			$ln = $Minutes
		EndIf
		If $ls <> $Seconds Then
			DisplayNumber( $Seconds, "i" )
			$ls = $Seconds
		EndIf
	EndIf
EndFunc

Func NewDate( )
	$cdateitem = $cdateitem + 1
	RegWrite( "HKEY_CURRENT_USER\Software\Dennis Smith\Countdown Clock", $cdateitem, "REG_SZ", $zerohour )
	If $cdateitem = 1 Then GUICtrlCreateMenuitem ( "", $datemenu )
	if $cdateitem <= $maxdates  Then
		$dateitem[$cdateitem] = GUICtrlCreateMenuitem ( $zerohour, $datemenu )
	Else
		For $item = 1 to $maxdates
			$recentdates = RegRead( "HKEY_CURRENT_USER\Software\Dennis Smith\Countdown Clock", $item+1 )
			RegWrite( "HKEY_CURRENT_USER\Software\Dennis Smith\Countdown Clock", $item, "REG_SZ", $recentdates )
		Next
		$dateitem[$maxdates] = GUICtrlCreateMenuitem ( $zerohour, $datemenu )
	EndIf
	$lm = -1
	$ld = -1
	$lh = -1
	$ln = -1
	$ls = -1
EndFunc

Func ChangeDate()
	$pillick = 0
	Dim $olddate, $oldtime
	$pos = WinGetPos( $title )
	GUISetState( @SW_HIDE , $cdWin )
	$changeWin = GUICreate("Enter New Date", 320, 200, $pos[0], $pos[1], $WS_EX_DLGMODALFRAME+$WS_CAPTION+$WS_SYSMENU, -1, $cdwin);, 0x00000018, $cdwin); WS_EX_ACCEPTFILES
	GUISwitch( $changeWin )
	$olddate = StringLeft( $zerohour, 10 )
	$oldtime = StringRight( $zerohour, 8 )
	$newdate = GuiCtrlCreateDate($olddate, 5, 5, 100, 20, $DTS_SHORTDATEFORMAT)
	If StringLeft($newdate) = 9 Then $newdate = "0" & $newdate
	$newtime = GUICtrlCreateDate ( $oldtime, 10, -1, 100, 20, $DTS_TIMEFORMAT)
	$btn = GUICtrlCreateButton ("Ok", -1,  0, 60, 20)
	GUISetState ()
	While 1
		$msg = GUIGetMsg()
		Select
		Case $msg = $GUI_EVENT_CLOSE
			exitloop
		Case $msg = $btn
			$strdate = Guictrlread($newdate)
			$strtime = GUICtrlRead($newtime)
			If StringLen($strdate) = 9 Then
				$zerohour = StringRight( $strdate, 4 ) & "/" & StringMid( $strdate, 3, 2 ) & "/0" & StringLeft( $strdate, 1 ) & " " & $strtime
			Else
				$zerohour = StringRight( $strdate, 4 ) & "/" & StringMid( $strdate, 4, 2 ) & "/" & StringLeft( $strdate, 2 ) & " " & $strtime
			EndIf
			$pos = WinGetPos( $title )
			$wh[0] = $pos[2]
			$wh[1] = $pos[3]
			GUIDelete( $cdWin )
			UpdateCountdown()
			NewDate()
			$updatenow = 1
			exitloop
		EndSelect
	Wend
	GUIDelete( $ChangeWin )
	GUISetState( @SW_SHOW , $cdWin )
	GUISwitch( $cdWin )
EndFunc

Func MyExit()
	; Shut down GDI+ library
	_GDIPlus_Shutdown()
	$pos = WinGetPos( $title )
	if $maximized = 0 Then
		RegWrite( "HKEY_CURRENT_USER\Software\Dennis Smith\Countdown Clock", "x", "REG_SZ", $pos[0] )
		RegWrite( "HKEY_CURRENT_USER\Software\Dennis Smith\Countdown Clock", "y", "REG_SZ", $pos[1] )
		RegWrite( "HKEY_CURRENT_USER\Software\Dennis Smith\Countdown Clock", "w", "REG_SZ", $pos[2] )
		RegWrite( "HKEY_CURRENT_USER\Software\Dennis Smith\Countdown Clock", "h", "REG_SZ", $pos[3] )
	EndIf
	RegWrite( "HKEY_CURRENT_USER\Software\Dennis Smith\Countdown Clock", "m", "REG_SZ", $maximized )
	Exit
EndFunc

$pos[0] = RegRead( "HKEY_CURRENT_USER\Software\Dennis Smith\Countdown Clock", "x" )
if $pos[0] = "" Then
	$pos[0] = 1504
	$pos[1] = 4
	$pos[2] = 1694
	$pos[3] = 1064
	$maximized = RegRead( "HKEY_CURRENT_USER\Software\Dennis Smith\Countdown Clock", "m" )
;~ 	$wh[0] = 200
;~ 	$wh[1] = ($totalpos + 2) * 20
Else
	$pos[1] = RegRead( "HKEY_CURRENT_USER\Software\Dennis Smith\Countdown Clock", "y" )
	$pos[2] = RegRead( "HKEY_CURRENT_USER\Software\Dennis Smith\Countdown Clock", "w" )
	$pos[3] = RegRead( "HKEY_CURRENT_USER\Software\Dennis Smith\Countdown Clock", "h" )
	$maximized = RegRead( "HKEY_CURRENT_USER\Software\Dennis Smith\Countdown Clock", "m" )
EndIf
ConsoleWrite( "1: " & $pos[1] & ", 2: " & $pos[2] & ", 3: " & $pos[3] & ", m: " & $maximized & @CRLF )
UpdateCountdown()

Func Main()
;~ 	ConsoleWrite( "Entering Main()" & @CRLF )
	Do
		#cs - Disabled for Screen Saver mode
		$msg = GUIGetMsg()
		Select
		Case $msg = $GUI_EVENT_CLOSE
			MyExit()
		Case $msg = $GUI_EVENT_MINIMIZE
			TrayTip( $title, $Months & "m " & $Days & "d " & $Hours & ":" & $Minutes & ":" & $Seconds, 5 )
		Case $msg = $GUI_EVENT_MAXIMIZE
			$maximized = 1
			RegWrite( "HKEY_CURRENT_USER\Software\Dennis Smith\Countdown Clock", "m", "REG_SZ", $maximized )
		Case $msg = $GUI_EVENT_RESTORE
			$maximized = 0
			RegWrite( "HKEY_CURRENT_USER\Software\Dennis Smith\Countdown Clock", "m", "REG_SZ", $maximized )
		Case $msg = $ontopitem
			OnTop()
		Case $msg = $changedate
			ChangeDate()
			Case Else
		#ce
			$dif = TimerDiff($begin)
			if $dif > 500 Then
				DisplayCountdown()
			EndIf
		#cs
		EndSelect
		for $menuitem = 1 to $maxdates
			if $msg = $dateitem[$menuitem] Then
				$getzerohour = RegRead( "HKEY_CURRENT_USER\Software\Dennis Smith\Countdown Clock", $menuitem )
				if not @error Then
					$pillick = 0
					$zerohour = $getzerohour
					GUIDelete( $cdWin )
					$lm = -1
					$ld = -1
					$lh = -1
					$ln = -1
					$ls = -1
					$updatenow = 1
					UpdateCountdown()
				EndIf
			EndIf
		Next
		#ce
	Until _SS_ShouldExit()
EndFunc

; 1 MMm,
; 2 DDd,
; 3 hh:
; 4 nn:
; 5 ss
