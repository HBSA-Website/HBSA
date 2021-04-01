<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/MasterPage.master" CodeBehind="ClubLoginRegistration.aspx.vb" Inherits="HBSA_Web_Application.ClubLoginRegistration" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .auto-style3 {
            width: 100%;
        }
    </style>
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

    <div style="text-align:center; width: 100%;">

        <div style="width:100%; font-family: Verdana; color:DarkGrey;font-size:9pt;background-color:#FFFFFF" >

            <div style="text-align:center; " class="auto-style3">
                <h3><asp:Literal ID="Header_Literal" runat="server">Club Representative's Login Registration</asp:Literal></h3>
            </div>
            
            <br />
            Enter your details and click Submit:<br />
            NOTE: There can only be one registration for each club.<br /><br />
        </div>
    </div>
    <br />

    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>

    <table style="width:auto; margin-left:auto; margin-right:auto; border-top-width: thin; border-left-width: thin; font-size: 11pt; 
                  border-left-color: #333333; border-bottom-width: thin; border-bottom-color: #333333;
                  color: #333333; border-top-color: #333333; font-family: Verdana; border-right-width: thin; 
                  border-right-color: #333333; background:#FFFFFF">

         <tr>
            <td colspan="2"><asp:Literal ID="Status_Literal" runat="server" Text=""></asp:Literal></td>
        </tr>
       
        <tr style="height:30px">
            <td style="border-right: #333333 1px solid; border-top: #333333 1px solid; font-size: 9pt; vertical-align: middle; border-left: #333333 1px solid; color: #333333; border-bottom: #333333 1px solid; font-family: Verdana; text-align: right">
               Club name:</td>
            <td style=" border-right: #333333 1px solid; border-top: #333333 1px solid; font-size: 9pt; border-left: #333333 1px solid; color: #333333; border-bottom: #333333 1px solid; font-family: Verdana; text-align: left;">
                <asp:DropDownList ID="Club_DropDownList" runat="server" AutoPostBack="True" />
            </td>
               <td></td>
            <td rowspan="12" style="background-color: #FFFFFF; color:black; vertical-align:top;">
                <table>
                    <tr>
                        <td colspan="2" style="padding:2px;">
                            <span style="font-size: larger; font-weight: bold">This form is for either a new Registration, or for changing an existing one.
                                    It is a 3 step process.  The email address has to be verified.<br /></span>
                        </td>
                    </tr>
                    <tr style="vertical-align:top;">
                        <td style="padding:2px;">1.</td>
                        <td style="padding:2px;">
                            Enter or amend the registration details and click Submit. The system will then 
                            check the details and if they are acceptable they are recorded in the database. 
                            At this stage the registration is in an unconfirmed state and cannot be used 
                            successfully.
                        </td>
                    </tr>
                    <tr style="vertical-align:top">
                        <td style="padding:2px;">2.</td>
                        <td style="padding:2px;">
                           An email is sent to the league secretary, and to the email address entered.  It contains
                           instructions on how to confirm the email address, along with a confirmation code and a link
                           back to the web site.
                        </td>
                    </tr>
                    <tr style="vertical-align:top">
                        <td style="padding:2px;">3.</td>
                        <td style="padding:2px;">   When the email arrives there are two options:
                            <table>
                                <tr style="vertical-align:top">
                                    <td style="padding:2px;">3.1</td>
                                    <td style="padding:2px;">Click the link in the email. This should 
                                        open up your web browser at the login confirmation page with all details completed except your password.
                                        Simply enter your password and click confirm.</td>
                                </tr>
                                <tr style="vertical-align:top">
                                     <td style="padding:2px;">3.2</td>
                                    <td style="padding:2px;">
                                        The email will contain your confirmation code. On the Huddersfield Snooker web site click Club Log in and enter your email address and
                                         password and click Login. You will be taken to the Login Confirmation page with all details completed except your password and the
                                         confirmation code. Enter your password and the confirmation code (it is recommended that you copy and paste this code as it is case sensitive).
                                         Then click confirm.<br /><br />
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
            <td style="border-right: #333333 1px solid; border-top: #333333 1px solid; font-size: 9pt; vertical-align: middle; border-left: #333333 1px solid; color: #333333; border-bottom: #333333 1px solid; font-family: Verdana; text-align: right">
                Email&nbsp;address&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                <br />
                (to&nbsp;be&nbsp;used&nbsp;at&nbsp;login):</td>
            <td style=" border-right: #333333 1px solid; border-top: #333333 1px solid; font-size: 9pt; border-left: #333333 1px solid; color: #333333; border-bottom: #333333 1px solid; font-family: Verdana; text-align: left;">
                <asp:TextBox ID="email_TextBox" runat="server" BorderWidth="0px" Width="220px"></asp:TextBox></td>
        </tr>
        <tr style="height:30px">
            <td style="border-right: #333333 1px solid; border-top: #333333 1px solid; font-size: 9pt; vertical-align: middle; border-left: #333333 1px solid; color: #333333; border-bottom: #333333 1px solid; font-family: Verdana; text-align: right">
                <asp:Literal ID="Password_Literal" runat="server">Password:</asp:Literal></td>
            <td style=" border-right: #333333 1px solid; border-top: #333333 1px solid; font-size: 9pt; border-left: #333333 1px solid; color: #333333; border-bottom: #333333 1px solid; font-family: Verdana; text-align: left;">
                <asp:TextBox ID="RegistrationPassword_TextBox" ClientIDMode="Static" runat="server" BorderWidth="0px" Width="176px" TextMode="Password"></asp:TextBox>
                <img title="Click to show password" alt="Click to show password" src="../images/EyeClosed.jpg" height="15"
                    onclick="showHidePassword(this,'RegistrationPassword_TextBox'); " />
            </td>
            <td id="Password_Comment" runat="server" rowspan="2"><i>Leave these blank to preserve<br />the existing password</i></td>
        </tr>
        <tr style="height:30px">
            <td style="border-right: #333333 1px solid; border-top: #333333 1px solid; font-size: 9pt; vertical-align: middle; border-left: #333333 1px solid; color: #333333; border-bottom: #333333 1px solid; font-family: Verdana; text-align: right">
               Confirm password:</td>
            <td style=" border-right: #333333 1px solid; border-top: #333333 1px solid; font-size: 9pt; border-left: #333333 1px solid; color: #333333; border-bottom: #333333 1px solid; font-family: Verdana; text-align: left;">
                <asp:TextBox ID="ConfirmPassword_TextBox" ClientIDMode="Static" runat="server" BorderWidth="0px" Width="176px" TextMode="Password"></asp:TextBox>
                <img title="Click to show password" alt="Click to show password" src="../images/EyeClosed.jpg" height="15"
                                                             onclick="showHidePassword(this,'ConfirmPassword_TextBox'); " />
            </td>
        </tr>
        <tr style="height:30px">
            
            <td style=" border-right: #333333 1px solid; border-top: #333333 1px solid; font-size: 9pt; vertical-align: middle;
                                   border-left: #333333 1px solid; color: #333333; border-bottom: #333333 1px solid; font-family: Verdana; text-align: right">
                Your first/preferred name:</td>
            <td style="
                border-right: #333333 1px solid; border-top: #333333 1px solid; font-size: 9pt; 
                border-left: #333333 1px solid; color: #333333; border-bottom: #333333 1px 
                solid; font-family: Verdana; text-align: left;">
                <asp:TextBox ID="FirstName_TextBox" runat="server" BorderWidth="0px" 
                    Width="220px"></asp:TextBox>
                </td>

        </tr>
        <tr style="height:30px">
            <td style="border-right: #333333 1px solid; border-top: #333333 1px solid; font-size: 9pt; vertical-align: middle; border-left: #333333 1px solid; color: #333333; border-bottom: #333333 1px solid; font-family: Verdana; text-align: right">
                Surname:</td>
            <td style=" border-right: #333333 1px solid; border-top: #333333 1px solid; font-size: 9pt; border-left: #333333 1px solid; color: #333333; border-bottom: #333333 1px solid; font-family: Verdana; text-align: left;">
                <asp:TextBox ID="Surname_TextBox" runat="server" BorderWidth="0px" Width="220px"></asp:TextBox></td>
        </tr>
        <tr style="height:30px">
            <td style="border-right: #333333 1px solid; border-top: #333333 1px solid; font-size: 9pt; vertical-align: middle; border-left: #333333 1px solid; color: #333333; border-bottom: #333333 1px solid; font-family: Verdana; text-align: right">
                Telephone:</td>
            <td style=" border-right: #333333 1px solid; border-top: #333333 1px solid; font-size: 9pt; border-left: #333333 1px solid; color: #333333; border-bottom: #333333 1px solid; font-family: Verdana; text-align: left;">
                <asp:TextBox ID="Telephone_TextBox" runat="server" BorderWidth="0px" Width="220px"></asp:TextBox></td>
        </tr>
                
        <tr>
              <td style="border-right: #006600 1px solid; border-top: #006600 1px solid; font-size: 9pt;
                vertical-align: middle; border-left: #006600 1px solid;
                border-bottom: #006600 1px solid; font-family: Verdana; text-align:right;" >
                Prove you're human:
            </td>

            <td style="border-right: #006600 1px solid; border-top: #006600 1px solid; font-size: 9pt;
                border-left: #006600 1px solid; border-bottom: #006600 1px solid;
                font-family: Verdana; text-align: left;">
                    <asp:UpdatePanel ID="captchaPanel" runat="server">
                        <ContentTemplate>
                             Enter the code below in the box: <em>(Note it&#39;s case sensitive)</em><br />
                             <asp:TextBox runat="server" ID="captcha_Textbox" Width="90px" Height="20px"/>
                             <img id="captcha_Image" runat="server" style="height: 25px; width: 200px;vertical-align: -8px;" alt="Captcha Image" class="auto-style2" /> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                             <asp:Button ID="captchaRefresh_Button" runat="server" Text="Click for new code" BackColor="#ffFFff" BorderStyle="None" Font-Underline="True" ForeColor="#0066FF" />
                       </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>

        <tr>
        <td style="text-align:center"><asp:Button ID="Return_Button" runat="server" Text="Return" Height="30px" Width="121px" /></td>
        <td style="text-align:center"><asp:Button ID="submitButton" runat="server" Text="Submit" Height="30px" Width="121px" visible="false"/></td>
        </tr>
    </table>
 
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
