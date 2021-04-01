<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/admin/adminMasterPage.master" CodeBehind="EmailTemplates.aspx.vb" Inherits="HBSA_Web_Application.EmailTemplates" %>

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
    <h2 style="text-align: left">Email Templates Maintenance.</h2>

    <p>Emails sent out from this web site use templates to build their content.
    <br />
    Use this page to maintain those &#39;templates&#39;.<br /><br />
    Select an Email template:<asp:DropDownList ID="EmailTemplates_DropDownList" runat="server" AutoPostBack="true"/>
    </p>
    <p><asp:Button ID="Update_Button" runat="server" Text="Update the selected EmailTemplate."/>
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    <asp:Button ID="Delete_Button" runat="server" Text="Delete the selected EmailTemplate." />
    </p>
    <p><asp:Literal ID="Message_Literal" runat="server" /></p>
    <div id="Snapshot_Div" runat="server" Visible="false" style="border:1px solid black;color:black;background:white;">
        <asp:Literal ID="SnapShot_Literal" runat="server"></asp:Literal>
    </div>


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