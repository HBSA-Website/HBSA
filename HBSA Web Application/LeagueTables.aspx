<%@ Page Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" Inherits="HBSA_Web_Application.LeagueTables" title="HBSA - League Tables" Codebehind="LeagueTables.aspx.vb" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

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

       <div style="font-family: Verdana; color:Green; text-align:center; font-size: small;"
                ;>
            <b>
            <br />
            League Tables<br />
            </b>
            <br />
            <asp:Literal ID="Selection_Literal" runat="server" Text="Select a league and a section:"></asp:Literal>
            <br />
            <asp:DropDownList ID="Section_DropDownList" runat="server" BackColor="#FFFFCC" AutoPostBack="True" ></asp:DropDownList>
            &nbsp;&nbsp;&nbsp;
            <br />
            <br />
            <div style="text-align: center; width: 100%">
            <table style="width:100%">
                <tr>
                    <td style="vertical-align:top; text-align:center">
                        <asp:GridView ID="LeagueTable_GridView" runat="server" BackColor="White" 
                            BorderColor="#CC9966" BorderStyle="Solid" BorderWidth="1px" CellPadding="4" Font-Size="9pt" >
                            <AlternatingRowStyle BackColor="#F7F7F7" />
                            <HeaderStyle BackColor="#006600" Font-Bold="True" ForeColor="#FFFFCC" />
                            <RowStyle BackColor="White" ForeColor="#006600" />
                            <SelectedRowStyle BackColor="#FFCC66" Font-Bold="True" ForeColor="#663399" />
                        </asp:GridView>
                    </td>
                </tr>
            </table>
                <br />



        </div>
    
    
    </div>
        </ContentTemplate>
    </asp:UpdatePanel>

</asp:Content>

