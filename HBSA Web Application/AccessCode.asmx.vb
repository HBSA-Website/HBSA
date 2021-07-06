Imports System.ComponentModel
Imports System.Web.Services
Imports System.Web.Services.Protocols

' To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line.
<System.Web.Script.Services.ScriptService()>
<System.Web.Services.WebService(Namespace:="http://tempuri.org/")> _
<System.Web.Services.WebServiceBinding(ConformsTo:=WsiProfiles.BasicProfile1_1)> _
<ToolboxItem(False)> _
Public Class AccessCode
    Inherits System.Web.Services.WebService

    <WebMethod()>
    Public Function CheckAccessCode(AccessCode As String) As String

        Using cfg As New HBSAcodeLibrary.HBSA_Configuration

            If AccessCode.Trim.ToLower = cfg.Value("ViewPlayerDetailsAccessCode").ToLower Then
                Return "good"
            Else
                Return "bad"
            End If

        End Using

    End Function

End Class