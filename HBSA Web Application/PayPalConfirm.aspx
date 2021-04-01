<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/MasterPage.master" CodeBehind="PayPalConfirm.aspx.vb" Inherits="HBSA_Web_Application.PayPalConfirm" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div style="font-family: Verdana; color:black; text-align:center; background-color:white; font-size: 11pt;">
        <b>Huddersfield Billiards &amp; Snooker Association</b><br />
            <br />Payment Confirmation
        <br />
        
        <hr />
        <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true"></asp:ScriptManager>

        <asp:UpdateProgress runat="server" id="Update_Progress" DisplayAfter="10">
            <ProgressTemplate>
                <div id="Loading" style="position: fixed; left:440px;top:260px">
                    <asp:Image ID="loadingImage" runat="server" ImageUrl="~/images/AjaxLoading.gif" Width="100px" />
                </div>
            </ProgressTemplate>
        </asp:UpdateProgress>

    <asp:UpdatePanel ID="CompetitionsPanel" runat="server" Visible="true">
        <ContentTemplate>

        <b><asp:Literal ID="Club_Literal" runat="server"></asp:Literal></b>   <br /><br />

        <asp:Panel ID="Confirm_Panel" runat="server" Visible="false">
            Thank you for choosing to pay with PayPal.<br /><br />
            Your Payment ID is <asp:Literal ID="PaymentID_Literal1" runat="server"></asp:Literal><br/>
            <i>(please quote on all correspondence relating to this transaction)</i><br /><br />
            Amount: <b>&pound;<asp:Literal ID="Amount_Literal" runat="server">0.00</asp:Literal></b><br /><br />
            You may add a note here for reference later:<br />
            <asp:TextBox ID="Note_TextBox" runat="server" MaxLength="255" Width="553px"></asp:TextBox>
            <br />
            Then click the confirm button to pay:<br />
            <br />
            &nbsp;<asp:Button ID="Confirm_Button" runat="server" Text="Confirm" Font-Size="12pt" />
            <br />
        </asp:Panel>
        
        <asp:Panel ID="Paid_Panel" runat="server" Visible="false" BackColor="White" Font-Size="11pt">
        <b>&pound;<asp:Literal ID="Paid_Literal" runat="server"></asp:Literal></b>&nbsp;has just been paid via PayPal.<br />  
            The amount due was £<asp:Literal ID="FullAmount_Literal" runat="server"></asp:Literal>. <br /> 
            <asp:Literal ID="Outstanding_Literal" runat="server"></asp:Literal>.<br /><br />
            The HBSA payment ID is:<asp:Literal ID="PaymentID_Literal" runat="server"></asp:Literal><br />
            The PayPal Transaction ID is:<asp:Literal ID="TransactionID_Literal" runat="server"></asp:Literal><br />
            Please make a note of these details and keep them for future reference.  <br />
            <input runat="server" id="print_Button" style="border: 0px solid #000000; width:90px; font-size: 11pt; text-decoration: underline; color: #0000FF; height:35px; width:114px" type="button" value="Print receipt" onclick="printPrintArea('printArea');"  />
            
            <br />
            Click one of the links at the top of this page to proceed.<br />
        <br />
        Your payment history:
       <tables tyle="width:100%"><tr><td style="text-align:center">

                    <asp:GridView ID="Payments_gridview" runat="server"
                                    BorderStyle="Solid" BorderWidth="1px" CellPadding="2" ShowHeader="true" EmptyDataText="No payments" Font-Size="8pt">
                                    <HeaderStyle BackColor="white" Font-Bold="True" ForeColor="black" Height="5" />
                                    <RowStyle BackColor="White" ForeColor="black" HorizontalAlign="Left" />
                                    <AlternatingRowStyle BackColor="#e0e0e0" ForeColor="#181818" HorizontalAlign="Left" />
                                </asp:GridView>
                               </td></tr></tables>             

        <div id="printArea" style="width:100%; visibility: hidden;">
             <div style="text-align:center;">
                 <br />
                 <img src="images/SHBSA.jpg" width="450" alt="Huddersfield Billiards and Snooker Association"/>
                 <br />
                 &nbsp;<br />
                 <table style="text-align:left; font-size: 9pt;">
                     <tr><td colspan="3" style="text-align:center; font-size: 18pt; font-family: 'Baskerville Old Face'; font-style: italic;">RECEIPT</td></tr>
                     <tr><td colspan="3"></td></tr>
                     <tr>
                         <td><asp:Literal ID="TodaysDate_Receipt_Literal" runat="server"/></td>
                         <td></td>
                         <td>Received with thanks from <asp:Literal ID="PaidBy_Receipt_Literal" runat="server"/></td>
                     </tr>
                     <tr>
                         <td colspan="2"></td>
                         <td>On behalf of <asp:Literal ID="ClubName_Receipt_Literal" runat="server"></asp:Literal></td>
                     </tr>
                     <tr>
                         <td colspan="2"></td>
                         <td><b>The sum of &pound;<asp:Literal ID="Amount_Receipt_Literal" runat="server"></asp:Literal></b></td>
                     </tr>
                     <tr>
                         <td colspan="2"></td>
                         <td>Your payment ID: <asp:Literal ID="PaymentID_Receipt_Literal" runat="server"></asp:Literal></td>
                     </tr>
                     <tr><td colspan="3"></td></tr>
                     <tr><td colspan="3" style="text-align:center">Many Thanks from the HBSA</td></tr>
                 </table>
                 
                 
             </div>
            
        </div>

        </asp:Panel>    

        </div>

        <hr />
    </ContentTemplate>
    </asp:UpdatePanel>
   <script type = "text/javascript">

        function getAbsPosition(el) {
            var el2 = el;
            var curtop = 0;
            var curleft = 0;
            if (document.getElementById || document.all) {
                do {
                    curleft += (el.offsetLeft || 0) - (el.scrollLeft || 0);
                    curtop += (el.offsetTop || 0) - (el.scrollTop || 0);
                    el = el.offsetParent;
                    el2 = el2.parentNode;
                    while (el2 != el) {
                        curleft -= el2.scrollLeft;
                        curtop -= el2.scrollTop;
                        el2 = el2.parentNode;
                    }
                } while (el.offsetParent);

            } else if (document.layers) {
                curtop += el.y;
                curleft += el.x;
            }
            return {top: curtop, left: curleft};
        }

        function printPrintArea(PrintAreaDiv) {

            var PrintArea = document.getElementById(PrintAreaDiv);
            var Cords = getAbsPosition(PrintArea);
            var pLeft = Cords.left
            var pTop = Cords.top;
            pLeft = pLeft + window.screenX;
            pTop = pTop + window.screenY;
            
            var printWindow = window.open('', '', 'top=' + pTop + ',left=' + pLeft + ',width=800,location=0,menubar=0,resizable=1,scrollbars=1,status=0,toolbar=0');
            
            printWindow.document.write('<html><head><title>HBSA Receipt</title></head>');
            
            printWindow.document.write('<body style="font-family:Verdana; font-size: 11pt;"><div style="text-align: center; width: 100%">' + PrintArea.innerHTML + '</div></body></html>');
                        
            printWindow.document.close();

            setTimeout(function () {printWindow.print();}, 500);

        }
    </script>

        </div>
</asp:Content>
