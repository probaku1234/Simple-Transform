Scriptname SimpleTransformQuestScript extends Quest
{The documentation string.}

; code
SimpleTransformOutfitSets Property STQOutfitSets Auto

Actor Property PlayerRef Auto

Spell Property TransformSpell Auto

Bool Property IsTransformed = false Auto Hidden
Bool Property IsInTranform  = false Auto Hidden
Bool Property TransformEyes Auto Hidden
Int Property OriginalSkinColor Auto Hidden
Int Property STQSkinColor = -16775751 Auto Hidden
Int Property STQSkinColorAlpha = 255 Auto Hidden
Int Property STQSuccubusHairColorInt Auto Hidden
Int Property HotkeySetOutfit = 211 Auto Hidden 
Int Property HotkeyTransform = 221 Auto Hidden
Int Property STQTattooSlot = 0 Auto Hidden
Int Property STQTattooColor =  0x000000 Auto Hidden
ColorForm Property OriginalHairColor Auto Hidden
ColorForm Property STQSuccubusHairColor Auto 
Sound Property SoundTransformMoan Auto
EffectShader Property SuccubusTransFXS Auto
EffectShader Property FireFXShader Auto
EffectShader Property ShockPlayerCloakFXShader Auto
Bool Property TransformTattoo Auto Hidden
Bool Property DebugMode Auto Hidden
HeadPart Property STQSuccubusEyes Auto
HeadPart Property OriginalEyes Auto Hidden

Event OnPlayerLoadGame()
    If !PlayerRef.HasSpell(TransformSpell)
        If PlayerRef.AddSpell(TransformSpell)
            Debug.Notification("Transform Spell Added")
        EndIf
    EndIf
    
    STQReload()
    Debug.Notification("STQ Reloaded")
EndEvent

Event OnInit()
    OnPlayerLoadGame()
EndEvent

Event OnKeyDown(Int KeyCode)
    If (KeyCode == HotkeySetOutfit)
        STQOutfitSets.CreateOutfit(PlayerRef)
    EndIf

    If (KeyCode == HotkeyTransform)
        TransformSpell.Cast(PlayerRef)
    EndIf
EndEvent

Function ReloadHotKeys()
    UnregisterForAllKeys()
    RegisterForKey(HotkeySetOutfit)
    RegisterForKey(HotkeyTransform)
EndFunction

Function STQReload()
    If (IsTransformed)
        Game.SetTintMaskColor(STQSkinColor, 6, 0)
        STQSuccubusHairColor.SetColor(STQSuccubusHairColorInt)
        PlayerRef.GetLeveledActorBase().SetHairColor(STQSuccubusHairColor)
        PlayerRef.QueueNiNodeUpdate()
    EndIf
    ReloadHotKeys()
EndFunction

Int Function GetBodyPaintColor(Int Slot)
    Int Color = NiOverride.GetNodeOverrideInt(PlayerRef, True, "Body [Ovl" + Slot + "]", 8, -1)
    Return Color
EndFunction