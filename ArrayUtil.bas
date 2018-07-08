Attribute VB_Name = "ArrayUtil"
Public Function ArrayLength(arr As Variant) As Long
    On Error GoTo handler
    ArrayLength = UBound(arr) + 1
    Exit Function
handler:
    ArrayLength = 0
End Function

