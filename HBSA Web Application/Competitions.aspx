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
