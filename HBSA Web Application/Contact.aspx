<%@ Page Title="" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" Inherits="HBSA_Web_Application.Contact" Codebehind="Contact.aspx.vb" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
 </asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    
    <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>

           <asp:UpdateProgress runat="server" id="Update_Progress" DisplayAfter="10">
            <ProgressTemplate>
                <div id="Loading" style="position: fixed; left:600px;top:600px">
                    <asp:Image ID="loadingImage" runat="server" ImageUrl="~/images/AjaxLoading.gif" Width="100px" />
                </div>
            </ProgressTemplate>
        </asp:UpdateProgress>

    <table style="width:auto; margin-left:auto; margin-right:auto;">
    <tr>
        <td>
            <div style="font-family: Verdana; width:800px; background-color: #CCFFCC; font-size: larger;"  >
            <br /><br />
            <span style="color: #006600">To email us please enter your details, select where email should go, 
            <br />
            enter the &quot;Prove you&#39;re human&quot; code, then click "Send your message".
            <br /><br />
            </span>
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>

    <table style="text-align:center; border-top-width: thin; border-left-width: thin; font-size: 11pt; 
                  border-left-color: #006600; border-bottom-width: thin; border-bottom-color: #006600;
                  color: #006600; border-top-color: #006600; font-family: Verdana; border-right-width: thin; 
                  border-right-color: #006600;">
        <tr>
            <td style="border-right: #006600 1px solid; border-top: #006600 1px solid; font-size: 9pt; vertical-align: middle; border-left: #006600 1px solid; width: 138px; color: #006600; border-bottom: #006600 1px solid; font-family: Verdana; text-align: right">
                Your email address:</td>
            <td style="width: 380px; border-right: #006600 1px solid; border-top: #006600 1px solid; font-size: 9pt; border-left: #006600 1px solid; color: #006600; border-bottom: #006600 1px solid; font-family: Verdana; text-align: left; width:380px;">
                <asp:TextBox ID="from_TextBox" runat="server" BorderWidth="0px" Width="380px"></asp:TextBox></td>
            <td style="border-right: #006600 1px solid; border-top: #006600 1px solid; font-size: 9pt; border-left: #006600 1px solid; width: 137px; color: #006600; border-bottom: #006600 1px solid; font-family: Verdana; text-align: left"
                    rowspan="6">
            Please enter details in all of these boxes</td>
        </tr>
        <tr>
            <td style="border-right: #006600 1px solid; border-top: #006600 1px solid; font-size: 9pt; vertical-align: middle; border-left: #006600 1px solid; width: 138px; color: #006600; border-bottom: #006600 1px solid; font-family: Verdana; text-align: right">
                Your name:</td>
            <td style="width: 380px; border-right: #006600 1px solid; border-top: #006600 1px solid; font-size: 9pt; border-left: #006600 1px solid; color: #006600; border-bottom: #006600 1px solid; font-family: Verdana; text-align: left; width:380px">
                <asp:TextBox ID="name_TextBox" runat="server" BorderWidth="0px" Width="380px"></asp:TextBox></td>
        </tr>
        <tr>
            <td style="border-right: #006600 1px solid; border-top: #006600 1px solid; font-size: 9pt; vertical-align: middle; border-left: #006600 1px solid; width: 138px; color: #006600; border-bottom: #006600 1px solid; font-family: Verdana; text-align: right">
                Your club:</td>
            <td style="width: 380px; border-right: #006600 1px solid; border-top: #006600 1px solid; font-size: 9pt; border-left: #006600 1px solid; color: #006600; border-bottom: #006600 1px solid; font-family: Verdana; text-align: left; width:380px">
                <asp:TextBox ID="club_TextBox" runat="server" BorderWidth="0px" Width="380px"></asp:TextBox></td>
        </tr>
        <tr>
            <td rowspan="1" style="border-right: #006600 1px solid; border-top: #006600 1px solid;
                font-size: 9pt; border-left: #006600 1px solid; color: #006600;
                border-bottom: #006600 1px solid; font-family: Verdana; text-align: right;">
                Select where the email should be sent:</td>
            <td rowspan="1" style="border-right: #006600 1px solid; border-top: #006600 1px solid;
                font-size: 9pt; border-left: #006600 1px solid; color: #006600;
                border-bottom: #006600 1px solid; font-family: Verdana; text-align: left; width:380px">
                &nbsp;&nbsp;&nbsp;&nbsp;<asp:DropDownList ID="Destination_DropDownList" runat="server" AutoPostBack="true"></asp:DropDownList>  </td>

        </tr>
        <tr id="CompsRow" runat="server" visible="false">
            <td rowspan="1" style="border-right: #006600 1px solid; border-top: #006600 1px solid;
                font-size: 9pt; border-left: #006600 1px solid; color: #006600;
                border-bottom: #006600 1px solid; font-family: Verdana; text-align: right;">
                Select a competition:</td>
            <td rowspan="1" style="border-right: #006600 1px solid; border-top: #006600 1px solid;
                font-size: 9pt; border-left: #006600 1px solid; color: #006600;
                border-bottom: #006600 1px solid; font-family: Verdana; text-align: left; width:380px">
                &nbsp;&nbsp;&nbsp;&nbsp;<asp:DropDownList ID="Competitions_DropDownList" runat="server"></asp:DropDownList>  </td>

        </tr>
        <tr>
            <td style="border-right: #006600 1px solid; border-top: #006600 1px solid; font-size: 9pt;
                vertical-align: middle; border-left: #006600 1px solid; width: 138px; color: #006600;
                border-bottom: #006600 1px solid; font-family: Verdana; text-align: right; height: 73px;">
                Your message:
            </td>
            <td style="border-right: #006600 1px solid; border-top: #006600 1px solid; font-size: 9pt;
                border-left: #006600 1px solid; width: 380px; color: #006600; border-bottom: #006600 1px solid;
                font-family: Verdana; text-align: left; height: 73px;">
                <asp:TextBox ID="body_TextBox" runat="server" BorderWidth="0px" Height="106px" TextMode="MultiLine" Width="380px"></asp:TextBox></td>
        </tr>
        <tr>
              <td style="border-right: #006600 1px solid; border-top: #006600 1px solid; font-size: 9pt;
                vertical-align: middle; border-left: #006600 1px solid; width: 138px; color: #006600;
                border-bottom: #006600 1px solid; font-family: Verdana; text-align:right;" >
                Prove you're human:
            </td>
            <td style="border-right: #006600 1px solid; border-top: #006600 1px solid; font-size: 9pt;
                border-left: #006600 1px solid; color: #006600; border-bottom: #006600 1px solid;
                font-family: Verdana; text-align: left; width:380px">
                    <asp:UpdatePanel ID="captchaPanel" runat="server">
                        <ContentTemplate>
                            &nbsp;&nbsp;&nbsp;&nbsp;Enter the code below in the box: <em>(Note it&#39;s case sensitive)</em><br />
                           &nbsp;&nbsp;&nbsp;&nbsp;<asp:TextBox runat="server" ID="captcha_Textbox" Width="90px" Height="20px"/>
                           <img id="captcha_Image" runat="server" src="data:image/GIF;base64," style="height: 25px; width: 200px; vertical-align: -8px;" alt="Captcha Image" /> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                              <asp:Button ID="captchaRefresh_Button" runat="server" Text="Click for new code" BackColor="#CCFFCC" BorderStyle="None" Font-Underline="True" ForeColor="#0066FF" />
                       </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
            <tr>
            <td rowspan="1" style="border-right: #006600 1px solid; border-top: #006600 1px solid;
                font-size: 9pt; border-left: #006600 1px solid; color: #006600;
                border-bottom: #006600 1px solid; font-family: Verdana; text-align: right;">
                Send the message:</td>
            <td rowspan="1" style="border-right: #006600 1px solid; border-top: #006600 1px solid;
                font-size: 9pt; border-left: #006600 1px solid; color: #006600;
                border-bottom: #006600 1px solid; font-family: Verdana; text-align: left; width:380px">
                &nbsp;&nbsp;&nbsp;&nbsp;<asp:Button ID="Send_Button" runat="server" ForeColor="#004000" Text="Send your message" /></td>
                
            </tr>
         </table>

            <span><asp:Literal ID="status_Literal" runat="server" Mode="PassThrough"></asp:Literal></span>
            <br /><br />

        </ContentTemplate>
    </asp:UpdatePanel>


</div>
        </td>
    </tr>
</table>

</asp:Content>

