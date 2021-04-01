<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/admin/adminMasterPage.master" CodeBehind="LastSixMatches.aspx.vb" Inherits="HBSA_Web_Application.LastSixMatches" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div style="text-align:left; width:100%">
        <h3>Last six matches Report</h3>
        This reports shows the points gained in the most recent 6 matches.<br />
        The report is either for a full league, or for a section within a league.
        <asp:ScriptManager ID="ScriptManager1" runat="server">
        </asp:ScriptManager>
        
    <script type="text/javascript">

        //this script to detect the export, and load the generatefile page into a iFrame
        //so that ajax doesn't block the file download process
        var prm = Sys.WebForms.PageRequestManager.getInstance();
        prm.add_initializeRequest(InitializeRequest);
        function InitializeRequest(sender, args) {
            if (sender._postBackSettings.sourceElement.id.indexOf("Export_Button") != -1) {
                var iframe = document.createElement("iframe");
                iframe.src = "AdminDownload.aspx?source=Last6Matches&fileName=Last6Matches";
                iframe.style.display = "none";
                document.body.appendChild(iframe);
            }
        }
    </script>

        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <ContentTemplate>
                <div style="text-align:left; width:100%">
                    <table>
                        <tr>
                            <td>
                                <div style="border: 1px solid #0000FF; color: #0000FF; background-color: #99CCFF">
                                    <table style="text-align:left" >
                                        <tr>
                                            <td style="text-align:right">Select a league:</td>
                                            <td>
                                                <asp:DropDownList ID="League_DropDownList" runat="server" BackColor="#FFFFCC" AutoPostBack="True" >
                                                    <asp:ListItem Value="0" Text="ALL" Selected="True" />
                                                </asp:DropDownList>
                                            </td>
                                            <td  id="Download_Cell" runat="server" visible="false" style="text-align:left; vertical-align: super;">
                                                <asp:Button ID="Export_Button" runat="server" Text="Download" Width="118px" />
                                                &nbsp;&nbsp; Click this to download the report as a spreadsheet csv file.</td>
                                        </tr>
                                        <tr>
                                            <td style="text-align:right">Select a division/section: </td>
                                            <td>
                                                <asp:DropDownList ID="Section_DropDownList" runat="server" BackColor="#FFFFCC" AutoPostBack="True" Visible="false">
                                                    <asp:ListItem Value="0" Text="ALL" Selected="True" />
                                                </asp:DropDownList>
                                                
                                            </td>
                                            <td id="Report_Button_Cell" runat="server" visible="false" style="text-align:left; vertical-align: super;">
                                                <asp:Button ID="Report_Button" runat="server" Width="118px" Text="Get the report" />
                                                &nbsp;&nbsp; Click this to get the selected report.
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                        </tr>
                    </table>
                </div>
                <br />
                <table>
                    <tr style="vertical-align:top;">
                        <td>
                            <asp:GridView ID="Last6Matches_GridView" runat="server"  
                                        EnableModelValidation="True" Font-Size="9pt" BackColor="White" BorderColor="Black" 
                                        BorderStyle="Solid" BorderWidth="1px" CellPadding="3"
                                        AllowSorting="false" EmptyDataText="No data found">
                                <HeaderStyle BackColor="#4A3C8C" Font-Bold="True" ForeColor="#F7F7F7" />
                                <RowStyle Height="18px" BackColor="#E7E7FF" ForeColor="#000044" />
                                <AlternatingRowStyle Height="18px" BackColor="#F7F7F7" />
                                <SelectedRowStyle BackColor="#738A9C" Font-Bold="True" ForeColor="#F7F7F7" />
                            </asp:GridView>
                        </td>
                    </tr>
                </table>
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>
</asp:Content>
