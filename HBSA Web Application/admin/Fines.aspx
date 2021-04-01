<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/admin/adminMasterPage.master" CodeBehind="Fines.aspx.vb" Inherits="HBSA_Web_Application.Fines" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="AjaxToolkit" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .auto-style3 {
            height: 19px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <script type="text/javascript">

        //this script to detect the export, and load the generatefile page into an iFrame
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

    <div style="text-align:left; width:100%">
        <h3>Fines</h3>
        
         <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        
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
                                        <td>
                                            Select a club:
                                        </td>
                                        <td colspan="3">
                                            <asp:DropDownList ID="Clubs_DropDownList" runat="server" AutoPostBack="true"></asp:DropDownList>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:CheckBox ID="Owing_CheckBox" runat="server" Text="Only show fines not paid:" TextAlign="Left" Checked="True" AutoPostBack="true" />
                                        </td>
                                        <td></td>
                                        <td>
                                            <asp:Button ID="Export_Button" runat="server" Text="Download" Visible="false" />
                                        </td>
                                        <td></td>
                                        <td>
                                            <asp:Button ID="Fine_Button" runat="server" Text="Impose a Fine" Visible="true" />
                                        </td>
                                        <td></td>
                                        <td>
                                            <asp:Button ID="Remove_Button" runat="server" Text="Remove Fines" Visible="true" />
                                        </td>
                                    </tr>
                            </table>
                        </div>

                            </tr>
                        </table>
 
                      <asp:GridView ID="Fines_GridView" runat="server" Font-Size="9pt" BackColor="White" BorderColor="Black" 
                                      BorderStyle="Solid" BorderWidth="1px" CellPadding="3"
                                      AllowSorting="True" EmptyDataText="No fines recorded">
                            <Columns>
                                <asp:CommandField SelectText="Details/Rescind" ShowSelectButton="True" ButtonType="Link" />
                                <asp:CommandField EditText="Add payment" ShowEditButton="True" ButtonType="Link" />
                                <asp:CommandField DeleteText="Mark Paid" ShowDeleteButton="True" ButtonType="Link" />
                            </Columns>
                            <HeaderStyle BackColor="#4A3C8C" Font-Bold="True" ForeColor="#F7F7F7" />
                            <RowStyle Height="18px" BackColor="#E7E7FF" ForeColor="#000044" />
                            <AlternatingRowStyle Height="18px" BackColor="#F7F7F7" />
                            <SelectedRowStyle BackColor="#738A9C" Font-Bold="True" ForeColor="#F7F7F7" />
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
                                      AllowSorting="True" EmptyDataText="No payments recorded for this fine">
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
                            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                            <asp:Button ID="Rescind_Button" runat="server" Text="Rescind" />
                            <span style="color:red"><b><asp:Literal ID="Rescind_Literal" runat="server"/></b></span>

                        </td>
                    </tr>
                </table>
  
    </div>
        </asp:Panel>

       <asp:Panel ID="AddPayment_Panel" runat="server" Visible="false">
            <div id="divAddPayment" style="display:block; 
                                            border: 1px solid #000080; font-family: Arial, Helvetica, sans-serif; font-size: 8Pt; vertical-align: top; 
                                            text-align: left; position: fixed; background-color: #99CCFF; top:220px; left:50px;">
                <table style="width: 100%; height: 100%">
                    <tr>
                        <td onmousedown="dragStart(event, 'divAddPayment')" 
                            onmouseover="this.style.cursor='pointer';" 
                            style="height: 8px; border-right: #000080 1px solid; border-top: #000080 1px solid; border-left: #000080 1px solid; border-bottom: #000080 1px solid; background-image: url('../images/menuBarBG.gif');">
                            <strong>
                                <asp:Literal ID="AddPayment_Literal" runat="server" Text="Add&nbsp;a&nbsp;payment&nbsp;for&nbsp;fine"></asp:Literal></strong></td>
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
                                    <th style="text-align:center;">Note</th>
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
                                        <asp:ListItem>League Entry Fee</asp:ListItem>
                                        <asp:ListItem>Fine</asp:ListItem>
                                        <asp:ListItem>Other</asp:ListItem>
                                        </asp:DropDownList></td>
                                    <td>&pound;<asp:TextBox ID="AmountPaid_TextBox" runat="server" MaxLength="10" style="text-align: left" Width="50px">0.00</asp:TextBox></td>
                                    <td><asp:TextBox ID="Note_TextBox" runat="server" MaxLength="255"></asp:TextBox></td>
                                    <td><asp:TextBox ID="PaidBy_TextBox" runat="server" MaxLength="1000"></asp:TextBox></td>
                                </tr>
                            </table>
                            <asp:TextBox ID="FineID_TextBox" runat="server" MaxLength="32" Width="120px" Visible="false"></asp:TextBox>
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

       <asp:Panel ID="ImposeFine_Panel" runat="server" Visible="false">
            <div id="divImposeFine" style="display:block; 
                                            border: 1px solid #000080; font-family: Arial, Helvetica, sans-serif; font-size: 8Pt; vertical-align: top; 
                                            text-align: left; position: fixed; background-color: #99CCFF; top:200px; left:150px;">
                <table style="width: 100%; height: 100%">
                    <tr>
                        <td onmousedown="dragStart(event, 'divImposeFine')" 
                            onmouseover="this.style.cursor='pointer';" 
                            style="height: 8px; border-right: #000080 1px solid; border-top: #000080 1px solid; border-left: #000080 1px solid; border-bottom: #000080 1px solid; background-image: url('../images/menuBarBG.gif');">
                            <strong>
                                <asp:Literal ID="ImposeFine_Literal" runat="server" Text="Impose&nbsp;a&nbsp;fine"></asp:Literal></strong></td>
                    </tr>
                </table>
                <table>
                    <tr>
                        <td>
			                <table>
                                <tr>
                                    <th style="text-align:center;">Club</th>
                                    <th style="text-align:center;">Offence</th>
                                    <th style="text-align:center;">Amount</th>
                                    <th style="text-align:center;">Comment</th>
                                </tr>
                                <tr>
                                    <td><asp:DropDownList ID="FineImposeClub_DropDownList" runat="server" /></td>
                                    <td><asp:TextBox ID="FineImposeOffence_TextBox" runat="server" MaxLength="255" Width="255px"></asp:TextBox></td>
                                    <td><span style="font-size: 11pt; vertical-align:super;">&pound;</span>
                                        <asp:TextBox ID="FineImposeAmount_TextBox" runat="server" MaxLength="10" style="text-align: left" Width="50px">0.00</asp:TextBox></td>
                                    <td><asp:TextBox ID="FineImposeComment_TextBox" runat="server" MaxLength="255" Width="255px"></asp:TextBox></td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td><span style="color:red">Note: When the "Impose the fine" button is clicked, the fine will be imposed, and an email sent to all concerned parties.</span></td>
                    </tr>
                    <tr>
                        <td>
                            <asp:Button ID="FineImpose_Button" runat="server" Text="Impose the fine" width="220"/>
                            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                            <asp:Button ID="FineImposeCancel_Button" runat="server" Text="Close" width="220" />
                            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                            <span style="font-size: 10pt; vertical-align: top; color: #FF0000;"><br />
                                <asp:Literal ID="FineImpose_Literal" runat="server"></asp:Literal></span>
                        </td>
                    </tr>
                </table>
  
    </div>
        </asp:Panel>

        <asp:Panel ID="Remove_Panel" runat="server" Visible="false">
            <div id="divRemoveFines" style="display:block; 
                                            border: 1px solid #000080; font-family: Arial, Helvetica, sans-serif; font-size: 8Pt; vertical-align: top; 
                                            text-align: left; position: fixed; background-color: #99CCFF; top:100px; left:350px;">
                <table style="width: 100%;">
                    <tr>
                        <td onmousedown="dragStart(event, 'divRemoveFines')" 
                            onmouseover="this.style.cursor='pointer';" 
                            style="border: 1px solid #000080; background-image: url('../images/menuBarBG.gif');" class="auto-style3">
                            <strong><asp:Literal ID="Literal1" runat="server" Text="Remove fines"></asp:Literal></strong></td>
                    </tr>
                </table>
                <br />
                <table>
                    <tr>
                        <td colspan="4">
                            <asp:Literal ID="RemoveFines_Literal" runat="server">
                                Choose start and end dates then click Remove to delete ALL fines <br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;and payments between, and including, those dates.
                            </asp:Literal>
                        </td>
                    </tr>
                    <tr><td> </td></tr>
                        <tr>
                            <td style="text-align: right">Date from: </td>
                            <td>
                                <asp:TextBox ID="From_TextBox" runat="server"  />
                                <asp:Image ID="From_Image" runat="server" ImageUrl="~/images/Icon-Calendar.png" />
                                <AjaxToolkit:CalendarExtender ID="From_CalendarExtender" runat="server" TargetControlID="From_TextBox" PopupButtonID="From_Image" Format="dd MMM yyyy" TodaysDateFormat="d MMM yyyy"></AjaxToolkit:CalendarExtender>
                            </td>
                            <td style="text-align: right">Date To: </td>
                            <td>
                                <asp:TextBox ID="To_TextBox" runat="server" />
                                <asp:Image ID="To_Image" runat="server" ImageUrl="~/images/Icon-Calendar.png" />
                                <AjaxToolkit:CalendarExtender ID="To_CalendarExtender" runat="server" TargetControlID="To_TextBox" PopupButtonID="To_Image" Format="dd MMM yyyy" TodaysDateFormat="d MMM yyyy"></AjaxToolkit:CalendarExtender>
                            </td>
                        </tr>
                        <tr><td> </td></tr>
                        <tr>
                            <td></td>
                            <td style="text-align:center"><asp:Button ID="RemoveFines_Button" runat="server" Text="Remove" /></td>
                            <td></td>
                            <td style="text-align: center"><asp:Button ID="CancelRemoveFines_Button" runat="server" Text="Cancel"/></td>
                        </tr>
                </table>
                <br />
    	    </div>
        </asp:Panel>
    

      </ContentTemplate>
  </asp:UpdatePanel>

        </div>

</asp:Content>
