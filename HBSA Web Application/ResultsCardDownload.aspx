<%@ Page Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" Inherits="HBSA_Web_Application.ResultsCardDownload" title="HBSA - Results Sheets Download" Codebehind="ResultsCardDownload.aspx.vb" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

          <div style="font-family: Verdana; color:Green; text-align:center; font-size:10pt; background-color: #CCFFCC;";>
            <b>Results sheet download</b><br />
            <br />
              Click a link below and a suitable results sheet will be offered for download which can be printed.<br />
              <br />
              <asp:Button ID="DownloadOpen_Button" runat="server" Text="Open Snooker Results Sheet" BorderStyle="Solid" BorderWidth="0px" BackColor="#CCFFCC" Font-Underline="True" ForeColor="#000099" onmouseover="this.style.cursor='pointer'" />
              <asp:Button ID="DownloadVets_Button" runat="server" Text="Vets Snooker Results Sheet" BorderStyle="Solid" BorderWidth="0px" BackColor="#CCFFCC" Font-Underline="True" ForeColor="#000099" onmouseover="this.style.cursor='pointer'" />
              <asp:Button ID="DownloadBilliards_Button" runat="server" Text="Billiards Results Sheet" BorderStyle="Solid" BorderWidth="0px" BackColor="#CCFFCC" Font-Underline="True" ForeColor="#000099" onmouseover="this.style.cursor='pointer'" />
              <br />
              <br />
              <i>Note that it will require Acrobat Reader.<br />
              If you don&#39;t already have it on your computer it can be obtained (free) here:
                  <a href="http://get.adobe.com/uk/reader/" target="_blank">
                      <img alt="Adobe Acrobat Reader" src="images/reader_24.jpg" style="border:none" /></a></i><br />

        <br />

        </div>

</asp:Content>

