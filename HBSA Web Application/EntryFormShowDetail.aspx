<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/MasterPage.master" CodeBehind="EntryFormShowDetail.aspx.vb" Inherits="HBSA_Web_Application.EntryFormShowDetail" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        #print_Button {
            width: 90px;
            height: 26px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

        <div id="NothingPage" runat="server" visible="false" style="text-align:center">
            <h3 style="color:red">This page can only be entered from a link within this web site</h3>
        </div>

        <div id="FullPage" runat="server" style="text-align:left">
    
        <table style="width:100%">
          <tr>
            <td style="width:143px">
                <h5>Entry Form Details</h5>
            </td>
            <td>
                <asp:Button ID="Return_Button" runat="server" Text="Return to the entry form" BorderStyle="None" BackColor="White" Font-Underline="True" ForeColor="Blue" onmouseover="this.style.cursor='pointer';" />
            </td> 
          </tr>
          <tr>
            <td style="vertical-align:top;">
                <asp:Button ID="Download_Button" runat="server" Text="Download" EnableViewState="false" Width="90px" />
                <br /><br />
                <input runat="server" id="print_Button" style="width:90px" type="button" value="Print" onclick="printPrintArea('printArea');" />
            </td>
            <td style="text-align:left">
                <div id="printArea" style="width: 100%">
                    <span style="font-size: larger; font-weight: bold"><asp:Literal ID="Header_Literal" runat="server"></asp:Literal></span><br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                        <asp:Literal ID="Payment_Literal" runat="server"></asp:Literal><br /><br />
                        <asp:GridView ID="EntryForm_GridView" runat="server" BackColor="White" EnableViewState="false"
                            BorderColor="#CC9966" BorderStyle="Solid" BorderWidth="1px" CellPadding="4" 
                            EnableModelValidation="True" Font-Size="9pt" EmptyDataText="No competition entries have been made for this club.">
                            <AlternatingRowStyle BackColor="#F7F7F7" />
                            <RowStyle BackColor="White" ForeColor="#004400" />
                        </asp:GridView>
    
                    </div>
                </td>
            </tr>
        </table>
    </div>

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
            
            printWindow.document.write('<html><head><title>HBSA Entry Form</title></head>');
            
            printWindow.document.write('<body style="font-family:Verdana; font-size: 11pt;"><div style="text-align: center; width: 100%">' + PrintArea.innerHTML + '</div></body></html>');
                        
            printWindow.document.close();

            setTimeout(function () {printWindow.print();}, 500);

        }
    </script>


</asp:Content>
