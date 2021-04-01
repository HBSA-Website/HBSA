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
            Case Else
                Return "ERROR:  Unknown detail type: " + DetailType
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
            HTML.Append("<b>" & player.FullName & "</b><br /> ")
            HTML.Append(player.LeagueName & "&nbsp;" & player.Team & " team<br />")
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
                HTML.Append("<br />" + Format(.DateImposed, "dd MMM yyyy") + ": " + .Offence)
                HTML.Append("<br />Amount: " + Format(.Amount, "£0.00") + "&nbsp;&nbsp; ")
                If (.Amount - .AmountPaid) <= 0 Then
                    HTML.Append("<b>Paid</b>")
                Else
                    HTML.Append("Outstanding: " + Format(.Amount - .AmountPaid, "£0.00"))
                End If
                If .Comment <> "" Then
                    HTML.Append("<br />" + .Comment)
                End If
                If .Payments.Rows.Count = 0 Then
                    HTML.Append("<br />No payment(s) made.")
                Else
                    HTML.Append("<br/><b>Payment" + If(.Payments.Rows.Count > 1, "s", "") + "</b>")
                    For Each payment As DataRow In .Payments.Rows
                        HTML.Append("<br/>" + Format(payment!DateTimePaid, "dd MMM yyyy") + " " & payment!PaidBy + "&nbsp; " + Format(payment!AmountPaid, "£0.00") + " " + payment!PaymentMethod)
                    Next
                End If
            End With
        End Using

        Return HTML.ToString()

    End Function
End Class