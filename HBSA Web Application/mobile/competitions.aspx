<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/mobile/mobileMaster.Master" ClientIDMode="Static" CodeBehind="competitions.aspx.vb" Inherits="HBSA_Web_Application.competitions1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
       .hoverDiv {
            border-style: solid; 
            border-width: 1px; 
            padding: 5px; 
            position:absolute; 
            left: 50px;
            display:none; 
            background-color: #FFFFCC;
        }
       .noteBox {
           text-align:center;
           color: red;
           font-style:italic;
       }
       .entrantBox {
           text-align:center;
       }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <script type="text/javascript">
    function loadHoverDiv(DivID) {

        document.getElementById(DivID).style.display = "block";
    
    }

    function hideHoverDiv(DivID) {

        document.getElementById(DivID).style.display = "none";
    }
</script>
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
                var dd = document.getElementById("Competitions_DropDownList")
                if (dd.selectedIndex != 0) {  //need to force rebuild of players table
                    dd.selectedIndex = 0;     // restart the club dd
                    __doPostBack("Competitions_DropDownList"); //force code behind to build playerts table
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

    <asp:ScriptManager ID="ScriptManager1" runat="server">
        <Services>
            <asp:ServiceReference Path="~/AccessCode.asmx" />
        </Services>
    </asp:ScriptManager>
    <asp:UpdateProgress runat="server" id="Update_Progress" DisplayAfter="10">
            <ProgressTemplate>
                <div id="Loading" style="position: fixed; left:440px;top:260px">
                    <asp:Image ID="loadingImage" runat="server" ImageUrl="~/images/AjaxLoading.gif" Width="100px" />
                </div>
            </ProgressTemplate>
        </asp:UpdateProgress>

    <input id="ViewContactDetailsHidden" type="hidden" runat="server" /> 

    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
         <ContentTemplate>

    <div style="text-align:center;">

        <span style="font-weight:bold;">Competitions</span>
        <asp:Panel ID="AccessCode_Panel" Style="text-align: left; max-height: 999999px;" runat="server" Visible="false" BorderWidth="1px" BorderStyle="Solid" BackColor="White">
            <p style="color: red; font-weight: bold">Access code required for Players' eMail addresses and telephone numbers</p>
            <p>
                If you wish to view Players' eMail addresses and/or telephone numbers enter the required Access code and click Apply.<br />
                Access code:
                <input id="AccessCode_Text" type="password" style="width: 180px;" autocomplete="new-password" />
                &nbsp;&nbsp;&nbsp;&nbsp;<span id="ApplyCode" style="color: blue; text-decoration: underline"
                    onmouseover="this.style.cursor = 'pointer';" onclick="checkAccessCode('AccessCode_Text','AccessCodeMsg')">Apply </span>
                &nbsp;&nbsp;<span id="AccessCodeMsg" style="color: red"></span>
                <br />
            </p>
            <p>
                If you don't know the access code contact your club representative or a team representative (who can enter match results) who will be able to log on and find this code.
            </p>
            <p>
                If you wish, touch/click cancel to proceed without seeing players' contact details:
                      &nbsp;&nbsp;&nbsp;&nbsp;<asp:Button ID="CancelAccessCode_Button" runat="server" Text="Cancel" />
            </p>
        </asp:Panel>

        <div style="width:100%">
            Select a competition:<br />
            <asp:DropDownList ID="Competitions_DropDownList" runat="server" CssClass="dropDown"  AutoPostBack="True" ></asp:DropDownList><br />
            <asp:Literal ID="Comment_Literal" runat="server"></asp:Literal><br /><br />
            <i><span style="color:red">NOTE: touch an entrant due to play, to see contact details.</span></i><br />
            <asp:Table ID="Competition_Table" runat="server"></asp:Table>
       </div>
    </div>

        </ContentTemplate>
    </asp:UpdatePanel>
 
</asp:Content>
