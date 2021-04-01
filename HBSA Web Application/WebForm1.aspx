<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="WebForm1.aspx.vb" Inherits="HBSA_Web_Application.WebForm1" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
    <asp:LinkButton ID="lnkView" runat="server" Text="View PDF" OnClick="View"></asp:LinkButton><br />
        <a href="Documents/Entry Form Vets.pdf" target="_blank">View PDF on new tab</a><br />
        <br />

<asp:FileUpload id="FileUploadControl" runat="server" />
    <asp:Button runat="server" id="UploadButton" text="Upload" onclick="UploadButton_Click" />
    <br /><br />
    <asp:Label runat="server" id="StatusLabel" text="Upload status: " />

&nbsp;<hr />
        <div id="PlaceHolder" runat="server" style="width:100%;height:200px;">
            <asp:Image id="image" runat="server" />
            <asp:Literal ID="ltEmbed" runat="server" />
        </div>
    </div>
    </form>
</body>
</html>
