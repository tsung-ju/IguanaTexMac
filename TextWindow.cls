VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "TextWindow"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
' Replacement for TextBox

Option Explicit


Private Declare PtrSafe Function TWInit _
    Lib "/Library/Application Support/Microsoft/Office365/User Content.localized/Add-Ins.localized/libIguanaTexHelper.dylib" _
   () As LongLong
Private Declare PtrSafe Function TWTerm _
 Lib "/Library/Application Support/Microsoft/Office365/User Content.localized/Add-Ins.localized/libIguanaTexHelper.dylib" _
(ByVal Handle As LongLong, ByVal b As LongLong, ByVal c As LongLong, ByVal d As LongLong) As Integer

Private Declare PtrSafe Function TWResize _
    Lib "/Library/Application Support/Microsoft/Office365/User Content.localized/Add-Ins.localized/libIguanaTexHelper.dylib" _
   (ByVal Handle As LongLong, ByVal b As LongLong, ByVal c As LongLong, ByVal d As LongLong) As Integer

Private Declare PtrSafe Function TWShow _
    Lib "/Library/Application Support/Microsoft/Office365/User Content.localized/Add-Ins.localized/libIguanaTexHelper.dylib" _
   (ByVal Handle As LongLong, ByVal b As LongLong, ByVal c As LongLong, ByVal d As LongLong) As Integer

Private Declare PtrSafe Function TWHide _
    Lib "/Library/Application Support/Microsoft/Office365/User Content.localized/Add-Ins.localized/libIguanaTexHelper.dylib" _
   (ByVal Handle As LongLong, ByVal b As LongLong, ByVal c As LongLong, ByVal d As LongLong) As Integer

Private Declare PtrSafe Function TWSet _
    Lib "/Library/Application Support/Microsoft/Office365/User Content.localized/Add-Ins.localized/libIguanaTexHelper.dylib" _
   (ByVal Handle As LongLong, ByVal data As LongPtr, ByVal length As LongLong, ByVal d As LongLong) As Integer

Private Declare PtrSafe Function TWGet _
    Lib "/Library/Application Support/Microsoft/Office365/User Content.localized/Add-Ins.localized/libIguanaTexHelper.dylib" _
   (ByVal Handle As LongLong, ByRef data As LongPtr, ByRef length As LongLong, ByVal d As LongLong) As Integer

Private Declare PtrSafe Function TWGetSel _
    Lib "/Library/Application Support/Microsoft/Office365/User Content.localized/Add-Ins.localized/libIguanaTexHelper.dylib" _
   (ByVal Handle As LongLong, ByVal b As LongLong, ByVal c As LongLong, ByVal d As LongLong) As Integer

Private Declare PtrSafe Function TWSetSel _
    Lib "/Library/Application Support/Microsoft/Office365/User Content.localized/Add-Ins.localized/libIguanaTexHelper.dylib" _
   (ByVal Handle As LongLong, ByVal Sel As LongLong, ByVal c As LongLong, ByVal d As LongLong) As Integer

Private Declare PtrSafe Function TWFocus _
    Lib "/Library/Application Support/Microsoft/Office365/User Content.localized/Add-Ins.localized/libIguanaTexHelper.dylib" _
   (ByVal Handle As LongLong, ByVal b As LongLong, ByVal c As LongLong, ByVal d As LongLong) As Integer

Private Declare PtrSafe Function TWGetSZ _
    Lib "/Library/Application Support/Microsoft/Office365/User Content.localized/Add-Ins.localized/libIguanaTexHelper.dylib" _
   (ByVal Handle As LongLong, ByVal b As LongLong, ByVal c As LongLong, ByVal d As LongLong) As Integer

Private Declare PtrSafe Function TWSetSZ _
    Lib "/Library/Application Support/Microsoft/Office365/User Content.localized/Add-Ins.localized/libIguanaTexHelper.dylib" _
   (ByVal Handle As LongLong, ByVal sz As LongLong, ByVal c As LongLong, ByVal d As LongLong) As Integer

Private Declare PtrSafe Function memcpy Lib "libc.dylib" (ByVal dest As LongPtr, ByVal src As LongPtr, ByVal n As LongLong) As LongPtr
Private Declare PtrSafe Sub free Lib "libc.dylib" (ByVal ptr As LongPtr)

' members
Private Handle As LongLong

' properties
Public Property Get Utf8() As Byte()
    Dim ptr As LongPtr
    Dim length As LongLong
    Dim ret() As Byte

    TWGet Handle, ptr, length, 0
    
    If length <> 0& Then
        ReDim ret(CLng(length) - 1)
        memcpy VarPtr(ret(0)), ptr, length
    End If

    free ptr

    Utf8 = ret
End Property

Public Property Let Utf8(data() As Byte)
    Dim length As Long
    length = ArrayLength(data)
    If length > 0 Then
         TWSet Handle, VarPtr(data(0)), length, 0
    Else
         TWSet Handle, 0, 0, 0
    End If
End Property

Public Property Get Text() As String
    Text = Utf8ToString(Me.Utf8)
End Property

Public Property Let Text(Str As String)
    Me.Utf8 = StringToUtf8(Str)
End Property

Public Property Get SelStart() As Integer
    SelStart = TWGetSel(Handle, 0, 0, 0)
End Property

Public Property Let SelStart(Sel As Integer)
    TWSetSel Handle, Sel, 0, 0
End Property

Public Property Get FontSize() As Integer
    FontSize = TWGetSZ(Handle, 0, 0, 0)
End Property

Public Property Let FontSize(sz As Integer)
    TWSetSZ Handle, sz, 0, 0
End Property

' constructor/destructor
Private Sub Class_Initialize()
    Handle = TWInit
End Sub

Private Sub Class_Terminate()
    TWTerm Handle, 0, 0, 0
End Sub

' methods
Public Sub Show()
    TWShow Handle, 0, 0, 0
End Sub

Public Sub Hide()
    TWHide Handle, 0, 0, 0
End Sub

Public Sub ResizeAs(target As control, parentForm As UserForm)
    Dim currentFocus As control
    Set currentFocus = parentForm.ActiveControl
    target.SetFocus
    TWResize Handle, 0, 0, 0
    currentFocus.SetFocus
End Sub

Public Sub SetFocus()
    TWFocus Handle, 0, 0, 0
End Sub

