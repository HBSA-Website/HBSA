<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/admin/adminMasterPage.master" CodeBehind="FixtureDates.aspx.vb" Inherits="HBSA_Web_Application.FixtureDates" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="AjaxToolkit" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <h3>FixtureDates Maintenance</h3>
    <asp:ScriptManager ID="ScriptManager2" runat="server"></asp:ScriptManager>
    <asp:UpdateProgress ID="UpdateProgress1" runat="server" DisplayAfter="1000">
        <ProgressTemplate>Processing, please wait a moment...</ProgressTemplate>
    </asp:UpdateProgress>
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <div style="text-align: left;">
                Fixture dates are set by section/division.  However they are usually the same for all sections/divisions in a league.<br />
                Therefore choose to either set/view the fixture dates for all sections/divisions in a league, or set/view dates for each section/division. 
                    <table style="text-align: left">
                        <tr>
                            <td style="text-align: right">Select a division/section:</td>
                            <td>
                                <asp:DropDownList ID="Section_DropDownList" runat="server" BackColor="#FFFFCC" AutoPostBack="True" />
                            </td>
                    </table>

                <asp:Panel ID="Main_Panel" runat="server" Visible="false">
                    Set the League's first fixture date, and then the dates between which (inclusive)<br />
                    there will not be any fixtures (the Christmas period).  Then click Recalculate when<br />
                    a new set of Fixture dates will be stored and shown.  This can be done as often as<br />
                    is needed until a set of dates is as required.<br />
                    <br />
                    NOTE: it is not advisable to do this after any results have been recorded as they may become lost.<br />
                    <br />

                    <table>
                        <tr style="vertical-align: top;">
                            <td>
                                <table>
                                    <tr>
                                        <th style="text-align: right; vertical-align: middle">Start Date:</th>
                                        <td>
                                            <asp:TextBox ID="StartDate_TextBox" runat="server"></asp:TextBox>
                                            <asp:ImageButton ID="StartDate_Image" runat="server" ImageUrl="~/images/Icon-Calendar.png" />
                                            <%--<asp:Calendar ID="StartDate_Calendar" runat="server" Visible="false" BackColor="White" BorderColor="#000099" BorderStyle="Solid" BorderWidth="1px"></asp:Calendar>--%>
                                            <ajaxToolkit:CalendarExtender ID="StartDate_CalendarExtender" runat="server" TargetControlID="StartDate_TextBox" PopupButtonID="StartDate_Image" Format="dd MMM yyyy" TodaysDateFormat="d MMM yyyy"></ajaxToolkit:CalendarExtender>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th style="text-align: right">Curfew Start</th>
                                        <td>
                                            <asp:TextBox ID="CurfewStart_TextBox" runat="server"></asp:TextBox>
                                            <asp:Image ID="CurfewStart_Image" runat="server" ImageUrl="~/images/Icon-Calendar.png" />
                                            <%--<asp:Calendar ID="CurfewStart_Calendar" runat="server" Visible="false" BackColor="White" BorderColor="#000099" BorderStyle="Solid" BorderWidth="1px"></asp:Calendar>--%>
                                            <ajaxToolkit:CalendarExtender ID="CurfewStart_CalendarExtender" runat="server" TargetControlID="CurfewStart_TextBox" PopupButtonID="CurfewStart_Image" Format="dd MMM yyyy" TodaysDateFormat="d MMM yyyy"></ajaxToolkit:CalendarExtender>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th style="text-align: right">Curfew End</th>
                                        <td>
                                            <asp:TextBox ID="CurfewEnd_TextBox" runat="server"></asp:TextBox>
                                            <asp:Image ID="CurfewEnd_Image" runat="server" ImageUrl="~/images/Icon-Calendar.png" />
                                            <%--<asp:Calendar ID="CurfewEnd_Calendar" runat="server" Visible="false" BackColor="White" BorderColor="#000099" BorderStyle="Solid" BorderWidth="1px"></asp:Calendar>--%>
                                            <ajaxToolkit:CalendarExtender ID="CurfewEnd_CalendarExtender" runat="server" TargetControlID="CurfewEnd_TextBox" PopupButtonID="CurfewEnd_Image" Format="dd MMM yyyy" TodaysDateFormat="d MMM yyyy"></ajaxToolkit:CalendarExtender>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th style="text-align: right">Enter the total<br />
                                            number of fixtures<br />
                                            for the season:</th>
                                        <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<asp:TextBox ID="NumberOfFixtures_TextBox" runat="server" BackColor="#FFFFCC" Height="14px" Width="16px"></asp:TextBox>
                                        </td>

                                    </tr>
                                    <tr style="text-align: center">
                                        <td colspan="2">
                                            <asp:Button ID="Recalc_Button" runat="server" Text="Recalculate" /></td>
                                    </tr>
                                    <tr>
                                        <td colspan="2"><span style="color:red"><asp:Literal ID="Err_Literal" runat="server"></asp:Literal></span></td>
                                    </tr>
                                </table>
                            </td>

                            <td>
                                <asp:GridView ID="FixtureDates_GridView" runat="server"
                                    EnableModelValidation="True" Font-Size="9pt" BackColor="White" BorderColor="Black"
                                    BorderStyle="Solid" BorderWidth="2px" CellPadding="3"
                                    EmptyDataText="No data found" HeaderStyle-HorizontalAlign="Left" AutoGenerateColumns="False">
                                    <Columns>
                                        <asp:BoundField DataField="WeekNo" HeaderText="Week No">
                                            <ItemStyle HorizontalAlign="Center" />
                                        </asp:BoundField>
                                        <asp:BoundField DataField="FixtureDate" HeaderText="Fixture Date" />
                                    </Columns>
                                    <HeaderStyle BackColor="#4A3C8C" Font-Bold="True" ForeColor="#F7F7F7" HorizontalAlign="Left" />
                                    <RowStyle Height="18px" BackColor="#E7E7FF" ForeColor="#000044" />
                                    <AlternatingRowStyle Height="18px" BackColor="#F7F7F7" />
                                    <SelectedRowStyle BackColor="#738A9C" Font-Bold="True" ForeColor="#F7F7F7" />
                                </asp:GridView>
                            </td>

                        </tr>
                    </table>

                </asp:Panel>

            </div>

        </ContentTemplate>
    </asp:UpdatePanel>

</asp:Content>


