Attribute VB_Name = "ShellWait"
Public Function OpenLink(ByVal Link As String) As Long
    Dim ret As Long
    ret = CLng(AppleScriptTask("IguanaTex.scpt", "MacExecute", "open " & ShellEscape(Link)))
    If ret = 0 Then
        ' success
        OpenLink = 33 ' returns a value greater than 32
    Else
        ' failed
        OpenLink = 0
    End If
End Function


Public Function Execute(ByVal CommandLine As String, StartupDir As String, Optional debugMode As Boolean = False, Optional WaitTime As Long = -1) As Long
    Const RegPath = "Software\IguanaTex"
    Dim TeXExePath As String
    TeXExePath = GetRegistryValue(HKEY_CURRENT_USER, RegPath, "TeXExePath", DEFAULT_TEX_EXE_PATH)
    Execute = CLng(AppleScriptTask("IguanaTex.scpt", "MacExecute", _
        "export PATH=" & ShellEscape(TeXExePath) & """:$PATH""" & " && " & _
        "cd " & ShellEscape(StartupDir) & " && " & _
        CommandLine))
End Function

