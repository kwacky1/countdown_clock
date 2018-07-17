#include <Date.au3>
#include <GUIConstants.au3>
;Opt ("GUICoordMode", 2) 

Dim $Months, $Days, $Hours, $Minutes, $Seconds, $sNewDate
Dim $lm, $ld, $lh, $ln, $ls, $ml, $dl, $x1, $x2, $ontop
Dim $wh, $ws[2]
;$zerohour = "2005/09/23 12:00:00"
$zerohour = "2005/08/05 12:00:00"

Func HowLong()
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
EndFunc

HowLong()
$totalpos = 6
$title = "Countdown to " & $sNewDate
GUICreate( $title, 200, ($totalpos + 2) * 20, -1, -1, $WS_MINIMIZEBOX+$WS_MAXIMIZEBOX+$WS_SIZEBOX+$WS_EX_TOPMOST )
$wh = WinGetClientSize( $title )
$viewmenu = GUICtrlCreateMenu ( "View" )
$ontopitem = GUICtrlCreateMenuitem ( "Always On Top", $viewmenu )

$number = 0
$a	= GUICtrlCreateLabel( $number,		$wh[0]/$totalpos*1,		0 					)
$b	= GUICtrlCreateLabel( $number,		21, 					$wh[1]/$totalpos*1	)
$ml	= GUICtrlCreateLabel( "Months",		42, 					$wh[1]/$totalpos*1	)
	 
$c	= GUICtrlCreateLabel( $number,		$wh[0]/$totalpos*1, 	0 					)
$d	= GUICtrlCreateLabel( $number,		21, 					$wh[1]/$totalpos*2 	)
$dl	= GUICtrlCreateLabel( "Days",		42, 					$wh[1]/$totalpos*2	)
	 
$e	= GUICtrlCreateLabel( $number,		$wh[0]/$totalpos*1, 	0					)
$f	= GUICtrlCreateLabel( $number,		21, 					$wh[1]/$totalpos*3 	)
$x1	= GUICtrlCreateLabel( "Hours",		42,						$wh[1]/$totalpos*3	)

$g	= GUICtrlCreateLabel( $number, 		$wh[0]/$totalpos*1,		0					)
$h	= GUICtrlCreateLabel( $number, 		21, 					$wh[1]/$totalpos*4 	)
$x2	= GUICtrlCreateLabel( "Minutes",	42,						$wh[1]/$totalpos*4	)

$i	= GUICtrlCreateLabel( $number, 		$wh[0]/$totalpos*1,		0 					)
$j	= GUICtrlCreateLabel( $number, 		21, 					$wh[1]/$totalpos*5 	)
$x3	= GUICtrlCreateLabel( "Seconds",	42,						$wh[1]/$totalpos*5	)

GUISetState( @SW_SHOW )

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
	If ($wh[0] <> $ws[0]) or ($wh[1] <> $ws[1]) Then
		$x = ControlGetPos( $title, "", $a )
		ToolTip( $x[0] & ", " & $x[1] & ", " & $x[2] & ", " & $x[3] )
		$x = $x[2]
		$fontmodifer = (($wh[1] + $wh[0])/2) * 0.07
		GUICtrlSetPos(	$a, 	0, 		$wh[1]/$totalpos*1, 	$wh[0]/16, 		$wh[1]/$totalpos ) 
		GUICtrlSetFont( $a, 	$fontmodifer )
		GUICtrlSetPos( 	$b,		$x-2, 	20, 	$wh[0]/$totalpos,		$wh[1]/$totalpos ) 
		GUICtrlSetFont( $b, 	$fontmodifer )

		GUICtrlSetPos( 	$ml, 	$x*2, 	$wh[1]/$totalpos*1, 	$wh[1]-($x*2),	$wh[1]/$totalpos ) 
		GUICtrlSetFont( $ml, 	$fontmodifer )
		
		GUICtrlSetPos( 	$c,		0, 		$wh[1]/$totalpos*2, 	$wh[0]/16, 		$wh[1]/$totalpos ) 
		GUICtrlSetFont( $c, 	$fontmodifer )
		GUICtrlSetPos( 	$d, 	$x, 	$wh[1]/$totalpos*2, 	$wh[0]/16, 		$wh[1]/$totalpos ) 
		GUICtrlSetFont( $d, 	$fontmodifer )

		GUICtrlSetPos( 	$dl, 	$x*2, 	$wh[1]/$totalpos*2, 	$wh[1]-($x*2),	$wh[1]/$totalpos ) 
		GUICtrlSetFont( $dl, 	$fontmodifer )
		
		GUICtrlSetPos( 	$e, 	0, 		$wh[1]/$totalpos*3, 	$wh[0]/16, 		$wh[1]/$totalpos ) 
		GUICtrlSetFont( $e, 	$fontmodifer )
		GUICtrlSetPos( 	$f, 	$x, 	$wh[1]/$totalpos*3, 	$wh[0]/16, 		$wh[1]/$totalpos ) 
		GUICtrlSetFont( $f, 	$fontmodifer )
		
		GUICtrlSetPos( 	$x1, 	$x*2, 	$wh[1]/$totalpos*3, 	$wh[1]-($x*2),	$wh[1]/$totalpos ) 
		GUICtrlSetFont( $x1, 	$fontmodifer )
		
		GUICtrlSetPos( 	$g, 	0, 		$wh[1]/$totalpos*4, 	$wh[0]/16, 		$wh[1]/$totalpos ) 
		GUICtrlSetFont( $g, 	$fontmodifer )
		GUICtrlSetPos( 	$h, 	$x, 	$wh[1]/$totalpos*4, 	$wh[0]/16, 		$wh[1]/$totalpos ) 
		GUICtrlSetFont( $h, 	$fontmodifer )
		
		GUICtrlSetPos( 	$x2, 	$x*2, 	$wh[1]/$totalpos*4, 	$wh[1]-($x*2),	$wh[1]/$totalpos ) 
		GUICtrlSetFont( $x2, 	$fontmodifer ) 
		
		GUICtrlSetPos( 	$i, 	0, 		$wh[1]/$totalpos*5, 	$wh[0]/16, 		$wh[1]/$totalpos ) 
		GUICtrlSetFont( $i, 	$fontmodifer )
		GUICtrlSetPos( 	$j, 	$x, 	$wh[1]/$totalpos*5, 	$wh[0]/16, 		$wh[1]/$totalpos ) 
		GUICtrlSetFont( $j, 	$fontmodifer ) 

		GUICtrlSetPos( 	$x3, 	$x*2, 	$wh[1]/$totalpos*5, 	$wh[1]-($x*2),	$wh[1]/$totalpos ) 
		GUICtrlSetFont( $x3, 	$fontmodifer ) 

		$ws[0] = $wh[0]
		$ws[1] = $wh[1]
	EndIf
EndFunc

Func DisplayCountdown()
	HowLong()
	If BitAND(WinGetState( $title ), 2 ) Then
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

While 1
	$msg = GUIGetMsg()
	Select
	Case $msg = $GUI_EVENT_CLOSE
		Exit
	Case $msg = $GUI_EVENT_MINIMIZE
		TrayTip( $title, $Months & "m " & $Days & "d " & $Hours & ":" & $Minutes & ":" & $Seconds, 5 )
	Case $msg = $ontopitem
		OnTop()
	Case Else
		DisplayCountdown()
	EndSelect
WEnd

; 123456789012345678
; ab  cd  ef  gh  ij
; 1 MMm, 
; 2 DDd, 
; 3 hh:
; 4 nn:
; 5 ss
;MsgBox( 4096, "Countdown to " & $sNewDate, "Months: " & $Months & " Days: " & $Days & " Hours: " & $Hours & " Minutes: " & $Minutes & " Seconds: " & $Seconds)
