<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="CreateAndDownloadFile.aspx.vb" Inherits="HBSA_Web_Application.CreateAndDownloadFile" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>HBSA File Exporter</title>
</head>
<!--  The following scripts allow the window.close to immediately close the window without the confirm request -->
<script type="text/javascript">
    if (window.name != 'prime') {
        window.name = 'prime';
        window.open(window.location.href, 'prime')
    }
</script>

<body>
    <form id="form1" runat="server">
    Creating your file - please wait a moment
    <div>
        <asp:Button ID="Error_Button" runat="server" Text="Generate" />
    </div>
    </form>
</body>
</html>
