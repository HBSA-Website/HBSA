<%@ Page Title="HBSA Content Management" Language="VB" MasterPageFile="~/admin/adminMasterPage.master" AutoEventWireup="false" Inherits="HBSA_Web_Application.ContentManager" Codebehind="ContentManager.aspx.vb" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <script type="text/javascript">
    function loadDiv(divID) {
        if ((divID != 'loading') && (divID != 'updating')) {
            var perCent
            if (divID == 'cfgHelp1') {
                perCent = 8 / 100;
            }
            else {
                perCent = 15 / 100;
            }
            // calc left as 15 % of page width
            var divLeft = document.documentElement.clientWidth * perCent;
            // calc top as 15 % of page height
            var divTop = document.documentElement.clientHeight * perCent;
            document.getElementById(divID).style.top = divTop;
            document.getElementById(divID).style.left = divLeft;
        }
        document.getElementById(divID).style.display = "block";
        if (divID == 'loading') {
            //ensure animated loading gif runs after post back
            setTimeout('document.images["imgLoading"].src="Images/loading.gif"', 200);
        }
        else if (divID == 'updating') {
            setTimeout('document.images["imgupdating"].src="Images/loading.gif"', 200);
        }
    }

</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <h2 style="text-align: left">Content Management.</h2>

    <table>
        <tr>
            <td style="vertical-align:top; width:70%">
                <div style="padding:4px;">
                    Various pages in the web site contain content that is manageable via this page.
                    <br />
                    <br />
                    Use this page to update those &#39;contents&#39;.<br /><br />
                    <br /> 
                    <table style="border-spacing:4px";>
                        <tr>
                            <td>Select a content file:</td>
                            <td><asp:DropDownList ID="WebPages_DropDownList" runat="server" AutoPostBack="true"/></td>
                        </tr>
                        <tr id="ButtonsRow" runat="server" visible="false">
                            <td>
                                <asp:Button ID="Update_Button" runat="server" Text="Update the selected content." /></td>
                            <td colspan="2">
                                <asp:Button ID="Delete_Button" runat="server" Text="Delete the selected content." /></td>
                        </tr>
                    </table>

               <br />
               <asp:Literal ID="Message_Literal" runat="server"></asp:Literal>

               <asp:panel id="Snapshot_Panel" runat="server" Visible="false" BorderStyle="Solid" BorderWidth="2px" BorderColor="Black" BackColor="#DDDDDD">
                   <asp:Literal ID="SnapShot_Literal" runat="server"></asp:Literal>
               </asp:panel>

            </div>

            </td>
            <td style="vertical-align:top;">
                <div style="padding: 20px;">
                 The &#39;contents&#39; that can be managed with this facility are:<br /><br />
                    <asp:Literal ID="Files_Literal" runat="server"></asp:Literal>
                </div>
            </td>
        </tr>
    </table>

    <div id="confirmDelete" runat="server" visible="false"
         style="border: 1px solid #000080; position: fixed; top: 290px; left: 200px;
                padding: 8px; text-align: center; background-color: #CCFFFF;">
        Please confirm deletion of '<asp:Literal ID="Delete_Literal" runat="server"></asp:Literal>'
        or cancel.
        <br /><br />
        <asp:Button ID="confirmDelete_button" runat="server" Text="Confirm" Width="133px" />
        &nbsp;&nbsp;&nbsp;&nbsp;
        <asp:Button ID="cancelDelete_button" runat="server" Text="Cancel" Width="133px" />
    </div>

</asp:Content>