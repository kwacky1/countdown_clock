#include <Date.au3>
#include <GUIConstants.au3>
Opt ("GUICoordMode", 2)

Dim $Months, $Days, $Hours, $Minutes, $Seconds, $sNewDate
Dim $lm = -1, $ld = -1, $lh = -1, $ln = -1, $ls = -1, $ml = -1, $dl = -1, $x1 = -1, $x2 = -1, $ontop
Dim $wh[2], $ws[2], $pos[4], $pillick = 0
Dim $totalpos = 6, $maxdates = 9, $updatenow = 0, $cdateitem, $begin, $maximized = 0, $showpillick
Dim $ontopitem, $changedate, $title, $number, $a, $b, $ml, $c, $d, $dl, $e, $f, $x1, $g, $h, $x2, $i, $j, $x3, $cdWin, $dateitem[10], $datemenu
$zerohour = "2006/12/31 23:59:59"
;$zerohour = "2005/08/05 12:00:00"

Func HowLong()
	if $zerohour < _NowCalc() Then
		$Months = 0
		$Hours = 0
		$Days = 0
		$Minutes = 0
		$Seconds = 0
		TrayTip( "Pillick", "The Event Chosen has Passed", 5 )
		if $pillick = 0 Then 
			$pillick = 1
		EndIf
	Else
		$Months =  _DateDiff( 'M',_NowCalc(), $zerohour )
		$sNewDate = _DateAdd( 'm', $Months, _NowCalc())

		$Days =    _DateDiff( 'D', $sNewDate, $zerohour )
		$sNewDate = _DateAdd( 'D', $Days, $sNewDate)

		$Hours =   _DateDiff( 'h', $sNewDate, $zerohour )
		$sNewDate = _DateAdd( 'h', $Hours, $sNewDate)

		$Minutes = _DateDiff( 'n', $sNewDate, $zerohour )
		$sNewDate = _DateAdd( 'n', $Minutes, $sNewDate)

		$Seconds = _DateDiff( 's', $sNewDate, $zerohour )
		$sNewDate = _DateAdd( 's', $Seconds, $sNewDate)
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
	$totalpos = 6
	HowLong()
	$title = "Countdown to " & $sNewDate
	$cdWin = GUICreate( $title, 200, ($totalpos + 2) * 20, (@DesktopWidth - 200) / 2, (@DesktopHeight - ($totalpos + 2) * 20) / 2, $WS_MINIMIZEBOX+$WS_MAXIMIZEBOX+$WS_SIZEBOX+$WS_EX_TOPMOST )
	CreateDateMenu()
	$viewmenu = GUICtrlCreateMenu ( "View" )
	$ontopitem = GUICtrlCreateMenuitem ( "Always On Top", $viewmenu )

	if $pillick = 1 Then
	GUISetCoord( 0, 0 )
;~ 	$showpillick = GUICtrlCreatePic("\\bnedevweb01\WWWDEVL\isd\images\people\andrew_kane.jpg",0,0, $pos[2], $pos[3])
	Else


	$number = 0

	$x = 12
	$y = 19

	GUISetCoord( $x,  $y, 14, 21 )
	$a	= GUICtrlCreateLabel( $number, -1, -1)
	$b	= GUICtrlCreateLabel( $number,		0, -1	)
	$ml	= GUICtrlCreateLabel( "Months",		0, -1, 100	)
	GUISetCoord( $x,  $y*2, 14, 21 )
	$c	= GUICtrlCreateLabel( $number,		-1, 	-1 )
	$d	= GUICtrlCreateLabel( $number,		0, -1	)
	$dl	= GUICtrlCreateLabel( "Days",		0, -1, 100	)
	GUISetCoord( $x,  $y*3, 14, 21 )
	$e	= GUICtrlCreateLabel( $number,		-1, 	-1 					)
	$f	= GUICtrlCreateLabel( $number,		0, -1	)
	$x1	= GUICtrlCreateLabel( "Hours",		0, -1, 100	)
	GUISetCoord( $x,  $y*4, 14, 21 )
	$g	= GUICtrlCreateLabel( $number, 		-1, 	-1 					)
	$h	= GUICtrlCreateLabel( $number, 		0, -1	)
	$x2	= GUICtrlCreateLabel( "Minutes",	0, -1, 100	)
	GUISetCoord( $x,  $y*5, 14, 21 )
	$i	= GUICtrlCreateLabel( $number, 		-1, 	-1 					)
	$j	= GUICtrlCreateLabel( $number, 		0, -1	)
	$x3	= GUICtrlCreateLabel( "Seconds",	0, -1, 100	)

	EndIf
	GUISetState( @SW_SHOW )
	WinMove( $title, "", $pos[0], $pos[1], $pos[2], $pos[3] )
	if $maximized = 1 then WinSetState( $title, "", @SW_MAXIMIZE )
	$wh = WinGetClientSize( $title )
EndFunc

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
		GUICtrlSetData( $a, $number)
	Case $position = "b"
		GUICtrlSetData( $b, $number)
	Case $position = "c"
		GUICtrlSetData( $c, $number)
	Case $position = "d"
		GUICtrlSetData( $d, $number)
	Case $position = "e"
		GUICtrlSetData( $e, $number)
	Case $position = "f"
		GUICtrlSetData( $f, $number)
	Case $position = "g"
		GUICtrlSetData( $g, $number)
	Case $position = "h"
		GUICtrlSetData( $h, $number)
	Case $position = "i"
		GUICtrlSetData( $i, $number)
	Case $position = "j"
		GUICtrlSetData( $j, $number)
	EndSelect
	If ($wh[0] <> $ws[0]) or ($wh[1] <> $ws[1]) or $updatenow Then
		$updatenow = 0
		$x = 12
		$y = 19
		$totalacross = 17
		$cpos = 0

		$fontmodifer = (($wh[1] + $wh[0])/2) * 0.09
;- Months
		If ($Months = 0) and (GUICtrlGetState( $a ) = 80) Then
			GUICtrlSetState( $a, $GUI_HIDE)
			GUICtrlSetState( $b, $GUI_HIDE )
			GUICtrlSetState( $ml, $GUI_HIDE )
			$totalpos = 5
			$cpos = 0
		Elseif GUICtrlGetState( $a ) = 80 Then
			$cpos = $cpos + 1
			GUISetCoord( $x,  $wh[1]/$totalpos*$cpos, 14, 21 )
			GUICtrlSetPos(	$a, 	-1, 		-1, 	$wh[0]/$totalacross, 		$wh[1]/$totalpos )
			GUICtrlSetFont( $a, 	$fontmodifer )
			GUICtrlSetPos( 	$b,		0, -1, 	$wh[0]/$totalacross,		$wh[1]/$totalpos )
			GUICtrlSetFont( $b, 	$fontmodifer )
			GUICtrlSetPos( 	$ml, 	$wh[0]/$totalacross, -1, 	$wh[0]/2,	$wh[1]/$totalpos )
			GUICtrlSetFont( $ml, 	$fontmodifer )
		EndIf
;- Days
		GUISetCoord( $x,  $wh[1]/$totalpos*$cpos);, 14, 21 )
		If ($Months = 0) and ($Days = 0) and (GUICtrlGetState( $c ) = 80) Then
			GUICtrlSetState( $c, $GUI_HIDE)
			GUICtrlSetState( $d, $GUI_HIDE )
			GUICtrlSetState( $dl, $GUI_HIDE )
			;ToolTip( GuiCtrlGetState( $a ) )
			$totalpos = 4
			$cpos = 0
		Elseif GUICtrlGetState( $c ) = 80 Then
			$cpos = $cpos + 1
			GUISetCoord( $x,  $wh[1]/$totalpos*$cpos, 14, 21 )
			GUICtrlSetPos( 	$c,		-1, 		-1, 	$wh[0]/$totalacross, 		$wh[1]/$totalpos )
			GUICtrlSetFont( $c, 	$fontmodifer )
			GUICtrlSetPos( 	$d, 	0, -1, 	$wh[0]/$totalacross, 		$wh[1]/$totalpos )
			GUICtrlSetFont( $d, 	$fontmodifer )
			GUICtrlSetPos( 	$dl, 	$wh[0]/$totalacross, 	-1, $wh[0]/2, 	$wh[1]/$totalpos )
			GUICtrlSetFont( $dl, 	$fontmodifer )
		EndIf
;- Hours
		If ($Months = 0) and ($Days = 0) and ($Hours = 0) and (GUICtrlGetState( $e ) = 80) Then
			GUICtrlSetState( $e, $GUI_HIDE)
			GUICtrlSetState( $f, $GUI_HIDE )
			GUICtrlSetState( $x1, $GUI_HIDE )
			;ToolTip( GuiCtrlGetState( $a ) )
			$totalpos = 3
			$cpos = 0
		Elseif GUICtrlGetState( $e ) = 80 Then
			$cpos = $cpos + 1
			GUISetCoord( $x,  $wh[1]/$totalpos*$cpos, 14, 21 )
			GUICtrlSetPos( 	$e, 	-1, 		-1, 	$wh[0]/$totalacross, 		$wh[1]/$totalpos )
			GUICtrlSetFont( $e, 	$fontmodifer )
			GUICtrlSetPos( 	$f, 	0, -1, 	$wh[0]/$totalacross, 		$wh[1]/$totalpos )
			GUICtrlSetFont( $f, 	$fontmodifer )
			GUICtrlSetPos( 	$x1, 	$wh[0]/$totalacross, 	-1, $wh[0]/2, 	$wh[1]/$totalpos )
			GUICtrlSetFont( $x1, 	$fontmodifer )
		EndIf
;- Minutes
		If ($Months = 0) and ($Days = 0) and ($Hours = 0) and ($Minutes = 0) and (GUICtrlGetState( $g ) = 80) Then
			GUICtrlSetState( $g, $GUI_HIDE)
			GUICtrlSetState( $h, $GUI_HIDE )
			GUICtrlSetState( $x2, $GUI_HIDE )
			;ToolTip( GuiCtrlGetState( $a ) )
			$totalpos = 2
			$cpos = 0
		Elseif GUICtrlGetState( $g ) = 80 Then
			$cpos = $cpos + 1
			GUISetCoord( $x,  $wh[1]/$totalpos*$cpos, 14, 21 )
			GUICtrlSetPos( 	$g, 	-1, 		-1, 	$wh[0]/$totalacross, 		$wh[1]/$totalpos )
			GUICtrlSetFont( $g, 	$fontmodifer )
			GUICtrlSetPos( 	$h, 	0, -1, 	$wh[0]/$totalacross, 		$wh[1]/$totalpos )
			GUICtrlSetFont( $h, 	$fontmodifer )
			GUICtrlSetPos( 	$x2, 	$wh[0]/$totalacross, 	-1, $wh[0]/2, 	$wh[1]/$totalpos )
			GUICtrlSetFont( $x2, 	$fontmodifer )
		EndIf
;- Seconds
		If ($Months = 0) and ($Days = 0) and ($Hours = 0) and ($Minutes = 0) and ($Seconds = 0) and (GUICtrlGetState( $i ) = 80) Then
			GUICtrlSetState( $i, $GUI_HIDE)
			GUICtrlSetState( $j, $GUI_HIDE )
			GUICtrlSetState( $x3, $GUI_HIDE )
			$totalpos = 1
			$cpos = 0
		Elseif GUICtrlGetState( $i ) = 80 Then
			$cpos = $cpos + 1
			GUISetCoord( $x,  $wh[1]/$totalpos*$cpos, 14, 21 )
			GUICtrlSetPos( 	$i, 	-1, 		-1, 	$wh[0]/$totalacross, 		$wh[1]/$totalpos )
			GUICtrlSetFont( $i, 	$fontmodifer )
			GUICtrlSetPos( 	$j, 	0, -1, 	$wh[0]/$totalacross, 		$wh[1]/$totalpos )
			GUICtrlSetFont( $j, 	$fontmodifer )
			GUICtrlSetPos( 	$x3, 	$wh[0]/$totalacross, 	-1, $wh[0]/2, 	$wh[1]/$totalpos )
			GUICtrlSetFont( $x3, 	$fontmodifer )
		EndIf
		$ws[0] = $wh[0]
		$ws[1] = $wh[1]
	EndIf
EndFunc

Func DisplayCountdown()
	HowLong()
	If BitAND(WinGetState( $title ), 2 ) and $pillick = 0 Then
		If $lm <> $Months Then
			$m2 = StringRight( $Months, 1 )
			If $Months > 9 Then
				$m1 = 1
			Else
				$m1 = 0
			EndIf
			DisplayNumber( $m1, "a" )
			DisplayNumber( $m2, "b" )
			$lm = $Months
		EndIf
		If $ld <> $Days Then
			$d2 = StringRight( $Days, 1 )
			If $Days > 9 Then
				$d1 = StringLeft( $Days, 1 )
			Else
				$d1 = 0
			EndIf
			DisplayNumber( $d1, "c" )
			DisplayNumber( $d2, "d" )
			$ld = $Days
		EndIf
		If $lh <> $Hours Then
			$h2 = StringRight( $Hours, 1 )
			If $Hours > 9 Then
				$h1 = StringLeft( $Hours, 1 )
			Else
				$h1 = 0
			EndIf
			DisplayNumber( $h1, "e" )
			DisplayNumber( $h2, "f" )
			$lh = $Hours
		EndIf
		If $ln <> $Minutes Then
			$n2 = StringRight( $Minutes, 1 )
			If $Minutes > 9 Then
				$n1 = StringLeft( $Minutes, 1 )
			Else
				$n1 = 0
			EndIf
			DisplayNumber( $n1, "g" )
			DisplayNumber( $n2, "h" )
			$ln = $Minutes
		EndIf
		If $ls <> $Seconds Then
			$s2 = StringRight( $Seconds, 1 )
			If $Seconds > 9 Then
				$s1 = StringLeft( $Seconds, 1 )
			Else
				$s1 = 0
			EndIf
			DisplayNumber( $s1, "i" )
			DisplayNumber( $s2, "j" )
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
if @error Then
	$pos[0] = (@DesktopWidth - 200) / 2
	$pos[1] = (@DesktopHeight - ($totalpos + 2) * 20) / 2
	$wh[0] = 200
	$wh[1] = ($totalpos + 2) * 20
Else
	$pos[1] = RegRead( "HKEY_CURRENT_USER\Software\Dennis Smith\Countdown Clock", "y" )
	$pos[2] = RegRead( "HKEY_CURRENT_USER\Software\Dennis Smith\Countdown Clock", "w" )
	$pos[3] = RegRead( "HKEY_CURRENT_USER\Software\Dennis Smith\Countdown Clock", "h" )
	$maximized = RegRead( "HKEY_CURRENT_USER\Software\Dennis Smith\Countdown Clock", "m" )
EndIf	
UpdateCountdown()

While 1
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
		$dif = TimerDiff($begin)
		if $dif > 500 Then
			DisplayCountdown()
		EndIf
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
WEnd

; 1 MMm,
; 2 DDd,
; 3 hh:
; 4 nn:
; 5 ss
