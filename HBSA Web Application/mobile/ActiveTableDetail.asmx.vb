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

End Class