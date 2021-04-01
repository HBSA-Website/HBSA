<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/admin/adminMasterPage.master" CodeBehind="EntryFormClubsSummary.aspx.vb" Inherits="HBSA_Web_Application.EntryFormClubsSummary" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div style="text-align:left; width:100%">
        <h3>Entry Forms Clubs Summary Report</h3>
        
         <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>                                       
        
    <script type="text/javascript">

        //this script to detect the export, and load the generatefile page into a iFrame
        //so that ajax doesn't block the file download process
        var prm = Sys.WebForms.PageRequestManager.getInstance();
        prm.add_initializeRequest(InitializeRequest);
        function InitializeRequest(sender, args) {
            if (sender._postBackSettings.sourceElement.id.indexOf("Export_Button") != -1) {
                var iframe = document.createElement("iframe");
                iframe.src = "AdminDownload.aspx?source=EntryFormsSummary&fileName=EntryFormsSummary";
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
                                    <td style="text-align:right">Select a state: </td>
                                    <td>
                                        <asp:DropDownList ID="State_DropDownList" runat="server" BackColor="#FFFFCC" AutoPostBack="True" >
                                            <asp:ListItem Value="0">All possible entry forms</asp:ListItem>
                                            <asp:ListItem Value="1" Selected="True">Clubs who have at least started entering data</asp:ListItem>
                                            <asp:ListItem Value="2">Clubs that have submitted their entry form</asp:ListItem>
                                            <asp:ListItem Value="-5">Clubs that have started, but not submitted, their entry form</asp:ListItem>
                                            <asp:ListItem Value="3">Entry forms that are fixed</asp:ListItem>
                                            <asp:ListItem Value="-1">Clubs that have not completed Entry forms</asp:ListItem>
                                            <asp:ListItem Value="-2">All Clubs with State and Contact List</asp:ListItem>
                                            <asp:ListItem Value="-3">Full Contact List for each State</asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                        <td style="text-align:right">
                                            <asp:Button ID="Export_Button" runat="server" Text="Download" Visible="false" />
                                        </td>
                                    </tr>
                            </table>
                        </div>

                            </tr>
                        </table>
              
        <asp:GridView ID="EntryFormsClubs_GridView" runat="server" Font-Size="9pt" BackColor="White" BorderColor="Black" 
                                      BorderStyle="Solid" BorderWidth="1px" CellPadding="3"
                                      AllowSorting="True" EmptyDataText="No entry forms in this category">
                            <Columns>
                                <asp:CommandField SelectText="Details" ShowSelectButton="True" />
                                <asp:CommandField EditText="Add payment" ShowEditButton="True" />
                            </Columns>
                            <HeaderStyle BackColor="#4A3C8C" Font-Bold="True" ForeColor="#F7F7F7" />
                            <RowStyle Height="18px" BackColor="#E7E7FF" ForeColor="#000044" />
                            <AlternatingRowStyle Height="18px" BackColor="#F7F7F7" />
                            <%--<SelectedRowStyle BackColor="#738A9C" Font-Bold="True" ForeColor="#F7F7F7" />--%>
                        </asp:GridView>
       </div>

      <asp:Panel ID="Payments_Panel" runat="server" Visible="false">
            <div id="divPayments" style="border: 1px solid #000080; font-family: Arial, Helvetica, sans-serif; font-size: 8Pt; display:block; vertical-align: top; 
                                   text-align: left; position: fixed; background-color: #99CCFF; top:220px; left:50px;">
                <table style="width: 100%; height: 100%">
                    <tr>
                        <td onmousedown="dragStart(event, 'divPayments')" 
                            onmouseover="this.style.cursor='pointer';" 
                            style="height: 8px; border-right: #000080 1px solid; border-top: #000080 1px solid; border-left: #000080 1px solid; border-bottom: #000080 1px solid; background-image: url('../images/menuBarBG.gif');">
                            <strong>
                                <asp:Literal ID="PaymentsPanel_Literal" runat="server" Text="Payment&nbsp;Details&nbsp;for&nbsp;"></asp:Literal></strong></td>
                    </tr>
                </table>
                <table>
                    <tr>
                        <td>
                            <asp:GridView ID="Payments_GridView" runat="server" Font-Size="9pt" BackColor="White" BorderColor="Black" 
                                      BorderStyle="Solid" BorderWidth="1px" CellPadding="3"
                                      AllowSorting="True" EmptyDataText="No payments made">
                                <HeaderStyle BackColor="#4A3C8C" Font-Bold="True" ForeColor="#F7F7F7" />
                                <RowStyle Height="18px" BackColor="#E7E7FF" ForeColor="#000044" />
                                <AlternatingRowStyle Height="18px" BackColor="#F7F7F7" />
                            </asp:GridView>

                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:Button ID="AddPayment_Button" runat="server" Text="Add a payment" />
                            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                            <asp:Button ID="PaymentsClose_Button" runat="server" Text="Close" />
                        </td>
                    </tr>
                </table>
  
    </div>
        </asp:Panel>

      <asp:Panel ID="AddPayment_Panel" runat="server" Visible="false">
            <div id="divAddPayment" style="border: 1px solid #000080; font-family: Arial, Helvetica, sans-serif; font-size: 8Pt; display:block; vertical-align: top; 
                                   text-align: left; position: fixed; background-color: #99CCFF; top:220px; left:50px;">
                <table style="width: 100%; height: 100%">
                    <tr>
                        <td onmousedown="dragStart(event, 'divAddPayment')" 
                            onmouseover="this.style.cursor='pointer';" 
                            style="height: 8px; border-right: #000080 1px solid; border-top: #000080 1px solid; border-left: #000080 1px solid; border-bottom: #000080 1px solid; background-image: url('../images/menuBarBG.gif');">
                            <strong>
                                <asp:Literal ID="AddPayment_Literal" runat="server" Text="Add&nbsp;a&nbsp;payment&nbsp;for&nbsp;"></asp:Literal></strong></td>
                    </tr>
                </table>
                <table>
                    <tr>
                        <td>
			                <table>
                                <tr>
                                    <th style="text-align:center;">Date Time Paid</th>
                                    <th style="text-align:center;">Payment Method</th>
                                    <th style="text-align:center;">Payment Reason</th>
                                    <th style="text-align:center;">Amount Paid</th>
                                    <th style="text-align:center;">Payment Fee</th>
                                    <th style="text-align:center;">Note</th>
                                    <th style="text-align:center;">Transaction ID</th>
                                    <th style="text-align:center;">Paid By</th>
                                </tr>
                                <tr>
                                    <td><asp:TextBox ID="DateTime__TextBox" runat="server" Width="120px"></asp:TextBox></td>
                                    <td><asp:DropDownList ID="PaymentMethod_DropDownList" runat="server">
                                        <asp:ListItem Selected="True">** Select **</asp:ListItem>
                                        <asp:ListItem>PayPal</asp:ListItem>
                                        <asp:ListItem>Cash</asp:ListItem>
                                        <asp:ListItem>Cheque</asp:ListItem>
                                        <asp:ListItem>Internet Banking</asp:ListItem>
                                        <asp:ListItem>Debit Card</asp:ListItem>
                                        <asp:ListItem>Credit Card</asp:ListItem>
                                        <asp:ListItem>BACS</asp:ListItem>
                                        <asp:ListItem>Other</asp:ListItem>
                                        </asp:DropDownList></td>
                                    <td><asp:DropDownList ID="PaymentReason_DropDownList" runat="server" Enabled="false">
                                        <asp:ListItem>Competition Entry Fee</asp:ListItem>
                                        <asp:ListItem Selected="True">League Entry Fee</asp:ListItem>
                                        <asp:ListItem>Fine</asp:ListItem>
                                        <asp:ListItem>Other</asp:ListItem>
                                        </asp:DropDownList></td>
                                    <td>&pound;<asp:TextBox ID="AmountPaid_TextBox" runat="server" MaxLength="10" style="text-align: left" Width="50px">0.00</asp:TextBox></td>
                                    <td>&pound;<asp:TextBox ID="PaymentFee_TextBox" runat="server" MaxLength="10" style="text-align: left" Width="50px">0.00</asp:TextBox></td>
                                    <td><asp:TextBox ID="Note_TextBox" runat="server" MaxLength="255"></asp:TextBox></td>
                                    <td><asp:TextBox ID="TransactionID_TextBox" runat="server" MaxLength="32" Width="120px"></asp:TextBox></td>
                                    <td><asp:TextBox ID="PaidBy_TextBox" runat="server" MaxLength="1000"></asp:TextBox></td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:Button ID="AddThisPayment_Button" runat="server" Text="Add this payment" />
                            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                            <asp:Button ID="AddPaymentClose_Button" runat="server" Text="Cancel" />
                            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                            <span style="font-size: 10pt; vertical-align: top; color: #FF0000;"><asp:Literal ID="Status_Literal" runat="server"></asp:Literal></span>
                        </td>
                    </tr>
                </table>
  
    </div>
        </asp:Panel>

      </ContentTemplate>
  </asp:UpdatePanel>

        </div>

</asp:Content>
