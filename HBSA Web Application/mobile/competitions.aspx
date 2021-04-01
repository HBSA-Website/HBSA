<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/mobile/mobileMaster.Master" ClientIDMode="Static" CodeBehind="competitions.aspx.vb" Inherits="HBSA_Web_Application.competitions1" %>
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

        <span style="font-weight:bold;">Competitions</span>
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
