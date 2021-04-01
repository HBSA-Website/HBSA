<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/admin/adminMasterPage.master" CodeBehind="TaggedPlayers.aspx.vb" Inherits="HBSA_Web_Application.TaggedPlayers" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div style="text-align:left; width:100%">
        <h3>Tagged Players Report</h3>


        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        
    <script type="text/javascript">

        //this script to detect the export, and load the generatefile page into a iFrame
        //so that ajax doesn't block the file download process
        var prm = Sys.WebForms.PageRequestManager.getInstance();
        prm.add_initializeRequest(InitializeRequest);
        function InitializeRequest(sender, args) {
            if (sender._postBackSettings.sourceElement.id.indexOf("Export_Button") != -1) {
                var iframe = document.createElement("iframe");
                iframe.src = "AdminDownload.aspx?source=TaggedPlayers&fileName=TaggedPlayers";
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
                                        <td style="text-align:right">Select a division/section or league:</td>
                                        <td>
                                            <asp:DropDownList ID="Section_DropDownList" runat="server" BackColor="#FFFFCC" AutoPostBack="True" >
                                            <asp:ListItem Value="0" Text="ALL" Selected="True" /></asp:DropDownList>
                                        </td>
                                        <td style="text-align:right">
                                            <asp:Button ID="Export_Button" runat="server" Text="Download" Visible="false" />
                                        </td>
                                    </tr>
                                <tr>
                                    <td style="text-align:right">Select a club: </td>
                                    <td>
                                        <asp:DropDownList ID="Club_DropDownList" runat="server" BackColor="#FFFFCC" AutoPostBack="True" >
                                        <asp:ListItem Value="0" Text="ALL" Selected="True" /></asp:DropDownList>
                                    </td>
                                    <td>
                                            <table style="text-align:left">
                                                <tr>
                                                    <td style="text-align:right">
                                                        <asp:CheckBox ID="ActionNeeded_CheckBox" runat="server" Text="Action Needed Only" TextAlign="Left" /></td>
                                                    <td><asp:Button ID="GetReport_Button" runat="server" Text="GO" /></td>
                                                </tr>
                                            </table>
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
                               <asp:GridView ID="TaggedPlayers_GridView" runat="server"  
                                        EnableModelValidation="True" Font-Size="9pt" BackColor="White" BorderColor="Black" 
                                        BorderStyle="Solid" BorderWidth="1px" CellPadding="3"
                                        AllowSorting="True" EmptyDataText="No data found">
                                    <HeaderStyle BackColor="#4A3C8C" Font-Bold="True" ForeColor="#F7F7F7" />
                                    <RowStyle Height="18px" BackColor="#E7E7FF" ForeColor="#000044" />
                                    <AlternatingRowStyle Height="18px" BackColor="#F7F7F7" />
                                    <SelectedRowStyle BackColor="#738A9C" Font-Bold="True" ForeColor="#F7F7F7" />
                              </asp:GridView>
                           </td>
                        <td></td>
                           <td>
                               <asp:Panel ID="ApplyChanges_Panel" runat="server" Visible="false">
                                   <asp:Button ID="Apply_Button" runat="server" Text="Apply Handicap Changes" /><br />
                                   <asp:Literal ID="Apply_Literal" runat="server"></asp:Literal><br />
                                   Clicking this button will apply all the<br />
                                   shown handicap changes immediately<br />
                                   (ActionNeeded is Raise or Reduce)<br />
                                   and send emails to all clubs, <br />
                                   teams and players where possible. 
                               </asp:Panel>
                           </td>

                       </tr>
                </table>    
                

            </ContentTemplate>
        </asp:UpdatePanel>

    </div>

</asp:Content>
