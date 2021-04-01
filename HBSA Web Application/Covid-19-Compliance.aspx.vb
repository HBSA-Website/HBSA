Public Class Covid_19_Compliance
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        'If IsNothing(Session("ClubLoginID")) Then
        '    Session("LoginCaller") = Request.Url.AbsolutePath
        '    Response.Redirect("ClubLogin.aspx")
        'End If

        'Status_Literal.Text = ""

        If Not IsPostBack Then

            Using allClubs As DataTable = HBSAcodeLibrary.ClubData.GetAllClubs()

                Session("ClubsData") = allClubs

                With ClubID_DropDownList
                    .Items.Clear()
                    .DataSource = allClubs
                    .DataValueField = "ID"
                    .DataTextField = "Club Name"
                    .DataBind()
                    .Items.Insert(0, New ListItem("**Select a Club**", 0))
                    .SelectedIndex = 0
                    Special_Resolutions.Visible = False
                End With

            End Using

        End If

    End Sub

    Protected Sub ClubID_DropDownList_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ClubID_DropDownList.SelectedIndexChanged

        If ClubID_DropDownList.SelectedIndex = 0 Then
            Special_Resolutions.Visible = False
        Else
            Using C19 As New HBSAcodeLibrary.Covid19Compliance(ClubID_DropDownList.SelectedValue)
                Check1.SelectedIndex = If(C19.Check1, 0, 1)
                Check2.SelectedIndex = If(C19.Check2, 0, 1)
                Check3.SelectedIndex = If(C19.Check3, 0, 1)
                Check4.SelectedIndex = If(C19.Check4, 0, 1)
                TextBox3.Text = C19.Text3
                TextBox4.Text = C19.Text4
                TextBox5.Text = C19.Text5
            End Using
            Special_Resolutions.Visible = True
        End If
        'Check_SelectedIndexChanged(sender, e)

    End Sub



    'Protected Sub Submit_Button_Click(sender As Object, e As EventArgs) Handles Submit_Button.Click

    '    Try

    '        Using C19 As New HBSAcodeLibrary.Covid19Compliance(ClubID_HiddenField.Value)
    '            C19.ClubID = ClubID_HiddenField.Value
    '            C19.Check1 = Check1.SelectedIndex = 0
    '            C19.Check2 = Check2.SelectedIndex = 0
    '            C19.Check3 = Check3.SelectedIndex = 0
    '            C19.Check4 = Check4.SelectedIndex = 0
    '            C19.Text3 = TextBox3.Text
    '            C19.Text4 = TextBox4.Text
    '            C19.Text5 = TextBox5.Text
    '            C19.Merge()
    '        End Using

    '        Status_Literal.Text = "Your compliance data has been saved.  Return here if you wish to change it."

    '    Catch ex As Exception

    '        Status_Literal.Text = "ERROR: " & ex.Message & "<br/>Please <a href='Contact.aspx'>inform us</a> and include this error message."

    '    End Try

    'End Sub

    'Protected Sub Check_SelectedIndexChanged(sender As Object, e As EventArgs) _
    '    Handles Check1.SelectedIndexChanged, Check2.SelectedIndexChanged, Check3.SelectedIndexChanged, Check4.SelectedIndexChanged

    '    Submit_Button.Enabled = Check1.SelectedIndex > -1 And
    '                            Check2.SelectedIndex > -1 And
    '                            Check3.SelectedIndex > -1 And
    '                            Check4.SelectedIndex > -1

    '    DisabledSubmit_Label.Visible = Not Submit_Button.Enabled

    'End Sub

End Class