<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/mobile/mobileMaster.Master" CodeBehind="ClubLoginRegistration.aspx.vb" Inherits="HBSA_Web_Application.ClubLoginRegistration1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <asp:HiddenField ID="profiling" runat="server" />
    <asp:HiddenField ID="clubIDhidden" runat="server" />

    <div class="SmallHeader">
         <span onclick="helpDiv.style.display = 'block';" onmouseover="this.style.cursor='pointer';" >
            Club Representative's Login Registration<br />
            This form is for either a new Registration, or for changing an existing one.
                                    It is a 3 step process.  The email address has to be verified.<br />
            <img height="40" alt="Help" title="Explanation" src="../images/BlueQuestionMark18.bmp"/>
          </span>
        <br />

        <div id="helpDiv" class="pageDiv" style="display:none;color:black;"
             onmouseover="this.style.cursor='pointer';"  onclick="helpDiv.style.display = 'none';" >
            <table style="width:100%">
            <tr>
                <td style=" text-align:left; border:none;
                        background-image: url('../images/menuBarBG.gif'); text-align:center;">
                    <u>Club login registration / change procedure</u></td>
            </tr>
            </table>
            <table>
                    <tr style="vertical-align:top">
                        <td>1.</td>
                        <td>
                            Enter or amend the registration details and click Submit. The system will then 
                            check the details and if they are acceptable they are recorded in the database. 
                            At this stage the registration is in an unconfirmed state and cannot be used 
                            successfully.
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
                            <table>
                                <tr style="vertical-align:top">
                                    <td>3.1</td>
                                    <td>Click the link in the email. This should 
                                        open up your web browser at the login confirmation page with all details completed except your password.
                                        Simply enter your password and click confirm.</td>
                                </tr>
                                <tr style="vertical-align:top">
                                     <td>3.2</td>
                                    <td>
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
        </div>

        <asp:Literal ID="loginLiteral" runat="server" /> &nbsp;
        <asp:Literal ID="passwordLiteral" runat="server" /> &nbsp;
        <asp:Literal ID="nameLiteral" runat="server" />
    </div>

    <div id="panelsDiv" runat="server">
    <br />
    <asp:Label ID="statusLabel" runat="server" Text="" ForeColor="Red"></asp:Label>

    <asp:Panel ID="loginPanel" runat="server" Visible="true">
        <table>
            <tr>
                <td style="text-align:right;">Club Name:</td>
                <td><asp:DropDownList ID="clubsDropDownList" runat="server" AutoPostBack="true"/></td>
            </tr>
            <tr>
                <td style="text-align:right;">Email&nbsp;address
                    <br />
                    &nbsp;&nbsp;<i>(to&nbsp;be&nbsp;used&nbsp;at&nbsp;login)</i>:</td>
                <td><asp:TextBox ID="EmailTextBox" runat="server" /></td>
            </tr>
           <tr>
                <td></td>
                <td><asp:Button ID="nextButton0" runat="server" Text="Next >" /></td>
            </tr>
        </table>
    </asp:Panel>

    <asp:HiddenField ID="HiddenPassword" runat="server" />
    <asp:HiddenField ID="HiddenConfirm" runat="server" />

    <asp:Panel ID="passwordPanel" runat="server" Visible="false">
        <table>
            <tr id="passwordComment" runat="server">
                <td colspan="2" style="text-align:center;"><i>Leave these blank to preserve the existing password</i></td>
            </tr>
            <tr>
                <td style="text-align:right;">Password:</td>
                <td><asp:TextBox ID="passwordTextBox" runat="server" TextMode="Password" /></td>
            </tr>
            <tr>
                <td style="text-align:right;">Confirm password:</td>
                <td><asp:TextBox ID="confirmPasswordTextBox" runat="server" TextMode="Password" /></td>
            </tr>
        </table>
        <table>    
            <tr> 
                <td></td>
                <td style="text-align:right;"><asp:Button ID="prevButton1" runat="server" Text="< Prev" Visible="true"/></td>
                <td></td>
                <td><asp:Button ID="nextButton1" runat="server" Text="Next >" Visible="true"/></td>
            </tr>
        </table>
    </asp:Panel>

    <asp:Panel ID="namePanel" runat="server" Visible="false">
        <table>
            <tr>
                <td style="text-align:right;">Your first/preferred name:</td>
                <td><asp:TextBox ID="firstNameTextbox" runat="server" /></td>
            </tr>
            <tr>
                <td style="text-align:right;">Your surname:</td>
                <td><asp:TextBox ID="surnameTextBox" runat="server" /></td>
            </tr>
            <tr>
                <td style="text-align:right;">Telephone number:</td>
                <td><asp:TextBox ID="telephoneTextBox" runat="server" /></td>
            </tr>
        </table>
        <table>    
            <tr> 
                <td></td>
                <td style="text-align:right;"><asp:Button ID="prevButton2" runat="server" Text="< Prev" Visible="true"/></td>
                <td></td>
                <td><asp:Button ID="submitButton" runat="server" Text="Submit >" Visible="true"/></td>
            </tr>
        </table>
    </asp:Panel>
    
    <p id="removeButton" runat="server" ><asp:Button ID="deleteButton" runat="server" Text="Remove this registration" /></p>

    <asp:Panel ID="deletePanel" runat="server" Visible="false">

        <table>
            <tr>
                <td colspan="2">
                    <asp:Label ID="deleteLabel" runat="server" Text="Click 'Remove Permanently' to remove this Club's login registration" ForeColor="DarkBlue"></asp:Label></td>
            </tr>
            <tr id="deleteRow" runat="server">
                <td><asp:Button ID="deleteConfirmButton" runat="server" Text="Remove Permanently" /></td>
                <td><asp:Button ID="deleteCancelButton" runat="server" Text="Cancel" /></td>
            </tr>
        </table>

    </asp:Panel>
    
    </div>

</asp:Content>
