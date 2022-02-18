<%@ Page Title="" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" Inherits="HBSA_Web_Application.Contact" CodeBehind="Contact.aspx.vb" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>

    <asp:UpdateProgress runat="server" ID="Update_Progress" DisplayAfter="10">
        <ProgressTemplate>
            <div id="Loading" style="position: fixed; left: 600px; top: 400px">
                <asp:Image ID="loadingImage" runat="server" ImageUrl="~/images/AjaxLoading.gif" Width="100px" />
            </div>
        </ProgressTemplate>
    </asp:UpdateProgress>

    <asp:UpdatePanel ID="Update_Panel" runat="server">
        <ContentTemplate>
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
                    padding: 6px;
                    font-size: 8pt;
                    font-style: italic;
                    vertical-align: middle;
                    color: black;
                    font-family: Verdana;
                    text-align: left;
                }

                .tBox {
                    Width: 380px
                }
            </style>

            <table style="width: auto; margin-left: auto; margin-right: auto; border-collapse: collapse; background-color: #CCFFCC;">
                <tr>
                    <td class="col2">To eMail us please select where the eMail should go, enter your details, enter the &quot;Prove you&#39;re human&quot; code,<br />
                        then click "Send your message".
                    </td>
                </tr>
                <tr>
                    <td class="col2" style="text-align: center">
                        <asp:DropDownList ID="Destination_DropDownList" runat="server" AutoPostBack="true" /></td>
                </tr>
            </table>
            <br />
            <asp:Panel ID="Agreement_Panel" runat="server" Visible="false">
                <table style="width: auto; margin-left: auto; margin-right: auto; border-collapse: collapse; background-color: #CCFFCC;">
                    <table style="width: auto; margin-left: auto; margin-right: auto; border-collapse: collapse; background-color: #CCFFCC;">
                        <tr>
                            <td class="col2">
                                <br />
                                Please Note :- When registering a new player, or requesting a handicap change please monitor the player prior to this request.<br />
                                Then and only then submit a fair and suggested handicap. Do NOT assume that all new players receive +21 as this is not the case.<br /> <br />
                            </td>
                        </tr>
                        <tr>
                            <td class="col2">
                                <b>
                                <br />
                                Have you personally observed and made an assessment of the player's ability, over several frames?</b>
                                <div style="padding-left: 20px;padding-top:5px;padding-bottom: 5px">
                                <asp:RadioButtonList ID="Check1" runat="server" RepeatLayout="Flow" AutoPostBack="true" RepeatDirection="Horizontal">
                                    <asp:ListItem>&nbsp;&nbsp;Yes&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</asp:ListItem>
                                    <asp:ListItem>&nbsp;&nbsp;No</asp:ListItem>
                                </asp:RadioButtonList>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td class="col2">
                                <b>
                                <br />
                                Have you gathered all relevant information?</b>
                                <div style="padding-left: 20px;padding-top:5px;padding-bottom: 5px">
                                    (such as: the players record in practice against other league players; their highest break; their handicaps in other leagues; whether the player plays existing cue sports, and if so to what standard.)<br />
                                </div>
                                <div style="padding-left: 20px;padding-top:5px;padding-bottom: 5px">
                                <asp:RadioButtonList ID="Check2" runat="server" RepeatLayout="Flow" AutoPostBack="true" RepeatDirection="Horizontal">
                                    <asp:ListItem>&nbsp;&nbsp;Yes&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</asp:ListItem>
                                    <asp:ListItem>&nbsp;&nbsp;No</asp:ListItem>
                                </asp:RadioButtonList>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td class="col2">
                                <span style="color:red; font-weight:bold">
                                <br />
                                Do you understand that if you recommend a handicap which proves to be too high (due to not assessing the player properly, not declaring information about the player, etc) then POINTS REDUCTIONS may be applied.</span><br />
                                <div style="padding-left: 20px;padding-top:5px;padding-bottom: 5px">
                                <asp:RadioButtonList ID="Check3" runat="server" RepeatLayout="Flow" AutoPostBack="true" RepeatDirection="Horizontal">
                                    <asp:ListItem>&nbsp;&nbsp;Yes&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</asp:ListItem>
                                    <asp:ListItem>&nbsp;&nbsp;No</asp:ListItem>
                                </asp:RadioButtonList>
                                </div>
                            </td>
                        </tr>
                        <tr><td>
                            <asp:Literal ID="Check_Literal" runat="server"></asp:Literal></td></tr>
                    </table>
            </asp:Panel>

            <asp:Panel ID="Contact_Panel" runat="server">

                <table style="width: auto; margin-left: auto; margin-right: auto; border-collapse: collapse; background-color: #CCFFCC;">
                    <tr>
                        <td class="col1">Your name:</td>
                        <td class="col2">
                            <asp:TextBox ID="Name_TextBox" runat="server" CssClass="tBox" /></td>
                        <td class="col3">Mandatory</td>
                    </tr>
                    <tr>
                        <td class="col1">Your email address:</td>
                        <td class="col2">
                            <asp:TextBox ID="Email_TextBox" runat="server" class="tBox" /></td>
                        <td class="col3">Mandatory</td>
                    </tr>
                    <tr>
                        <td class="col1">Your Phone No:</td>
                        <td calss="col2">
                            <asp:TextBox ID="Phone_TextBox" runat="server" CssClass="tBox" /></td>
                        <td class="col3">This may be used for any queries.<br />
                            Mandatory for player registration/handicap requests.</td>
                    </tr>
                    <tr id="CompsRow" runat="server" visible="false">
                        <td class="col1">Select a competition:</td>
                        <td class="col2">&nbsp;&nbsp;&nbsp;&nbsp;<asp:DropDownList ID="Competitions_DropDownList" runat="server"></asp:DropDownList>
                        </td>
                        <td class="col3">Mandatory for Competitions Results</td>
                    </tr>
                    <tr id="HcapRow1" runat="server" visible="false">
                        <td class="col1">Player's Name:</td>
                        <td class="col2">
                            <asp:TextBox ID="Player_TextBox" runat="server" class="tBox" /></td>
                        <td class="col3">Mandatory</td>
                    </tr>
                    <tr id="HcapRow6" runat="server" visible="false">
                        <td class="col1">Player's Phone No:</td>
                        <td class="col2">&nbsp;&nbsp;&nbsp;&nbsp;<asp:TextBox ID="PlayerPhone_TextBox" runat="server" />
                        </td>
                        <td class="col3">Optional. 
                <br />
                            This will be stored in the HBSA database and can be accessed by other HBSA members, for arranging individual matches, etc. </td>
                    </tr>
                    <tr id="HcapRow2" runat="server" visible="false">
                        <td class="col1">League:</td>
                        <td class="col2">&nbsp;&nbsp;&nbsp;&nbsp;<asp:DropDownList ID="League_DropDownList" runat="server">
                        </asp:DropDownList></td>
                        <td class="col3">Mandatory - Choose one</td>
                    </tr>
                    <tr>
                        <td class="col1">Your club:</td>
                        <td class="col2">&nbsp;&nbsp;&nbsp;&nbsp;<asp:DropDownList ID="Clubs_DropDownList" runat="server"></asp:DropDownList></td>
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
                        <td class="col2" style="text-align: center;">
                            <asp:TextBox ID="Handicap_TextBox" runat="server" class="tBox" Width=" 50px" /></td>
                        <td class="col3">Mandatory (use minus sign (-) for handicap less than zero)</td>
                    </tr>
                    <tr id="HcapRow5" runat="server" visible="false">
                        <td class="col1">Reasons for suggested handicap:</td>
                        <td class="col2">
                            <asp:TextBox ID="Reasons_TextBox" runat="server" CssClass="tBox" Width="380px" Height="56px" TextMode="MultiLine" /></td>
                        <td class="col3">e.g. Player's Highest Break, handicap in other leagues, playing history etc.</td>
                    </tr>
                    <tr>
                        <td class="col1">Your message:</td>
                        <td class="col2" colspan="2" style="width: 560px; text-align: left;">
                            <asp:TextBox ID="body_TextBox" runat="server" CssClass="tBox" Width="560px" Height="106px" TextMode="MultiLine" /></td>
                    </tr>
                    <tr>
                        <td class="col1">Prove you're human:</td>
                        <td class="col2" colspan="2" style="width: 560px; text-align: center;">
                            <asp:UpdatePanel ID="captchaPanel" runat="server">
                                <ContentTemplate>
                                    &nbsp;&nbsp;&nbsp;&nbsp;Enter the code below in the box:<br />
                                    &nbsp;&nbsp;&nbsp;&nbsp;<asp:TextBox runat="server" ID="captcha_Textbox" Width="90px" Height="20px" />
                                    <img id="captcha_Image" runat="server" src="data:image/GIF;base64," style="height: 25px; width: 200px; vertical-align: -8px;" alt="Captcha Image" />
                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                              <asp:Button ID="captchaRefresh_Button" runat="server" Text="Click for new code" BackColor="#CCFFCC" BorderStyle="None" Font-Underline="True" ForeColor="#0066FF" />
                                </ContentTemplate>
                            </asp:UpdatePanel>
                        </td>
                    </tr>
                    <tr>
                        <td class="col1">Send the message:</td>
                        <td class="col2" colspan="2" style="width: 560px; text-align: center;">
                            <asp:CheckBox ID="Copy_CheckBox" runat="server" Text="Tick this box to send a copy to your email address" />
                            <br />
                            <asp:Button ID="Send_Button" runat="server" ForeColor="#004000" Text="Submit your request" />
                            <br />
                            <br />
                        </td>
                    </tr>
                </table>

                <span>
                    <asp:Literal ID="status_Literal" runat="server" Mode="PassThrough"></asp:Literal></span>
                <br />
                <br />
            </asp:Panel>

            <style type="text/css">
                .ThisPanel {
                    width: 100%;
                    text-align: center;
                }
            </style>

            <asp:Panel ID="MessageSent_Panel" runat="server" CssClass="ThisPanel" Visible="false">
                <br />
                <br />
                <asp:Literal ID="MessageSent_Literal" runat="server"></asp:Literal><br />
                <br />
                <a id="Home_Link" href="../Home.aspx">Return to the homepage</a>
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        <a id="Contact_Link" href="Contact.aspx">Submit another message</a>
                <br />
                <br />
            </asp:Panel>

        </ContentTemplate>
    </asp:UpdatePanel>

</asp:Content>
