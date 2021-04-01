<%@ Page Title="HBSA Competitions Entrants Report" Language="vb" AutoEventWireup="false" MasterPageFile="~/admin/adminMasterPage.master" CodeBehind="CompetitionEntrantsReport.aspx.vb" Inherits="HBSA_Web_Application.CompetitionEntrantsReport" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

        <div style="text-align:left; width:100%">
        <h3>Entry Forms - Entrants reports by competition</h3>
        
         <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        
    <script type="text/javascript">

        //this script to detect the export, and load the generatefile page into a iFrame
        //so that ajax doesn't block the file download process
        var prm = Sys.WebForms.PageRequestManager.getInstance();
        prm.add_initializeRequest(InitializeRequest);
        function InitializeRequest(sender, args) {
            if (sender._postBackSettings.sourceElement.id.indexOf("Export_Button") != -1) {
                var iframe = document.createElement("iframe");
                iframe.src = "AdminDownload.aspx?source=CompEntrantsReport&fileName=CompEntrantsReport";
                iframe.style.display = "none";
                document.body.appendChild(iframe);
            }
        }
    </script>

         <asp:UpdateProgress runat="server" id="Update_Progress" DisplayAfter="10">
            <ProgressTemplate>
                <div id="Loading" style="position: fixed; left:440px;top:260px">
                    <asp:Image ID="loadingImage" runat="server" ImageUrl="~/images/AjaxLoading.gif" Width="100px" />
                </div>
            </ProgressTemplate>
        </asp:UpdateProgress>

       <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <ContentTemplate>

       <div style="text-align:left; width:100%">
            
                <table>
                      <tr>
                        <td>
                            <div style="border: 1px solid #0000FF; color: #0000FF; background-color: #99CCFF">
                                <table style="text-align:left" >
                                    <tr>
                                    <td style="text-align:right">Select a Competition: </td>
                                    <td>
                                        <asp:DropDownList ID="Competitions_DropDownList" runat="server" BackColor="#FFFFCC" AutoPostBack="True" />
                                    </td>
                                    <td style="text-align:right">
                                        <asp:Button ID="Export_Button" runat="server" Text="Download" Visible="false" />
                                    </td>
                                    </tr>
                            </table>
                        </div>

                            </tr>
                        </table>
              
            <asp:GridView ID="Entrants_GridView" runat="server" Font-Size="9pt" BackColor="White" BorderColor="Black" 
                                      BorderStyle="Solid" BorderWidth="1px" CellPadding="3"
                                      AllowSorting="True" EmptyDataText="No entrants forms in this competition">
                <HeaderStyle BackColor="#4A3C8C" Font-Bold="True" ForeColor="#F7F7F7" />
                <RowStyle Height="18px" BackColor="#E7E7FF" ForeColor="#000044" />
                <AlternatingRowStyle Height="18px" BackColor="#F7F7F7" />
            </asp:GridView>
       </div>

      </ContentTemplate>
  </asp:UpdatePanel>

        </div>


</asp:Content>

