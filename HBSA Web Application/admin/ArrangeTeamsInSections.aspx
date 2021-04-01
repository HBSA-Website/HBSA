<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/admin/adminMasterPage.master" CodeBehind="ArrangeTeamsInSections.aspx.vb" Inherits="HBSA_Web_Application.ArrangeTeamsInSections" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    
 

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

           <link href="/admin/Styles/Dynamic.css" rel="stylesheet" type="text/css" />

        <script type="text/javascript" src="/admin/Scripts/redips-drag-min.js"></script>
        <script type="text/javascript" src="/admin/Scripts/Dynamicdragdrop.js"></script>

    <h2 style="text-align:left;">Arrange Teams in Sections</h2>

    <asp:ScriptManager ID="ScriptManagerPage" runat="server">    </asp:ScriptManager>

                    <asp:UpdateProgress runat="server" id="Update_Progress" DisplayAfter="10">
                        <ProgressTemplate>
                            <div id="Loading" style="position: fixed; left:200px;top:160px">
                                <asp:Image ID="loadingImage" runat="server" ImageUrl="~/images/AjaxLoading.gif" width="100px" />
                            </div>
                        </ProgressTemplate>
                    </asp:UpdateProgress>

            
<div style="text-align:left;">

    Choose the League to work with. <br />
    <br />
    <asp:DropDownList ID="League_DropDownList" runat="server" AutoPostBack="True" BackColor="#FFFFCC"></asp:DropDownList>
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <asp:Button ID="Refresh_Button" runat="server" Text="Refresh" Width="100px" ToolTip="This will reload the data from the database and refresh the screen." />  
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <asp:Button ID="Save_Button" runat="server" Text="Save" Width="100px" ToolTip="This will save the data shown in the database. Note that any team in unnumbered cells will be deleted" />  
    <br /><br />
    <a href="Teams.aspx">NOTE: to remove or add a team go to Teams Maintenance</a> <br /><br />
</div>

    <asp:Panel ID="QuerySavePanel" runat="server" Visible="false">
        <div style="padding: 4px; z-index:50; border: 1px solid #0000FF; position:absolute; top:300px; left:200px; background-color: #CCFFFF; text-align:center; width: 395px;">
            <asp:Literal ID="QuerySave_Literal" runat="server">Do you want to save your changes?</asp:Literal><br /><br />
            <asp:Button ID="QuerySave_Button" runat="server" Text="Yes - Save" />
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <asp:Button ID="QueryCancel_Button" runat="server" Text="No - Cancel" />
        </div>
    </asp:Panel>

    <asp:Panel ID="msgBox_Panel" runat="server" Visible="false">
        <div style="padding: 4px; z-index:50; border: 1px solid #0000FF; position:absolute; top:300px; left:200px; background-color: #CCFFFF; 
                    text-align:center; width: 380px;">
            <asp:Literal ID="msgBox_Literal" runat="server">! Cannot update the database<br />The current season is active !</asp:Literal><br /><br />
            <asp:Button ID="Close_Button" runat="server" Text="Close" />
        </div>
    </asp:Panel>

    <asp:UpdatePanel ID="upPage" UpdateMode="Conditional" runat="server">
        <ContentTemplate>

            <div id="drag">
                <div id="draggableContent">
                    <table id="tblPage" runat="server"> <%--Note Client ID Static doesn't appear to be needed on straight HTML element--%>
 
                    </table>
                </div>
            </div>
        <asp:HiddenField ID="dragAction" ClientIDMode="Static" runat="server" />
        </ContentTemplate>
    </asp:UpdatePanel>

</asp:Content>
