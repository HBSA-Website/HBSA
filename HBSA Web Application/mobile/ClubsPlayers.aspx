<%@ Page Title="Clubs and Players" Language="vb" ClientIDMode="Static" AutoEventWireup="false" 
    MasterPageFile="~/mobile/mobileMaster.Master" CodeBehind="ClubsPlayers.aspx.vb" Inherits="HBSA_Web_Application.ClubsPlayers1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="AjaxToolkit" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        function checkAccessCode(AccessCode, msgSpan) {
            var elAccessCode = document.getElementById(AccessCode);
            HBSA_Web_Application.AccessCode.CheckAccessCode(elAccessCode.value, Completed, Errored, msgSpan);
        }
        function Completed(outcome, msgSpan) {
            if (outcome != "good") {
                document.getElementById(msgSpan).innerHTML = "Incorrect access code";
                document.getElementById("ViewContactDetailsHidden").value = "";
            } else {
                document.getElementById("ViewContactDetailsHidden").value = "Accessible";
                var dd = document.getElementById("Club_DropDownList")
                if (dd.selectedIndex != 0) {  //need to force rebuild of players table
                    dd.selectedIndex = 0;     // restart the club dd
                    __doPostBack("Club_DropDownList"); //force code behind to build playerts table 
                } else {
                    var panel = document.getElementById("AccessCode_Panel");
                    panel.style.display = "none"
                }
            }
        }
        function Errored(result) {
            alert("Error: " + result.get_message());
        }
    </script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

        <style>
            td {
                padding-top: 30px;
                padding-bottom: 30px;
            }
        </style>

    <asp:ScriptManager ID="ScriptManager1" runat="server">
        <Services>
           <asp:ServiceReference Path="~/mobile/ActiveTableDetail.asmx" />
            <asp:ServiceReference Path="~/AccessCode.asmx" />
        </Services>
    </asp:ScriptManager>

    <input id="ViewContactDetailsHidden" type="hidden" runat="server" />

    <span style="font-weight: bold;">Clubs and Players</span><br />
    Select a club: <asp:DropDownList ID="Club_DropDownList" runat="server" AutoPostBack="true"></asp:DropDownList>
    <hr />
    <div style="font-size: larger; font-weight: bold;">AND/OR</div>
    <hr />

    <span style="font-size:smaller;font-style:italic;">Start entering a player&#39;s name until you see the name you want then click/touch it:
    <br/>
    &nbsp;&nbsp;then click GO </span>
    <asp:TextBox ID="Player_TextBox" runat="server" autocomplete="new-password"></asp:TextBox>
                <ajaxToolkit:AutoCompleteExtender ID="AutoCompleteExtender1" runat="server" TargetControlID="Player_TextBox" 
                    MinimumPrefixLength="2" UseContextKey="True" ServiceMethod="SuggestPlayers" CompletionInterval="10" CompletionSetCount="20" 
                    CompletionListCssClass="mobileCompletionList" CompletionListItemCssClass="mobileCompletionLlistItem" 
                    CompletionListHighlightedItemCssClass="mobileCompletionItemHighlighted"></ajaxToolkit:AutoCompleteExtender>
   
    &nbsp;&nbsp;&nbsp;&nbsp;
    <asp:Button ID="GetByName_Button" runat="server" Text="GO" />
    <hr />

    <div id="ClubsAndPlayers_Div" runat="server"></div>
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<asp:Literal ID="Team_Literal" runat="server"></asp:Literal>
    <div id="Teams_Div" runat="server"></div>
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<asp:Literal ID="Player_Literal" runat="server"></asp:Literal>

    <asp:Panel ID="AccessCode_Panel" Style="font-size: 32px;" runat="server" Visible="false" BorderWidth="1px" BorderStyle="Solid" BackColor="White">
        <p style="color: red; font-weight: bold;">Access code required for Players' eMail addresses and telephone numbers</p>
        <p>
            If you wish to view Players&#39; eMail addresses and/or telephone numbers enter the access code and touch/click Apply.<br />
           Access Code:
            <input id="AccessCode_Text" type="password" style="width: 180px;" autocomplete="new-password" />
            &nbsp;&nbsp;&nbsp;&nbsp;
            <span id="ApplyCode" style="color: blue; text-decoration: underline"
                onmouseover="this.style.cursor = 'pointer';" onclick="checkAccessCode('AccessCode_Text','AccessCodeMsg')"> Apply </span>
            &nbsp;&nbsp;
            <span id="AccessCodeMsg" style="color:red"></span>
            <br />If you don&#39;t know the access code contact your club representative or a team representative (who can enter match results) who will be able to log on and find this access code.
            <br />If you wish to just continue click Cancel:&nbsp;&nbsp;<asp:Button ID="CancelAccessCode_Button" runat="server" Text="Cancel" />
        </p>
    </asp:Panel>

    <div id="Players_Div" runat="server"></div>

    <div id="ActiveDetailDiv" class="infoDiv" onclick="this.style.display='none';">

</div>

</asp:Content>
