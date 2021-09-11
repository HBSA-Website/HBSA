<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/mobile/MobileMaster.master" CodeBehind="PlayerRegistrationRequest.aspx.vb" Inherits="HBSA_Web_Application.PlayerRegistrationRequest1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
  <style type="text/css">
      input {
          width:400px;
      }
      textarea {
          width:400px;
      }
  </style>
    <div class="PageHeader">
        Player Registration Request
    </div>
    <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>   
    <div style="width:100%; text-align:left;color:black;">
    Enter the details, enter the &quot;Prove you&#39;re human&quot; code, then click "Send".
        <br />
    </div>
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
    <ContentTemplate>
        <table style="max-height:99999px; width:auto;margin-left:auto;margin-right:auto;color:black">
            <tr>
                <td>Your name:</td>
                <td colspan="2"><asp:TextBox ID="RequesterName_TextBox" runat="server"></asp:TextBox></td>
            </tr>
            <tr>
                <td>Your email address:</td>
                <td><asp:TextBox ID="RequesterEmail_TextBox" runat="server"></asp:TextBox></td>
                <td>When this request has been processed, this email address will be used to communicate the outcome.</td>
            </tr>
            <tr>
                <td>Player&#39;s full Name:</td>
                <td colspan="2"><asp:TextBox ID="PlayerName_TextBox" runat="server"></asp:TextBox></td>
            </tr>
            <tr>
                <td>Division or Section:</td>
                <td colspan="2"><asp:DropDownList ID="Section_DropDownList" runat="server" AutoPostBack="true" ></asp:DropDownList></td>
            </tr>
            <tr>
                <td>Player&#39;s Team:</td>
                <td colspan="2"><asp:DropDownList ID="Team_DropDownList" runat="server"></asp:DropDownList>
                    &nbsp;<span style="color:red"><asp:Literal ID="Team_Literal" runat="server"></asp:Literal></span>
                </td>
            </tr>
            <tr>
                <td>Suggested Handicap:</td>
                <td style="text-align:center"><asp:TextBox ID="Handicap_TextBox" runat="server" Width="66px"></asp:TextBox></td>
                <td>Enter a sensible handicap suggestion.  In the comments box below please explain your justification for the suggestion</td>
            </tr>
            <tr id="Over80Row" runat="server">
                <td>Over 80?</td>
                <td style="text-align:center"><asp:CheckBox ID="Over80_CheckBox" runat="server" CssClass="BigCheckBox" Text=" " /></td>
                <td>Tick this box if the player to be registered is over 80 Years of age.</td>
            </tr>
            <tr>
                <td>Players email address:</td>
                <td><asp:TextBox ID="PlayerEmail_TextBox" runat="server"></asp:TextBox></td>
                <td> (Optional)</td>
            </tr>
            <tr>
                <td>Players phone no.:</td>
                <td><asp:TextBox ID="PlayerTelNo_TextBox" runat="server"></asp:TextBox></td>
                <td> (Optional)</td>
            </tr>
            <tr>
                <td>Comments:<br/><br/>Reason for Handicap:</td>
                <td><asp:TextBox ID="body_TextBox" runat="server" TextMode="MultiLine" Height="360"></asp:TextBox></td>
                <td rowspan="3">When the request is sent, an email will be sent to the committee who will consider the request and 
                                the handicap set accordingly.  You will be informed by the email address given at the start of the outcome.
                                If the player's email has been completed a copy of the email will be sent there as well. 
                </td>
            </tr>
            <tr>
                <td>Prove you're human:</td>
                <td style="font-size:24px;">
                            Enter the code below in the box: <br /><em>(Note it&#39;s case sensitive)</em><br />
                            <img id="captcha_Image" runat="server" src="data:image/GIF;base64," style="height:76px;" alt="Captcha Image" /><br />
                            <asp:TextBox runat="server" ID="captcha_Textbox" /><br />
                            <asp:Button ID="captchaRefresh_Button" runat="server" Text="Click for new code" BorderStyle="None" Font-Underline="True" ForeColor="#0066FF" BackColor="White" />
                </td>
            </tr>
            <tr>
                <td>Send the message:</td>
                <td><asp:Button ID="Send_Button" runat="server" ForeColor="#004000" Text="Send" /></td>
            </tr>
        </table>
    <asp:Literal ID="status_Literal" runat="server" Mode="PassThrough"></asp:Literal>
    </ContentTemplate>
    </asp:UpdatePanel>
    <br />
</asp:Content>
