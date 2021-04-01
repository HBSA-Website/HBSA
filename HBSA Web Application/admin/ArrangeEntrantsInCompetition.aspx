<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/admin/adminMasterPage.master" CodeBehind="ArrangeEntrantsInCompetition.aspx.vb" Inherits="HBSA_Web_Application.ArrangeEntrantsInCompetition" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

           rawI<link href="/admin/Styles/Dynamic.css" rel="stylesheet" type="text/css" /><script type="text/javascript" src="/admin/Scripts/redips-drag-min.js"></script><script type="text/javascript" src="/admin/Scripts/Dynamicdragdrop.js"></script><h2 style="text-align:left;">Arrange Entrants in Competitions</h2>

    <asp:ScriptManager ID="ScriptManagerPage" runat="server">    </asp:ScriptManager>

                    <asp:UpdateProgress runat="server" id="Update_Progress" DisplayAfter="10">
                        <ProgressTemplate>
                            <div id="Loading" style="position: fixed; left:200px;top:160px">
                                <asp:Image ID="loadingImage" runat="server" ImageUrl="~/images/AjaxLoading.gif" width="100px" />
                            </div>
                        </ProgressTemplate>
                    </asp:UpdateProgress>

            
<div style="text-align:left;">

    Choose the Competition to work with. <br />
    <br />
    <asp:DropDownList ID="Competitions_DropDownList" runat="server" AutoPostBack="True" BackColor="#FFFFCC"></asp:DropDownList>
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <asp:Button ID="Refresh_Button" runat="server" Text="Refresh" Width="100px" ToolTip="This will discard any changes, reload the data from the database, and refresh the screen." />  
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <asp:Button ID="Save_Button" runat="server" Text="Save" Width="100px" ToolTip="This will save the data shown in the database. Note that any entrant in unnumbered cells will be deleted" />  
    <br /><br />
    Entrants are shown in pairs, the 1st of which plays the 2nd.  Click and hold on an entrant, then drag to an empty location<br />
    The 2 slots at the bottom of the table can be used as a temporary holding slots.  When the arrangement is complete click Save.<br />
    At any time (before saving) click Refresh to start again.  Ensure there are no empty slots in the main body before saving. Ensure that byes are always the 2nd of a match pair.<br />
    <%--<a href="CompetitionsEntries.aspx">NOTE: to remove or add an entrant go to Entrants in Competitions</a> <br />    <br />--%>
</div>

    <asp:Panel ID="QuerySavePanel" runat="server" Visible="false">
        <div style="padding: 4px; z-index:50; border: 1px solid #0000FF; position:absolute; top:300px; left:200px; background-color: #CCFFFF; text-align:center; width: 395px;">
            <asp:Literal ID="QuerySave_Literal" runat="server">Do you want to save your changes?</asp:Literal><br /><br />
            <asp:Button ID="QuerySave_Button" runat="server" Text="Yes - Save" />
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <asp:Button ID="QueryCancel_Button" runat="server" Text="No - Cancel" />
        </div>
    </asp:Panel>

          <asp:Panel ID="Confirm_Panel" runat="server" Visible="false">
            <div id="divConfirmCompetition" style="border: 1px solid #000080; font-family: Arial, Helvetica, sans-serif; font-size: 8Pt; display:block; vertical-align: top; 
                                   text-align: left; position: fixed; background-color: #99CCFF;
                                   width:540px; top: 180px; left:50px; 
                                   ">
                <table style="width: 100%; height: 100%">
                    <tr>
                        <td onmousedown="dragStart(event, 'divConfirmCompetition')" 
                            onmouseover="this.style.cursor='pointer';" 
                            style="height: 8px; border-right: #000080 1px solid; border-top: #000080 1px solid; border-left: #000080 1px solid; border-bottom: #000080 1px solid; background-image: url('../images/menuBarBG.gif');">
                            <strong>Competition</strong></td>
                    </tr>
                </table>
                
                <table style="font-size:9pt; width:100%; vertical-align: top;">
                    <tr>
                        <td>
                            <div id="Div1" style="display:block; text-align: left;">
                                <asp:Literal ID="Confirm_Literal" runat="server"></asp:Literal>
                                <br/><br/>

                              <div>
                               <table style="width:100%">
                                 <tr>
                                    <td style="text-align:center">
                                        <asp:Button ID="ConfirmCompetition_Button" runat="server" Text="Confirm" />
                                    </td>
                                    <td style="text-align:center">
                                        <asp:Button ID="CancelConfirm_Button" runat="server" Text="Cancel" />
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


    <asp:UpdatePanel ID="upPage" UpdateMode="Conditional" runat="server">
        <ContentTemplate>

            <div id="drag">
                <div id="draggableContent">
                    <table id="tblPage" clientidmode="Static" runat="server">
 
                    </table>
                </div>
            </div>
        <asp:HiddenField ID="dragAction" ClientIDMode="Static" runat="server" />
        </ContentTemplate>
    </asp:UpdatePanel>

</asp:Content>
