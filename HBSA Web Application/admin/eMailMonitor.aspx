<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/admin/adminMasterPage.master" CodeBehind="EmailMonitor.aspx.vb" Inherits="HBSA_Web_Application.EmailMonitor" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="AjaxToolkit" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div style="text-align: left; width: 100%;">
        <h3>Email Monitor</h3>

        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>

        <div style="text-align: left; width: 100%">

            <asp:UpdatePanel ID="UpdatePanel1" runat="server">

                <ContentTemplate>

                    <asp:UpdateProgress runat="server" ID="Update_Progress" DisplayAfter="10">
                        <ProgressTemplate>
                            <div id="Loading" style="position: fixed; left: 35%; top: 200px">
                                <asp:Image ID="loadingImage" runat="server" ImageUrl="~/images/AjaxLoading.gif" Width="100px" />
                            </div>
                        </ProgressTemplate>
                    </asp:UpdateProgress>

                    <table style="border: 1px solid black">
                        <tr>
                            <td>Date from: </td>
                            <td>
                                <asp:TextBox ID="From_TextBox" runat="server" />
                                <asp:Image ID="From_Image" runat="server" ImageUrl="~/images/Icon-Calendar.png" />
                                <%--<asp:Calendar ID="From_Calendar" runat="server" Visible="false" BackColor="White" BorderColor="#000099" BorderStyle="Solid" BorderWidth="1px"></asp:Calendar>--%>
                                <ajaxToolkit:CalendarExtender ID="From_CalendarExtender" runat="server" TargetControlID="From_TextBox" PopupButtonID="From_Image" Format="dd MMM yyyy" TodaysDateFormat="d MMM yyyy"></ajaxToolkit:CalendarExtender>
                            </td>
                            <td>Time from: </td>
                            <td>
                                <asp:DropDownList ID="FromHour_DropDown" runat="server">
                                    <asp:ListItem Selected="True">00</asp:ListItem>
                                    <asp:ListItem>01</asp:ListItem>
                                    <asp:ListItem>02</asp:ListItem>
                                    <asp:ListItem>03</asp:ListItem>
                                    <asp:ListItem>04</asp:ListItem>
                                    <asp:ListItem>05</asp:ListItem>
                                    <asp:ListItem>06</asp:ListItem>
                                    <asp:ListItem>07</asp:ListItem>
                                    <asp:ListItem>08</asp:ListItem>
                                    <asp:ListItem>09</asp:ListItem>
                                    <asp:ListItem>10</asp:ListItem>
                                    <asp:ListItem>11</asp:ListItem>
                                    <asp:ListItem>12</asp:ListItem>
                                    <asp:ListItem>13</asp:ListItem>
                                    <asp:ListItem>14</asp:ListItem>
                                    <asp:ListItem>15</asp:ListItem>
                                    <asp:ListItem>16</asp:ListItem>
                                    <asp:ListItem>17</asp:ListItem>
                                    <asp:ListItem>18</asp:ListItem>
                                    <asp:ListItem>19</asp:ListItem>
                                    <asp:ListItem>20</asp:ListItem>
                                    <asp:ListItem>21</asp:ListItem>
                                    <asp:ListItem>22</asp:ListItem>
                                    <asp:ListItem>23</asp:ListItem>
                                </asp:DropDownList>
                                <asp:DropDownList ID="FromMinute_DropDown" runat="server">
                                    <asp:ListItem Selected="True">00</asp:ListItem>
                                    <asp:ListItem>05</asp:ListItem>
                                    <asp:ListItem>10</asp:ListItem>
                                    <asp:ListItem>15</asp:ListItem>
                                    <asp:ListItem>20</asp:ListItem>
                                    <asp:ListItem>25</asp:ListItem>
                                    <asp:ListItem>30</asp:ListItem>
                                    <asp:ListItem>35</asp:ListItem>
                                    <asp:ListItem>40</asp:ListItem>
                                    <asp:ListItem>45</asp:ListItem>
                                    <asp:ListItem>50</asp:ListItem>
                                    <asp:ListItem>55</asp:ListItem>
                                </asp:DropDownList>
                            </td>
                        </tr>
                        <tr>
                            <td>Date To: </td>
                            <td>
                                <asp:TextBox ID="To_TextBox" runat="server" />
                                <asp:Image ID="To_Image" runat="server" ImageUrl="~/images/Icon-Calendar.png" />
                                <ajaxToolkit:CalendarExtender ID="To_CalendarExtender" runat="server" TargetControlID="To_TextBox"
                                    PopupButtonID="To_Image" Format="dd MMM yyyy" TodaysDateFormat="d MMM yyyy"></ajaxToolkit:CalendarExtender>
                            </td>
                            <td>Time To: </td>
                            <td>
                                <asp:DropDownList ID="ToHour_DropDown" runat="server">
                                    <asp:ListItem Selected="True">00</asp:ListItem>
                                    <asp:ListItem>01</asp:ListItem>
                                    <asp:ListItem>02</asp:ListItem>
                                    <asp:ListItem>03</asp:ListItem>
                                    <asp:ListItem>04</asp:ListItem>
                                    <asp:ListItem>05</asp:ListItem>
                                    <asp:ListItem>06</asp:ListItem>
                                    <asp:ListItem>07</asp:ListItem>
                                    <asp:ListItem>08</asp:ListItem>
                                    <asp:ListItem>09</asp:ListItem>
                                    <asp:ListItem>10</asp:ListItem>
                                    <asp:ListItem>11</asp:ListItem>
                                    <asp:ListItem>12</asp:ListItem>
                                    <asp:ListItem>13</asp:ListItem>
                                    <asp:ListItem>14</asp:ListItem>
                                    <asp:ListItem>15</asp:ListItem>
                                    <asp:ListItem>16</asp:ListItem>
                                    <asp:ListItem>17</asp:ListItem>
                                    <asp:ListItem>18</asp:ListItem>
                                    <asp:ListItem>19</asp:ListItem>
                                    <asp:ListItem>20</asp:ListItem>
                                    <asp:ListItem>21</asp:ListItem>
                                    <asp:ListItem>22</asp:ListItem>
                                    <asp:ListItem>23</asp:ListItem>
                                </asp:DropDownList>
                                <asp:DropDownList ID="ToMinute_DropDown" runat="server">
                                    <asp:ListItem Selected="True">00</asp:ListItem>
                                    <asp:ListItem>05</asp:ListItem>
                                    <asp:ListItem>10</asp:ListItem>
                                    <asp:ListItem>15</asp:ListItem>
                                    <asp:ListItem>20</asp:ListItem>
                                    <asp:ListItem>25</asp:ListItem>
                                    <asp:ListItem>30</asp:ListItem>
                                    <asp:ListItem>35</asp:ListItem>
                                    <asp:ListItem>40</asp:ListItem>
                                    <asp:ListItem>45</asp:ListItem>
                                    <asp:ListItem>50</asp:ListItem>
                                    <asp:ListItem>55</asp:ListItem>
                                </asp:DropDownList>
                            </td>
                        </tr>
                    </table>

                    <table>
                        <tr>
                            <td>Subject contains:
                                <asp:TextBox ID="SubjectFilter_TextBox" runat="server" /><i>&nbsp;&nbsp;&nbsp;&nbsp;(Press enter, tab, or click the mouse outside this box to activate)</i></td>
                        </tr>
                        <tr>
                            <td style="text-align: center">
                                <asp:Button ID="GetEmails_Button" runat="server" Text="Get Email List" /></td>
                        </tr>
                    </table>

                    <asp:Literal ID="Status_Literal" runat="server"></asp:Literal>

                    <asp:GridView ID="Emails_GridView" runat="server"
                        EnableModelValidation="True" Font-Size="9pt" Width="100%" BackColor="White" BorderColor="#E7E7FF"
                        BorderStyle="None" BorderWidth="1px" CellPadding="3"
                        EmptyDataText="No data found">
                        <Columns>
                            <asp:CommandField CausesValidation="False" InsertVisible="False" ShowCancelButton="False" ShowEditButton="True" EditText="Send" SelectText="Show" ShowSelectButton="True" />
                        </Columns>
                        <HeaderStyle BackColor="#4A3C8C" Font-Bold="True" ForeColor="#F7F7F7" />
                        <RowStyle Height="18px" BackColor="#E7E7FF" ForeColor="#000044" VerticalAlign="Top" />
                        <AlternatingRowStyle Height="18px" BackColor="#F7F7F7" VerticalAlign="Top" />
                    </asp:GridView>

                    <asp:Panel ID="Email_Panel" runat="server" Visible="false">
                        <div id="Email_Div" style="position: fixed; top: 100px; left: 60px; width: 85%; background-color: #CCFFFF; border-style: solid; border-width: 1px; padding: 4px; table-layout: fixed; border-spacing: 2px;">
                            <table style="text-align: center">
                                <tr>
                                    <td>
                                        <asp:Button ID="Send_Button" runat="server" Text="Send this Email" /></td>
                                    <td></td>
                                    <td>
                                        <asp:Button ID="Close_Button" runat="server" Text="Close this window" /></td>
                                </tr>
                            </table>

                            <table>
                                <tr>
                                    <td style="text-align: right">To:</td>
                                    <td><asp:Literal ID="To_Literal" runat="server"></asp:Literal></td>
                                </tr>
                                <tr>
                                    <td style="text-align: right">From:</td>
                                    <td><asp:Literal ID="From_Literal" runat="server"></asp:Literal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Reply To: 
			<asp:Literal ID="Reply_To_Literal" runat="server"></asp:Literal></td>
                                </tr>
                                <tr>
                                    <td style="text-align: right">CC:</td>
                                    <td><asp:Literal ID="CC_Literal" runat="server"></asp:Literal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;BCC:
	                                      <asp:Literal ID="BCC_Literal" runat="server"></asp:Literal></td>
                                </tr>
                                <tr>
                                    <td style="text-align: right">Subject:</td>
                                    <td><asp:Literal ID="Subject_Literal" runat="server"></asp:Literal></td>
                                </tr>
                                <tr>
                                    <td style="text-align: right">Sent:</td>
                                    <td><asp:Literal ID="Sent_Literal" runat="server"></asp:Literal></td>
                                </tr>
                                <tr>
                                    <td style="text-align: right; vertical-align: top;">Body:</td>
                                    <td><asp:Literal ID="Body_Literal" runat="server"></asp:Literal></td>
                                </tr>
                            </table>
                        </div>

                    </asp:Panel>

                </ContentTemplate>

            </asp:UpdatePanel>

        </div>
    </div>
</asp:Content>
