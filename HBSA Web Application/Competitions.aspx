<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/MasterPage.master" CodeBehind="Competitions.aspx.vb" Inherits="HBSA_Web_Application.Competitions" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
       .hoverDiv {
            border-style: solid;
            border-width: 1px; 
            padding: 5px; 
            position:absolute; 
            margin-left: 50px; 
            margin-top: 0px; 
            display:none; 
            background-color: #FFFFCC;
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

    <div style="text-align:center;">

        <h3>Competitions</h3>

        <asp:Panel ID="AccessCode_Panel" Style="text-align: left" runat="server" Visible="false" BorderWidth="1px" BorderStyle="Solid" BackColor="White">
            <p style="color: red; font-weight: bold">Access code required for Players' eMail addresses and telephone numbers</p>
            <p>
                If you wish to view Players' eMail addresses and/or telephone numbers enter the required Access code and click Apply.<br />
                Access code:
                <asp:TextBox ID="AccessCode_TextBox" runat="server"></asp:TextBox>
                &nbsp;&nbsp;&nbsp;&nbsp;<asp:Button ID="AccessCode_Button" runat="server" Text="Apply" />
                &nbsp;&nbsp;&nbsp;&nbsp;<asp:Literal ID="AccessCode_Literal" runat="server"></asp:Literal>
                <br />
            </p>
            <p>
                If you don't know the access code contact your club representative or a team representative (who can enter match results) who will be able to log on and find this code.
            </p>
            <p>
                If you wish, click cancel to proceed without seeing players' contact details:
                      &nbsp;&nbsp;&nbsp;&nbsp;<asp:Button ID="CancelAccessCode_Button" runat="server" Text="Cancel" />
            </p>
        </asp:Panel>


        <div>
           <table style="width:100%;">
            <tr>
                <td style="vertical-align:top; text-align:center;">Select a competition:
                    <asp:DropDownList ID="Competitions_DropDownList" runat="server" BackColor="#FFFFCC" AutoPostBack="True" ></asp:DropDownList>
                </td>
                                
            </tr>
            <tr><td>
                <asp:Literal ID="Comment_Literal" runat="server"></asp:Literal><br /><br />
                <i><span style="color: red;font-size:larger;">NOTE: move the mouse pointer over, or touch, an entrant due to play, to see contact details.</span></i><br />
                </td>
            </tr>
            <tr>
                <td colspan="2" style="vertical-align:top; text-align:center;">
                     <asp:Table ID="Competition_Table" runat="server"></asp:Table>
                </td>
            </tr>
        </table>
       </div>
    </div>

        </ContentTemplate>
    </asp:UpdatePanel>
 
 
</asp:Content>
