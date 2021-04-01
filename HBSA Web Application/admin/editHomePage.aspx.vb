Public Class EditHomePage
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load

        If Session("adminDetails") Is Nothing _
        OrElse Session("adminDetails").Rows.count = 0 Then

            Session("Caller") = Request.Url.AbsolutePath
            Response.Redirect("adminhome.aspx")

        Else

            If Not IsPostBack Then

                PopulateGridView()

            End If
        End If

    End Sub

    Sub PopulateGridView()

        Using Articles As System.Data.DataTable = HBSAcodeLibrary.HomeContent.HomePageArticles

            HomePageArticles_GridView.DataSource = Articles
            HomePageArticles_GridView.DataBind()

        End Using

    End Sub

    Protected Sub HomePageArticles_GridView_RowCreated(sender As Object, e As GridViewRowEventArgs) Handles HomePageArticles_GridView.RowCreated

        If e.Row.RowType <> DataControlRowType.EmptyDataRow Then
            e.Row.Cells(2).Visible = False
        End If

    End Sub

    Protected Sub HomePageArticles_GridView_RowEditing(sender As Object, e As GridViewSelectEventArgs) Handles HomePageArticles_GridView.SelectedIndexChanging

        Dim ID As Integer = HomePageArticles_GridView.Rows(e.NewSelectedIndex).Cells(2).Text

        Using Article As New HBSAcodeLibrary.HomeContent(ID)

            ID_Hidden.Value = ID
            Title_TextBox.Text = Article.title
            Date_Literal.Text = Format(Article.dateTimeLodged, "dd MMM yyyy hh:mm")
            contentEditorTextBox.Text = Article.articleHTML
            EditError_Literal.Text = ""
            EditPanel.Visible = True

        End Using

        e.Cancel = True

    End Sub

    Protected Sub Cancel_Butten_Click(sender As Object, e As EventArgs) Handles Cancel_Button.Click

        EditPanel.Visible = False

    End Sub

    Protected Sub Save_Button_Click(sender As Object, e As EventArgs) Handles Save_Button.Click

        'just build the details, the sproc will decide on insert or update

        If Title_TextBox.Text.Trim = "" Then

            EditError_Literal.Text = "Cannot save: Please enter a title."

        Else

            Using Article As New HBSAcodeLibrary.HomeContent(ID_Hidden.Value)

                Article.title = Title_TextBox.Text
                Article.articleHTML = contentEditorTextBox.Text
                Article.Merge()
                EditPanel.Visible = False
                PopulateGridView()
                EditError_Literal.Text = ""

            End Using

        End If

    End Sub

    Protected Sub New_Button_Click(sender As Object, e As EventArgs) Handles New_Button.Click

        ID_Hidden.Value = 0
        Title_TextBox.Text = ""
        Date_Literal.Text = Format(HBSAcodeLibrary.Utilities.UKDateTimeNow(), "dd MMM yyyy hh:mm")
        contentEditorTextBox.Text = ""
        EditError_Literal.Text = ""
        EditPanel.Visible = True

    End Sub

    Protected Sub HomePageArticles_GridView_RowDeleting(sender As Object, e As GridViewDeleteEventArgs) Handles HomePageArticles_GridView.RowDeleting

        Delete_Literal.Text = "To delete <br/><br/><strong>" & HomePageArticles_GridView.Rows(e.RowIndex).Cells(3).Text &
                              " dated " & HomePageArticles_GridView.Rows(e.RowIndex).Cells(4).Text &
                               "</strong><br/><br> click Delete, or click Cancel."

        ID_Hidden.Value = HomePageArticles_GridView.Rows(e.RowIndex).Cells(2).Text

        ConfirmDelete_Panel.Visible = True
        e.Cancel = True

    End Sub

    Protected Sub CancelDelete_Button_Click(sender As Object, e As EventArgs) Handles CancelDelete_Button.Click

        ConfirmDelete_Panel.Visible = False

    End Sub

    Protected Sub Delete_Button_Click(sender As Object, e As EventArgs) Handles Delete_Button.Click

        If ID_Hidden.Value = "ALL" Then
            HBSAcodeLibrary.HomeContent.DeleteALL()
        Else

            Using Article As New HBSAcodeLibrary.HomeContent(ID_Hidden.Value)
                Article.ID = -Article.ID
                Article.Merge()
            End Using

        End If

        ConfirmDelete_Panel.Visible = False
        PopulateGridView()

    End Sub


    Protected Sub Delete_All_Button_Click(sender As Object, e As EventArgs) Handles Delete_All_Button.Click

        Delete_Literal.Text = "To delete <br/><br/><strong>ALL Home Page Articles</strong><br/><br> click Delete, or click Cancel."
        ID_Hidden.Value = "ALL"
        ConfirmDelete_Panel.Visible = True

    End Sub

End Class