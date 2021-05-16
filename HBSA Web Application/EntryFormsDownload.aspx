<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/MasterPage.master" CodeBehind="EntryFormsDownload.aspx.vb" Inherits="HBSA_Web_Application.EntryFormsDownload" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div style="font-family: Verdana; color: Green; text-align: center; font-size: 10pt; background-color: #CCFFCC;">
        <h3>HBSA - Entry Forms Download</h3>

        <asp:DropDownList ID="EntryFormType_DropDownList" runat="server" Style="width: auto; margin-left: auto; margin-right: auto;" AutoPostBack="true">
            <asp:ListItem Value="0" Text="Choose the type of entry form you require:" Selected="True" />
            <asp:ListItem Value="1" Text="HBSA Snooker Leagues:" Selected="False" />
            <asp:ListItem Value="2" Text="HBSA Competitions:" Selected="False" />
        </asp:DropDownList>

        <br />

        <asp:Panel ID="Selection_Panel" runat="server" Visible="true"><br />
        <i>These files are in Adobe pdf format and may be used with Adobe Acrobat, or other applications that are capable of reading and/or editing pdf files.<br />
        If you don&#39;t already have it on your computer a free reader can be obtained here (click this logo): <a href="http://get.adobe.com/uk/reader/" target="_blank">
           <img alt="Adobe Acrobat Reader" src="images/reader_24.jpg" style="border: none" /></a></i>
        </asp:Panel>

        <asp:Panel ID="Leagues_Panel" runat="server" Visible="false">
            <p><strong><span class="font-size: 12pt;">HBSA Leagues Entry Forms</span> </strong></p>
            <p>
                Note that there are now two sheets for an entry form.  The 2nd sheet will be required if there are more than two teams to be entered for a club.
            </p>
            <p>
                Click a link below and a suitable entry form will be offered for download which may be edited and printed.<br />
            </p>
            <p>
                <asp:Button ID="DownloadOpen_Button" runat="server" Text="Open Snooker Entry Form" BorderStyle="Solid" BorderWidth="0px" BackColor="#CCFFCC" Font-Underline="True" ForeColor="#000099" onmouseover="this.style.cursor='pointer'" />
                <asp:Button ID="DownloadVets_Button" runat="server" Text="Vets Snooker Entry Form" BorderStyle="Solid" BorderWidth="0px" BackColor="#CCFFCC" Font-Underline="True" ForeColor="#000099" onmouseover="this.style.cursor='pointer'" />
                <asp:Button ID="DownloadBilliards_Button" runat="server" Text="Billiards Entry Form" BorderStyle="Solid" BorderWidth="0px" BackColor="#CCFFCC" Font-Underline="True" ForeColor="#000099" onmouseover="this.style.cursor='pointer'" />
            </p>
        </asp:Panel>

        <asp:Panel ID="Competitions_Panel" runat="server" Visible="false">
            <p><strong><span class="font-size: 12pt;">Competitions Entry Forms</span> </strong></p>
            <p>
                Click a link below and a suitable entry form will be offered for download which may be edited and printed.<br />
            </p>
            <p>
                <asp:Button ID="DownloadSnookerComps_Button" runat="server" Text="Open Snooker Competitions Entry Form" BorderStyle="Solid" BorderWidth="0px" BackColor="#CCFFCC" Font-Underline="True" ForeColor="#000099" onmouseover="this.style.cursor='pointer'" />
                <asp:Button ID="DownLoadVetsComps_Button" runat="server" Text="Vets Competitions Entry Form" BorderStyle="Solid" BorderWidth="0px" BackColor="#CCFFCC" Font-Underline="True" ForeColor="#000099" onmouseover="this.style.cursor='pointer'" />
                <asp:Button ID="DownLoadBilliardsComps_Button" runat="server" Text="Billiards Competitions Entry Form" BorderStyle="Solid" BorderWidth="0px" BackColor="#CCFFCC" Font-Underline="True" ForeColor="#000099" onmouseover="this.style.cursor='pointer'" />
            </p>
        </asp:Panel>
    <br />
    </div>

</asp:Content>
