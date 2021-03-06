
; #FUNCTION# ====================================================================================================================
; Name ..........: Collect
; Description ...:
; Syntax ........: Collect()
; Parameters ....:
; Return values .: None
; Author ........: Code Gorilla #3
; Modified ......: Sardo 2015-08, KnowJack(Aug 2015), kaganus (August 2015)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func Collect()
	if $RunState = False Then Return

	ClickP($aAway,1,0,"#0332") ;Click Away

	If $iChkCollect = 0 Then Return

	Local $collx, $colly, $i = 0

	VillageReport(True, True)
	$tempCounter = 0
	While ($iGoldCurrent = "" Or $iElixirCurrent = "" Or ($iDarkCurrent = "" And $iDarkStart <> "")) And $tempCounter < 3
		$tempCounter += 1
		VillageReport(True, True)
	WEnd
	Local $tempGold = $iGoldCurrent
	Local $tempElixir = $iElixirCurrent
	Local $tempDElixir = $iDarkCurrent

	SetLog("Collecting Resources", $COLOR_BLUE)
	If _Sleep($iDelayCollect2) Then Return

	if $listResourceLocation <> "" then
		local $ResourceLocations = StringSplit($listResourceLocation,"|")
		for $i=1 to $ResourceLocations[0]
			if $ResourceLocations[$i] <> "" then
				$pixel = StringSplit($ResourceLocations[$i],";")
				If isInsideDiamondXY($pixel[1],$pixel[2]) Then
				   if IsMainPage() Then click($pixel[1],$pixel[2],1,0,"#0331")
				Else
					SetLog("Error in Mines/Collector locations found, finding positions again", $COLOR_RED)
					IniDelete($building, "other", "listResource")
					If _Sleep($iDelayCollect2) Then Return
					$listResourceLocation = ""
					BotDetectFirstTime()
					IniWrite($building, "other", "listResource", $listResourceLocation)
					ExitLoop
				EndIf
				If _Sleep($iDelayCollect2) Then Return
			endif
		next
	endif

	checkAttackDisable($iTaBChkIdle)  ; Early Take-A-Break detection

	While 1
		If _Sleep($iDelayCollect1) Or $RunState = False Then ExitLoop
		_CaptureRegion(0,0,780)
		If _ImageSearch(@ScriptDir & "\images\collect.png", 1, $collx, $colly, 20) Then
			If IsMainPage() Then Click($collx, $colly,1,0,"#0330") ;Click collector
			If _Sleep($iDelayCollect1) Then Return
			ClickP($aAway,1,0,"#0329") ;Click Away
		Elseif $i >= 20 Then
			ExitLoop
		EndIf
		$i += 1
	WEnd
	If _Sleep($iDelayCollect3) Then Return
	checkMainScreen(False)  ; check if errors during function

	VillageReport(True, True)
	$tempCounter = 0
	While ($iGoldCurrent = "" Or $iElixirCurrent = "" Or ($iDarkCurrent = "" And $iDarkStart <> "")) And $tempCounter < 3
		$tempCounter += 1
		VillageReport(True, True)
	WEnd

	If $tempGold <> "" And $iGoldCurrent <> "" Then
		$tempGoldCollected = $iGoldCurrent - $tempGold
		$iGoldFromMines += $tempGoldCollected
		$iGoldTotal += $tempGoldCollected
	EndIf

	If $tempElixir <> "" And $iElixirCurrent <> "" Then
		$tempElixirCollected = $iElixirCurrent - $tempElixir
		$iElixirFromCollectors += $tempElixirCollected
		$iElixirTotal += $tempElixirCollected
	EndIf

	If $tempDElixir <> "" And $iDarkCurrent <> "" Then
		$tempDElixirCollected = $iDarkCurrent - $tempDElixir
		$iDElixirFromDrills += $tempDElixirCollected
		$iDarkTotal += $tempDElixirCollected
	EndIf

	UpdateStats()
EndFunc   ;==>Collect