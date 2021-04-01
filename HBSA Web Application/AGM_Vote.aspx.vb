Imports System.ComponentModel
Imports System.Runtime.Serialization

Public Class AGM_Vote
    Inherits System.Web.UI.Page

    'Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load


    '    If IsNothing(Session("ClubLoginID")) AndAlso ((Session("adminDetails") Is Nothing OrElse Session("adminDetails").Rows.count = 0)) Then
    '        Session("LoginCaller") = Request.Url.AbsolutePath
    '        Response.Redirect("ClubLogin.aspx")
    '    End If

    '    If Not IsPostBack Then

    '        With Club_DropDownList
    '            .Items.Clear()
    '            .Visible = True
    '            .Items.Add(New ListItem("**Select a Club**", "-1"))
    '            Using clubs As DataTable = HBSAcodeLibrary.ClubData.GetClubs

    '                For Each club As DataRow In clubs.Rows
    '                    .Items.Add(New ListItem(club.Item("Club Name"), club.Item("ID")))
    '                    If club.Item("ID") = If(Session("ClubLoginID") Is Nothing, 0, Session("ClubLoginID")) Then
    '                        .SelectedIndex = .Items.Count - 1
    '                    End If
    '                Next

    '                If Not Session("adminDetails") Is Nothing AndAlso Session("adminDetails").Rows.count > 0 Then
    '                    ClubSelection.Visible = True
    '                Else
    '                    ClubSelection.Visible = False
    '                End If

    '                Club_DropDownList_SelectedIndexChanged(New Object, New EventArgs)

    '            End Using

    '        End With

    '    End If

    'End Sub

    'Protected Sub Club_DropDownList_SelectedIndexChanged(sender As Object, e As EventArgs) Handles Club_DropDownList.SelectedIndexChanged

    '    Club_Literal.Text = Club_DropDownList.SelectedItem.Text

    '    'populate the check boxes
    '    Using VotesCast As DataTable = HBSAcodeLibrary.SharedRoutines.ReportAGM_Vote(Club_DropDownList.SelectedValue)

    '        Dim ResolutionID As Integer = 0
    '        For Each ctrl In VotingTables.Controls
    '            If TypeOf ctrl Is HtmlTable Then
    '                Dim tbl As HtmlTable = ctrl
    '                For Each tblRow As HtmlTableRow In tbl.Rows

    '                    Dim ix As Integer = 0
    '                    Dim cb(2) As CheckBox
    '                    Dim VotesRow As Boolean = False
    '                    For Each tblCell As HtmlTableCell In tblRow.Cells
    '                        For Each ctl As Control In tblCell.Controls
    '                            If TypeOf ctl Is CheckBox Then
    '                                cb(ix) = ctl
    '                                ix += 1
    '                                VotesRow = True
    '                            End If
    '                        Next
    '                    Next
    '                    If VotesRow Then
    '                        If Not IsNothing(VotesCast) AndAlso VotesCast.Rows.Count > 1 Then
    '                            cb(0).Checked = VotesCast.Rows(ResolutionID)!VotesFor
    '                            cb(1).Checked = VotesCast.Rows(ResolutionID)!VotesAgainst
    '                            cb(2).Checked = VotesCast.Rows(ResolutionID)!VotesWithheld
    '                        Else
    '                            cb(0).Checked = False
    '                            cb(1).Checked = False
    '                            cb(2).Checked = False
    '                        End If
    '                        ResolutionID += 1
    '                    End If


    '                Next
    '            End If
    '        Next



    '    End Using


    'End Sub

    'Protected Sub SubmitVote_Button_Click(sender As Object, e As EventArgs) Handles SubmitVote_Button.Click

    '    Dim Resolutions As New List(Of Object)
    '    Dim ErrorLiterals As New List(Of Literal)

    '    For Each ctrl In VotingTables.Controls
    '        If TypeOf ctrl Is HtmlTable Then
    '            Dim tbl As HtmlTable = ctrl
    '            For Each tblRow As HtmlTableRow In tbl.Rows

    '                Dim ix As Integer = 0
    '                Dim Votes(2) As CheckBox
    '                Dim VotesRow As Boolean = False
    '                For Each tblCell As HtmlTableCell In tblRow.Cells
    '                    For Each ctl As Control In tblCell.Controls
    '                        If TypeOf ctl Is CheckBox Then
    '                            Votes(ix) = ctl
    '                            ix += 1
    '                            VotesRow = True
    '                        ElseIf TypeOf ctl Is Literal Then
    '                            ErrorLiterals.Add(ctl)
    '                        End If
    '                    Next
    '                Next
    '                If VotesRow Then Resolutions.Add(Votes)


    '            Next
    '        End If
    '    Next

    '    'Check Each resolution has a vote
    '    Status_Literal.Text = ""
    '    Status_Literal2.Text = ""
    '    For Each resolution In Resolutions
    '        Dim ck(2) As CheckBox
    '        ck = resolution
    '        Dim ckId As String = ck(0).ID
    '        Dim uIx As Integer = ckId.IndexOf("_")
    '        Dim ResolutionID As Integer = CInt(ckId.Substring(uIx - 2, 2))
    '        Dim ErrorLiteral As Literal = ErrorLiterals(ResolutionID - 1)
    '        If Not ck(0).Checked AndAlso Not ck(1).Checked AndAlso Not ck(2).Checked Then
    '            Status_Literal.Text = "Every resolution/election must contain 1 vote.  See resolutions above"
    '            ErrorLiteral.Text = "<br/><span style='color:red'>There must be one vote cast for this resolution</span>"
    '        Else
    '            ErrorLiteral.Text = ""
    '        End If
    '    Next

    '    If Status_Literal.Text = "" Then
    '        For Each resolution In Resolutions
    '            Dim ck(2) As CheckBox
    '            ck = resolution
    '            Dim ckId As String = ck(0).ID
    '            Dim uIx As Integer = ckId.IndexOf("_")
    '            Dim ResolutionID As Integer = CInt(ckId.Substring(uIx - 2, 2))
    '            Dim ErrorLiteral As Literal = ErrorLiterals(ResolutionID - 1)
    '            Try
    '                HBSAcodeLibrary.SharedRoutines.MergeAGM_Vote(Club_DropDownList.SelectedValue, ResolutionID, ck(0).Checked, ck(1).Checked, ck(2).Checked)
    '                ErrorLiteral.Text = ""
    '            Catch ex As Exception
    '                Status_Literal.Text = "Database error storing a vote.   See resolutions above"
    '                ErrorLiteral.Text = "Database error: " & ex.Message
    '            End Try
    '        Next


    '        If Status_Literal.Text = "" Then
    '            Status_Literal.Text = "<span style='color:navy'>" & Club_DropDownList.SelectedItem.Text & "'s vote has been recorded.<br />" &
    '                                  "You can visit this page any time to recast your vote up until Tuesday the 14<sup>th</sup> July 2020.</span>"
    '        End If

    '    End If

    '    Status_Literal2.Text = Status_Literal.Text.Replace("above", "below")

    'End Sub
End Class