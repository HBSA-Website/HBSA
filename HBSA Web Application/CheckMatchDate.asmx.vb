Imports System.ComponentModel
Imports System.Web.Services
Imports System.Web.Services.Protocols
Imports HBSA_Web_Application.MatchResult

' To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line.
<System.Web.Script.Services.ScriptService()>
<System.Web.Services.WebService(Namespace:="http://tempuri.org/")> _
<System.Web.Services.WebServiceBinding(ConformsTo:=WsiProfiles.BasicProfile1_1)> _
<ToolboxItem(False)> _
Public Class CheckMatchDate
    Inherits System.Web.Services.WebService

    <WebMethod()>
    Public Function CheckMatchDate(HomeTeamID, MatchDate) As String
        Using match As DataTable = HBSAcodeLibrary.MatchResult.MatchPlayed(HomeTeamID, MatchDate)
            If match.Rows.Count > 0 Then
                Return "<span style='color:red;'>" &
                       "The home team already recorded a match for this date.</span><br/> &nbsp;&nbsp;&nbsp;&nbsp;(" & match.Rows(0).ItemArray(1) & ")" &
                       "<br/>Choose a different date or amend the other match.<br/> Click on this message to dismiss it."
            Else
                Return ""
            End If
        End Using

    End Function

End Class