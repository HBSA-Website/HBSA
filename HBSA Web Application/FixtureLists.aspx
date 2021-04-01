<%@ Page Title="" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" Inherits="HBSA_Web_Application.FixtureLists" Codebehind="FixtureLists.aspx.vb" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <style type="text/css">
        #print_Button {
            width: 84px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">


       <script type = "text/javascript">

           //this script to detect the export, and load the generatefile page into a iFrame
           //so that ajax doesn't block the file download process

           var prm = Sys.WebForms.PageRequestManager.getInstance();
           prm.add_initializeRequest(InitializeRequest);
           function InitializeRequest(sender, args) {
               if (sender._postBackSettings.sourceElement.id.indexOf("Download_Button") != -1) {
                   var iframe = document.createElement("iframe");
                   iframe.src = "Admin/AdminDownload.aspx?source=Fixtures&fileName=Fixtures";
                   iframe.style.display = "none";
                   document.body.appendChild(iframe);
               }
           }


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

            
            var selector = document.getElementById("<%=Section_DropDownList.ClientID%>");
            var printTitle = 'Fixtures for ' + selector.options[selector.selectedIndex].text;

            selector = document.getElementById("<%=FixtureDate_DropDownList.ClientID%>");
            if (selector) {
                if (selector.options[selector.selectedIndex].text.indexOf("All") != 0) {
                    printTitle += ' on ' + selector.options[selector.selectedIndex].text;
                }
            }

            selector = document.getElementById("<%=Team_DropDownList.ClientID%>");
            if (selector) {
                if (selector.options[selector.selectedIndex].text.indexOf("All") != 0) {
                    printTitle += ' for ' + selector.options[selector.selectedIndex].text;
                }
           }

            var scriptBox = document.getElementById("printScript");
            var jSc = scriptBox.value;

            var printWindow = window.open('', '', 'top=' + pTop + ',left=' + pLeft + ',height=842,width=595,location=0,menubar=0,resizable=1,scrollbars=1,status=0,toolbar=0');
            
            printWindow.document.write('<html><head><title>HBSA Fixtures</title><div style="text-align: center; width: 100%"><h3>' + printTitle + '</h3></head>');
            printWindow.document.write(jSc);
            printWindow.document.write('<body style="font-family:Verdana; font-size: 11pt;">' + PrintArea.innerHTML + '</body></html>');
                        
            printWindow.document.close();

            //setTimeout(function () {printWindow.print();}, 500);

        }
    </script>

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

        <div style="font-family: Verdana; color:Green; text-align:center; background-color:#ccffcc">
            <b>Fixtures</b><br />
            <asp:CheckBox ID="FixtureType_CheckBox" runat="server"  
                Text="Untick this to see fixtures as shown in the handbook, otherwise you will see actual dates and club names" 
                Checked="True" AutoPostBack="True" Font-Size="10pt" />
            <br />
            <span style="font-size:10pt; color: #0000CC;">
                <asp:Literal ID="Selection_Literal" runat="server" Text="Select a league and a section, then optionally a match date and/or team, then Click Show Fixtures."></asp:Literal>
            </span>
            <br />
            &nbsp;&nbsp;&nbsp;
            <asp:DropDownList ID="Section_DropDownList" runat="server" BackColor="#FFFFCC" AutoPostBack="true"></asp:DropDownList>
            &nbsp;&nbsp;&nbsp;
            <asp:DropDownList ID="FixtureDate_DropDownList" runat="server" BackColor="#FFFFCC"></asp:DropDownList>
            &nbsp;&nbsp;&nbsp;
            <asp:DropDownList ID="Team_DropDownList" runat="server" BackColor="#FFFFCC"></asp:DropDownList>
            &nbsp;&nbsp;&nbsp;
            <asp:Button ID="Get_Button" runat="server" Text="Show Fixtures" />
            &nbsp;&nbsp;&nbsp;
            <input id="printScript" type="hidden" value="<script type='text/javascript'>setTimeout(function () {window.print();window.onfocus = function () { self.close(); }}, 500);</script>" />
            <input runat="server" id="print_Button" visible="false" type="button" value="Print" 
                onclick="printPrintArea('printArea');" />&nbsp;&nbsp;&nbsp;
            <asp:Button ID="Download_Button" runat="server" Text="Download" Visible="false" />
            
             <br />
            <span style="color:red"><asp:Literal ID="Download_Literal" runat="server"></asp:Literal></span>
            <br />

            <div id="printArea" style="text-align: center; width: 100%">
                
               <table style="width:auto;margin-left:auto;margin-right:auto;">
                <tr>
                    <td style="vertical-align:top; text-align:center">
                        <asp:GridView ID="Fixtures_GridView" runat="server" BackColor="White" 
                        BorderColor="#CC9966" BorderStyle="Solid" BorderWidth="1px" CellPadding="4" 
                        EnableModelValidation="True" Font-Size="9pt" >
                        <AlternatingRowStyle BackColor="#F7F7F7" />
                        <HeaderStyle BackColor="#006600" Font-Bold="True" ForeColor="#FFFFCC" />
                        <RowStyle BackColor="White" ForeColor="#006600" />
                        <SelectedRowStyle BackColor="#FFCC66" Font-Bold="True" ForeColor="#663399" />
                    </asp:GridView></td>
                </tr>
            </table>
            <div style="text-align: center; width: 100%">
            <table style="width:100%">
                <tr>
                    <td style="vertical-align:top; text-align:right">
                        <asp:GridView ID="Matrix_GridView" runat="server" BackColor="White" 
                        BorderColor="#CC9966" BorderStyle="Solid" BorderWidth="1px" CellPadding="2" 
                        EnableModelValidation="True" Font-Size="8pt" >
                        <AlternatingRowStyle BackColor="#F7F7F7" />
                        <HeaderStyle BackColor="#006600" Font-Bold="True" ForeColor="#FFFFCC" />
                        <RowStyle BackColor="White" ForeColor="#006600" Font-Size="6pt" HorizontalAlign="Center" />
                        
                    </asp:GridView></td>
                    <td></td>
                    <td style="vertical-align:top; text-align:left">
                        <asp:GridView ID="Section_GridView" runat="server" BackColor="White" 
                        BorderColor="#CC9966" BorderStyle="Solid" BorderWidth="1px" CellPadding="4" Font-Size="8pt" AutoGenerateColumns="False" >
                        <AlternatingRowStyle BackColor="#F7F7F7" />
                        <HeaderStyle BackColor="#006600" Font-Bold="True" ForeColor="#FFFFCC" />
                        <RowStyle BackColor="White" ForeColor="#006600" />
                        <Columns>
                            <asp:BoundField DataField=" " >
                            <ItemStyle VerticalAlign="Top" />
                            </asp:BoundField>
                            <asp:BoundField DataField="Club/Team" HeaderText="Club/Team" >
                            <ItemStyle VerticalAlign="Top" />
                            </asp:BoundField>
                            <asp:BoundField DataField="ClubTelNo" HeaderText="Club Tel" >
                            <ItemStyle VerticalAlign="Top" />
                            </asp:BoundField>
                            <asp:BoundField DataField="TeamTelNo" HeaderText="Team Tel" />
                            <asp:BoundField DataField="Players" HeaderText="Players" >
                            <ItemStyle Width="300px" Font-Size="7pt" />
                            </asp:BoundField>
                        </Columns>
                        <SelectedRowStyle BackColor="#FFCC66" Font-Bold="True" ForeColor="#663399" />
                    </asp:GridView></td>
                </tr>
            </table>
            </div>       
        </div>
    
    
    </div>

        </ContentTemplate>
    </asp:UpdatePanel>

</asp:Content>

