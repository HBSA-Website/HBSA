<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/MasterPage.master" CodeBehind="EntryFormsDownload.aspx.vb" Inherits="HBSA_Web_Application.EntryFormsDownload" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div style="font-family: Verdana; color:Green; text-align:center; font-size:10pt; background-color: #CCFFCC;";>
        <h3>HBSA - Entry Forms Download</h3>

        <asp:Literal ID="Chooser_Literal" runat="server" Visible="false">Entry forms are not available at this time.</asp:Literal>

        <asp:table width="100%" runat="server" id="ChooserTable" Visible="false">
            <asp:tablerow>
                <asp:tablecell>
                            Choose the type of entry form you require:
                    <asp:RadioButtonList ID="Type_RadioButtonList" runat="server" RepeatDirection="Horizontal" BackColor="#FFFFCC" AutoPostBack="true">
                        <asp:ListItem Value="Leagues">HBSA Leagues</asp:ListItem>
                        <asp:ListItem Value="Competitions">HBSA Competitions</asp:ListItem>
                      </asp:RadioButtonList>
                </asp:tablecell>
            </asp:tablerow>
            <asp:TableRow> 
                <asp:TableCell>
                    <i>These files are in the Adobe pdf format and may be used with Adobe Acrobat. If you don&#39;t already have it on your computer the free reader can be obtained here (click this logo):
                    <a href="http://get.adobe.com/uk/reader/" target="_blank">
                      <img alt="Adobe Acrobat Reader" src="images/reader_24.jpg" style="border:none" /></a></i>
                </asp:TableCell>
            </asp:TableRow>
        </asp:table>
        

    <asp:Panel ID="Leagues_Panel" runat="server" Visible="false">
        <p><strong> <span class="font-size: 12pt;">HBSA Leagues Entry Forms</span> </strong></p>
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
        <p></p>
    </asp:Panel>
   
         <asp:Panel ID="Competitions_Panel" runat="server" Visible="false">
        <p><strong> <span class="font-size: 12pt;">Competitions Entry Forms</span> </strong></p>
              <p>
              Click a link below and a suitable entry form will be offered for download which may be edited and printed.<br />
            </p>
        <p>
              <asp:Button ID="DownloadSnookerComps_Button" runat="server" Text="Open Snooker Competitions Entry Form" BorderStyle="Solid" BorderWidth="0px" BackColor="#CCFFCC" Font-Underline="True" ForeColor="#000099" onmouseover="this.style.cursor='pointer'" />
              <asp:Button ID="DownLoadVetsComps_Button" runat="server" Text="Vets Competitions Entry Form" BorderStyle="Solid" BorderWidth="0px" BackColor="#CCFFCC" Font-Underline="True" ForeColor="#000099" onmouseover="this.style.cursor='pointer'" />
              <asp:Button ID="DownLoadBilliardsComps_Button" runat="server" Text="Billiards Competitions Entry Form" BorderStyle="Solid" BorderWidth="0px" BackColor="#CCFFCC" Font-Underline="True" ForeColor="#000099" onmouseover="this.style.cursor='pointer'" />
            </p>
        <p></p>
    </asp:Panel>

        </div>

</asp:Content>
