Scriptname SimpleTransformConfig  extends SKI_ConfigBase 

SimpleTransformQuestScript Property STQ Auto
SimpleTransformOutfitSets Property STQOutfitSets Auto

GlobalVariable Property SliderA Auto
GlobalVariable Property SliderB Auto
GlobalVariable Property SliderC Auto
GlobalVariable Property ToggleA Auto
GlobalVariable Property TextA Auto

Int OID_SliderA
Int OID_SliderB
Int OID_SliderC
Int OID_ToggleA
Int OID_TextA

Int Function GetVersion()
    Return 1
EndFunction

Event OnPageReset(string page)

    If (Page == "") 
        SetTitleText("$ST_TITLE")
        LoadCustomContent("NWS/Pikachu2.dds", 0.0, 0.0)
    Else
        UnloadCustomContent()
    EndIf

    If Page == ("Transform") 
        SetCursorFillMode(TOP_TO_BOTTOM)
        
        AddHeaderOption("Customize Transform Options")
        
        AddColorOptionST("STQSkinColor", "Skin Color", STQ.STQSkinColor)
        AddTextOptionST("SetSkinColor", "", "Use Current Skin Color")
        AddColorOptionST("STQSuccubusHairColorInt", "Hair Color", STQ.STQSuccubusHairColorInt)
        AddTextOptionST("SetHairColor", "", "Use Current Hair Color")

        AddToggleOptionST("TransformTattoo", "Enable Transform Tattoo", STQ.TransformTattoo)
        AddMenuOptionST("STQTattooSlot", "Tattoo Slot", STQ.STQTattooSlot+1)
        AddColorOptionST("STQTattooColor", "Tattoo Color", STQ.STQTattooColor)
        AddTextOptionST("SetTattooColor", "", "Use Current Tattoo Color")
        AddToggleOptionST("TransformEyes", "Enable Transform Eyes", STQ.TransformEyes)
        AddToggleOptionST("EnableMaleTransform", "Enable Male Transform", STQ.EnableMaleTransform)

        SetCursorPosition(1)
        AddHeaderOption("Hotkeys")
        AddKeyMapOptionST("HotkeySetOutfit", "Set Outfit", STQ.HotkeySetOutfit)
        AddKeyMapOptionST("HotkeyTransform", "Transform", STQ.HotkeyTransform)
    Endif

    If (Page == "Debug")
        SetCursorFillMode(TOP_TO_BOTTOM)

        AddHeaderOption("Debug")

        AddToggleOptionST("DebugMode", "Enable Debug Mod", STQ.DebugMode)
    EndIf
EndEvent

Event OnOptionHighlight(Int Option)
    If (Option == OID_SliderA) 
        SetInfoText("Currently only changes the SliderA Global Variable")
    ElseIf (Option == OID_SliderB)
        SetInfoText("Currently only changes the SliderB Global Variable")
    ElseIf (Option == OID_SliderC)
        SetInfoText("Currently only changes the SliderC Global Variable")
    ElseIf (Option == OID_ToggleA)
        SetInfoText("Currently only changes the ToggleA Global Variable")
    ElseIf (Option == OID_TextA)
        SetInfoText("Currently only changes the TextA Global Variable")
    Endif
EndEvent

Event OnOptionSliderOpen(Int Option)
    If option == OID_SliderA 
            SetSliderDialogStartValue(SliderA.GetValue()) 
            SetSliderDialogDefaultValue(50) 
            SetSliderDialogRange(0, 100) 
            SetSliderDialogInterval(1)

    ElseIf option == OID_SliderB
            SetSliderDialogStartValue(SliderB.GetValue())
            SetSliderDialogDefaultValue(0.5)
            SetSliderDialogRange(0, 10)
            SetSliderDialogInterval(0.1)

    ElseIf option == OID_SliderC
            SetSliderDialogStartValue(SliderC.GetValue())
            SetSliderDialogDefaultValue(0.05)
            SetSliderDialogRange(0, 1)
            SetSliderDialogInterval(0.01)       
    EndIf
EndEvent

Event OnOptionSliderAccept(Int Option, Float Value)
    If option == OID_SliderA 
            SliderA.SetValue(Value) 
            SetSliderOptionValue(option, value, "{0}") 

    ElseIf option == OID_SliderB
            SliderB.SetValue(Value)
            SetSliderOptionValue(option, value, "{1}")

    ElseIf option == OID_SliderC
            SliderC.SetValue(Value)
            SetSliderOptionValue(option, value, "{2}")
    Endif
EndEvent

Event OnOptionSelect(int option)
    If (option == OID_ToggleA) 
        If ToggleA.GetValue() == 1 
            ToggleA.SetValue(0) 
            SetToggleOptionValue(OID_ToggleA, 0) 
        ElseIf ToggleA.GetValue() == 0 
            ToggleA.SetValue(1) 
            SetToggleOptionValue(OID_ToggleA, 1) 
        EndIf

    Elseif (option == OID_TextA) 
        If TextA.GetValue() == 0
            TextA.SetValue(1)
            SetTextOptionValue(OID_TextA, 1) 
        ElseIf TextA.GetValue() == 1
            TextA.SetValue(2)
            SetTextOptionValue(OID_TextA, 2)
        ElseIf TextA.GetValue() == 2
            TextA.SetValue(0)
            SetTextOptionValue(OID_TextA, 0)
        EndIf
    Endif
EndEvent

;Text Options
State SetSkinColor
    Event OnSelectST()
        STQ.STQSkinColor = Game.GetTintMaskColor(6, 0)
        SetColorOptionValueST(STQ.STQSkinColor, False, "STQSkinColor")
    EndEvent
    Event OnHighlightST()
        SetInfoText("Set current skin color as transformed skin color.")
    EndEvent
EndState

State SetHairColor
    Event OnSelectST()
        STQ.STQSuccubusHairColorInt = STQ.PlayerRef.GetLeveledActorBase().GetHairColor().GetColor()
        STQ.STQSuccubusHairColor.SetColor(STQ.STQSuccubusHairColorInt)
        SetColorOptionValueST(STQ.STQSuccubusHairColorInt, False, "STQSuccubusHairColorInt")
    EndEvent
    Event OnHighlightST()
        SetInfoText("Set current hair color as transformed hair color.")
    EndEvent
EndState

State SetTattooColor
    Event OnSelectST()
        STQ.STQTattooColor = STQ.GetBodyPaintColor(STQ.STQTattooSlot)
        SetColorOptionValueST(STQ.STQTattooColor, False, "STQTattooColor")
    EndEvent
    Event OnHighlightST()
        SetInfoText("Set current tattoo color as transformed tattoo color.")
    EndEvent
EndState
;Color Options
Event OnColorOpenST()
    String Option = GetState()
    If Option == "STQSkinColor"
        SetColorDialogStartColor(STQ.STQSkinColor)
		SetColorDialogDefaultColor(STQ.STQSkinColor)
    ElseIf Option == "STQSuccubusHairColorInt"
        SetColorDialogStartColor(STQ.STQSuccubusHairColorInt)
		SetColorDialogDefaultColor(STQ.STQSuccubusHairColorInt)
    ElseIf Option == "STQTattooColor"
        SetColorDialogStartColor(STQ.STQTattooColor)
        SetColorDialogDefaultColor(STQ.STQTattooColor)
    EndIf
EndEvent

Event OnColorAcceptST(Int Color)
    String Option = GetState()
    If Option == "STQSkinColor"
        STQ.STQSkinColor = Color + STQ.STQSkinColorAlpha * 16777216
		SetColorOptionValueST(Color)
    ElseIf Option == "STQSuccubusHairColorInt"
        STQ.STQSuccubusHairColorInt = Color
        STQ.STQSuccubusHairColor.SetColor(Color)
        SetColorOptionValueST(Color)
    ElseIf Option == "STQTattooColor"
        STQ.STQTattooColor = Color
        SetColorOptionValueST(Color)
    EndIf
EndEvent

; Key Map
Event OnKeyMapChangeST(Int KeyCode, String ConflictControl, String ConflictName)
    String Option = GetState()
    If Option == "HotkeySetOutfit"
        If !KeyConflict(KeyCode, ConflictControl, ConflictName)
            STQ.HotkeySetOutfit = KeyCode
            SetKeyMapOptionValueST(STQ.HotkeySetOutfit)
        EndIf
    ElseIf (Option == "HotkeyTransform")
        If (!KeyConflict(KeyCode, ConflictControl, ConflictName))
            STQ.HotkeyTransform = KeyCode
            SetKeyMapOptionValueST(STQ.HotkeyTransform)
        EndIf
    EndIf
    STQ.ReloadHotKeys()
EndEvent

Bool Function KeyConflict(Int KeyCode, String ConflictControl, String ConflictName)
    Bool Continue = True
    If ConflictControl != ""
        String Msg
        If (ConflictName != "")
            Msg = "This key is already mapped to: \n'" + ConflictControl + "'\n(" + ConflictName + ")\n\nAre you sure you want to continue?"
        Else
            Msg = "This key is already mapped to: \n'" + ConflictControl + "'\n\nAre you sure you want to continue?"
        EndIf
        Continue = ShowMessage(Msg, True, "$Yes", "$No")
    EndIf
    Return !Continue
EndFunction

;Menu Options
State STQTattooSlot
    Event OnMenuOpenST()
        Int OverlayNum = NiOverride.GetNumBodyOverlays()
        String[] Options = New String[10]
        Int Index = 0
        While (Index < OverlayNum)
            Options[Index] = Index + 1
            Index += 1
        EndWhile
        SetMenuDialogStartIndex(0)
        SetMenuDialogDefaultIndex(0)
        SetMenuDialogOptions(Options)
    EndEvent
    Event OnMenuAcceptST(Int I)
        STQ.STQTattooSlot = I
        SetMenuOptionValueST(STQ.STQTattooSlot + 1)
    EndEvent
EndState

;Toggle Switchs
Event OnSelectST()
    String Option = GetState()
    If (Option == "TransformTattoo")
        STQ.TransformTattoo = !STQ.TransformTattoo
        SetToggleOptionValueST(STQ.TransformTattoo)
    ElseIf (Option == "TransformEyes")
        STQ.TransformEyes = !STQ.TransformEyes
        SetToggleOptionValueST(STQ.TransformEyes)
    ElseIf (Option == "DebugMode")
        STQ.DebugMode = !STQ.DebugMode
        SetToggleOptionValueST(STQ.DebugMode)
    ElseIf (Option == "EnableMaleTransform")
        STQ.EnableMaleTransform = !STQ.EnableMaleTransform
        SetToggleOptionValueST(STQ.EnableMaleTransform)
        If (STQ.EnableMaleTransform)
            ShowMessage("Pikapika", False, "$Yes")
        EndIf
    EndIf
EndEvent