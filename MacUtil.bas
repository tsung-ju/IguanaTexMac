Attribute VB_Name = "MacUtil"
Public Const PathSeperator As String = "/"

Public Function ShellEscape(Str As String) As String
    ShellEscape = "'" & Replace(Replace(Str, "\", "\\"), "'", "'\''") & "'"
End Function

Public Function ReadAllBytes(filename As String) As Byte()
    Dim fnum As Integer
    fnum = FreeFile()
    Open filename For Binary Access Read As fnum

    Dim length As Long
    length = FileLen(filename)

    Dim data() As Byte
    If length <> 0 Then
        ReDim data(length - 1)
        Get #fnum, , data
    End If

    Close #fnum

    ReadAllBytes = data
End Function

Public Function ReadAll(filename As String) As String
    ReadAll = Utf8ToString(ReadAllBytes(filename))
End Function

Public Function ReadAllExternal(pathname As String) As String
    ReadAllExternal = AppleScriptTask("IguanaTex.scpt", "ReadAllExternal", pathname)
End Function

Public Function MacTempPath() As String
    MacTempPath = MacScript("POSIX path of (path to temporary items)")
End Function

Public Function MacChooseFileOfType(typeStr As String) As String
    MacChooseFileOfType = AppleScriptTask("IguanaTex.scpt", "MacChooseFileOfType", typeStr)
End Function

Public Function MacChooseApp(defaultValue As String) As String
    MacChooseApp = AppleScriptTask("IguanaTex.scpt", "MacChooseApp", defaultValue)
End Function

Public Function MacChooseFile(defaultValue As String) As String
    MacChooseFile = AppleScriptTask("IguanaTex.scpt", "MacChooseFile", defaultValue)
End Function

Public Function MacChooseFolder(defaultValue As String) As String
    MacChooseFolder = AppleScriptTask("IguanaTex.scpt", "MacChooseFolder", defaultValue)
End Function







