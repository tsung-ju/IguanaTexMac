Attribute VB_Name = "RegistryAccess"
' Portions taken from:
' http://www.kbalertz.com/kb_145679.aspx
   
Option Explicit

Public Const REG_SZ As Long = 1
Public Const REG_DWORD As Long = 4

Public Const HKEY_CLASSES_ROOT = &H80000000
Public Const HKEY_CURRENT_USER = &H80000001
Public Const HKEY_LOCAL_MACHINE = &H80000002
Public Const HKEY_USERS = &H80000003

Public Const ERROR_NONE = 0
Public Const ERROR_BADDB = 1
Public Const ERROR_BADKEY = 2
Public Const ERROR_CANTOPEN = 3
Public Const ERROR_CANTREAD = 4
Public Const ERROR_CANTWRITE = 5
Public Const ERROR_OUTOFMEMORY = 6
Public Const ERROR_ARENA_TRASHED = 7
Public Const ERROR_ACCESS_DENIED = 8
Public Const ERROR_INVALID_PARAMETERS = 87
Public Const ERROR_NO_MORE_ITEMS = 259

Public Const KEY_QUERY_VALUE = &H1
Public Const KEY_SET_VALUE = &H2
Public Const KEY_ALL_ACCESS = &H3F

Public Const REG_OPTION_NON_VOLATILE = 0


Public Function GetRegistryValue(Hive, Keyname, Valuename, defaultValue)
    If Hive <> HKEY_CURRENT_USER Then
        MsgBox "GetRegistryValue with Hive other than HKEY_CURRENT_USER is not implemented. return defaultValue."
        GetRegistryValue = defaultValue
        Exit Function
    End If
    
    Dim Str As String
    
    Str = GetSetting("IguanaTex", Keyname, Valuename, "")
    If Str = "" Then
        GetRegistryValue = defaultValue
    Else
        Dim sp() As String
        sp = Split(Str, ":", 2)
        If UBound(sp) + 1 < 2 Then
            GetRegistryValue = defaultValue
        ElseIf sp(0) = "sz" Then
            GetRegistryValue = sp(1)
        ElseIf sp(0) = "dword" Then
            GetRegistryValue = CLng(sp(1))
        Else
            GetRegistryValue = defaultValue
        End If
    End If
End Function


Public Sub SetRegistryValue(Hive, ByRef Keyname As String, ByRef Valuename As String, _
Valuetype As Long, Value As Variant)
    If Hive <> HKEY_CURRENT_USER Then
        MsgBox "SetRegistryValue with Hive other than HKEY_CURRENT_USER is not implemented."
        Exit Sub
    End If

    If Valuetype = REG_SZ Then
        SaveSetting "IguanaTex", Keyname, Valuename, "sz:" & Value
    ElseIf Valuetype = REG_DWORD Then
        SaveSetting "IguanaTex", Keyname, Valuename, "dword:" & CStr(Value)
    Else
        MsgBox "Error saving registry key."
    End If
End Sub
