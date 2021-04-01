<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/MasterPage.master" CodeBehind="Breaks.aspx.vb" Inherits="HBSA_Web_Application.Breaks" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    
    <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
       <asp:UpdateProgress runat="server" id="Update_Progress" DisplayAfter="10">
            <ProgressTemplate>
                <div id="Loading" style="position: fixed; left:440px;top:260px">
                    <asp:Image ID="loadingImage" runat="server" ImageUrl="~/images/AjaxLoading.gif" Width="100px" />
                </div>
            </ProgressTemplate>
        </asp:UpdateProgress>

    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
         <ContentTemplate>

          <div style="font-family: Verdana; color:Green; text-align:center; font-size:10pt; background-color: #CCFFCC;";>
            <b>Breaks over 25</b><br />
            <br />
              Click a link below and an appropriate set of breaks will be shown.<br />
              <br />
              <asp:Button ID="Open_Button" runat="server" Text="Open Snooker Leagues" onmouseover="this.style.cursor='pointer'" BorderStyle="Solid" BorderWidth="0px" BackColor="#CCFFCC" Font-Underline="True" ForeColor="#000099" />
              <asp:Button ID="Vets_Button" runat="server" Text="Vets Snooker Leagues" onmouseover="this.style.cursor='pointer'" BorderStyle="Solid" BorderWidth="0px" BackColor="#CCFFCC" Font-Underline="True" ForeColor="#000099" />
              <asp:Button ID="Billiards_Button" runat="server" Text="Billiards Leagues" onmouseover="this.style.cursor='pointer'" BorderStyle="Solid" BorderWidth="0px" BackColor="#CCFFCC" Font-Underline="True" ForeColor="#000099" />
              <br />
              <br />
              <table style="width:100%;"><tr><td style="text-align:center;">
              <asp:GridView ID="Breaks_GridView" runat="server" BackColor="White" 
                        BorderColor="#CC9966" BorderStyle="Solid" BorderWidth="1px" CellPadding="4" 
                        EnableModelValidation="True" Font-Size="9pt">
                        <AlternatingRowStyle BackColor="#F7F7F7" Height="18px" />
                        <HeaderStyle BackColor="#006600" Font-Bold="True" ForeColor="#FFFFCC" />
                        <RowStyle BackColor="White" ForeColor="#006600" Height="18px" HorizontalAlign="Left" />
                        </asp:GridView>
              </td></tr></table>
        </div>

        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
