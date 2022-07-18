<%@ Page Title="" Language="VB" MasterPageFile="~/admin/adminMasterPage.master" AutoEventWireup="false" Inherits="HBSA_Web_Application.admin_PointsAdjuster" Codebehind="PointsAdjuster.aspx.vb" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

    <div style="text-align:left; width:100%">
    <h3>League Points Adjustments</h3>

    <asp:Button ID="Add_Button" runat="server" Text="Create Adjustment" />
    <br /><br />
        <span style="font-size:larger;color:black;"><asp:Literal ID="Status_Literal" runat="server"></asp:Literal></span>
    <br />
                <asp:GridView ID="Adjustments_GridView" runat="server" Font-Size="9pt" BackColor="White" BorderColor="#E7E7FF" 
                        BorderStyle="None" BorderWidth="1px" CellPadding="3">
                        <HeaderStyle BackColor="#4A3C8C" Font-Bold="True" ForeColor="#F7F7F7" />
                        <RowStyle Height="18px" BackColor="#E7E7FF" ForeColor="#000044" />
                        <AlternatingRowStyle Height="18px" BackColor="#F7F7F7" />
                        <Columns>
                            <asp:CommandField ButtonType="Button" ControlStyle-ForeColor="#000044" ShowCancelButton="False" ShowDeleteButton="True" SelectText="Change" ShowSelectButton="True" >
                                    <ControlStyle Font-Size="7pt" ></ControlStyle>
                            </asp:CommandField>
                            </Columns>
                        <SelectedRowStyle BackColor="#738A9C" Font-Bold="True" ForeColor="#F7F7F7" />
                    </asp:GridView>

</div>
                    
    <asp:Panel ID="Edit_Panel" runat="server" Visible="false">
        <div style="border: 1px solid #0000FF; position: fixed; top: 200px; left: 300px; color: #0000FF; background-color: #99CCFF;">
            <table style="text-align:left" >
                <tr>
                    <td colspan="2" style="text-align:center;color:red"><asp:Literal ID="Edit_Panel_Literal" runat="server"></asp:Literal></td>
                </tr>
                <tr>
                    <td style="text-align:right"><asp:Literal ID="Selection_Literal" runat="server" Text="Division/section and a team:"></asp:Literal></td>
                    <td><asp:DropDownList ID="Section_DropDownList" runat="server" BackColor="#FFFFCC" AutoPostBack="True" ></asp:DropDownList>
                        <asp:DropDownList ID="Team_DropDownList" runat="server" BackColor="#FFFFCC"  ></asp:DropDownList></td>
                </tr>
                <tr>
                    <td style="text-align:right">Number of points to </td>
                    <td><asp:DropDownList ID="Adjustment_DropDown" runat="server" BackColor="#FFFFCC" >
                                    <asp:ListItem Value="-">Deduct</asp:ListItem>
                                    <asp:ListItem Value="+">Add</asp:ListItem>
                            </asp:DropDownList>
                        <asp:TextBox ID="Points_TextBox" runat="server" BackColor="#FFFFCC" Width="25px"></asp:TextBox>
                    </td>
                </tr>
                <tr style="color:palevioletred; font-style:italic">
                    <td style="text-align:right; vertical-align:top;">Note:</td>
                    <td>
                          To adjust the league position Add or deduct 0.1 points<br />
                          </td>
                </tr>
                <tr>
                    <td style="text-align:right">Reason for adjustment:</td>
                    <td><asp:TextBox ID="Reason_TextBox" runat="server" BackColor="#FFFFCC" Width="319px" MaxLength="255" /></td>
                </tr>
                <tr>
                    <td style="text-align:center" colspan="2">
                        Tick this box
                        <asp:CheckBox ID="SendEmail_CheckBox" runat="server" Text=" to send emails to the Club contact and Team Captain" />
                        <br />
                        <asp:Button ID="Save_Button" runat="server" Text="Save" Width="64px" />
                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                        <asp:Button ID="Cancel_Button" runat="server" Text="Cancel" Width="64px" />
                    </td>
                </tr>
                <tr>
                    <td colspan="2" style="text-align:center"></td>
                </tr>
            </table>
        </div>
    </asp:Panel>            

    
</asp:Content>

