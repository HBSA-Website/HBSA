Public Class BreaksCategories
    Inherits System.Web.UI.Page
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Session("adminDetails") Is Nothing _
        OrElse Session("adminDetails").Rows.count = 0 Then

            Session("Caller") = Request.Url.AbsolutePath
            Response.Redirect("adminhome.aspx")

        Else
            If Not IsPostBack Then
                populateLeagues()
            End If

            populatecategories()

        End If

    End Sub

    Sub PopulateLeagues()

        Dim Leagues As DataTable = HBSAcodeLibrary.LeagueData.GetLeagues

        With League_DropDownList

            .Items.Clear()
            .DataSource = Leagues
            .DataTextField = "League Name"
            .DataValueField = "ID"
            .DataBind()
            .Items.Insert(0, New ListItem("**Select a League**", "0"))

        End With

    End Sub

    Sub Populatecategories()

        With Categories_Table

            ' if there are rows there get rid of non header rows first
            While .Rows.Count > 1
                .Rows.Remove(.Rows(.Rows.Count - 1))
            End While

            If League_DropDownList.SelectedIndex > 0 Then
                Dim BreakCategories As DataTable = HBSAcodeLibrary.AwardsTemplate.GetBreaksCategories(True, League_DropDownList.SelectedValue)

                For i As Integer = 0 To BreakCategories.Rows.Count - 1

                    Dim Category As DataRow = BreakCategories.Rows(i)

                    Dim tRow As New TableRow With {
                        .ID = "Category_" & CStr(i),
                        .HorizontalAlign = HorizontalAlign.Center
                    }

                    Dim tCell1 As New TableCell

                    Dim insertButton As Button = TableButton()
                    insertButton.ID = "insertButton_" & CStr(Category.Item("ID").ToString)
                    insertButton.Text = "Insert(below)"
                    tCell1.Controls.Add(insertButton)

                    Dim tSpacer As New Literal With {
                        .Text = "&nbsp;&nbsp;&nbsp;&nbsp;"
                    }
                    tCell1.Controls.Add(tSpacer)

                    Dim deleteButton As Button = TableButton()
                    deleteButton.ID = "deleteButton_" & CStr(Category.Item("ID").ToString)
                    deleteButton.Text = "Delete"
                    tCell1.Controls.Add(deleteButton)

                    tRow.Cells.Add(tCell1)

                    Dim tCell4 As New TableCell
                    Dim LowHCapBox As New TextBox With {
                        .ID = "LowHCapBox_" & Category.Item("ID").ToString,
                        .Width = 120,
                        .Text = Category.Item("LowHandicap").ToString,
                        .AutoPostBack = True
                    }
                    LowHCapBox.Style("text-align") = "center"
                    AddHandler LowHCapBox.TextChanged, AddressOf HandleTextChange
                    tCell4.Controls.Add(LowHCapBox)
                    tRow.Cells.Add(tCell4)

                    Dim tCell5 As New TableCell
                    If i = BreakCategories.Rows.Count - 1 Then  'last category
                        Dim HighHCapBox As New TextBox With {
                            .ID = "HighHCapBox_" & Category.Item("ID").ToString,
                            .Width = 120,
                           .Text = Category.Item("HighHandicap").ToString,
                           .AutoPostBack = True
                        }
                        HighHCapBox.Style("text-align") = "center"
                        AddHandler HighHCapBox.TextChanged, AddressOf HandleTextChange
                        tCell5.Controls.Add(HighHCapBox)
                        tRow.Cells.Add(tCell5)

                    Else
                        tCell5.Text = Category.Item("HighHandicap").ToString
                    End If

                    tRow.Cells.Add(tCell5)

                    If msg_Literal.Text <> "" AndAlso msg_Literal.Text.Split("_")(1) = Category.Item("ID") Then
                        Dim tCell6 As New TableCell With {
                            .HorizontalAlign = HorizontalAlign.Left,
                            .ForeColor = System.Drawing.Color.Red,
                            .Text = msg_Literal.Text.Split("_")(0)
                        }
                        tRow.Cells.Add(tCell6)
                        msg_Literal.Text = ""
                    End If

                    Categories_Table.Rows.Add(tRow)

                Next

            End If

        End With


    End Sub

    Private Function TableButton() As Button

        Dim tBtn As New Button With {
            .Width = 80,
            .Height = 16
        }
        tBtn.Font.Size = FontUnit.Smaller
        AddHandler tBtn.Click, AddressOf HandleButton
        Return tBtn
    End Function

    Private Sub HandleTextChange(ByVal sender As Object, ByVal e As EventArgs)
        Dim ID = sender.id.split("_")(1)
        Dim HighOrLow As String = If(sender.ID.tolower Like "*high*", "High", "Low")
        Dim Handicap As Integer
        If sender.text.tolower Like "*limit*" Then
            Handicap = If(HighOrLow = "High", HBSAcodeLibrary.Utilities.maxInteger, HBSAcodeLibrary.Utilities.minInteger)
        Else
            Try
                Handicap = CInt(sender.text)
            Catch ex As Exception
                msg_Literal.Text = "Handicap must be an integer_" & ID
                Populatecategories()
                Exit Sub
            End Try

        End If

        Try
            Dim msg As String = HBSAcodeLibrary.AwardsTemplate.UpdateBreakCategory(League_DropDownList.SelectedValue, ID, Handicap, HighOrLow)
            If msg = "" Then
                msg_Literal.Text = "The " & HighOrLow & " handicap was changed_" & ID
            Else
                msg_Literal.Text = msg & "_" & ID
            End If

        Catch ex As Exception
            msg_Literal.Text = ex.Message & "_" & ID
        End Try

        Populatecategories()

    End Sub

    Private Sub HandleButton(ByVal sender As Object, ByVal e As EventArgs)
        Dim ID As Integer = CInt(sender.id.split("_")(1))
        If sender.text.tolower Like "*insert*" Then
            Try
                HBSAcodeLibrary.AwardsTemplate.InsertBreakCategory(League_DropDownList.SelectedValue, ID)
                msg_Literal.Text = "WARNING: The inserted category needs the High & Low handicaps changing,<br/> and the categories above and below may well need changing as well_" & ID + 1
            Catch ex As Exception
                msg_Literal.Text = "Cannot insert: " & ex.Message & "_" & ID
            End Try

        Else
            Try
                HBSAcodeLibrary.AwardsTemplate.DeleteBreakCategory(League_DropDownList.SelectedValue, ID)
                msg_Literal.Text = "The category was deleted,<br/> check the other categories_" & ID
            Catch ex As Exception
                msg_Literal.Text = ex.Message & "_" & ID
            End Try

        End If

        Populatecategories()

    End Sub

    Protected Sub League_DropDownList_SelectedIndexChanged(sender As Object, e As EventArgs) Handles League_DropDownList.SelectedIndexChanged

        Using League As New HBSAcodeLibrary.LeagueData(League_DropDownList.SelectedValue)
            MinHCap.Text = If(League.MinHandicap = HBSAcodeLibrary.Utilities.minInteger, "No Limit", League.MinHandicap)
            MaxHCap.Text = If(League.MaxHandicap = HBSAcodeLibrary.Utilities.maxInteger, "No Limit", League.MaxHandicap)
        End Using

        populatecategories()

    End Sub
End Class