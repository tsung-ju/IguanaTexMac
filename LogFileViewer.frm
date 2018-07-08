VERSION 5.00
Begin {C62A69F0-16DC-11CE-9E98-00AA00574A4F} LogFileViewer 
   Caption         =   "Error in Latex Code"
   ClientHeight    =   6975
   ClientLeft      =   40
   ClientTop       =   320
   ClientWidth     =   8860.001
   OleObjectBlob   =   "LogFileViewer.frx":0000
   StartUpPosition =   1  'CenterOwner
End
Attribute VB_Name = "LogFileViewer"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub UserForm_Initialize()
    Me.Top = Application.Top + 110
    Me.Left = Application.Left + 25
End Sub

Private Sub CloseLogButton_Click()
    
    SelStartPos = LatexForm.TextWindow1.SelStart
    TempPath = LatexForm.TextBoxTempFolder.Text
    
    If Left(TempPath, 1) = "." Then
        Dim sPath As String
        sPath = ActivePresentation.path
        If Len(sPath) > 0 Then
            If Right(sPath, 1) <> PathSeperator Then
                sPath = sPath & PathSeperator
            End If
            TempPath = sPath & TempPath
        Else
            MsgBox "You need to have saved your presentation once to use a relative path."
            Exit Sub
        End If
    End If
    
    LatexForm.TextWindow1.Text = ReadAll(TempPath & GetFilePrefix() & ".tex")


    CloseLogButton.Caption = "Close"
    Unload LogFileViewer
    LatexForm.TextWindow1.SetFocus
    If SelStartPos < Len(LatexForm.TextWindow1.Text) Then
        LatexForm.TextWindow1.SelStart = SelStartPos
    End If
End Sub

Private Sub CmdButtonExternalEditor_Click()
    TempPath = LatexForm.TextBoxTempFolder.Text
    If Left(TempPath, 1) = "." Then
        Dim sPath As String
        sPath = ActivePresentation.path
        If Len(sPath) > 0 Then
            If Right(sPath, 1) <> PathSeperator Then
                sPath = sPath & PathSeperator
            End If
            TempPath = sPath & TempPath
        Else
            MsgBox "You need to have saved your presentation once to use a relative path."
            Exit Sub
        End If
    End If
    LogFileViewer.Caption = """" & GetEditorPath() & """ """ & TempPath & GetFilePrefix() & ".tex"""
    CloseLogButton.Caption = "Reload modified code"
    AppleScriptTask "IguanaTex.scpt", "MacExecute", GetEditorPath() & " " & ShellEscape(TempPath & FilePrefix & ".tex")

End Sub
