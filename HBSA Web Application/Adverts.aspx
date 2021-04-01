<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/MasterPage.master" CodeBehind="Adverts.aspx.vb" Inherits="HBSA_Web_Application.Adverts1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<%--    <script type="text/javascript">
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

</script>--%>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <h2 style="text-align: left">Adverts.</h2>

    <table style="width:100%">
        <tr>
            <td style="width:70%; vertical-align:top;">
                <div style="padding: 20px;">
                    Use this page to view any of the advertisements (full sized).<br /><br />
                    These adverts are identified by their names.<br />
                    Adverts can be viewed. Note that adverts are held as pictures(images).  Any text must be included in the image.<br />
                    If a Web URL (web address) is there, clicking the advert will take the user to that web page.
                    <br />
                    <br /> 
                    <table style="border-spacing:4px;">
                        <tr style="vertical-align:top;" >
                            <td>Select an advert:</td>
                            <td><asp:DropDownList ID="Adverts_DropDownList" runat="server" AutoPostBack="true" style="max-width:600px"/></td>
                        </tr>
                        <tr>
                            <td><asp:Literal ID="WebURL_Literal" runat="server"></asp:Literal></td>
                        </tr>
                        <tr style="vertical-align:top;">
                            <td colspan="2">
                                <a id="snapshot_link" runat="server" href="~/Advert.ashx" target="_blank">
                                    <img id="snapshot_img" src="data:image/JPEG;base64," runat="server" style="border: 1px solid black" />
                                </a>
                            </td>
                        </tr>
                    </table>
                
            </div>

            </td>
            <td style="vertical-align:top;">
                <div style="padding: 20px;">
                 The adverts that can be viewed with this facility are:<br /><br />
                    <asp:Literal ID="Files_Literal" runat="server"></asp:Literal>
                </div>
            </td>
        </tr>
    </table>

</asp:Content>
