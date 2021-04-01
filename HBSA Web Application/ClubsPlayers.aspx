<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/MasterPage.master" CodeBehind="ClubsPlayers.aspx.vb" Inherits="HBSA_Web_Application.ClubsPlayers" %>
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

          <div style="font-family: Verdana; color:Green; text-align:center; background-color:#ccffcc; font-size: 11pt;">
            <b>Clubs and Players</b><br />
            <br />
            
            <table style="font-size: 11pt; width:100%">
                <tr>
                    <td style="text-align: right; font-size: 11pt">Select a league and section</td>
                    <td rowspan="2" style="text-align: center; vertical-align:top; font-size: 16px; font-weight: bold">&nbsp;&nbsp;&nbsp;OR&nbsp;&nbsp;&nbsp;</td>
                    <td style="text-align: left; font-size: 11pt">Select a Club</td>
                </tr>
                <tr>
                    <td style="text-align: right;"><asp:DropDownList ID="Section_DropDownList" runat="server" BackColor="#FFFFCC" AutoPostBack="True" ></asp:DropDownList></td>
                    <td style="text-align: left;"><asp:DropDownList ID="Club_DropDownList" runat="server" BackColor="#FFFFCC" AutoPostBack="True" ></asp:DropDownList></td>
             
                </tr>
            </table>

            <br />
            <div style="text-align: center; width: 100%">
            <table style="width:100%">
                <tr>
                    <td style="vertical-align:top;">
                        <asp:GridView ID="ClubsAndPlayers_GridView" runat="server" BackColor="White" 
                        BorderColor="#CC9966" BorderStyle="Solid" BorderWidth="1px" CellPadding="4" Font-Size="9pt" >
                        <AlternatingRowStyle BackColor="#F7F7F7" HorizontalAlign="Left" />
                        <HeaderStyle BackColor="#006600" Font-Bold="True" ForeColor="#FFFFCC" />
                        <RowStyle BackColor="White" ForeColor="#006600" HorizontalAlign="Left"  />
                    </asp:GridView></td>
                    <td style="vertical-align:top;">
                        <asp:GridView ID="Teams_GridView" runat="server" BackColor="White"
                        BorderColor="#CC9966" BorderStyle="Solid" BorderWidth="1px" CellPadding="4" 
                        EnableModelValidation="True" Font-Size="9pt" >
                        <AlternatingRowStyle BackColor="#F7F7F7" HorizontalAlign="Left" />
                        <HeaderStyle BackColor="#006600" Font-Bold="True" ForeColor="#FFFFCC" />
                        <RowStyle BackColor="White" ForeColor="#006600" HorizontalAlign="Left" />
                        <SelectedRowStyle BackColor="#FFCC66" Font-Bold="True" ForeColor="#663399" />
                    </asp:GridView></td>
                </tr>
                <tr>
                    <td colspan="2" style="vertical-align:top; text-align:center;">
                        <asp:GridView ID="Players_GridView" runat="server" BackColor="White"
                        BorderColor="#CC9966" BorderStyle="Solid" BorderWidth="1px" CellPadding="4" 
                        EnableModelValidation="True" Font-Size="9pt" >
                        <AlternatingRowStyle BackColor="#F7F7F7" HorizontalAlign="Left" />
                        <HeaderStyle BackColor="#006600" Font-Bold="True" ForeColor="#FFFFCC" />
                        <RowStyle BackColor="White" ForeColor="#006600" HorizontalAlign="Left" />
                        <SelectedRowStyle BackColor="#FFCC66" Font-Bold="True" ForeColor="#663399" />
                    </asp:GridView></td>
                    
                </tr>
            </table>
  
    </div>

          </div>


        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
