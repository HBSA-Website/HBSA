<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/MasterPage.master" CodeBehind="Fines.aspx.vb" Inherits="HBSA_Web_Application.Fines1" %>
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
                iframe.src = "AdminDownload.aspx?source=FinesSummary&fileName=FinesSummary";
                iframe.style.display = "none";
                document.body.appendChild(iframe);
            }
        }
    </script>


    <div style="width:100%; font-family: Verdana; color:Green; text-align:center; background-color:#ccffcc;">
        <h3>Fines</h3>
        
<%--         <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        
         <asp:UpdateProgress runat="server" id="Update_Progress" DisplayAfter="10">
            <ProgressTemplate>
                <div id="Loading" style="position: fixed; left:440px;top:260px">
                    <asp:Image ID="loadingImage" runat="server" ImageUrl="~/images/AjaxLoading.gif" Width="100px" />
                </div>
            </ProgressTemplate>
        </asp:UpdateProgress>

       <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <ContentTemplate>--%>

            <div>
              
                <table style="width:100%;">
                      <tr>
                        <td style="text-align:center;">
                            <div>
                                <table style="text-align:center">
                                    <tr>
                                        <td style="padding:4px;">
                                            <asp:CheckBox ID="Owing_CheckBox" runat="server" Text="Only show fines not fully paid:" TextAlign="Left" Checked="True" AutoPostBack="true" />
                                        </td>
                                        <td></td>
                                        <td style="padding:4px;">
                                            <asp:Button ID="Export_Button" runat="server" Text="Download" Visible="false" />
                                        </td>
                                        <td></td>
                                    </tr>
                            </table>
                        </div>
                        </td>
                            </tr>
                    <tr>
                        <td style="text-align:center;">
                            <asp:GridView ID="Fines_GridView" runat="server" Font-Size="9pt" BackColor="White" BorderColor="Black" 
                                      BorderStyle="Solid" BorderWidth="1px" CellPadding="3"
                                      AllowSorting="True" EmptyDataText="No fines recorded">
                            <Columns>
                                <asp:CommandField SelectText="Details" ShowSelectButton="True" />
                                <asp:CommandField EditText="Pay Now" ShowEditButton="True" Visible="false" />
                            </Columns>
                            <HeaderStyle BackColor="Green" Font-Bold="True" ForeColor="White" />
                            <RowStyle Height="18px" BackColor="#E7E7FF" ForeColor="#000044" />
                            <AlternatingRowStyle Height="18px" BackColor="#F7F7F7" />
            </asp:GridView>

                        </td>
                    </tr>
                        </table>
 
       </div>

       <asp:Panel ID="Payments_Panel" runat="server" Visible="false">
            <div id="divPayments" style="border: 1px solid #000080; font-family: Arial, Helvetica, sans-serif; font-size: 8Pt; display:block; vertical-align: top; 
                                   text-align: left; position: fixed; background-color: #ccffcc; top:320px; left:450px;">
                <table style="width: 100%; height: 100%">
                    <tr>
                        <td onmousedown="dragStart(event, 'divPayments')" 
                            onmouseover="this.style.cursor='pointer';" 
                            style="height: 8px; border-right: #000080 1px solid; border-top: #000080 1px solid; border-left: #000080 1px solid; border-bottom: #000080 1px solid; background-image: url('../images/menuBarBG.gif');">
                            <strong>
                                <asp:Literal ID="PaymentsPanel_Literal" runat="server" Text="Payment&nbsp;Details&nbsp;"></asp:Literal></strong></td>
                    </tr>
                </table>
                <table>
                    <tr>
                        <td>
                            <asp:GridView ID="Payments_GridView" runat="server" Font-Size="9pt" BackColor="White" BorderColor="Black" 
                                      BorderStyle="Solid" BorderWidth="1px" CellPadding="3"
                                      AllowSorting="True" EmptyDataText="No payments recorded">
                                <HeaderStyle BackColor="green" Font-Bold="True" ForeColor="white" />
                                <RowStyle Height="18px" BackColor="#E7E7FF" ForeColor="#000044" />
                                <AlternatingRowStyle Height="18px" BackColor="#F7F7F7" />
                            </asp:GridView>

                        </td>
                    </tr>
                    <tr>
                        <td>
                            <%--<asp:Button ID="PayNow_Button" runat="server" Text="Pay Now" />--%>
                            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                            <asp:Button ID="PaymentsClose_Button" runat="server" Text="Close" />
                        </td>
                    </tr>
                </table>
  
    </div>
        </asp:Panel>

<%--       <asp:Panel ID="AddPayment_Panel" runat="server" Visible="false">
            <div id="divAddPayment" style="display:none; 
                                            border: 1px solid #000080; font-family: Arial, Helvetica, sans-serif; font-size: 8Pt; vertical-align: top; 
                                            text-align: left; position: fixed; background-color: #ccffcc; top:420px; left:350px;">
                <table style="width: 100%; height: 100%">
                    <tr>
                        <td onmousedown="dragStart(event, 'divAddPayment')" 
                            onmouseover="this.style.cursor='pointer';" 
                            style="height: 8px; border-right: #000080 1px solid; border-top: #000080 1px solid; border-left: #000080 1px solid; border-bottom: #000080 1px solid; background-image: url('../images/menuBarBG.gif');">
                            <strong>
                                Pay&nbsp;the&nbsp;fine</strong></td>
                    </tr>
                </table>
                <table>
                    <tr>
                        <td class="auto-style2">
			                <table>
                                <tr>
                                    <th align="center">Offence</th>
                                    <th align="center">Comment</th>
                                    <th align="center">Fine</th>
                                    <th align="center">Amount to Pay</th>
                                    <th align="center">Note</th>
                                </tr>
                                <tr>
                                    <td><asp:Literal ID="Offence_Literal" runat="server"></asp:Literal></td>
                                    <td><asp:Literal ID="Comment_Literal" runat="server"></asp:Literal></td>
                                    <td>&pound<asp:Literal ID="Fine_Literal" runat="server"></asp:Literal></td>
                                    <td>&pound;<asp:TextBox ID="AmountToPay_TextBox" runat="server" MaxLength="10" style="text-align: left" Width="50px">0.00</asp:TextBox></td>
                                    <td><asp:TextBox ID="Note_TextBox" runat="server" MaxLength="255"></asp:TextBox></td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:ImageButton ID="PayPal_Button0" runat="server" ImageUrl="https://www.paypalobjects.com/en_GB/i/btn/btn_paynowCC_LG.gif" Visible="False" />
                            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                            <asp:Button ID="AddPaymentClose_Button" runat="server" Text="Cancel" />
                            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                            <span style="font-size: 10pt; vertical-align: top; color: #FF0000;"><asp:Literal ID="Status_Literal" runat="server"></asp:Literal></span>
                        </td>
                    </tr>
                </table>
  
    </div>
        </asp:Panel>--%>

<%--      </ContentTemplate>
  </asp:UpdatePanel>--%>

        </div>

</asp:Content>
