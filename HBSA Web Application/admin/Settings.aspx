<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/admin/adminMasterPage.master" CodeBehind="Settings.aspx.vb" Inherits="HBSA_Web_Application.Settings" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
  <%--Set up references to JQuery libraries etc.--%>  
  <link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css" />
  <script src="https://code.jquery.com/jquery-3.2.1.js" type="text/javascript"></script> 
    <%--//1.12.4.js"></script>--%>
  <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"  type="text/javascript"></script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server" ViewStateMode="Enabled">
<%--<asp:HiddenField ID="hiddenEnterPressed" runat="server" ClientIDMode="Static" />--%>

    <script type="text/javascript">
        $('input[type="text"]').keydown(function (event) {
            if (event.keyCode == 13) {
                event.preventDefault();
                return false;
            }
        });
    </script>
    
    <h3>web Site Settings</h3>
    <a href ="Configuration.aspx">Click here to go to raw configuration parameters.</a> 

       <p style="color: #FF3300">
        WARNING:<br />
        These items are critical to the operation of this web site.  If they are incorrectly changed, or deleted it could
        cause the system to crash.<br />
        Therefore only make changes that you are confident will have the desired effect.
    </p>
    <p style="color: #FF6000">
        <i>NOTES: To make a change enter the new details then press tab, enter/return, or click elsewhere on the page.&nbsp; <br />
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;to put multiple email addresses in a setting separate them with a semicolon (;)<br />
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="font-size: larger; font-weight: bold; color: #FF0000">Changes are made and are effective immediately.</span>
        </i>
    </p>

    <asp:ScriptManager ID="ScriptManager1" runat="server">
    </asp:ScriptManager>

    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <asp:Table ID="Settings_Table" runat="server" Font-Size="10pt" ClientIDMode="Static" ></asp:Table>
        </ContentTemplate>
    </asp:UpdatePanel>

</asp:Content>
