<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/admin/adminMasterPage.master" CodeBehind="ActivityLog.aspx.vb" Inherits="HBSA_Web_Application.ActivityLog" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <h3>Activity Log</h3>
       
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>

        <div style="text-align:left; width:100%">

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
                            <td>Date from: </td>
                            <td>
                                <asp:TextBox ID="From_TextBox" runat="server"  />
                                <asp:Image ID="From_Image" runat="server" ImageUrl="~/images/Icon-Calendar.png" />
                                <ajaxToolkit:CalendarExtender ID="From_CalendarExtender" runat="server" TargetControlID="From_TextBox" PopupButtonID="From_Image" Format="dd MMM yyyy" TodaysDateFormat="d MMM yyyy"></ajaxToolkit:CalendarExtender>
                            </td>
                            <td>Time from: </td>
                            <td>
                                <asp:DropDownList ID="FromHour_DropDown" runat="server" >
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
                                <ajaxToolkit:CalendarExtender ID="To_CalendarExtender" runat="server" TargetControlID="To_TextBox" PopupButtonID="To_Image" Format="dd MMM yyyy" TodaysDateFormat="d MMM yyyy"></ajaxToolkit:CalendarExtender>
                            </td>
                            <td>Time To: </td>
                            <td>
                                <asp:DropDownList ID="ToHour_DropDown" runat="server" >
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
                                <asp:DropDownList ID="ToMinute_DropDown" runat="server" >
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
                            <td>Activity contains: </td><td><asp:TextBox ID="Activity_TextBox" runat="server"></asp:TextBox></td>
                            <td>Action is </td><td><asp:DropDownList ID="Action_DropDownList" runat="server"></asp:DropDownList></td>
                            <td>What contains: </td><td style="border: 1px solid #000000"><asp:TextBox ID="What_TextBox" runat="server"></asp:TextBox></td>
                        </tr>
                        <tr>
                            <td></td>
                            <td style="text-align:center"><asp:Button ID="GetActivityLog_Button" runat="server" Text="Get Activity Log" /></td>
                        </tr>
                    </table>
                    
                    <asp:Literal ID="Status_Literal" runat="server"></asp:Literal>
                    
                    <asp:GridView ID="Activity_GridView" runat="server"  
                        EnableModelValidation="True" Font-Size="9pt" BackColor="White" BorderColor="#E7E7FF" 
                        BorderStyle="None" BorderWidth="1px" CellPadding="3"
                        EmptyDataText="No data found for the requested time span">
                        <HeaderStyle BackColor="#4A3C8C" Font-Bold="True" ForeColor="#F7F7F7" />
                        <RowStyle Height="18px" BackColor="#E7E7FF" ForeColor="#000044" />
                        <AlternatingRowStyle Height="18px" BackColor="#F7F7F7" />
                    </asp:GridView>


            </ContentTemplate>
        </asp:UpdatePanel>
    </div>
</asp:Content>
