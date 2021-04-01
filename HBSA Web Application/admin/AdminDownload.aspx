<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="AdminDownload.aspx.vb" Inherits="HBSA_Web_Application.AdminDownload" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
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
    Creating your file - please wait a moment...
    <div>
        <asp:Button ID="Error_Button" runat="server" Text="Generate" />
    </div>
    </form>
</body>
</html>
