Public Class JuniorsComp2
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        Using content As New HBSAcodeLibrary.ContentData("Juniors")
            juniorContentLiteral1.Text = content.ContentHTML
        End Using

        Using Juniors As New HBSAcodeLibrary.JuniorsCompetitions

            With Table1_GridView
                If Juniors.Tables.Tables.Count > 0 Then
                    .DataSource = Juniors.Tables.Tables(0)
                    .DataBind()
                Else
                    .Visible = False
                End If
            End With

            With Table2_GridView
                If Juniors.Tables.Tables.Count > 1 Then
                    .DataSource = Juniors.Tables.Tables(1)
                    .DataBind()
                    .Visible = True
                Else
                    .Visible = False
                End If
            End With

            With Table3_GridView
                If Juniors.Tables.Tables.Count > 2 Then
                    .DataSource = Juniors.Tables.Tables(2)
                    .DataBind()
                    .Visible = True
                Else
                    .Visible = False
                End If
            End With

            With Table4_GridView
                If Juniors.Tables.Tables.Count > 3 Then
                    .DataSource = Juniors.Tables.Tables(3)
                    .DataBind()
                    .Visible = True
                Else
                    .Visible = False
                End If
            End With

            With Results1_Gridview
                If Juniors.Results.Tables.Count > 0 Then
                    .DataSource = Juniors.Results.Tables(0)
                    .DataBind()
                    .Visible = True
                Else
                    .Visible = False
                End If
            End With

            With Results2_Gridview
                If Juniors.Results.Tables.Count > 1 Then
                    .DataSource = Juniors.Results.Tables(1)
                    .DataBind()
                    .Visible = True
                    Div2Head.Visible = True
                Else
                    .Visible = False
                    Div2Head.Visible = False
                End If
            End With

            With Results3_Gridview
                If Juniors.Results.Tables.Count > 2 Then
                    .DataSource = Juniors.Results.Tables(2)
                    .DataBind()
                    .Visible = True
                    Div3Head.Visible = True
                Else
                    .Visible = False
                    Div3Head.Visible = False
                End If
            End With

            With Results4_Gridview
                If Juniors.Results.Tables.Count > 3 Then
                    .DataSource = Juniors.Results.Tables(3)
                    .DataBind()
                    .Visible = True
                    Div4Head.Visible = True
                Else
                    .Visible = False
                    Div4Head.Visible = False
                End If
            End With

        End Using

    End Sub

    Private Sub Results_Gridview_RowDataBound(sender As Object, e As GridViewRowEventArgs) _
        Handles Results1_Gridview.RowDataBound, Results2_Gridview.RowDataBound, 'Results3_Gridview.RowDataBound, Results4_Gridview.RowDataBound,
                Table1_GridView.RowDataBound, Table2_GridView.RowDataBound ', Table3_GridView.RowDataBound, Table4_GridView.RowDataBound

        For Each GridViewCell As TableCell In e.Row.Cells

            Try
                Dim temp As Integer = CInt(GridViewCell.Text)
                GridViewCell.HorizontalAlign = HorizontalAlign.Center
            Catch ex As Exception

                GridViewCell.HorizontalAlign = HorizontalAlign.Left

            End Try
            GridViewCell.Text = GridViewCell.Text.Replace(" ", "&nbsp;")
        Next

        'If e.Row.RowType = DataControlRowType.Header Then

        '    Session("JuniorsResults") = (e.Row.Cells(0).Text = "ID")

        'End If

        'If Session("JuniorsResults") Then
        '    e.Row.Cells(0).Visible = False
        'End If

    End Sub
End Class