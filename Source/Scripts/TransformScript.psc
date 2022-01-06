Scriptname TransformScript extends ActiveMagicEffect
{The documentation string.}

; code
SimpleTransformQuestScript Property STQ Auto
SimpleTransformOutfitSets Property STQOutfitSets Auto
Int Property BPGTintColorStart = 0xFF0000 Auto Hidden
Int Property BPGTintColorEnd =  0x000000 Auto Hidden

Event OnEffectStart(Actor akTarget, Actor akCaster)
    If !STQ.IsInTranform && akCaster == STQ.PlayerRef
        Transform(akCaster)
    EndIf
EndEvent

Function Transform(Actor akActor)
    If (akActor.IsOnMount())
        Debug.Notification("No Transform While on Mount")
        Return
    EndIf
    If (!STQ.EnableMaleTransform && akActor.GetLeveledActorBase().GetSex() != 1)
        Debug.Notification("Male Transform Not Enabled")
        Return
    EndIf
    If STQ.IsTransformed
        BecomeHuman(akActor)
    Else
        BecomeSuccu(akActor)
    EndIf
EndFunction

Function BecomeSuccu(Actor akActor)
    If (STQ.DebugMode)
        Debug.Notification("Become Succubus")
    EndIf
    
    STQ.IsTransformed = True
    STQ.IsInTranform = True

    ; Play Transform Effect
    Int TransformMoan = STQ.SoundTransformMoan.Play(akActor)
    STQ.SuccubusTransFXS.Play(akActor, 0.5)
    Utility.Wait(0.5)
    STQ.FireFXShader.Play(akActor, 0.5)
    STQ.ShockPlayerCloakFXShader.Play(akActor, 0.5)

    ; Transform Skin Color
    STQ.OriginalSkinColor = Game.GetTintMaskColor(6, 0)
    Game.SetTintMaskColor(STQ.STQSkinColor, 6, 0)

    ; Trasform Eyes
    If STQ.TransformEyes
        Int Eye = akActor.GetLeveledActorBase().GetNumHeadParts()
        Int i = 0
        While (i < Eye)
            If (akActor.GetLeveledActorBase().GetNthHeadPart(i).GetType() == 2)
                STQ.OriginalEyes = akActor.GetLeveledActorBase().GetNthHeadPart(i)
                i = Eye
            EndIf
            i += 1
        EndWhile
        akActor.ChangeHeadPart(STQ.STQSuccubusEyes)
    EndIf

    ; Transform Tattoo
    If (STQ.TransformTattoo)
        STQ.OriginalTattooColor = STQ.GetBodyPaintColor(STQ.STQTattooSlot)
        STQ.OriginalTattooAlpha = STQ.GetBodyPaintAlpha(STQ.STQTattooSlot)
        STQ.OriginalTattooGlowColor = STQ.GetBodyPaintGlowColor(STQ.STQTattooSlot)
        STQ.OriginalTattooGlowAlpha = STQ.GetBodyPaintGlowAlpha(STQ.STQTattooSlot)

        NiOverride.AddNodeOverrideInt(akActor, True, "Body [Ovl" + STQ.STQTattooSlot + "]", 7, -1, STQ.STQTattooColor, True)
        NiOverride.AddNodeOverrideFloat(akActor, True, "Body [Ovl" + STQ.STQTattooSlot + "]", 8, -1, STQ.STQTattooAlpha, True)
        NiOverride.AddNodeOverrideInt(akActor, True, "Body [Ovl" + STQ.STQTattooSlot + "]", 0, -1, STQ.STQTattooGlowColor, True)
        NiOverride.AddNodeOverrideFloat(akActor, True, "Body [Ovl" + STQ.STQTattooSlot + "]", 1, -1, STQ.STQTattooGlowAlpha, True)
    EndIf

    ; Transform Hair Color
    STQ.OriginalHairColor = akActor.GetLeveledActorBase().GetHairColor()
    ; STQ.STQSuccubusHairColor = akActor.GetLeveledActorBase().GetHairColor()
    STQ.STQSuccubusHairColor.SetColor(STQ.STQSuccubusHairColorInt)
    akActor.GetLeveledActorBase().SetHairColor(STQ.STQSuccubusHairColor)
    akActor.QueueNiNodeUpdate()

    ; Armor
    ObjectReference OutfitChest = STQOutfitSets.STQOutfitChestList.GetAt(2) as ObjectReference
    ObjectReference OriginalOutfitChest = STQOutfitSets.STQOutfitChestList.GetAt(3) as ObjectReference
    
    GetWornFormsAndAddtoChest(akActor, OriginalOutfitChest)
    
    Int Index = 0    
    Int OutfitSize = OutfitChest.GetNumItems()
    If OutfitSize > 0
        While Index < OutfitSize
            Form OutfitItem = OutfitChest.GetNthForm(Index)
            akActor.EquipItem(OutfitItem, True, True)
            ; Utility.Wait(0.2)
            Index += 1
        EndWhile
    EndIf
    
    If (STQ.EnableFuta)
        Int handle = ModEvent.Create("GenderBender_SetActorGender")
        If (handle)
            ModEvent.PushForm(handle, akActor)
	        ModEvent.PushInt(handle, 0)
	        ModEvent.Send(handle)
        EndIf    
    EndIf

    STQ.IsInTranform = False
EndFunction

Function BecomeHuman(Actor akActor)
    If (STQ.DebugMode)
        Debug.Notification("Become Human")
    EndIf
    
    STQ.IsInTranform = True
    STQ.IsTransformed = False

    ; Play Transform Effect
    STQ.SuccubusTransFXS.Play(akActor, 0.5)
    Utility.Wait(0.5)

    ; Transform Skin Color
    Game.SetTintMaskColor(STQ.OriginalSkinColor, 6, 0)

    ; Transform Eyes
    If (STQ.OriginalEyes)
        akActor.ChangeHeadPart(STQ.OriginalEyes)
    EndIf

    ; Transform Tattoo
    If (STQ.OriginalTattooColor)
        NiOverride.AddNodeOverrideInt(akActor, True, "Body [Ovl" + STQ.STQTattooSlot + "]", 7, -1, STQ.OriginalTattooColor, True)
        NiOverride.AddNodeOverrideFloat(akActor, True, "Body [Ovl" + STQ.STQTattooSlot + "]", 8, -1, STQ.OriginalTattooAlpha, True)
        NiOverride.AddNodeOverrideInt(akActor, True, "Body [Ovl" + STQ.STQTattooSlot + "]", 0, -1, STQ.OriginalTattooGlowColor, True)
        NiOverride.AddNodeOverrideFloat(akActor, True, "Body [Ovl" + STQ.STQTattooSlot + "]", 1, -1, STQ.OriginalTattooGlowAlpha, True)
    EndIf

    ; Transform Hair Color
    akActor.GetLeveledActorBase().SetHairColor(STQ.OriginalHairColor)
    akActor.QueueNiNodeUpdate()

    ;
    ; Armor
    ObjectReference OutfitChest = STQOutfitSets.STQOutfitChestList.GetAt(2) as ObjectReference
    Int Index = 0    
    Int OutfitSize = OutfitChest.GetNumItems()
    If OutfitSize > 0
        While Index < OutfitSize
            Form OutfitItem = OutfitChest.GetNthForm(Index)
            ; Debug.Notification(OutfitItem.GetName() + ": " + akActor.GetItemCount(OutfitItem))
            akActor.UnequipItem(OutfitItem, False, True)
            Utility.Wait(0.2)
            akActor.RemoveItem(OutfitItem, akActor.GetItemCount(OutfitItem), True)
            Index += 1
        EndWhile
    EndIf

    ObjectReference OriginalOutfitChest = STQOutfitSets.STQOutfitChestList.GetAt(3) as ObjectReference
    Int I = 0    
    Int OrigianlOutfitSize = OriginalOutfitChest.GetNumItems()
    If OrigianlOutfitSize > 0
        While I < OrigianlOutfitSize
            Form OutfitItem = OriginalOutfitChest.GetNthForm(I)
            ; Debug.Notification(OutfitItem.GetName() + ": " + akActor.GetItemCount(OutfitItem))
            akActor.EquipItem(OutfitItem, False, True)
            ; Utility.Wait(0.2)
            I += 1
        EndWhile
    EndIf
    OriginalOutfitChest.RemoveAllItems()

    If (STQ.EnableFuta)
        Int handle = ModEvent.Create("GenderBender_SetActorGender")
        If (handle)
            ModEvent.PushForm(handle, akActor)
	        ModEvent.PushInt(handle, 1)
	        ModEvent.Send(handle)
        EndIf    
    EndIf

    STQ.IsInTranform = False
    ; Debug.Notification("Body Overlay: " + NiOverride.GetNumBodyOverlays())
EndFunction

Function GetWornFormsAndAddtoChest(Actor akActor, ObjectReference OriginalOutfitChest)
    Int Index
    Int SlotsChecked
    SlotsChecked += 0x00100000
    SlotsChecked += 0x00200000 ;ignore reserved slots
    SlotsChecked += 0x80000000
    
    Int ThisSlot = 0x01
    While (ThisSlot < 0x80000000)
        If (Math.LogicalAnd(SlotsChecked, ThisSlot) != ThisSlot)
            Armor ThisArmor = akActor.GetWornForm(ThisSlot) as Armor
            If (ThisArmor)
                OriginalOutfitChest.AddItem(ThisArmor, 1, True)
                SlotsChecked += ThisArmor.GetSlotMask()
            Else
                SlotsChecked += ThisSlot
            EndIf
        EndIf
        ThisSlot *= 2
    EndWhile
EndFunction
