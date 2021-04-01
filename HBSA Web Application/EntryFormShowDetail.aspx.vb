Public Class EntryFormShowDetail
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Request.QueryString("ClubID") Is Nothing OrElse
           Request.QueryString("Form") Is Nothing Then
            FullPage.Visible = False
            NothingPage.Visible = True
            Exit Sub
        End If


        Dim ClubID As Integer = CInt(Request.QueryString("ClubID").ToString)
        Dim FormType As String = Request.QueryString("Form").ToString
        Dim EntryFormTable As DataTable
        Dim ClubName As String = New HBSAcodeLibrary.ClubData(ClubID).ClubName

        If FormType = "League" Then
            EntryFormTable = HBSAcodeLibrary.EntryFormData.FullReport("byClub", ClubID)
            Header_Literal.Text = "League Entry Form for " & ClubName

            If EntryFormTable.Rows.Count > 0 Then
                Using EntryForm As HBSAcodeLibrary.EntryFormData = New HBSAcodeLibrary.EntryFormData(ClubID)
                    With EntryForm
                        Dim InfoPage As New HBSAcodeLibrary.ContentData("Payments")
                        Payment_Literal.Text = "The fee for this entry is <span style='color:red;'> &pound;" & Format(.TeamFees + .ClubFee, "0.00") & "</span>" &
                                 "<br/>" & InfoPage.ContentHTML
                        InfoPage.Dispose()

                        If .AmountPaid > 0 Then
                            Payment_Literal.Text &= " of which <span style='color:red;'> &pound;" & Format(.AmountPaid, "0.00") & "</span> has already been paid."
                        End If

                    End With
                End Using

                EntryForm_GridView.ShowHeader = False

            Else

                Payment_Literal.Text = ""

            End If

        Else
            EntryFormTable = HBSAcodeLibrary.CompetitionEntryFormData.FullReport(ClubID)
            Header_Literal.Text = "Competition Entry Form for " & If(ClubName, "All clubs")

            If EntryFormTable.Rows.Count > 0 Then
                Using EntryForm As HBSAcodeLibrary.CompetitionEntryFormData = New HBSAcodeLibrary.CompetitionEntryFormData(ClubID)
                    With EntryForm
                        Dim InfoPage As New HBSAcodeLibrary.ContentData("Payments")
                        Payment_Literal.Text = "The fee for this entry is <span style='color:red;'> &pound;" & Format(.EntryFormFee, "0.00") & "</span>" &
                             "<br/>" & InfoPage.ContentHTML
                        InfoPage.Dispose()

                        If .AmountPaid > 0 Then
                            Payment_Literal.Text &= " of which <span style='color:red;'> &pound;" & Format(.AmountPaid, "0.00") & "</span> has already been paid."
                        End If

                    End With
                End Using

                EntryForm_GridView.ShowHeader = True

            Else

                Payment_Literal.Text = ""

            End If

        End If

            Session("EntryFormTable") = EntryFormTable

        EntryForm_GridView.DataSource = EntryFormTable
        EntryForm_GridView.DataBind()

        If EntryFormTable.Rows.Count = 0 Then
            print_Button.Visible = False
            Download_Button.Visible = False
        Else
            print_Button.Visible = True
            Download_Button.Visible = True

        End If

    End Sub

    Protected Sub Download_Button_Click(sender As Object, e As EventArgs) Handles Download_Button.Click

        Response.Redirect("CreateAndDownloadFile.aspx?source=EntryFormTable&fileName=EntryForm")

    End Sub

    Protected Sub Return_Button_Click(sender As Object, e As EventArgs) Handles Return_Button.Click

        Dim FormType As String = Request.QueryString("Form").ToString

        If FormType = "League" Then
            Response.Redirect("~/EntryForm.aspx")
        Else
            Response.Redirect("~/CompetitionsEntryForm.aspx")
        End If

    End Sub

    Private Sub EntryForm_GridView_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles EntryForm_GridView.RowDataBound

        If e.Row.RowType = DataControlRowType.DataRow Then
            Dim decodedText As String = HttpUtility.HtmlDecode(e.Row.Cells(0).Text)
            If decodedText.StartsWith("<b") Then
                e.Row.Cells(0).Text = decodedText
            End If
        End If

    End Sub
End Class
