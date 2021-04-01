<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/MasterPage.master" CodeBehind="TrophiesAndPrizes.aspx.vb" Inherits="HBSA_Web_Application.TrophiesAndPrizes" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

        <script type="text/javascript">

        //this script to detect the export, and load the generatefile page into a iFrame
        //so that ajax doesn't block the file download process
        var prm = Sys.WebForms.PageRequestManager.getInstance();
        prm.add_initializeRequest(InitializeRequest);
        function InitializeRequest(sender, args) {
            if (sender._postBackSettings.sourceElement.id.indexOf("Export_Button") != -1) {
                var iframe = document.createElement("iframe");
                iframe.src = "Admin/AdminDownload.aspx?source=TrophiesAndPrizes&fileName=TrophiesAndPrizes";
                iframe.style.display = "none";
                document.body.appendChild(iframe);
            }
        }
</script>

            <div style="text-align:center; width:auto; margin-left:auto; margin-right:auto;">
        <h3>Trophies and Prizes</h3>
        <asp:ScriptManager ID="ScriptManager1" runat="server">
        </asp:ScriptManager>
       <asp:UpdateProgress runat="server" id="Update_Progress" DisplayAfter="10">
            <ProgressTemplate>
                <div id="Loading" style="position: fixed; left:440px;top:260px">
                    <asp:Image ID="loadingImage" runat="server" ImageUrl="~/images/AjaxLoading.gif" Width="100px" />
                </div>
            </ProgressTemplate>
        </asp:UpdateProgress>

        
        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <ContentTemplate>
                <div style="text-align:left;">
                    <table style="width:auto; margin-left:auto; margin-right:auto;">
                        <tr>
                            <td>
                                <div style="border: 1px solid black;">
                                    <table style="text-align:left;width:auto; margin-left:auto; margin-right:auto;">
                                        <tr>
                                            <td style="text-align:right; padding:4px;" class="RowHeight">Select a report:</td>
                                            <td style="padding:4px;" class="RowHeight">
                                                <asp:DropDownList ID="Report_DropDownList" runat="server" BackColor="#FFFFCC" AutoPostBack="true" />
                                            </td>
                                        </tr>
                                        <tr id="ExportCells" runat="server" visible="false">
                                            <td style="padding:4px;"> Click this to download the report as a spreadsheet csv file. </td>
                                            <td style="text-align:left; vertical-align: super; padding:4px;">
                                                <asp:Button ID="Export_Button" runat="server" Text="Download" />
                                                &nbsp;&nbsp; </td>
                                        </tr>
                                    </table>
                                </div>
                            </td>
                        </tr>
                    </table>
                </div>
                <div style="width:100%; align-content:center">
                <asp:Literal ID="Status_Literal" runat="server" />
                </div>
                <table style="width:auto; margin-left:auto; margin-right:auto;">
                    <tr style="vertical-align:top">
                        <td>
                    <asp:GridView ID="Awards_GridView" runat="server"
                        EnableModelValidation="True" Font-Size="9pt" Width="100%" BackColor="White" BorderColor="black"
                        BorderStyle="Solid" BorderWidth="1px" CellPadding="3"
                        AllowSorting="True" EmptyDataText="<span style='color:red'>No data found</span>">
                        <HeaderStyle BackColor="white" Font-Bold="True" ForeColor="black" />
                        <RowStyle Height="18px" BackColor="white" ForeColor="black" />
                        <AlternatingRowStyle Height="18px" BackColor="#F7F7F7" />
                    </asp:GridView>
                        </td>
                    </tr>
                </table>

            </ContentTemplate>
        </asp:UpdatePanel>
    </div>

</asp:Content>
