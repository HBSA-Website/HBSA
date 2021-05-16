<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/mobile/mobileMaster.Master" CodeBehind="EntryFormsDownload.aspx.vb" Inherits="HBSA_Web_Application.EntryFormsDownload1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <h3>HBSA - Entry Forms Download</h3>

    <asp:DropDownList ID="EntryFormType_DropDownList" runat="server" Style="width: auto; margin-left: auto; margin-right: auto;" AutoPostBack="true">
        <asp:ListItem Value="0" Text="Choose the type of entry form you require:" Selected="True" />
        <asp:ListItem Value="1" Text="HBSA Snooker Leagues:" Selected="False" />
        <asp:ListItem Value="2" Text="HBSA Competitions:" Selected="False" />
    </asp:DropDownList>

    <br />

    <asp:Panel ID="Selection_Panel" runat="server" Visible="true">
        <br />
        <i>These files are in Adobe pdf format and may be used with Adobe Acrobat, or other applications that are capable of reading and/or editing pdf files.<br />
            If you don&#39;t already have it on your computer a free reader can be obtained here (Touch/Click this logo): <a href="http://get.adobe.com/uk/reader/" target="_blank">
                <img alt="Adobe Acrobat Reader" src="../images/reader_24.jpg" style="border: none; width: 69px; height: 69px;" /></a></i>
    </asp:Panel>

    <asp:Panel ID="Leagues_Panel" runat="server" Visible="false">
        <p><strong><span class="font-size: 12pt;">HBSA Leagues Entry Forms</span> </strong></p>
        <p>
            Note that there are now two sheets for an entry form.  The 2nd sheet will be required if there are more than two teams to be entered for a club.
        </p>
        <p>
            Touch/Click a link below and a suitable entry form will be offered for download which may be edited and printed.<br />
        </p>
        <p><asp:HyperLink ID="HyperLink1" runat="server" NavigateUrl="~/Documents/Entry Form Snooker.pdf">Open Snooker Entry Form</asp:HyperLink><br />
        </p>
        <p><asp:HyperLink ID="HyperLink2" runat="server" NavigateUrl="~/Documents/Entry Form Vets.pdf">Vets Snooker Entry Form</asp:HyperLink><br />
        </p>
        <p><asp:HyperLink ID="HyperLink3" runat="server" NavigateUrl="~/Documents/Entry Form Billiards.pdf">Billiards Entry Form</asp:HyperLink><br />
        </p>
    </asp:Panel>

    <asp:Panel ID="Competitions_Panel" runat="server" Visible="false">
        <p><strong><span class="font-size: 12pt;">Competitions Entry Forms</span> </strong></p>
        <p> Touch/Click a link below and a suitable entry form will be offered for download which may be edited and printed.</p>
        <p><asp:HyperLink ID="HyperLink4" runat="server" NavigateUrl="~/Documents/Competition_Entry_Form_Snooker.pdf">Open Snooker Competitions Entry Form</asp:HyperLink><br />
        </p>
        <p><asp:HyperLink ID="HyperLink5" runat="server" NavigateUrl="~/Documents/Competition_Entry_Form_Vets.pdf">Vets Snooker Competitions Entry Form</asp:HyperLink><br />
        </p>
        <p><asp:HyperLink ID="HyperLink6" runat="server" NavigateUrl="~/Documents/Competition_Entry_Form_Billiards.pdf">Billiards Snooker Competitions Entry Form</asp:HyperLink><br />
        </p>
    </asp:Panel>
</asp:Content>
