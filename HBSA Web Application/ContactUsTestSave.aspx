<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/MasterPage.master" CodeBehind="ContactUsTest.aspx.vb" Inherits="HBSA_Web_Application.ContactUsTest" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
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

        <table style="border: thin solid #006600; width:auto; margin-left:auto; margin-right:auto; max-height:99999px;
               font-size:12px; font-family: Verdana; background-color: #CCFFCC; color: #006600; padding:10px;">
            <tr><td>
            To eMail us please enter your details, select where email should go, 
            <br />
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;enter the &quot;Prove you&#39;re human&quot; code, then click "Send your message".
            <br />
                </td></tr>
        </table>

    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>

    <style type="text/css">
        .col1 {
            width: 180px;
            border-right: #006600 1px solid;
            border-top: #006600 1px solid;
            border-left: #006600 1px solid;
            border-bottom: #006600 1px solid;
            font-size: 9pt;
            vertical-align: middle;
            color: #006600;
            font-family: Verdana;
            text-align: right;
        }
        .col2 {
            width: 380px;
            border-right: #006600 1px solid;
            border-top: #006600 1px solid;
            border-left: #006600 1px solid;
            border-bottom: #006600 1px solid;
            font-size: 9pt;
            vertical-align: middle;
            color: #006600;
            font-family: Verdana;
            text-align: left;
        }
        .col3 {
            width: 180px;
            border-right: #006600 1px solid;
            border-top: #006600 1px solid;
            border-left: #006600 1px solid;
            border-bottom: #006600 1px solid;
            padding:6px;
            font-size: 8pt;
            font-style:italic;
            vertical-align: middle;
            color: black;
            font-family: Verdana;
            text-align: left;
        }
        .tBox {border: none;
               Width:380px

        }
}
    </style>


    <table style="width:auto; margin-left:auto; margin-right:auto;
                  font-size: 11pt; border:thin solid #006600; border-collapse:collapse;
                  color: #006600; font-family: Verdana; 
                  background-color: #CCFFCC; ">
        <tr>
            <td class="col1">Select where the email should be sent:</td>
            <td class="col2">&nbsp;&nbsp;&nbsp;&nbsp;<asp:DropDownList ID="Destination_DropDownList" runat="server" AutoPostBack="true" /></td>
            <td class="col3">Mandatory</td>
        </tr>
        <tr>
            <td class="col1">Your name:</td>
            <td class="col2"><asp:TextBox ID="name_TextBox" runat="server" CssClass="tBox"></asp:TextBox></td>
            <td class="col3">Mandatory</td>
        </tr>
        <tr>
            <td class="col1">Your club:</td>
            <td class="col2">&nbsp;&nbsp;&nbsp;&nbsp;<asp:DropDownList ID="club_DD" runat="server" ></asp:DropDownList></td>
            <td class="col3">Mandatory for Handicaps/Registrations</td>
        </tr>
        <tr>
            <td class="col1">Your email address:</td>
            <td class="col2"><asp:TextBox ID="from_TextBox" runat="server" class="tBox"></asp:TextBox></td>
            <td class="col3">Mandatory</td>
        </tr>
        <tr>
            <td class="col1">Your Phone No:</td>
            <td calss="col2"><asp:TextBox ID="Phone_TextBox" runat="server" CssClass="tBox" TextMode="Number"></asp:TextBox></td>
            <td class="col3">This may be used for any queries.</td>
        </tr>
        <tr id="CompsRow" runat="server" visible="false">
            <td class="col1">Select a competition:</td>
            <td class="col2">&nbsp;&nbsp;&nbsp;&nbsp;<asp:DropDownList ID="Competitions_DropDownList" runat="server"></asp:DropDownList>  </td>
            <td class="col3">Mandatory for Competitions Results</td>
        </tr>
        <tr id="HcapRow1" runat="server" visible="false">
            <td class="col1">Player's Name:</td>
            <td class="col2"><asp:TextBox ID="Player_TextBox" runat="server" class="tBox"></asp:TextBox></td>
            <td class="col3">Mandatory</td>
        </tr>
        <tr id="HcapRow2" runat="server" visible="false">
            <td class="col1">League:</td>
            <td class="col2">
                <asp:RadioButton ID="League_RadioButton" runat="server" >
                    
                </asp:RadioButton></td>
            <td class="col3">Mandatory</td>
        </tr>

        <tr>
            <td class="col1">Your message:</td>
            <td class="col2"  colspan="2" style="width:560px;text-align:center;">
                <asp:TextBox ID="body_TextBox" runat="server" CssClass="tBox" Width="560px" Height="106px" TextMode="MultiLine" ></asp:TextBox></td>
        </tr>
        <tr>
            <td class="col1">Prove you're human:</td>
            <td class="col2" colspan="2" style="width:560px;text-align:center;">
                    <asp:UpdatePanel ID="captchaPanel" runat="server">
                        <ContentTemplate>
                            &nbsp;&nbsp;&nbsp;&nbsp;Enter the code below in the box:<br />
                           &nbsp;&nbsp;&nbsp;&nbsp;<asp:TextBox runat="server" ID="captcha_Textbox" Width="90px" Height="20px"/>
                           <img id="captcha_Image" runat="server" src="data:image/GIF;base64," style="height: 25px; width: 200px; vertical-align: -8px;" alt="Captcha Image" /> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                              <asp:Button ID="captchaRefresh_Button" runat="server" Text="Click for new code" BackColor="#CCFFCC" BorderStyle="None" Font-Underline="True" ForeColor="#0066FF" />
                       </ContentTemplate>
                    </asp:UpdatePanel>
            </td>
        </tr>
        <tr>
            <td class="col1">Send the message:</td>
            <td class="col2" colspan="2" style="width:560px;text-align:center;"><asp:Button ID="Send_Button" runat="server" ForeColor="#004000" Text="Send your message" /></td>
        </tr>
     </table>

            <span><asp:Literal ID="status_Literal" runat="server" Mode="PassThrough"></asp:Literal></span>
            <br /><br />

        </ContentTemplate>
    </asp:UpdatePanel>

</asp:Content>
