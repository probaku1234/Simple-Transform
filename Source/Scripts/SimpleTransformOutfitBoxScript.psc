Scriptname SimpleTransformOutfitBoxScript extends ObjectReference
{The documentation string.}

; code
Event OnItemAdded(Form akBaseItem, Int aiItemCount, ObjectReference akItemReference, ObjectReference akSourceContainer)
    Armor myArmor = akBaseItem as Armor
    If !(myArmor && myArmor.GetSlotMask())
        RemoveItem(akBaseItem, aiItemCount, True, akSourceContainer)
        Debug.Notification(akBaseItem.GetName() + " is not armor")
    EndIf
EndEvent