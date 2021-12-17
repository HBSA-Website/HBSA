Public Class NewPlayers
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Session("adminDetails") Is Nothing _
        OrElse Session("adminDetails").Rows.count = 0 Then

            Session("Caller") = Request.Url.AbsolutePath
            Response.Redirect("adminhome.aspx")

        Else
            If Not IsPostBack Then
                'User_HiddenField.Value = Session("AdminUser")
                FillGrid()
            End If
        End If

    End Sub

    Sub FillGrid()

        Using NewPlayers As DataTable = HBSAcodeLibrary.PlayerData.NewPlayers()

            With NewPlayers_GridView
                .DataSource = NewPlayers
                .DataBind()
            End With

        End Using

    End Sub
    Private Sub NewPlayers_GridView_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles NewPlayers_GridView.RowDataBound

        If e.Row.Cells.Count > 1 Then
            e.Row.Cells(1).Visible = False
        End If

    End Sub

    Private Sub NewPlayers_GridView_RowEditing(sender As Object, e As GridViewEditEventArgs) Handles NewPlayers_GridView.RowEditing

        Dim PlayerID As Integer = CInt(NewPlayers_GridView.Rows(e.NewEditIndex).Cells(1).Text)
        PlayerID_Label.Text = PlayerID
        SendEmails_CheckBox.Checked = True
        Handicap_TextBox.Text = ""

        Using Player As New HBSAcodeLibrary.PlayerData(PlayerID)
            Player_Label.Text = Player.FullName & " of " & Player.ClubName & " " & Player.Team & " in the " & Player.LeagueName & " League"
        End Using

        HandicapChange_Panel.Visible = True

        e.Cancel = True

    End Sub

    Protected Sub SubmitPlayer_Button_Click(sender As Object, e As EventArgs) Handles SubmitPlayer_Button.Click

        Error_Literal.Text = ""
        Using Player As New HBSAcodeLibrary.PlayerData(CInt(PlayerID_Label.Text))
            Using ld As New HBSAcodeLibrary.LeagueData(Player.LeagueID)
                Try
                    Player.Handicap = CInt(Handicap_TextBox.Text)
                    If Player.Handicap < ld.MinHandicap OrElse
                            Player.Handicap > ld.MaxHandicap Then
                        Error_Literal.Text = "Handicap must be between " & If(ld.MinHandicap = -2147483648, "'No Minimum'", ld.MinHandicap) &
                                             " And " & If(ld.MinHandicap = 2147483647, "'No Maximum'", ld.MaxHandicap)
                        Exit Sub
                    End If
                Catch ex As Exception
                    Error_Literal.Text = "Handicap must be numeric."
                    Exit Sub
                End Try
            End Using

            Try
                Player.Merge(Session("user"))

                If SendEmails_CheckBox.Checked Then
                    Status_Literal.Text = HBSAcodeLibrary.Emailer.SendPlayerMaintenanceEmail("handicapChange", "",
                                                                                          Player.ClubEmail,
                                                                                          Player.TeamEMail,
                                                                                          Player.eMail,
                                                                                          Player.FullName,
                                                                                          (Player.ClubName & " " & Player.Team).Trim,
                                                                                          -99,
                                                                                          Player.Handicap,
                                                                                          (Player.LeagueName & " " & Player.SectionName).Trim
                                                                                         )
                    If Status_Literal.Text = "" Then
                        Status_Literal.Text = "<span style='color=darkblue'>"
                        Status_Literal.Text += Player.FullName & "'s Handicap set to " & Player.Handicap & " and emails sent to club, team etc."
                        Status_Literal.Text += "</span>"
                    Else
                        Error_Literal.Text = "ERROR: <br/>" &
                                              Status_Literal.Text
                        Exit Sub
                    End If
                Else
                    Status_Literal.Text = "<span style='color=darkblue'>"
                    Status_Literal.Text += Player.FullName & "'s Handicap set to " & Player.Handicap
                    Status_Literal.Text += "</span>"

                End If

            Catch ex As Exception
                Error_Literal.Text = "ERROR: <br/>" & ex.Message
                Exit Sub
            End Try

        End Using

        FillGrid()

        HandicapChange_Panel.Visible = False

    End Sub

    Protected Sub CancelPlayer_Button_Click(sender As Object, e As EventArgs) Handles CancelPlayer_Button.Click

        HandicapChange_Panel.Visible = False

    End Sub
End Class