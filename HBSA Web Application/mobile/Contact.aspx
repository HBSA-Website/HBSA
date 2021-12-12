<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/mobile/mobileMaster.Master" CodeBehind="Contact.aspx.vb" Inherits="HBSA_Web_Application.Contact1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
   
    <div class="PageHeader">
        Contact
    </div>
    <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>

        <asp:UpdateProgress runat="server" id="Update_Progress" DisplayAfter="10">
            <ProgressTemplate>
                <div id="Loading" style="position: fixed; left:600px;top:400px">
                    <asp:Image ID="loadingImage" runat="server" ImageUrl="~/images/AjaxLoading.gif" Width="100px" />
                </div>
            </ProgressTemplate>
        </asp:UpdateProgress>

    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>

        <asp:Panel ID="Contact_Panel" runat="server">
    <div style="width:100%; text-align:center;">
    To email us please enter your details, select where email should go,  enter the &quot;Prove you&#39;re human&quot; code, then click "Send your message".
    </div>
    <br />
        <table>
            <tr>
                <td>Select where the email should be sent:</td>
                <td><asp:DropDownList ID="Destination_DropDownList" runat="server" AutoPostBack="true"></asp:DropDownList></td>
            </tr>
            <tr>
                <td>Your name:</td>
                <td><asp:TextBox ID="name_TextBox" runat="server" ></asp:TextBox>
                    <br />
                </td>
            </tr>
            <tr>
                <td style="width:25%">Your email address:</td>
                <td style="width:75%"><asp:TextBox ID="Email_TextBox" runat="server" ></asp:TextBox>
                    <br />
                </td>
            </tr>
            <tr>
                <td>Your Phone No:</td>
                <td><asp:TextBox ID="Phone_TextBox" runat="server" />
                    <br />
                </td>
            </tr>
            <tr id="CompsRow" runat="server" visible="false">
                <td>Select a competition:</td>
                <td><asp:DropDownList ID="Competitions_DropDownList" runat="server"></asp:DropDownList>
                    <br />
                </td>
            </tr>
        <tr id="HcapRow7" runat="server" visible="false">
            <td>Justify handicap:</td>
            <td style="background-color:white;">
                Please Note :- When registering a new player, or requesting a handicap change please monitor the player prior to this request. Then and only then submit a fair and suggested handicap. Do NOT assume that all new players receive +21 as this is not the case.<br />
                <span style="color:red;">If a handicap is later proven to be unfair sanctions may be applied to the team.</span><br /><br />
                <asp:CheckBox ID="Justify_CheckBox" CssClass="BigCheckBox" runat="server" Text="Tick this box to indicate you have read the note above, and that you agree and will comply." Font-Italic="False" ForeColor="Blue" />
                <br />
            </td>
        </tr>
        <tr id="HcapRow1" runat="server" visible="false">
            <td>Player's Name:</td>
            <td><asp:TextBox ID="Player_TextBox" runat="server" class="tBox" />
                <br />
            </td>
        </tr>
        <tr id="HcapRow6" runat="server" visible="false">
            <td>Player's Phone No:</td>
            <td><asp:TextBox ID="PlayerPhone_TextBox" runat="server" /> 
                <br />
            </td>
        </tr>
        <tr id="HcapRow2" runat="server" visible="false">
            <td>League:</td>
            <td><asp:DropDownList ID="League_DropDownList" runat="server" />
                <br />
            </td>
        </tr>
            <tr>
                <td>Your club:</td>
                <td><asp:DropDownList ID="Clubs_DropDownList" runat="server" ></asp:DropDownList>
                    <br />
                </td>
            </tr>
        <tr id="HcapRow3" runat="server" visible="false">
            <td>Team that the request relates to:</td>
            <td><asp:DropDownList ID="Team_DropDownList" runat="server">
                                                        <asp:ListItem>** Select a Team **</asp:ListItem>
                                                        <asp:ListItem>' ' (no team letter)</asp:ListItem>
                                                        <asp:ListItem>'A'</asp:ListItem>
                                                        <asp:ListItem>'B'</asp:ListItem>
                                                        <asp:ListItem>'C'</asp:ListItem>
                                                        <asp:ListItem>'D'</asp:ListItem>
                                                        <asp:ListItem>'E'</asp:ListItem>
                                                        <asp:ListItem>'F'</asp:ListItem>
                                                     </asp:DropDownList>
                <br />
            </td>
        </tr>
        <tr id="HcapRow4" runat="server" visible="false">
            <td>Suggested Handicap:</td>
            <td><asp:TextBox ID="Handicap_TextBox" runat="server" Width =" 100px"  />
                <br />
            </td>
        </tr>
        <tr id="HcapRow5" runat="server" visible="false">
            <td>Reasons for suggested handicap:</td>
            <td><asp:TextBox ID="Reasons_TextBox" runat="server"  TextMode="MultiLine"  width="70%" Height="180" />
                <br />
            </td>
        </tr>

            <tr>
                <td>Your message:</td>
                <td><asp:TextBox ID="body_TextBox" runat="server" TextMode="MultiLine" width="90%" Height="240"></asp:TextBox></td>
            </tr>
            <tr>
                <td>Prove you're human:</td>
                <td>
                            Enter the code below in the box: <em>(Note it&#39;s case sensitive)</em><br />
                            <img id="captcha_Image" runat="server" src="data:image/GIF;base64," style="height:76px;" alt="Captcha Image" /><br />
                            <asp:TextBox runat="server" ID="captcha_Textbox" />
                            <br /><br /><asp:Button ID="captchaRefresh_Button" runat="server" Text="Click for new code" BorderStyle="None" Font-Underline="True" ForeColor="#0066FF" />
                            <br />
                </td>
            </tr>
            <tr>
                <td>Send the message:</td>
                <td style="text-align:center"><asp:CheckBox ID="Copy_CheckBox" CssClass="BigCheckBox" runat="server" Text="Tick/Touch this box to send a copy to your email address"/>
                <br />
                    <asp:Button ID="Send_Button" runat="server" ForeColor="#004000" Text="Send your message" /><br /><br /></td>
            </tr>
        </table>

    <span><asp:Literal ID="status_Literal" runat="server" Mode="PassThrough"></asp:Literal></span>
    <br />
    <br />
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
        <asp:HyperLink ID="Home_HyperLink" runat="server" NavigateUrl="Home.aspx">Return to the homepage</asp:HyperLink>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        <asp:HyperLink ID="Contact_HyperLink" runat="server" NavigateUrl="Contact.aspx">Submit another message</asp:HyperLink>
        <br /><br />
    </asp:Panel> 

      </ContentTemplate>
    </asp:UpdatePanel>

</asp:Content>
