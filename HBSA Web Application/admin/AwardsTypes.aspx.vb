Public Class AwardsTypes
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Not IsPostBack Then
            ReportTypes()
        End If

    End Sub

    Protected Sub ReportTypes()

        With AwardsTypes_GridView
            .DataSource = HBSAcodeLibrary.AwardsType.Types
            .DataBind()
        End With

    End Sub

    Private Sub AwardsTypes_GridView_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles AwardsTypes_GridView.RowDataBound

        If e.Row.Cells.Count > 1 Then
            e.Row.Cells(1).Visible = False
        End If

    End Sub

    Private Sub AwardsTypes_GridView_RowDeleting(sender As Object, e As GridViewDeleteEventArgs) Handles AwardsTypes_GridView.RowDeleting

        EditPanel_Literal2.Text = "Click Confirm if you want to delete this Award Type, or click Cancel."
        EditStatus_Literal.Text = ""

        With AwardsTypes_GridView.Rows(e.RowIndex)
            AwardType.Value = .Cells(1).Text
            Name_TextBox.Text = .Cells(2).Text.Replace("&nbsp;", "")
            Description_TextBox.Text = .Cells(3).Text.Replace("&nbsp;", "")
            StoredProcedureName_TextBox.Text = .Cells(4).Text.Replace("&nbsp;", "")

            Name_TextBox.Enabled = False
            Description_TextBox.Enabled = False
            StoredProcedureName_TextBox.Enabled = False

        End With

        Submit_Button.Text = "Confirm"
        Submit_Button.Visible = True

        Edit_Panel.Visible = True

        e.Cancel = True

    End Sub

    Private Sub AwardsTypes_GridView_RowEditing(sender As Object, e As GridViewEditEventArgs) Handles AwardsTypes_GridView.RowEditing

        EditPanel_Literal2.Text = "Enter changes then Click Change, or click Cancel."
        EditStatus_Literal.Text = ""

        With AwardsTypes_GridView.Rows(e.NewEditIndex)
            AwardType.Value = .Cells(1).Text
            Name_TextBox.Text = .Cells(2).Text.Replace("&nbsp;", "")
            Description_TextBox.Text = .Cells(3).Text.Replace("&nbsp;", "")
            StoredProcedureName_TextBox.Text = .Cells(4).Text.Replace("&nbsp;", "")

            Name_TextBox.Enabled = True
            Description_TextBox.Enabled = True
            StoredProcedureName_TextBox.Enabled = True

        End With

        Submit_Button.Text = "Change"
        Submit_Button.Visible = True

        Edit_Panel.Visible = True

        e.Cancel = True

    End Sub

    Protected Sub Cancel_Button_Click(sender As Object, e As EventArgs) Handles Cancel_Button.Click

        Edit_Panel.Visible = False

    End Sub

    Protected Sub AddType_Button_Click(sender As Object, e As EventArgs) Handles AddType_Button.Click

        EditPanel_Literal2.Text = "Enter details then click Create, or click Cancel."
        EditStatus_Literal.Text = ""

        AwardType.Value = Nothing
        Name_TextBox.Text = ""
        Description_TextBox.Text = ""
        StoredProcedureName_TextBox.Text = ""

        Name_TextBox.Enabled = True
        Description_TextBox.Enabled = True
        StoredProcedureName_TextBox.Enabled = True

        Submit_Button.Text = "Create"
        Submit_Button.Visible = True

        Edit_Panel.Visible = True

    End Sub

    Private Sub Submit_Button_Click(sender As Object, e As EventArgs) Handles Submit_Button.Click

        Dim StatusMsg As String = ""

        'Note: with create the hidden value is empty so will instatiate an object with empty public properties
        Using AwardType As New HBSAcodeLibrary.AwardsType(If(Me.AwardType.Value = "", 0, Me.AwardType.Value))

            With AwardType

                Select Case Submit_Button.Text

                    Case "Confirm"    'Delete
                        StatusMsg = .Delete
                        If Not StatusMsg Like "*deleted*" Then
                            EditStatus_Literal.Text = "<span style='color:red;'>WARNING: " & StatusMsg & "</span>.  Click Delete to remove this award anyway."
                            Submit_Button.Text = "Delete"
                            Exit Sub
                        End If

                    Case "Delete"    'Delete override
                        Dim Override As Boolean = True
                        StatusMsg = .Delete(Override)

                    Case "Change"     'Amend
                        .Name = Name_TextBox.Text
                        .Description = Description_TextBox.Text
                        .StoredProcedureName = StoredProcedureName_TextBox.Text
                        .update()
                        StatusMsg = "Award Type " & Me.AwardType.Value & " Changed.  See table below for details"

                    Case "Create"     'Insert
                        .Name = Name_TextBox.Text
                        .Description = Description_TextBox.Text
                        .StoredProcedureName = StoredProcedureName_TextBox.Text
                        .create()
                        StatusMsg = Description_TextBox.Text & " Created.  See table below for details"

                End Select

            End With

        End Using

        Edit_Panel.Visible = False
        ReportTypes()
        Status_Literal.Text = StatusMsg

    End Sub

End Class