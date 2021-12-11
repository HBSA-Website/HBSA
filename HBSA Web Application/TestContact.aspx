<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/MasterPage.master" CodeBehind="TestContact.aspx.vb" Inherits="HBSA_Web_Application.TestContact" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    
    <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>

        <asp:UpdateProgress runat="server" id="Update_Progress" DisplayAfter="10">
            <ProgressTemplate>
                <div id="Loading" style="position: fixed; left:600px;top:400px">
                    <asp:Image ID="loadingImage" runat="server" ImageUrl="~/images/AjaxLoading.gif" Width="100px" />
                </div>
            </ProgressTemplate>
        </asp:UpdateProgress>

    <asp:UpdatePanel ID="Update_Panel" runat="server">
        <ContentTemplate>
            <asp:Panel ID="Contact_Panel" runat="server">
    <style type="text/css">
        .col1 {
            /*width: 180px;*/
            border: #006600 1px solid;
            font-size: 9pt;
            vertical-align: middle;
            color: black;
            font-family: Verdana;
            text-align: right;
        }
        .col2 {
            /*width: 380px;*/
            border: #006600 1px solid;
            font-size: 9pt;
            vertical-align: middle;
            color: black;
            font-family: Verdana;
            text-align: left;
        }
        .col3 {
            /*width: 180px;*/
            border: #006600 1px solid;
            padding:6px;
            font-size: 8pt;
            font-style:italic;
            vertical-align: middle;
            color: black;
            font-family: Verdana;
            text-align: left;
        }
        .tBox {
            Width:380px
        }
    </style>

    <table style="width:auto; margin-left:auto; margin-right:auto;border-collapse:collapse;background-color: #CCFFCC; ">
            <tr><td class="col2" style="width:100%; font-size:12pt; text-align:center; background-color:white;" colspan="3" >
            <br />
                To eMail us please select where the eMail should go, enter your details, enter the &quot;Prove you&#39;re human&quot; code, then click "Send your message".
            <br /><br />
                </td></tr>


        <tr>
            <td class="col1">Select where the email should be sent:</td>
            <td class="col2">&nbsp;&nbsp;&nbsp;&nbsp;<asp:DropDownList ID="Destination_DropDownList" runat="server" AutoPostBack="true" /></td>
            <td class="col3">Mandatory</td>
        </tr>
        <tr>
            <td class="col1">Your name:</td>
            <td class="col2"><asp:TextBox ID="Name_TextBox" runat="server" CssClass="tBox" /></td>
            <td class="col3">Mandatory</td>
        </tr>
        <tr>
            <td class="col1">Your email address:</td>
            <td class="col2"><asp:TextBox ID="Email_TextBox" runat="server" class="tBox" /></td>
            <td class="col3">Mandatory</td>
        </tr>
        <tr>
            <td class="col1">Your Phone No:</td>
            <td calss="col2"><asp:TextBox ID="Phone_TextBox" runat="server" CssClass="tBox" /></td>
            <td class="col3">This may be used for any queries.<br />
                             Mandatory for player registration/handicap requests.</td>
        </tr>
        <tr id="CompsRow" runat="server" visible="false">
            <td class="col1">Select a competition:</td>
            <td class="col2">&nbsp;&nbsp;&nbsp;&nbsp;<asp:DropDownList ID="Competitions_DropDownList" runat="server"></asp:DropDownList>  </td>
            <td class="col3">Mandatory for Competitions Results</td>
        </tr>
        <tr id="HcapRow7" runat="server" visible="false">
            <td class="col1">Justify handicap:</td>
            <td class="col3" colspan="2" style="background-color:white;">Please Note :- When registering a new player, or requesting a handicap change please monitor the player prior to this request. Then and only then submit a fair and suggested handicap. Do NOT assume that all new players receive +21 as this is not the case.<br />
                <span style="color:red;">If a handicap is later proven to be unfair sanctions may be applied to the team.</span><br /><br />
                <asp:CheckBox ID="Justify_CheckBox" runat="server" Text="Tick this box to indicate you have read the note above, and that you agree and will comply." Font-Italic="False" ForeColor="Blue" /></td>
        </tr>
        <tr id="HcapRow1" runat="server" visible="false">
            <td class="col1">Player's Name:</td>
            <td class="col2"><asp:TextBox ID="Player_TextBox" runat="server" class="tBox" /></td>
            <td class="col3">Mandatory</td>
        </tr>
        <tr id="HcapRow6" runat="server" visible="false">
            <td class="col1">Player's Phone No:</td>
            <td class="col2">&nbsp;&nbsp;&nbsp;&nbsp;<asp:TextBox ID="PlayerPhone_TextBox" runat="server" /> </td>
            <td class="col3">Optional. 
                <br />
                This will be stored in the HBSA database and can be accessed by other HBSA members, for arranging individual matches, etc. </td>
        </tr>
        <tr id="HcapRow2" runat="server" visible="false">
            <td class="col1">League:</td>
            <td class="col2">
                &nbsp;&nbsp;&nbsp;&nbsp;<asp:DropDownList ID="League_DropDownList" runat="server">
                </asp:DropDownList></td>
            <td class="col3">Mandatory - Choose one</td>
        </tr>
        <tr>
            <td class="col1">Your club:</td>
            <td class="col2">&nbsp;&nbsp;&nbsp;&nbsp;<asp:DropDownList ID="Clubs_DropDownList" runat="server" ></asp:DropDownList></td>
            <td class="col3">Mandatory for Handicaps/Registrations</td> 
        </tr>
        <tr id="HcapRow3" runat="server" visible="false">
            <td class="col1">Team that the request relates to:</td>
            <td class="col2">&nbsp;&nbsp;&nbsp;&nbsp;<asp:DropDownList ID="Team_DropDownList" runat="server">
                                                        <asp:ListItem>** Select a Team **</asp:ListItem>
                                                        <asp:ListItem>' ' (no team letter)</asp:ListItem>
                                                        <asp:ListItem>'A'</asp:ListItem>
                                                        <asp:ListItem>'B'</asp:ListItem>
                                                        <asp:ListItem>'C'</asp:ListItem>
                                                        <asp:ListItem>'D'</asp:ListItem>
                                                        <asp:ListItem>'E'</asp:ListItem>
                                                        <asp:ListItem>'F'</asp:ListItem>
                                                     </asp:DropDownList></td>
            <td class="col3">Mandatory</td>
        </tr>
        <tr id="HcapRow4" runat="server" visible="false">
            <td class="col1">Suggested Handicap:</td>
            <td class="col2" style="text-align:center;"><asp:TextBox ID="Handicap_TextBox" runat="server" class="tBox" Width =" 50px"  /></td>
            <td class="col3">Mandatory (use minus sign (-) for handicap less than zero)</td>
        </tr>
        <tr id="HcapRow5" runat="server" visible="false">
            <td class="col1">Reasons for suggested handicap:</td>
            <td class="col2"><asp:TextBox ID="Reasons_TextBox" runat="server" CssClass="tBox" Width="380px" Height="56px" TextMode="MultiLine"  /></td>
            <td class="col3">e.g. Player's Highest Break, handicap in other leagues, playing history etc.</td>
        </tr>
        <tr>
            <td class="col1">Your message:</td>
            <td class="col2"  colspan="2" style="width:560px;text-align:left;">
                <asp:TextBox ID="body_TextBox" runat="server" CssClass="tBox" Width="560px" Height="106px" TextMode="MultiLine"  /></td>
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
            <td class="col2" colspan="2" style="width:560px;text-align:center;">
                <asp:CheckBox ID="Copy_CheckBox" runat="server" Text="Tick this box to send a copy to your email address"/>
                <br />
                <asp:Button ID="Send_Button" runat="server" ForeColor="#004000" Text="Submit your request" />
                <br /><br />
            </td>
        </tr>
     </table>

            <span><asp:Literal ID="status_Literal" runat="server" Mode="PassThrough"></asp:Literal></span>
            <br /><br />
    </asp:Panel>

        <style type="text/css">
            .ThisPanel{
                width:100%;
                text-align:center;
            }
        </style>

    <asp:Panel ID="MessageSent_Panel" runat="server" CssClass="ThisPanel" Visible="false">
        <br /><br />
        <asp:Literal ID="MessageSent_Literal" runat="server"></asp:Literal><br /><br />
        <a id="Home_Link" href="../Home.aspx">Return to the homepage</a>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        <a id="Contact_Link" href="Contact.aspx">Submit another message</a>
        <br /><br />
    </asp:Panel> 

        </ContentTemplate>
    </asp:UpdatePanel>

</asp:Content>
