Scriptname SimpleTransformOutfitSets extends Quest
{The documentation string.}

; code
Formlist Property STQOutfitChestList Auto 
ObjectReference Property STQOutfitBox Auto Hidden

Event OnMenuClose(String MenuName)
    If (MenuName == "ContainerMenu")
        UnregisterForMenu("ContainerMenu")
        CompleteOutfit()
    EndIf
EndEvent

Function CreateOutfit(Actor akActor)
    If (Utility.IsInMenuMode())
        Return
    EndIf
    Debug.Trace("Open Outfit Menu", 0)
    Debug.Trace(STQOutfitChestList.GetSize(), 0)
    ObjectReference OutfitChest = STQOutfitChestList.GetAt(2) as ObjectReference

    Utility.Wait(0.1)

    RegisterForMenu("ContainerMenu")
    OutfitChest.Activate(akActor)
EndFunction

Function CompleteOutfit()
    Debug.Trace("Close Outfit Menu", 0)
EndFunction