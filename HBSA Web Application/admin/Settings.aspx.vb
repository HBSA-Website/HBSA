Public Class Settings
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Session("adminDetails") Is Nothing _
            OrElse Session("adminDetails").Rows.count = 0 Then

            Session("Caller") = Request.Url.AbsolutePath
            Response.Redirect("adminhome.aspx")

        Else

            If Not IsPostBack Then
                BuildTables("")
            Else
                If ViewState.Item("DynamicCtls") = "MyCtls" Then
                    BuildTables("")
                End If
            End If

        End If

    End Sub

    Private Sub BuildTables(senderID As String, Optional errMsg As String = "")

        Settings_Table.Rows.Clear() 'start from fresh each time

        Using AllSettings As New HBSAcodeLibrary.Settings

            For Each Category As DataRow In AllSettings.categories.Rows
                Dim CategoryText As String = Category.Item(0)
                Dim CategoryPrefix As String = CategoryText.Replace(" ", "")
                Dim CategorySettings As DataTable = AllSettings.SettingsByCategory(CategoryText)

                Dim tr As New TableRow

                Dim td0 As New TableCell With {
                    .Text = CategoryText,
                    .VerticalAlign = VerticalAlign.Top
                }
                td0.Font.Size = FontUnit.Point(10)
                tr.Cells.Add(td0)

                Dim td2 As New TableCell
                td2.Controls.Add(CategorySettingsTable(CategoryPrefix, CategorySettings, senderID, errMsg))
                tr.Cells.Add(td2)

                Settings_Table.Rows.Add(tr)

            Next

        End Using

        'VERY IMPORTANT -> remember that we created these controls for the next postback
        ViewState.Item("DynamicCtls") = "MyCtls"

    End Sub

    Private Function CategorySettingsTable(CategoryPrefix As String,
                                           CategorySettings As DataTable,
                                           senderID As String,
                                           errMsg As String
                                           ) As Panel
        Dim Div As New Panel With {
            .ID = "div" & CategoryPrefix,
            .ClientIDMode = ClientIDMode.Static
        }
        Div.Attributes.Add("style", "display:block; text-align: left; font-size: 10pt;")

        Dim tbl As New Table()

        For Each Setting As DataRow In CategorySettings.Rows

            Dim tr As New TableRow
            Dim td0 As New TableCell With {
                .HorizontalAlign = HorizontalAlign.Left
            }
            Dim td1 As New TableCell With {
                .HorizontalAlign = HorizontalAlign.Left
            }

            td0.Text = Setting.Item("Setting")
            td0.Width = Unit.Point(120)
            tr.Cells.Add(td0)

            If Setting.Item("ControlType") = "CheckBox" Then

                Dim cb As New CheckBox With {
                    .ID = Setting.Item("ConfigKey") & "|" & Setting.Item("ControlType") & "|" & Setting.Item("value"),
                    .Checked = CBool(Setting.Item("value")),
                    .AutoPostBack = True
                }
                AddHandler cb.CheckedChanged, AddressOf Setting_Changed
                td1.Controls.Add(cb)

            Else
                Dim tb As New TextBox With {
                    .ID = Setting.Item("ConfigKey") & "|" & Setting.Item("ControlType") & "|" & Setting.Item("value")
                }


                Select Case Setting.Item("ControlType")
                    Case "Password"
                        'tb.TextMode = TextBoxMode.Password
                        tb.Text = Setting.Item("value")
                        tb.Width = tb.Text.Length * 10
                    Case "Date"
                        'tb.TextMode = TextBoxMode.Date
                        tb.Text = CDate(Setting.Item("value")).ToString("dd MMM yyyy")
                        tb.Width = tb.Text.Length * 10
                    Case "Integer"
                        tb.Text = Setting.Item("value")
                        tb.Width = tb.Text.Length * 12
                    Case Else
                        tb.Text = Setting.Item("value")
                        tb.Width = tb.Text.Length * 10
                End Select

                tb.AutoPostBack = True
                'tb.Attributes.Add("onkeydown", "keyPressed(event, '" & tb.ID & "');")
                AddHandler tb.TextChanged, AddressOf Setting_Changed

                td1.Controls.Add(tb)

            End If

            If Setting.Item("ConfigKey") = senderID OrElse          'if this control has just changed indicate it as such
               Session("Changed") = Setting.Item("ConfigKey") Then  'or this is second postback caused by enter, need to re show this ctl
                'add message to the setting just changed
                Dim td2 As New TableCell With {
                    .HorizontalAlign = HorizontalAlign.Left
                }
                Dim ltl As New Literal With {
                    .ID = Setting.Item("ConfigKey") & "_Literal",
                    .Text = "<span style='color: #FF0000'>&nbsp;&nbsp;&nbsp;"
                }

                If errMsg = "" Then
                    ltl.Text &= "Changed"
                Else
                    ltl.Text &= errMsg
                End If
                ltl.Text &= "</span>"

                td1.Controls.Add(ltl)

                If Session("Changed") <> Setting.Item("ConfigKey") Then
                    Session("Changed") = Setting.Item("ConfigKey") 'having set this ctl, ensure it is reset if 2nd postback caused by enter 
                Else
                    Session("Changed") = ""                        'having shown for 2nd time reset the variable
                End If

            End If

            tr.Cells.Add(td1)

            tbl.Rows.Add(tr)

        Next

        Div.Controls.Add(tbl)

        Return Div

    End Function

    Protected Sub Setting_Changed(sender As Object, e As EventArgs)

        Dim attributes() As String = sender.id.split("|")
        Dim ConfigKey As String = attributes(0)
        Dim CtlType As String = attributes(1)
        Dim originalValue As String = attributes(2)
        Dim errMsg As String = ""

        If CtlType = "CheckBox" Then
            Dim Checked As Boolean = DirectCast(Settings_Table.FindControl(sender.id), CheckBox).Checked
            HBSAcodeLibrary.HBSA_Configuration.update(ConfigKey, Checked)
        Else
            Dim txt As String = DirectCast(Settings_Table.FindControl(sender.id), TextBox).Text
            Try

                Select Case CtlType
                    Case "Password"
                        HBSAcodeLibrary.HBSA_Configuration.update(ConfigKey, txt)

                    Case "Date"
                        HBSAcodeLibrary.HBSA_Configuration.update(ConfigKey, CDate(txt).ToShortDateString)

                    Case "Integer"
                        HBSAcodeLibrary.HBSA_Configuration.update(ConfigKey, CInt(txt).ToString)

                    Case Else
                        HBSAcodeLibrary.HBSA_Configuration.update(ConfigKey, txt)

                End Select

            Catch ex As Exception
                errMsg = "Error changing setting: " & ex.Message
            End Try
        End If

        BuildTables(ConfigKey, errMsg)

    End Sub

End Class