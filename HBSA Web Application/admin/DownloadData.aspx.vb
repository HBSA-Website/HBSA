Imports System.IO

Public Class DownloadData
    Inherits System.Web.UI.Page
    Protected Sub DownloadContactsReport_Button_Click(sender As Object, e As EventArgs) Handles DownloadContactsReport_Button.Click
        download("ContactsReport", "Contacts Report")
    End Sub
    Protected Sub MatchResults_Button_Click(sender As Object, e As EventArgs) Handles MatchResults_Button.Click
        download("DownloadMatches", "Match Results")
    End Sub
    Protected Sub Handicaps_Button_Click(sender As Object, e As EventArgs) Handles Handicaps_Button.Click
        download("DownloadHandicaps", "End of season handicaps")
    End Sub
    Protected Sub ContentData_Button_Click(sender As Object, e As EventArgs)
        download("getHomeContent", "Home Page Articles")
    End Sub
    Protected Sub download(SPname As String, fileName As String)

        Dim main_DataTable As DataTable
        Status_Literal.Text = ""
        Try
            main_DataTable = HBSAcodeLibrary.SharedRoutines.DataForDownload(SPname)
        Catch ex As Exception
            Status_Literal.Text = "<span style='color:red'>ERROR " & ex.Message & "</span>"
            Exit Sub
        End Try

        If main_DataTable Is Nothing OrElse main_DataTable.Rows.Count = 0 Then
            Status_Literal.Text = "There is nothing to export..."
        Else
            Dim fName As String
            fName = fileName & " " & main_DataTable.TableName & Format(HBSAcodeLibrary.Utilities.UKDateTimeNow(), "_dd MMM yyyy HHmm") & ".csv"

            'build a csv file as a string
            Dim strFileContent As New StringBuilder((main_DataTable.Rows.Count + 1) * main_DataTable.Columns.Count * 10)

            Try
                If Not IsNothing(main_DataTable) Then
                    Dim col As DataColumn
                    For Each col In main_DataTable.Columns
                        strFileContent.Append(col.ColumnName & ",")
                    Next
                    strFileContent.Remove(strFileContent.Length - 1, 1)
                    strFileContent.Append(vbCrLf)
                    Dim dr As DataRow
                    For Each dr In main_DataTable.Rows
                        For ix As Integer = 0 To main_DataTable.Columns.Count - 1
                            Dim strItem = dr.Item(ix).ToString.Replace(",", ";").Replace(vbCr, "|").Replace(vbLf, "|")
                            If SPname = "getHomeContent" AndAlso ix = 2 Then 'need to convert html to plain text
                                strItem = HBSAcodeLibrary.Utilities.HTMLToText(strItem)
                                strItem = strItem.Replace("|", "").Replace(",", ";").Replace(vbCr, "").Replace(vbLf, "")
                            End If
                            strFileContent.Append(strItem & ",")
                        Next
                        strFileContent.Remove(strFileContent.Length - 1, 1)
                        strFileContent.Append(vbCrLf)
                    Next
                End If

                'stream the string to the user as a file
                Dim csvString = strFileContent.ToString

                Response.Clear()
                Response.ClearHeaders()
                Response.AppendHeader("Content-Length", csvString.Length.ToString())
                Response.ContentType = "text/plain"
                Response.AppendHeader("Content-Disposition", "attachment; filename = " & fName)
                Response.Output.Write(csvString)
                Response.End()

            Catch ex As Exception
                Status_Literal.Text = "<br/><span style='color:red;'><strong>Error occurred.</strong><br/>" &
                               "Please contact us with the following information:<br/<br/>" &
                               ex.ToString & "</span><br/>"
            End Try

        End If

    End Sub
End Class