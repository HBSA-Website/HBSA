<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/admin/adminMasterPage.master" CodeBehind="EmailTemplateEdit.aspx.vb" 
                  Inherits="HBSA_Web_Application.EmailTemplateEdit" ClientIDMode="Static" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="AjaxToolkit" %>
<%@ Register Assembly="CKEditor.NET" Namespace="CKEditor.NET" TagPrefix="CKEditor" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:ScriptManager ID="ToolkitScriptManager1" runat="server"></asp:ScriptManager>
    <input id="EmailTemplateName_HiddenField" type="hidden" runat="server"/>
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>

            Email Template Name: <asp:TextBox ID="EmailTemplateName_TextBox" runat="server" Enabled="false" Width="338px"></asp:TextBox>
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Date: <asp:Literal ID="Date_Literal" runat="server"/><br />
                    When editing there are variables that are replaced with actual values when the email is prepared. 
                    A variable is defined by a name bounded by || (vertical bars). 
                    There must not be any spaces between the vertical bars and the variable name. 
                    The variable name is case sensitive.&nbsp; 
                    It is acceptable to omit a variable. 
                    These variables are dependent on the email&#39;s purpose:<br />
                    <table id="handicapChangeVariables" runat="server" visible="false" style="border-collapse:collapse">
                        <tr><th style="border: 1px solid navy">Purpose</th><th style="border : 1px solid navy">Variable</th><th style="border: 1px solid navy">Value</th></tr>
                        <tr><td style="width:150px; border: 1px solid navy">Handicap change</td><td style="border: 1px solid navy">|Date|</td><td style="border: 1px solid navy">The date the handicap was changed</td></tr>
                        <tr><td style="width:150px; border: 1px solid navy" rowspan="5">Sent to all club members, teams and the player with email addresses, whenever a handicap is changed during a season</td><td style="border: 1px solid navy">|Player|</td><td style="border: 1px solid navy">The name of the player</td></tr>
                        <tr><td style="border: 1px solid navy">|old handicap|</td><td style="border: 1px solid navy">The player's previous handicap</td></tr>
                        <tr><td style="border: 1px solid navy">|new handicap|</td><td style="border: 1px solid navy">The player's new handicap</td></tr>
                        <tr><td style="border: 1px solid navy">|team|</td><td style="border: 1px solid navy">The team the player belongs to</td></tr>
                        <tr><td style="border: 1px solid navy">|Section|</td><td style="border: 1px solid navy">The team's League and division/section </td></tr>
                    </table>
                    <table id="PlayerRegistrationVariables" runat="server" visible="false" style="border-collapse:collapse">
                        <tr><th style="border: 1px solid navy">Purpose</th><th style="border : 1px solid navy">Variable</th><th style="border: 1px solid navy">Value</th></tr>
                        <tr><td style="width:150px; border: 1px solid navy">Player Registration</td><td style="border: 1px solid navy">|Date|</td><td style="border: 1px solid navy">Date the registration made</td></tr>
                        <tr><td style="width:150px; border: 1px solid navy" rowspan="5">Sent to all club members, teams and the player with email addresses, whenever a handicap is changed during a season</td><td style="border: 1px solid navy">|Player|</td><td style="border: 1px solid navy">The name of the player</td></tr>
                        <tr><td style="border: 1px solid navy">|handicap|</td><td style="border: 1px solid navy">The player's previous handicap</td></tr>
                        <tr><td style="border: 1px solid navy">|De-|</td><td style="border: 1px solid navy">Shown as is when player has been deregistered.</td></tr>
                        <tr><td style="border: 1px solid navy">|team|</td><td style="border: 1px solid navy">The team the player belongs to</td></tr>
                        <tr><td style="border: 1px solid navy">|Section|</td><td style="border: 1px solid navy">The team's League and division/section </td></tr>
                    </table>
                    <table id="fineImposedVariables" runat="server" visible="false" style="border-collapse:collapse" >
                        <tr><th style="border: 1px solid navy">Purpose</th><th style="border: 1px solid navy">Variable</th><th style="border: 1px solid navy">Value</th></tr>
                        <tr><td style="width:150px; border: 1px solid navy">Fine imposed</td><td style="border: 1px solid navy">|Date|</td><td style="border: 1px solid navy">The date the fine was imposed</td></tr>
                        <tr><td style="width:150px; border: 1px solid navy" rowspan="5">Sent to club email and team email addresses, when a fine is imposed by an administrator.</td><td style="border: 1px solid navy">|Club Name|</td><td style="border: 1px solid navy">The club on whom the fine is imposed</td></tr>
                        <tr><td style="border: 1px solid navy">|PayByDate|</td><td style="border: 1px solid navy">The date by which the fine must be paid</td></tr>
                        <tr><td style="border: 1px solid navy">|Amount|</td><td style="border: 1px solid navy">The fine amount</td></tr>
                        <tr><td style="border: 1px solid navy">|Offence|</td><td style="border: 1px solid navy">The offence that attracted the fine </td></tr>
                        <tr><td style="border: 1px solid navy">|Comment|</td><td style="border: 1px solid navy">Comment as entered by the fine imposer</td></tr>
                    </table>
                    <table id="MatchResultVariables" runat="server" visible="false" style="border-collapse:collapse" >
                        <tr><th style="border: 1px solid navy">Purpose</th><th style="border: 1px solid navy">Variable</th><th style="border: 1px solid navy">Value</th></tr>
                        <tr><td style="width:150px; border: 1px solid navy">Match Result</td><td style="border: 1px solid navy">|League|</td><td style="border: 1px solid navy">The name of the league for this match</td></tr>
                        <tr><td style="border: 1px solid navy"></td><td style="border: 1px solid navy">|Section|</td><td style="border: 1px solid navy">The division or section name for this match</td></tr>
                        <tr><td style="width:150px; border: 1px solid navy" rowspan="11">Sent to the league secretary and the person entering the result when a match result is submitted.</td><td style="border: 1px solid navy">|HomeTeam|</td><td style="border: 1px solid navy">The team that hosted the match</td></tr>
                        <tr><td style="border: 1px solid navy">|AwayTeam|</td><td style="border: 1px solid navy">The visiting team</td></tr>
                        <tr><td style="border: 1px solid navy">|FixtureDate|</td><td style="border: 1px solid navy">The date the match was scheduled for</td></tr>
                        <tr><td style="border: 1px solid navy">|MatchDate|</td><td style="border: 1px solid navy">The date the match was actually played if different from the fixture date. </td></tr>
                        <tr><td style="border: 1px solid navy">|xxxxyyyyn|</td><td style="border: 1px solid navy">The next 3 variables take this format where xxxx is Home or Away, <br />
                                                    and n is the frame number in the match.  Note that there are 4 frames <br />
                                                    in an open league match, otherwise there are only 3 frames.</td></tr>
                        <tr><td style="border: 1px solid navy">|xxxxHcapn|</td><td style="border: 1px solid navy">Handicap</td></tr>
                        <tr><td style="border: 1px solid navy">|xxxxScoren|</td><td style="border: 1px solid navy">Points scored in this frame</td></tr>
                        <tr><td style="border: 1px solid navy">|xxxxPlayern|</td><td style="border: 1px solid navy">The player's name</td></tr>
                        <tr><td style="border: 1px solid navy">|Breaks|</td><td style="border: 1px solid navy">List of breaks over 25 and the player who achieved it.</td></tr>
                        <tr><td style="border: 1px solid navy">|HomeFrames|</td><td style="border: 1px solid navy">The number of frames won by the home team</td></tr>
                        <tr><td style="border: 1px solid navy">|AwayFrames|</td><td style="border: 1px solid navy">The number of frames won by the away team</td></tr>

                    </table>
                    <table id="PointsAdjustmentVariables" runat="server" visible="false" style="border-collapse:collapse">
                        <tr><th style="border: 1px solid navy">Purpose</th><th style="border : 1px solid navy">Variable</th><th style="border: 1px solid navy">Value</th></tr>
                        <tr><td style="width:150px; border: 1px solid navy">Points Adjustment</td><td style="border: 1px solid navy">|Date|</td><td style="border: 1px solid navy">The date the change was imposed</td></tr>
                        <tr><td style="width:150px; border: 1px solid navy" rowspan="5">Sent to the club contact, and the team captain</td>
                            <td style="border: 1px solid navy">|Team|</td><td style="border: 1px solid navy">The team whose points have been adjusted</td></tr>
                        <tr><td style="border: 1px solid navy">|Section|</td><td style="border: 1px solid navy">The team's League and division/section </td></tr>
                        <tr><td style="border: 1px solid navy">|DownUp|</td><td style="border: 1px solid navy">&quot;A deduction&quot; or &quot;An addition&quot; whichever is appropriate </td></tr>
                        <tr><td style="border: 1px solid navy">|Adjustment|</td><td style="border: 1px solid navy">The points added or deducted </td></tr>
                        <tr><td style="border: 1px solid navy">|Reason|</td><td style="border: 1px solid navy">The reason given for the adjustment </td></tr>
                    </table>

            <br />
            <b>Email Template:</b><asp:Literal ID="Message_Literal" runat="server"></asp:Literal><br />
            
                <CKEditor:CKEditorControl ID="EmailTemplateEditorTextBox" BasePath="/ckeditor/" runat="server" Toolbar="Basic"
                    ToolbarBasic="|Font|FontSize|Bold|Italic|Underline|Strike|-|Format|-|NumberedList|BulletedList|Outdent|Indent|-|JustifyLeft|JustifyCenter|JustifyRight|JustifyBlock|
                              |Link|Unlink|-|TextColor|-|Undo|Redo|Cut|Copy|Paste|PasteText|PasteFromWord|
                              |Find|Replace|SelectAll|-|Image|Table|HorizontalRule|SpecialChar|"
                    Height="400px" Width="95%"></CKEditor:CKEditorControl>
            <asp:Button ID="Submit_Button" runat="server" Text="Save" CausesValidation="false" CssClass="smallButton" Width="79px"  />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <asp:Button ID="Cancel_Button" runat="server" CssClass="smallButton" CausesValidation="false" Text="Cancel" Width="79px" />

        </ContentTemplate>
    </asp:UpdatePanel>


</asp:Content>
