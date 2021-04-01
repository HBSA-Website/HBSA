<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/mobile/mobileMaster.Master" CodeBehind="Contact.aspx.vb" Inherits="HBSA_Web_Application.Contact1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
   
    <div class="PageHeader">
        Contact
    </div>
    <div style="width:100%; text-align:center;">
    To email us please enter your details, select where email should go,  enter the &quot;Prove you&#39;re human&quot; code, then click "Send your message".
    </div>
    <br />

        <table>
            <tr>
                <td style="width:25%">Your email address:</td>
                <td style="width:75%"><asp:TextBox ID="from_TextBox" runat="server" ></asp:TextBox></td>
            </tr>
            <tr>
                <td>Your name:</td>
                <td><asp:TextBox ID="name_TextBox" runat="server" ></asp:TextBox></td>
            </tr>
            <tr>
                <td>Your club:</td>
                <td><asp:TextBox ID="club_TextBox" runat="server" ></asp:TextBox></td>
            </tr>
            <tr>
                <td>Select where the email should be sent:</td>
                <td><asp:DropDownList ID="Destination_DropDownList" runat="server" AutoPostBack="true"></asp:DropDownList></td>
            </tr>
            <tr id="CompsRow" runat="server" visible="false">
                <td>Select a competition:</td>
                <td><asp:DropDownList ID="Competitions_DropDownList" runat="server"></asp:DropDownList></td>
            </tr>
            <tr>
                <td>Your message:</td>
                <td><asp:TextBox ID="body_TextBox" runat="server" TextMode="MultiLine" width="90%" Height="240"></asp:TextBox></td>
            </tr>
            <tr>
                <td>Prove you're human:</td>
                <td>
                            Enter the code below in the box: <em>(Note it&#39;s case sensitive)</em><br />
                            <asp:TextBox runat="server" ID="captcha_Textbox" />
                            <img id="captcha_Image" runat="server" src="data:image/GIF;base64," style="height:76px;" alt="Captcha Image" />
                            <asp:Button ID="captchaRefresh_Button" runat="server" Text="Click for new code" BorderStyle="None" Font-Underline="True" ForeColor="#0066FF" />
                </td>
            </tr>
            <tr>
                <td>Send the message:</td>
                <td><asp:Button ID="Send_Button" runat="server" ForeColor="#004000" Text="Send your message" /></td>
            </tr>
        </table>



    <span><asp:Literal ID="status_Literal" runat="server" Mode="PassThrough"></asp:Literal></span>
    <br />
    <br />


</asp:Content>
