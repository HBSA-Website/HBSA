<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/admin/adminMasterPage.master" CodeBehind="PlayByDates.aspx.vb" Inherits="HBSA_Web_Application.PlayByDates" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="AjaxToolkit" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>

    <div style="text-align:left; ">
        <h3>Competition "Play by" Dates</h3>

            <asp:UpdatePanel ID="UpdatePanel1" runat="server">

                <ContentTemplate>

                    <asp:UpdateProgress runat="server" id="Update_Progress" DisplayAfter="10">
                        <ProgressTemplate>
                            <div id="Loading" style="position: fixed; left:35%;top:200px">
                                <asp:Image ID="loadingImage" runat="server" ImageUrl="~/images/AjaxLoading.gif" Width="100px" />
                            </div>
                        </ProgressTemplate>
                    </asp:UpdateProgress>

        <table>
            <tr>
                <td>
                    <div style="border: 1px solid #0000FF; color: #0000FF; background-color: #99CCFF">
                        <table style="text-align:left" >
                            <tr>
                                <td style="text-align:right">Select a competition:</td>
                                <td><asp:DropDownList ID="Competitions_DropDownList" runat="server" BackColor="#FFFFCC" AutoPostBack="True" ></asp:DropDownList></td>
                                <td><asp:Literal ID="Status_Literal" runat="server"></asp:Literal></td>
                            </tr>
                        </table>
                    </div>
                </td>
            </tr>
        </table>

        <table>

            <tr>
                <td>
                    <asp:GridView ID="Dates_GridView" runat="server" Font-Size="9pt" Width="100%" BackColor="White" BorderColor="darkblue" ForeColor="Maroon"
                        BorderStyle="Solid" BorderWidth="1px" CellPadding="3"
                        EmptyDataText="No data found. Probably due to no entrants have been made yet, or the draw has not yet been made (see Competitions >> Entrants).">
                        <HeaderStyle BackColor="#4A3C8C" Font-Bold="True" ForeColor="#F7F7F7" />
                        <RowStyle Height="18px" BackColor="#E7E7FF" ForeColor="#000044" />
                        <AlternatingRowStyle Height="18px" BackColor="#F7F7F7" />
                        <SelectedRowStyle BackColor="#738A9C" Font-Bold="True" ForeColor="#F7F7F7" />
                    </asp:GridView>
                </td>
            </tr>
        </table>

        <asp:Panel ID="Update_Panel" runat="server" Visible="false">
            <div>
                <table>
                    <tr>
                        <td>
                            <div style="border: 1px solid #0000FF; color: #0000FF; background-color: #99CCFF">
                                <table style="text-align:left" >
                                    <tr>
                                        <td colspan="4">Select which round to apply a date and/or header comment to,<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;then enter/select a date and/or comment and click Apply</td>
                                    </tr>
                                    <tr style="vertical-align:top">
                                        <td style="text-align:right">Select a Round:</td>
                                        <td><asp:DropDownList ID="Round_DropDownList" runat="server" BackColor="#FFFFCC" AutoPostBack="True" ></asp:DropDownList></td>
                                        <td style="vertical-align:top;">
                                            <asp:TextBox ID="PlayByDate_TextBox" runat="server"></asp:TextBox>
                                            <asp:Image ID="Calendar_Image" runat="server" ImageUrl="~/images/Icon-Calendar.png" />
                                            <%--<asp:Calendar ID="Calendar" runat="server" Visible="false" BackColor="White" BorderColor="#000099" BorderStyle="Solid" BorderWidth="1px"></asp:Calendar>--%>
                                            <AjaxToolkit:CalendarExtender ID="CalendarExtender" runat="server" TargetControlID="PlayByDate_TextBox" PopupButtonID="Calendar_Image" Format="dd MMM yyyy" TodaysDateFormat="d MMM yyyy"></AjaxToolkit:CalendarExtender>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="2" style="text-align:right">Round header comment:</td>
                                        <td colspan="2">
                                            <asp:TextBox ID="Comment_TextBox" runat="server" Height="16px" Width="240px"></asp:TextBox></td>
                                    </tr>
                                    <tr>
                                        <td colspan="2"></td>
                                        <td><asp:Button ID="PlayByDate_Button" runat="server" Text="Apply" /></td>
                                    </tr>
                                </table>
                            </div>
                        </td>
                    </tr>
                </table>
            </div>
        </asp:Panel>

        </ContentTemplate>
      </asp:UpdatePanel>                                  
    </div>

</asp:Content>
