VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "FileSystemObject"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
' Replacement for Scripting.FileSystemObject

Option Explicit

Public Function FileExists(pathname As String) As Boolean
    FileExists = (Dir(pathname) <> "")
End Function

Public Function FolderExists(pathname As String) As Boolean
    FolderExists = (Dir(pathname) <> "")
End Function

Public Sub CreateFolder(pathname As String)
    MkDir pathname
End Sub

' calls `find <dirname> -name <pattern> -delete`
Public Sub FindDelete(dirname As String, pattern As String)
    AppleScriptTask "IguanaTex.scpt", "MacExecute", "find " & ShellEscape(dirname) & " -name " & ShellEscape(pattern) & " -delete"
End Sub

' does not support path globbing. use `FindDelete` instead.
Public Sub DeleteFile(pathname As String)
    If FileExists(pathname) Then
        ' remove readonly attribute if set
        SetAttr pathname, vbNormal
        Kill pathname
    End If
End Sub

