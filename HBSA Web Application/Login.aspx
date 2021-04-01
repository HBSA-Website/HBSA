<%@ Page Title="" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" Inherits="HBSA_Web_Application.Login" Codebehind="Login.aspx.vb" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <style type="text/css">
        .auto-style2 {
            width: 155px;
        }
    </style>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

    <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
       <asp:UpdateProgress runat="server" id="Update_Progress" DisplayAfter="10">
            <ProgressTemplate>
                <div id="Loading" style="position: fixed; left:440px;top:260px">
                    <asp:Image ID="loadingImage" runat="server" ImageUrl="~/images/AjaxLoading.gif" Width="100px" />
                </div>
            </ProgressTemplate>
        </asp:UpdateProgress>

    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
         <ContentTemplate>


<asp:Panel DefaultButton="Login_Button" runat="server" style="width:100%">

<table style="width:auto; margin-left:auto; margin-right:auto;"><tr><td>


    <div style="font-family: Verdana; font-size:12pt; color:Green; background-color: #CCFFCC; width:800px;text-align:left;">
    <h3>Team Login (for entering match results, and viewing fines)</h3>
    <br />Enter your login details:<br />
    <br />

    <table style="width:auto; margin-left:auto; margin-right:auto; border-top-width: thin; border-left-width: thin; font-size: 11pt; 
                  border-left-color: #006600; border-bottom-width: thin; border-bottom-color: #006600;
                  color: #006600; border-top-color: #006600; font-family: Verdana; border-right-width: thin; 
                  border-right-color: #006600;">
        <tr style="height:30px">
            <td style="border-right: #006600 1px solid; border-top: #006600 1px solid; font-size: 9pt; vertical-align: middle; border-left: #006600 1px solid; color: #006600; border-bottom: #006600 1px solid; font-family: Verdana; text-align: right">
                your email address:</td>
            <td style=" border-right: #006600 1px solid; border-top: #006600 1px solid; font-size: 9pt; border-left: #006600 1px solid; color: #006600; border-bottom: #006600 1px solid; font-family: Verdana; text-align: left;">
                <asp:TextBox ID="email_TextBox" runat="server" BorderWidth="0px" Width="220px"></asp:TextBox></td>
        </tr>
        
        <tr style="height:30px">
            <td style="border-right: #006600 1px solid; border-top: #006600 1px solid; font-size: 9pt; vertical-align: middle; border-left: #006600 1px solid; color: #006600; border-bottom: #006600 1px solid; font-family: Verdana; text-align: right">
                your password:</td>
            <td style="border-right: #006600 1px solid; border-top: #006600 1px solid; font-size: 9pt; border-left: #006600 1px solid; color: #006600; border-bottom: #006600 1px solid; font-family: Verdana; text-align: left;">
                <asp:TextBox ID="password_TextBox" ClientIDMode="Static" runat="server" BorderWidth="0px" Width="220px" TextMode="Password" ></asp:TextBox>
                <img title="Click to show password" alt="Click to show password" src="../images/EyeClosed.jpg" height="15"
                                          onclick="showHidePassword(this,'password_TextBox'); " />
            </td>
        </tr>
        <tr style="text-align:center;">
            <td colspan="2">
                <asp:Button ID="Login_Button" runat="server" Text="Log in" Height="30px" Width="121px"  onmouseover="this.style.cursor='hand'"/></td>
        </tr>
    </table>
    <table style="width:auto; margin-left:auto; margin-right:auto;">
    <tr>
        <td >
            <asp:Button ID="Register_Button" runat="server" Text="Register a new login" Height="30px" 
                        BackColor="#CCFFCC" BorderStyle="None" Font-Underline="True" ForeColor="#0033CC" 
                        onmouseover="this.style.cursor='pointer'" Font-Bold="True" Font-Size="12pt"/>
            </td>
        <td>
            <asp:Button ID="Password_Button"  runat="server" Text="Forgotten password" 
                        BackColor="#CCFFCC" BorderStyle="None" Font-Underline="True" 
                        ForeColor="#0033CC" onmouseover="this.style.cursor='pointer'" Font-Italic="True" /></td>
            <td>
                <asp:Button ID="Profile_Button" runat="server" BackColor="#CCFFCC" BorderStyle="None" Font-Underline="True" 
                            ForeColor="#0033CC" onmouseover="this.style.cursor='pointer'" Text="Change/Delete My Registration"  Font-Italic="True"  />
                </td>
        </tr>
    </table>

            <span style="font-family: Verdana; color:#006600;">
                <asp:Literal ID="status_Literal" runat="server" Mode="PassThrough"></asp:Literal>
            </span>
  </div>
  </td></tr></table> 

        </asp:Panel>

       <asp:Panel ID="Request_Panel" runat="server" Visible="false">
            <div id="divRequest" style="border: 1px solid #000080; font-family: Arial, Helvetica, sans-serif; font-size: 8Pt; display:block; vertical-align: top; 
                                   text-align: left; position: fixed; background-color:#CCFFBB;
                                   left:400px; top:160px;
                                   ">
                <table style="width: 100%; height: 100%">
                    <tr>
                        <td onmousedown="dragStart(event, 'divRequest')" 
                            onmouseover="this.style.cursor='pointer';" 
                            style="height: 8px; border-right: #000080 1px solid; border-top: #000080 1px solid; border-left: #000080 1px solid; border-bottom: #000080 1px solid; background-image: url('../images/menuBarBG.gif');">
                            <strong>
                                <asp:Literal ID="Request_Literal" runat="server" Text="Request&nbsp;Password&nbsp;Reset"></asp:Literal></strong></td>
                    </tr>
                </table>
                <table style="font-size:9pt; vertical-align: top;">
                    <tr>
                        <td style="padding:8px;text-align:center;">
                                <div id="Div1" style="font-size:10pt; display:block; text-align: center;">
                                  <div style="width:100%;">
                                      <asp:Literal ID="Instruction_Literal" runat="server" Text="Enter your email address, select your team and click Submit, or Cancel"></asp:Literal>
                                  </div>  

                                  <div>
                                <table style="width:100%;">
                                 <tr><th>Email</th></tr>
                                 <tr><td><asp:TextBox ID="RequestEmail_TextBox" runat="server" BackColor="#FFFFCC" style="text-align:left;" Width="240px"></asp:TextBox></td></tr>
                                 <tr id="RequestPasswordHeader" runat="server" visible="false">
                                       <th>Password</th>
                                 </tr>
                                 <tr id="RequestPassword" runat="server" visible="false">
                                        <td><asp:TextBox ID="RequestPassword_TextBox" ClientIDMode="Static" runat="server" BackColor="#FFFFCC" style="text-align:left;" Width="225px" TextMode="Password"></asp:TextBox>
                                                        <img title="Click to show password" alt="Click to show password" src="../images/EyeClosed.jpg" height="15"
                                                             onclick="showHidePassword(this,'RequestPassword_TextBox'); " />
                                        </td>
                                 </tr>
                                <tr id="RequestTeamHeader" runat="server" visible="false">
                                       <th>Select a team</th>
                                 </tr>
                                 <tr id="RequestTeam" runat="server" visible="false">
                                        <td style="text-align:center"><asp:DropDownList ID="RequestTeam_DropDownList" runat="server" BackColor="#FFFFCC"  Width="240px" AutoPostBack="true"></asp:DropDownList></td>
                                 </tr>
                               </table>
                                      <br />
                               <table style="width:100%">
                                 <tr>
                                    <td style="text-align:center">
                                        <asp:Button ID="SubmitRequest_Button" runat="server" Text="Submit" />
                                    </td>
                                    <td style="text-align:center">
                                        <asp:Button ID="CancelRequest_Button" runat="server" Text="Cancel" />
                                    </td>
                                 </tr>
                                    
                                </table>
                              </div>
                            </div>
                        </td>
                    </tr>
                </table>
  
    </div>
        </asp:Panel>

        </ContentTemplate>
    </asp:UpdatePanel>

</asp:Content>

