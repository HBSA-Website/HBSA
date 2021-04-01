Imports System.Data

Public Class CreateAndDownloadFile
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        Dim main_DataTable As DataTable

        main_DataTable = Session(Request.Params("source")) '"RecordTable")

        If main_DataTable Is Nothing OrElse main_DataTable.Rows.Count = 0 Then
            Error_Button.Text = "There is nothing to export..."
        Else

            'set up a csv file for the user.
            Dim fName As String
            fName = Request.Params("fileName") & " " & main_DataTable.TableName & Format(HBSAcodeLibrary.Utilities.UKDateTimeNow(), "_dd MMM yyyy HHmm") & ".csv"

            'build a csv file as a string
            Dim strFileContent As New StringBuilder((main_DataTable.Rows.Count + 1) * main_DataTable.Columns.Count * 10)

            Try
                If Not IsNothing(main_DataTable) Then

                    If Not Request.Params("fileName") = "EntryForm" Then
                        Dim col As DataColumn
                        For Each col In main_DataTable.Columns
                            strFileContent.Append(col.ColumnName & ",")
                        Next
                        strFileContent.Remove(strFileContent.Length - 1, 1)
                        strFileContent.Append(vbCrLf)
                    End If

                    Dim dr As DataRow
                    For Each dr In main_DataTable.Rows
                        For ix As Integer = 0 To main_DataTable.Columns.Count - 1
                            'If dr.Item(ix).ToString Like "*£*" Then
                            '    Dim s As Integer = Asc(dr.Item(ix).ToString.Substring(0, 1))
                            '    MsgBox(dr.Item(ix).ToString)
                            'End If
                            strFileContent.Append(dr.Item(ix).ToString.Replace(",", ";").Replace(vbCr, "|").Replace(vbLf, "|").Replace("£", " ") & ",")
                        Next
                        strFileContent.Remove(strFileContent.Length - 1, 1)
                        strFileContent.Append(vbCrLf)
                    Next
                End If

                'stream the string to the user as a file
                Response.ContentType = "text/plain"
                Response.AddHeader("Content-Disposition", "attachment; filename = " & fName)
                Response.Clear()

                Response.Output.Write(strFileContent.ToString)
                Response.End()

            Catch ex As Exception
                Error_Button.Text = "<br/><span style='color:red;'><strong>Error occurred.</strong><br/>" & _
                               "Please contact us with the following information:<br/<br/>" & _
                               ex.ToString & "</span><br/>"
            End Try

        End If

    End Sub

End Class

