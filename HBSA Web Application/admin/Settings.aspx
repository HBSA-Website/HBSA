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

    <asp:Button ID="AddSetting_Button" runat="server" Text="Add a new setting" />
    <asp:Panel ID="AddSetting_Panel" runat="server" Visible="false">
        <span class="privacy">Note that unless the application has been changed to use a new setting this will have no effect.<br /><br /></span>
        Enter all details and click Add, otherwise click cancel.<br />

        <table>
            <tr>
                <th style="text-align: right;">Category:</th>
                <td>
                    <asp:DropDownList ID="Category_DropDownList" runat="server" AutoPostBack="true"></asp:DropDownList>
                    <asp:Panel ID="Category_Panel" runat="server" Visible="false">
                        Enter new Category:<asp:TextBox ID="NewCategory_TextBox" MaxLength="24" Width="196px" runat="server"></asp:TextBox>
                        or 
                        <asp:Button ID="SelectCategory_Button" runat="server" Text="**Select a Category**" />
                    </asp:Panel>
                </td>
            </tr>
            <tr>
                <th style="text-align: right;">Setting description:</th>
                <td>
                    <asp:TextBox ID="Description_TextBox" runat="server" MaxLength="128" Width="600px"></asp:TextBox></td>
            </tr>
            <tr>
                <th style="text-align: right;">Control Type:</th>
                <td>
                    <asp:DropDownList ID="ControlType_DropDownList" runat="server">
                        <asp:ListItem Selected="True">**Select a control type**</asp:ListItem>
                        <asp:ListItem>CheckBox</asp:ListItem>
                        <asp:ListItem>Date</asp:ListItem>
                        <asp:ListItem>Integer</asp:ListItem>
                        <asp:ListItem>Password</asp:ListItem>
                        <asp:ListItem>TextBox</asp:ListItem>
                    </asp:DropDownList></td>
            </tr>
            <tr>
                <th style="text-align: right;">Configuration Key:</th>
                <td>
                    <asp:TextBox ID="ConfigKey_TextBox" MaxLength="150" width="600px" runat="server"></asp:TextBox></td>
            </tr>
            <tr>
                <th style="text-align: right;">Setting Value:</th>
                <td>
                    <asp:TextBox ID="SettingValue_TextBox" MaxLength="1000" Width="600px" runat="server"></asp:TextBox></td>
            </tr>
            <tr>
                <td>
                    <asp:Button ID="AddThisSetting_Button" runat="server" Text="Add this setting" />
                </td>
                <td>
                    <asp:Literal ID="AddSetting_Literal" runat="server"></asp:Literal><asp:Button ID="SettingAdded_Button" runat="server" Text="Setting Added" Visible="false" />
                </td>
            </tr>
        </table>

    </asp:Panel>



    <asp:Table ID="Settings_Table" runat="server" Font-Size="10pt" ClientIDMode="Static" ViewStateMode="Disabled" ></asp:Table>


</asp:Content>
