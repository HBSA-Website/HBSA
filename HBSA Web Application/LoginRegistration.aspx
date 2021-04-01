<%@ Page Title="" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" Inherits="HBSA_Web_Application.LoginRegistration" Codebehind="LoginRegistration.aspx.vb" %>

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

            <div style="text-align:center; " class="auto-style3">
                <h3><asp:Literal ID="Header_Literal" runat="server">Team Representative's Login Registration</asp:Literal></h3>
            </div>

   <div style="text-align:center; width: 100%; font-family: Verdana; color:Green;font-size:9pt;background-color:#CCFFCC" >
        <table>
            <tr>
                <td colspan="3" style="text-align:left;font-size:11pt;color:black">Enter your details and click Confirm:</td>
            </tr>
            <tr >
                <td></td>
                <td style="text-align:left;font-size:11pt;color:black">NOTE:</td>
                <td style="text-align:left;font-size:11pt;color:black">You will need a separate registration for each team in your club.</td>
            </tr>
            <tr>
                <td></td>
                <td></td>
                <td style="text-align:left;font-size:11pt;color:black">These can have the same email address but will need a different password for each team. 
                    <br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Therefore, ensure you enter the correct team letter for the password.</td>
            </tr>
            <tr>
                <td></td>
                <td></td>
                <td style="text-align:left;font-size:11pt;color:black">You cannot use the same email address more than once for a particular team.</td>
            </tr>
        </table>
    <br />

    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>

    <table align="center" style=" border-top-width: thin; border-left-width: thin; font-size: 11pt; 
                  border-left-color: #006600; border-bottom-width: thin; border-bottom-color: #006600;
                  color: #006600; border-top-color: #006600; font-family: Verdana; border-right-width: thin; 
                  border-right-color: #006600;" bgcolor="#CCFFCC">
        <tr style="height:30px">
            <td style="border-right: #006600 1px solid; border-top: #006600 1px solid; font-size: 9pt; vertical-align: middle; border-left: #006600 1px solid; color: #006600; border-bottom: #006600 1px solid; font-family: Verdana; text-align: right">
                League:</td>
            <td style="border-right: #006600 1px solid; border-top: #006600 1px solid; font-size: 9pt; border-left: #006600 1px solid; color: #006600; border-bottom: #006600 1px solid; font-family: Verdana; text-align: left;">
                <asp:DropDownList ID="League_DropDownList" runat="server" AutoPostBack="True">
                   
                </asp:DropDownList>
            </td>
            <td rowspan="12" style="background-color: #FFFFFF;font-size: 9pt; color:black; vertical-align:top; text-align:left">
                <table cellpadding="2px">
                    <tr>
                        <td colspan="2">
                            Registration is a 3 step process.  The email address has to be verified.
                        </td>
                    </tr>
                    <tr style="vertical-align:top">
                        <td>1.</td>
                        <td>
                           Enter the registration details and click Register. The system will then check the details
                           and if they are acceptable they are recorded in the database.  At this stage the registration
                           is in an unconfirmed state and cannot be used successfully.
                        </td>
                    </tr>
                    <tr style="vertical-align:top">
                        <td>2.</td>
                        <td>
                           An email is sent to the league secretary, and to the email address entered.  It contains
                           instructions on how to confirm the email address, along with a confirmation code and a link
                           back to the web site.
                        </td>
                    </tr>
                    <tr style="vertical-align:top">
                        <td>3.</td>
                        <td>   When the email arrives there are two options:
                            <table cellpadding="2px">
                                <tr style="vertical-align:top">
                                    <td>1.</td>
                                    <td>Click the link in the email. This should 
                                        open up your web browser at the login confirmation page with all details completed except your password.
                                        Simply enter your password and click confirm.</td>
                                </tr>
                                <tr style="vertical-align:top">
                                     <td>2.</td>
                                    <td>
                                        The email will contain your confirmation code.
                                        On the Huddersfield Snooker web site go to team log in and enter your email address and password
                                        and click Login.  You will be taken to the Login Confirmation page with all details completed except your 
                                        password and the confirmation code. Enter your password and the confirmation code (it is
                                        recommended that you copy and paste this code as it is case sensitive).  Then click confirm.
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2">
                                        When the confirm button is clicked and if the confirmation succeeds you will be taken to the login page.
                                    </td>
                                </tr>
                            </table>
                            </td>
                        </tr>
                </table>

            </td>
        </tr>
        <tr style="height:30px">
            <td style="border-right: #006600 1px solid; border-top: #006600 1px solid; font-size: 9pt; vertical-align: middle; border-left: #006600 1px solid; color: #006600; border-bottom: #006600 1px solid; font-family: Verdana; text-align: right">
                Division/Section:</td>
            <td style="border-right: #006600 1px solid; border-top: #006600 1px solid; font-size: 9pt; border-left: #006600 1px solid; color: #006600; border-bottom: #006600 1px solid; font-family: Verdana; text-align: left;">
                <asp:DropDownList ID="Section_DropDownList" runat="server" Visible="False" 
                    AutoPostBack="True">
                    
                </asp:DropDownList>
            </td>
        </tr>
        <tr style="height:30px">
            <td style="border-right: #006600 1px solid; border-top: #006600 1px solid; font-size: 9pt; vertical-align: middle; border-left: #006600 1px solid; color: #006600; border-bottom: #006600 1px solid; font-family: Verdana; text-align: right">
               Club&nbsp;name:</td>
            <td style=" border-right: #006600 1px solid; border-top: #006600 1px solid; font-size: 9pt; border-left: #006600 1px solid; color: #006600; border-bottom: #006600 1px solid; font-family: Verdana; text-align: left;">
                <asp:DropDownList ID="Club_DropDownList" runat="server" AutoPostBack="True" 
                    Visible="False">
                   
                </asp:DropDownList>
            </td>
        </tr>
        <tr style="height:30px">
            <td style="border-right: #006600 1px solid; border-top: #006600 1px solid; font-size: 9pt; vertical-align: middle; border-left: #006600 1px solid; color: #006600; border-bottom: #006600 1px solid; font-family: Verdana; text-align: right">
                Team&nbsp;Letter:</td>
            <td style="border-right: #006600 1px solid; border-top: #006600 1px solid; font-size: 9pt; border-left: #006600 1px solid; color: #006600; border-bottom: #006600 1px solid; font-family: Verdana; text-align: left;">
                <asp:DropDownList ID="TeamLetter_DropDownList" runat="server" Visible="False">
                </asp:DropDownList>
            </td>
        </tr>
        <tr style="height:30px">
            <td style="border-right: #006600 1px solid; border-top: #006600 1px solid; font-size: 9pt; vertical-align: middle; border-left: #006600 1px solid; color: #006600; border-bottom: #006600 1px solid; font-family: Verdana; text-align: right">
                Your first/preferred name:</td>
            <td style=" border-right: #006600 1px solid; border-top: #006600 1px solid; font-size: 9pt; border-left: #006600 1px solid; color: #006600; border-bottom: #006600 1px solid; font-family: Verdana; text-align: left;">
                <asp:TextBox ID="FirstName_TextBox" runat="server" BorderWidth="0px" Width="220px"></asp:TextBox></td>
        </tr>
        <tr style="height:30px">
            <td style="border-right: #006600 1px solid; border-top: #006600 1px solid; font-size: 9pt; vertical-align: middle; border-left: #006600 1px solid; color: #006600; border-bottom: #006600 1px solid; font-family: Verdana; text-align: right">
                Surname:</td>
            <td style=" border-right: #006600 1px solid; border-top: #006600 1px solid; font-size: 9pt; border-left: #006600 1px solid; color: #006600; border-bottom: #006600 1px solid; font-family: Verdana; text-align: left;">
                <asp:TextBox ID="Surname_TextBox" runat="server" BorderWidth="0px" Width="220px"></asp:TextBox></td>
        </tr>
        <tr style="height:30px">
            <td style="border-right: #006600 1px solid; border-top: #006600 1px solid; font-size: 9pt; vertical-align: middle; border-left: #006600 1px solid; color: #006600; border-bottom: #006600 1px solid; font-family: Verdana; text-align: right">
                Telephone:</td>
            <td style=" border-right: #006600 1px solid; border-top: #006600 1px solid; font-size: 9pt; border-left: #006600 1px solid; color: #006600; border-bottom: #006600 1px solid; font-family: Verdana; text-align: left;">
                <asp:TextBox ID="Telephone_TextBox" runat="server" BorderWidth="0px" Width="220px"></asp:TextBox></td>
        </tr>
                
        <tr style="height:30px">
            <td style="border-right: #006600 1px solid; border-top: #006600 1px solid; font-size: 9pt; vertical-align: middle; border-left: #006600 1px solid; color: #006600; border-bottom: #006600 1px solid; font-family: Verdana; text-align: right">
                Your email address:</td>
            <td style=" border-right: #006600 1px solid; border-top: #006600 1px solid; font-size: 9pt; border-left: #006600 1px solid; color: #006600; border-bottom: #006600 1px solid; font-family: Verdana; text-align: left;">
                <asp:TextBox ID="email_TextBox" runat="server" BorderWidth="0px" Width="220px"></asp:TextBox></td>
        </tr>
        <tr style="height:30px">
            <td style="border-right: #006600 1px solid; border-top: #006600 1px solid; font-size: 9pt; vertical-align: middle; border-left: #006600 1px solid; color: #006600; border-bottom: #006600 1px solid; font-family: Verdana; text-align: right">
                Password:
            </td>
            <td style=" border-right: #006600 1px solid; border-top: #006600 1px solid; font-size: 9pt; border-left: #006600 1px solid; color: #006600; border-bottom: #006600 1px solid; font-family: Verdana; text-align: left;">
                <asp:TextBox ID="Password_TextBox" ClientIDMode="Static" runat="server" BorderWidth="0px" Width="182px" TextMode="Password"></asp:TextBox>
                <img title="Click to show password" alt="Click to show password" src="../images/EyeClosed.jpg" height="15"
                                                             onclick="showHidePassword(this,'Password_TextBox'); " />
            </td>
        </tr>
        <tr style="height:30px">
            <td style="border-right: #006600 1px solid; border-top: #006600 1px solid; font-size: 9pt; vertical-align: middle; border-left: #006600 1px solid; color: #006600; border-bottom: #006600 1px solid; font-family: Verdana; text-align: right">
               Confirm&nbsp;password:</td>
            <td style=" border-right: #006600 1px solid; border-top: #006600 1px solid; font-size: 9pt; border-left: #006600 1px solid; color: #006600; border-bottom: #006600 1px solid; font-family: Verdana; text-align: left;">
                <asp:TextBox ID="ConfirmPassword_TextBox" ClientIDMode="Static" runat="server" BorderWidth="0px" Width="182px" TextMode="Password"></asp:TextBox>
                <img title="Click to show password" alt="Click to show password" src="../images/EyeClosed.jpg" height="15"
                                                             onclick="showHidePassword(this,'ConfirmPassword_TextBox'); " />
            </td>
        </tr>
        <tr>
              <td style="border-right: #006600 1px solid; border-top: #006600 1px solid; font-size: 9pt;
                vertical-align: middle; border-left: #006600 1px solid;color: #006600;
                border-bottom: #006600 1px solid; font-family: Verdana; text-align:right;" >
                Prove you're human:
            </td>

            <td style="border-right: #006600 1px solid; border-top: #006600 1px solid; font-size: 9pt;
                border-left: #006600 1px solid; color: #006600; border-bottom: #006600 1px solid;
                font-family: Verdana; text-align: left;">
                    <asp:UpdatePanel ID="captchaPanel" runat="server">
                        <ContentTemplate>
                             Enter the code below in the box: <em>(Note it&#39;s case sensitive)</em><br />
                             <asp:TextBox runat="server" ID="captcha_Textbox" Width="90px" Height="20px"/>
                             <img id="captcha_Image" runat="server" style="height: 25px; width: 200px;vertical-align: -8px;" alt="Captcha Image" class="auto-style2" /> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                             <asp:Button ID="captchaRefresh_Button" runat="server" Text="Click for new code" BackColor="#CCFFCC" BorderStyle="None" Font-Underline="True" ForeColor="#0066FF" />
                       </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>



         <tr>
        <td colspan="2"><asp:Label ID="Status_Label" runat="server" 
                    Text=""
                    ForeColor="Blue"></asp:Label></td>
        </tr>
       
        <tr>
        <td align="center"><asp:Button ID="Return_Button" runat="server" Text="Return" Height="30px" Width="121px" /></td>
        <td align="center"><asp:Button ID="Register_Button" runat="server" Text="Register" Height="30px" Width="121px" /></td>
        </tr>
    </table>
 
        </ContentTemplate>
    </asp:UpdatePanel>

    </div>

</asp:Content>

