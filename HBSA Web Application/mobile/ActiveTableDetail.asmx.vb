Imports System.ComponentModel
Imports System.Web.Services
'Imports System.Web.Services.Protocols
Imports HBSAcodeLibrary

' To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line.
<System.Web.Script.Services.ScriptService()>
<System.Web.Services.WebService(Namespace:="http://tempuri.org/")> _
<System.Web.Services.WebServiceBinding(ConformsTo:=WsiProfiles.BasicProfile1_1)> _
<ToolboxItem(False)> _
Public Class ActiveTableDetail
    Inherits System.Web.Services.WebService

    <WebMethod()>
    Public Function GetDetail(ID As String, DetailType As String) As String

        Select Case DetailType
            Case "Team"
                Return GetTeamDetail(ID)
            Case "Player"
                Return GetPlayerDetail(ID)
            Case "Fine"
                Return GetFineDetail(ID)
            Case "Handicap"
                Return GetHandicapDetail(ID)
            Case "PlayingRecord"
                Return GetPlayingRecord(ID)
            Case "ScoreCard"
                Return GetScoreCard(ID)
            Case Else
                Return "ERROR:  Unknown detail type: " & DetailType
        End Select

    End Function
    Private Function GetTeamDetail(TeamID As String) As String

        Dim HTML As StringBuilder = New StringBuilder()

        Using team As TeamData = New TeamData(TeamID)
            HTML.Append("<b>" & team.ClubName & " " & team.LeagueName & " " & team.Team & "</b><br /> ")
            HTML.Append(team.SectionName & " | <b>Capt:</b> " & team.Contact)
            If team.eMail <> "" Then
                HTML.Append("<br /><b>eMail:</b> " & team.eMail)
            End If
            If team.TelNo <> "" Then
                HTML.Append("<br /><b>TelNo:</b> " & team.TelNo)
            End If

        End Using

        Return HTML.ToString()

    End Function
    Private Function GetPlayerDetail(PlayerID As String) As String

        Dim HTML As StringBuilder = New StringBuilder()

        Using player As PlayerData = New PlayerData(PlayerID)
            HTML.Append("<b>" & player.FullName & "</b> ")
            HTML.Append(player.ClubName & "<br/>")
            HTML.Append(player.LeagueName & "&nbsp;" & If(player.Team.Trim = "", "", player.Team & " team") & "<br />")
            HTML.Append(player.SectionName & "&nbsp;| <b>H'Cap:</b> " & player.Handicap & "<br/>")
            HTML.Append("<b>Tag:</b> " & If(player.Tagged = 0, "Seasoned",
                                         If(player.Tagged = 3, "Unseasoned",
                                         If(player.Tagged = 1, "1 season to go",
                                            player.Tagged & " seasons to go"))) & "<br />")
            HTML.Append("<b>Over 80(Vets)?</b> " & If(player.Over70 > 0, "Yes", "No") & " | <b>Played?</b> " & If(player.Played > 0, "Yes", "No"))
            If player.eMail <> "" Then
                HTML.Append("<br /><b>eMail:</b> " & player.eMail)
            End If
            If player.TelNo <> "" Then
                HTML.Append("<br /><b>TelNo:</b> " & player.TelNo)
            End If
        End Using

        Return HTML.ToString()

    End Function

    Private Function GetFineDetail(FineID As String) As String

        Dim HTML As StringBuilder = New StringBuilder()
        Using FineDetail As HBSAcodeLibrary.Fines = New HBSAcodeLibrary.Fines(FineID)
            With FineDetail
                HTML.Append("<b>Fine</b>")
                HTML.Append("<br />" & Format(.DateImposed, "dd MMM yyyy") & ": " & .Offence)
                HTML.Append("<br />Amount: " & Format(.Amount, "£0.00") & "&nbsp;&nbsp; ")
                If (.Amount - .AmountPaid) <= 0 Then
                    HTML.Append("<b>Paid</b>")
                Else
                    HTML.Append("Outstanding: " & Format(.Amount - .AmountPaid, "£0.00"))
                End If
                If .Comment <> "" Then
                    HTML.Append("<br />" & .Comment)
                End If
                If .Payments.Rows.Count = 0 Then
                    HTML.Append("<br />No payment(s) made.")
                Else
                    HTML.Append("<br/><b>Payment" & If(.Payments.Rows.Count > 1, "s", "") & "</b>")
                    For Each payment As DataRow In .Payments.Rows
                        HTML.Append("<br/>" & Format(payment!DateTimePaid, "dd MMM yyyy") & " " & payment!PaidBy & "&nbsp; " & Format(payment!AmountPaid, "£0.00") & " " & payment!PaymentMethod)
                    Next
                End If
            End With
        End Using

        Return HTML.ToString()

    End Function
    Private Function GetHandicapDetail(ID As String) As String

        Dim parms() As String = ID.Split("|") '
        Dim HTML As StringBuilder = New StringBuilder()

        Using handiCaps As DataTable = HBSAcodeLibrary.PlayerData.HandicapsReportForWeb(parms(2), parms(3), True, parms(0).Replace("~", "'"), (parms(4) = 1))
            Dim player As DataRow = handiCaps.Rows(0)
            With player
                HTML.Append("<b>" & player("Player") & "&nbsp;H'Cap: " & player("Current Handicap") & "</b><hr />")
                If Not IsDBNull(player("Last Season H'cap")) Then
                    HTML.Append("Last season H'Cap: " & player("Last Season H'cap") & ", effective from: " & player("Last Season H'cap effective from") & "<br/>")
                    HTML.Append("Played:" & player("Played") & " Won:" & player("Won") & " Lost:" & player("Lost") & " Delta:" & player("Delta"))
                Else
                    HTML.Append("No previous season.")
                End If
            End With
        End Using

        Return HTML.ToString()

    End Function
    Private Function GetPlayingRecord(ID As String) As String

        Dim parms() As String = ID.Split("|") 'SectionID|Player|handicap|ClubID
        Dim HTML As StringBuilder = New StringBuilder()

        Using Records As DataTable = HBSAcodeLibrary.PlayerData.GetPlayingRecords _
                                                      (parms(0),
                                                       parms(3),
                                                       "",
                                                       parms(1).Replace("~", "'"),
                                                       False,
                                                       False, True, parms(2))
            Using detail As DataTable = HBSAcodeLibrary.PlayerData.GetPlayingRecordsDetail _
                                                              (parms(0),
                                                               parms(3),
                                                               "",
                                                               parms(1).Replace("~", "'"),
                                                               False, False, parms(2))


                Dim player As DataRow = Records.Rows(0)
                With player
                    HTML.Append("<b>" & player("Player") & "&nbsp;H'Cap: " & player("Handicap") &
                                " Effective " & player("Effective") & "<br/>P:" & player("P") & " W:" & player("W") & " L:" & player("L") &
                                " </b>Tag: " & player("Tag") & "<hr />")
                End With
                If detail.Rows.Count > 0 Then
                    HTML.Append("<table>")
                    HTML.Append("<tr><th>Match Date</th><th>Opposition</th><th>Opponent</th><th>F</th><th>A</th></tr>")
                    For Each match As DataRow In detail.Rows
                        HTML.Append("<tr>")
                        HTML.Append("<td>" & match("Match Date") & "</td>")
                        HTML.Append("<td>" & match("OpponentTeam") & "</td>")
                        HTML.Append("<td>" & match("Opponent") & "</td>")
                        HTML.Append("<td>" & match("ScoreFor") & "</td>")
                        HTML.Append("<td>" & match("ScoreAgainst") & "</td>")
                        HTML.Append("</tr>")
                    Next
                    HTML.Append("</table>")
                End If

            End Using

        End Using

        Return HTML.ToString()
    End Function

    Private Function GetScoreCard(ID As String) As String

        Dim HTML As StringBuilder = New StringBuilder()

        Dim filePath As String = Server.MapPath("~/Mobile/ResultCard.html")
        Dim ResultCardHTML As String = IO.File.ReadAllText(filePath)

        Using MatchResult As DataSet = HBSAcodeLibrary.MatchResult.ResultCard(ID)

            Dim ix As Integer = 0
            Dim iy As Integer = -1
            Dim cardHeader As DataRow = MatchResult.Tables(0).Rows(0)
            Dim cardBody As DataTable = MatchResult.Tables(1)
            Dim homeBreaksTable As DataTable = MatchResult.Tables(2)
            Dim awayBreaksTable As DataTable = MatchResult.Tables(3)

            While iy < ResultCardHTML.Length

                ix = ResultCardHTML.IndexOf("|", Math.Max(0, iy + 1))
                If ix < 0 Then  'no more words to replace - retrieve the remainder of the HTML & stop indexing
                    HTML.Append(ResultCardHTML.Substring(iy + 1))
                    Exit While
                End If

                'insert the HTML from the last point to the replace word
                HTML.Append(ResultCardHTML.Substring(iy + 1, ix - iy - 1))

                'find the replace word
                iy = ResultCardHTML.IndexOf("|", ix + 1)
                Dim replaceWord As String = ResultCardHTML.Substring(ix + 1, iy - ix - 1)

                Select Case replaceWord
                    Case "League"
                        HTML.Append(cardHeader!League)
                    Case "Section"
                        HTML.Append(cardHeader!Section)
                    Case "FixtureDate"
                        HTML.Append(cardHeader.Item("FixtureDate"))
                    Case "MatchDate"
                        HTML.Append(cardHeader.Item("Match Date"))
                    Case "HomeTeam"
                        HTML.Append(cardHeader!Home)

                    Case "AwayTeam"
                        HTML.Append(cardHeader!Away)
                    Case "HomeFrames"
                        HTML.Append(cardHeader!H_Pts)
                    Case "AwayFrames"
                        HTML.Append(cardHeader!A_Pts)

                    Case "HomeHcap1"
                        HTML.Append(cardBody.Rows(0).Item("Home H'cap"))
                    Case "HomePlayer1"
                        HTML.Append(cardBody.Rows(0)!HomePlayer)
                    Case "HomeScore1"
                        HTML.Append(cardBody.Rows(0)!HomeScore)
                    Case "AwayHcap1"
                        HTML.Append(cardBody.Rows(0).Item("Away H'cap"))
                    Case "AwayPlayer1"
                        HTML.Append(cardBody.Rows(0)!AwayPlayer)
                    Case "AwayScore1"
                        HTML.Append(cardBody.Rows(0)!AwayScore)

                    Case "HomeHcap2"
                        HTML.Append(cardBody.Rows(1).Item("Home H'cap"))
                    Case "HomePlayer2"
                        HTML.Append(cardBody.Rows(1)!HomePlayer)
                    Case "HomeScore2"
                        HTML.Append(cardBody.Rows(1)!HomeScore)
                    Case "AwayHcap2"
                        HTML.Append(cardBody.Rows(1).Item("Away H'cap"))
                    Case "AwayPlayer2"
                        HTML.Append(cardBody.Rows(1)!AwayPlayer)
                    Case "AwayScore2"
                        HTML.Append(cardBody.Rows(1)!AwayScore)

                    Case "HomeHcap3"
                        HTML.Append(cardBody.Rows(2).Item("Home H'cap"))
                    Case "HomePlayer3"
                        HTML.Append(cardBody.Rows(2)!HomePlayer)
                    Case "HomeScore3"
                        HTML.Append(cardBody.Rows(2)!HomeScore)
                    Case "AwayHcap3"
                        HTML.Append(cardBody.Rows(2).Item("Away H'cap"))
                    Case "AwayPlayer3"
                        HTML.Append(cardBody.Rows(2)!AwayPlayer)
                    Case "AwayScore3"
                        HTML.Append(cardBody.Rows(2)!AwayScore)

                    Case "HomeHcap4"
                        HTML.Append(If(Not cardHeader!League.ToLower Like "*open*", "&nbsp;", cardBody.Rows(3).Item("Home H'cap")))
                    Case "HomePlayer4"
                        HTML.Append(If(Not cardHeader!League.ToLower Like "*open*", "&nbsp;", cardBody.Rows(3)!HomePlayer))
                    Case "HomeScore4"
                        HTML.Append(If(Not cardHeader!League.ToLower Like "*open*", "&nbsp;", cardBody.Rows(3)!HomeScore))
                    Case "AwayHcap4"
                        HTML.Append(If(Not cardHeader!League.ToLower Like "*open*", "&nbsp;", cardBody.Rows(3).Item("Away H'cap")))
                    Case "AwayPlayer4"
                        HTML.Append(If(Not cardHeader!League.ToLower Like "*open*", "&nbsp;", cardBody.Rows(3)!AwayPlayer))
                    Case "AwayScore4"
                        HTML.Append(If(Not cardHeader!League.ToLower Like "*open*", "&nbsp;", cardBody.Rows(3)!AwayScore))


                    Case "HomeBreaks_GridView"
                        HTML.Append(BreakTableHTML(homeBreaksTable))
                    Case "AwayBreaks_GridView"
                        HTML.Append(BreakTableHTML(awayBreaksTable))

                    Case Else
                        Throw New Exception("Unrecognised replace word on the result card HTML: " & replaceWord)
                End Select

            End While

        End Using

        Return HTML.ToString()

    End Function

    Private Function BreakTableHTML(BreaksTable As DataTable) As String

        If BreaksTable.Rows.Count = 0 Then
            Return ""
        Else
            Dim BreaksHTML As New StringBuilder("<table style='border: none;'>")

            For Each row As DataRow In BreaksTable.Rows
                BreaksHTML.Append("<tr><tdstyle='border: none;'>" & row.ItemArray(0) & "</td><tdstyle='border: none;'>&nbsp;&nbsp;&nbsp;" & row.ItemArray(1) & "</td></tr>")
            Next

            BreaksHTML.Append("</table>")
            Return BreaksHTML.ToString

        End If
    End Function

End Class