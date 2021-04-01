<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/admin/adminMasterPage.master" CodeBehind="PrivacyReports.aspx.vb" Inherits="HBSA_Web_Application.PrivacyReports" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div style="text-align:left; width:100%">
        <h3>Privacy Acceptance report</h3>

        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        
        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <ContentTemplate>
    
            <div style="text-align:left; width:100%">
 
                  <table>
                      <tr>
                        <td>
                            <div style="border: 1px solid #0000FF; color: #0000FF; background-color: #99CCFF">
                                <table style="text-align:left" >
                                <tr>
                                    <td>
                                        <asp:DropDownList ID="Club_DropDownList" runat="server" BackColor="#FFFFCC" >
                                            <asp:ListItem Value="" Text="** Select a club(s) **" />
                                            <asp:ListItem Value="0" Text="All Clubs" />
                                        </asp:DropDownList>
                                    </td>
                                    <td>
                                        <asp:DropDownList ID="type_DropDownList1" runat="server" BackColor="#FFFFCC" AutoPostBack="True" >
                                            <asp:ListItem Value="" Text="** Select Entry type **" />
                                            <asp:ListItem Value="0" Text="Leagues" />
                                            <asp:ListItem Value="1" Text="Competitions" />
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                    <tr>
                                        <td>
                                            <asp:DropDownList ID="Privacy_DropDownList" runat="server" BackColor="#FFFFCC" AutoPostBack="True" >
                                                <asp:ListItem Value="" Text="** Select acceptance/non acceptance" />    
                                                <asp:ListItem Value="0" Text="NOT accepted" />
                                                <asp:ListItem Value="1" Text="Accepted" />
                                                <asp:ListItem Value="Any" Text="Any" />    
                                            </asp:DropDownList>
                                        </td>
                                        <td style="text-align:right">
                                            <asp:Button ID="report_Button" runat="server" Text="Get the report" />
                                        </td>
                                    </tr>
                            </table>
                        </div>

                            </tr>
                        </table>
 
                <span style="color:red"><asp:Literal ID="Err_Literal" runat="server"></asp:Literal></span>
                </div>

                     <asp:GridView ID="PrivacyReport_GridView" runat="server"  
                                        Font-Size="9pt" BackColor="White" BorderColor="Black" 
                                        BorderStyle="Solid" BorderWidth="1px" CellPadding="3"
                                        EmptyDataText="No data found">
                                    <HeaderStyle BackColor="#4A3C8C" Font-Bold="True" ForeColor="#F7F7F7" />
                                    <RowStyle Height="18px" BackColor="#E7E7FF" ForeColor="#000044" />
                                    <AlternatingRowStyle Height="18px" BackColor="#F7F7F7" />
                              </asp:GridView>

            </ContentTemplate>
        </asp:UpdatePanel>

    </div>

</asp:Content>