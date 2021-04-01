Public Class SiteMap
    Inherits System.Web.UI.Page

    Dim MenuTable As New DataTable

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load

        Dim MasterMenu As HtmlTable = CType(Master.FindControl("Menu_Div"), HtmlTable)
        Dim ColumnIx As Integer = -1
        Dim RowIx As Integer
        MenuTable.Columns.Add("1")
        MenuTable.Columns.Add("2")
        MenuTable.Columns.Add("3")
        MenuTable.Columns.Add("4")
        MenuTable.Columns.Add("5")


        If Not MasterMenu Is Nothing Then
            For Each Level_0_Row As HtmlTableRow In MasterMenu.Rows

                For Each Level_0 As HtmlTableCell In Level_0_Row.Cells
                    ColumnIx += 1
                    RowIx = -1
                    For Each menuControl In Level_0.Controls

                        If Not menuControl Is Nothing AndAlso Not menuControl.ID Is Nothing Then
                            If Not menuControl.TagName Is Nothing AndAlso menuControl.TagName = "div" Then
                                If menuControl.ID.ToLower.StartsWith("menu_") Then

                                    For Each element In menuControl.controls

                                        Dim tag As String
                                        Try
                                            tag = element.tagname
                                            If tag = "a" Then
                                                RowIx += 1
                                                addMenuTableCell(ColumnIx, RowIx, "", stripHtmlElements(DirectCast(element, HtmlAnchor).InnerText), 0)
                                            End If

                                        Catch ex As Exception
                                            'skip this control
                                        End Try
                                    Next


                                ElseIf menuControl.ID.ToLower.StartsWith("submenu_") Then


                                    Dim Level1_Table As HtmlTable
                                    Level1_Table = CType(menuControl.FindControl(menuControl.ID.Replace("Div", "Table")), HtmlTable)

                                    For Each level_1_Row As HtmlTableRow In Level1_Table.Rows
                                        For Each Level_1_Cell As HtmlTableCell In level_1_Row.Cells


                                            'look for menu with sub menu
                                            For Each menuControlx In Level_1_Cell.Controls
                                                If Not menuControlx Is Nothing AndAlso Not menuControlx.ID Is Nothing Then
                                                    If Not menuControlx.TagName Is Nothing AndAlso menuControlx.TagName = "div" Then
                                                        If menuControlx.ID.ToLower.StartsWith("menu_") Then
                                                            For Each element In menuControlx.controls

                                                                Dim tag As String
                                                                Try
                                                                    tag = element.tagname
                                                                    If tag = "a" Then
                                                                        RowIx += 1
                                                                        addMenuTableCell(ColumnIx, RowIx, (DirectCast(element, HtmlAnchor)).ResolveUrl(element.href), stripHtmlElements(DirectCast(element, HtmlAnchor).InnerText), 6)
                                                                        'look for submenu


                                                                    ElseIf tag = "div" Then
                                                                        If element.ID.ToLower.StartsWith("submenu_") Then

                                                                            Dim Level2_Table As HtmlTable
                                                                            Level2_Table = CType(menuControlx.FindControl(menuControlx.ID.Replace("Div", "Table")), HtmlTable)
                                                                            For Each level_2_Row As HtmlTableRow In Level2_Table.Rows
                                                                                For Each Level_2_Cell As HtmlTableCell In level_2_Row.Cells


                                                                                    'look for menu with sub menu
                                                                                    For Each MenuControly In Level_1_Cell.Controls
                                                                                        If Not MenuControly Is Nothing AndAlso Not MenuControly.ID Is Nothing Then
                                                                                            If Not MenuControly.TagName Is Nothing AndAlso MenuControly.TagName = "div" Then
                                                                                                If MenuControly.ID.ToLower.StartsWith("menu_") Then
                                                                                                    For Each elementy In MenuControly.controls

                                                                                                        Dim tagy As String
                                                                                                        Try
                                                                                                            tagy = elementy.tagname
                                                                                                            If tagy = "a" Then
                                                                                                                RowIx += 1
                                                                                                                addMenuTableCell(ColumnIx, RowIx, (DirectCast(elementy, HtmlAnchor)).ResolveUrl(elementy.href), stripHtmlElements(DirectCast(elementy, HtmlAnchor).InnerText), 12)
                                                                                                                'look for submenu
                                                                                                            End If

                                                                                                        Catch ex As Exception
                                                                                                            'skip this control
                                                                                                        End Try
                                                                                                    Next
                                                                                                End If
                                                                                            End If
                                                                                        End If
                                                                                    Next
                                                                                Next

                                                                            Next
                                                                        End If

                                                                    End If

                                                                Catch ex As Exception
                                                                    'skip this control
                                                                End Try
                                                            Next
                                                        Else

                                                        End If
                                                    End If

                                                End If
                                            Next







                                            For Each element In Level_1_Cell.Controls
                                                Dim tag As String
                                                Try

                                                    tag = element.tagname
                                                    If tag = "a" Then
                                                        RowIx += 1
                                                        addMenuTableCell(ColumnIx, RowIx, (DirectCast(element, HtmlAnchor)).ResolveUrl(element.href), stripHtmlElements(DirectCast(element, HtmlAnchor).InnerText), 6)
                                                    End If

                                                Catch ex As Exception
                                                    'skip this control

                                                End Try

                                            Next

                                        Next
                                    Next

                                End If

                            End If
                        End If
                    Next
                Next
            Next

        End If

        Menu_GridView.DataSource = MenuTable
        Menu_GridView.DataBind()


    End Sub

    Private Function stripHtmlElements(element As String) As String

        Dim s As String = ""
        element = element.Replace(vbCr, "").Replace(vbLf, "").Trim
        Dim ix As Integer = 0
        Dim iy As Integer
        Dim inElement As Boolean = False

        While ix < element.Length
            If Not inElement Then
                iy = If(element.IndexOf("<", ix) < 0, element.Length, element.IndexOf("<", ix))
                s += element.Substring(ix, iy - ix)
                ix = iy + 1
                inElement = True
            Else
                ix = element.IndexOf(">", ix)
                ix += 1
                inElement = False
            End If

        End While

        stripHtmlElements = s.Trim

    End Function

    Private Sub addMenuTableCell(colix As Integer, rowix As Integer, targetURL As String, targetName As String, indent As Integer)

        Dim content As String = targetName.Replace(" ", "&nbsp;")
        If targetURL.Trim <> "" Then
            content = "<a href='" & targetURL & "'>" & content & "</a>"
        End If

        For i = 0 To indent
            content = "&nbsp;" & content
        Next

        If MenuTable.Rows.Count <= rowix Then
            Dim menuRow As DataRow = MenuTable.NewRow
            menuRow(colix) = content
            MenuTable.Rows.Add(menuRow)
        Else
            MenuTable.Rows(rowix)(colix) = content
        End If
        MenuTable.AcceptChanges()

    End Sub

    'Private Sub Menu_GridView_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles Menu_GridView.RowDataBound

    '    If e.Row.RowType = DataControlRowType.Header Then
    '        For Each col As TableCell In e.Row.Cells
    '            Dim encoded As String = col.Text
    '            col.Text = Context.Server.HtmlDecode(encoded)
    '        Next
    '    End If

    'End Sub
End Class