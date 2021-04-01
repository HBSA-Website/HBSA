<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/admin/adminMasterPage.master" CodeBehind="AwardsTypes.aspx.vb" Inherits="HBSA_Web_Application.AwardsTypes" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %> 

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
 
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <script type="text/javascript">

        //this script to detect the export, and load the generatefile page into a iFrame
        //so that ajax doesn't block the file download process
        var prm = Sys.WebForms.PageRequestManager.getInstance();
        prm.add_initializeRequest(InitializeRequest);
        function InitializeRequest(sender, args) {
            if (sender._postBackSettings.sourceElement.id.indexOf("Export_Button") != -1) {
                var iframe = document.createElement("iframe");
                iframe.src = "AdminDownload.aspx?source=AwardsReport&fileName=Awards";
                iframe.style.display = "none";
                document.body.appendChild(iframe);
            }
        }

        function InsertText(TextToInsert) {

            var NameTextBox = document.getElementById("Name_TextBox");

            //IE (pre version 9.0) support
            if (document.selection) {
                NameTextBox.focus();
                sel = document.selection.createRange();
                sel.text = TextToInsert;
            }
            //MOZILLA and others
            else
            if (NameTextBox.selectionStart || NameTextBox.selectionStart == '0') {
                var startPos = NameTextBox.selectionStart;
                var endPos = NameTextBox.selectionEnd;
                NameTextBox.value = NameTextBox.value.substring(0, startPos)
                    + TextToInsert
                    + NameTextBox.value.substring(endPos, NameTextBox.value.length);
            }
            else {
                NameTextBox.value += TextToInsert;
            }
        }
    </script>

     <div style="text-align:left; width:100%">
        <asp:ScriptManager ID="ScriptManager1" runat="server">
        </asp:ScriptManager>
        
        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <ContentTemplate>
 
            <table><tr style="vertical-align:top"><td>
        <span style="font-size: 12pt; font-weight: bold">Awards - Types and their names etc.</span>
                <div style="text-align:left;">
                    <table>
                        <tr>
                            <td>
                                <div style="border: 1px solid #0000FF; color: #0000FF; background-color: #99CCFF">
                                    <table style="text-align:left">
                                        <tr>
                                            <td style="text-align:left; vertical-align: super;">
                                                <asp:Button ID="AddType_Button" runat="server" Text="Add a new Type" />
                                                &nbsp;&nbsp; Click this to create a new trophy and/or prize.
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                            </td>
                        </tr>
                    </table>
                </div>

                <asp:Literal ID="Status_Literal" runat="server" />

                <table>
                    <tr style="vertical-align:top">
                        <td>
                            <asp:GridView ID="AwardsTypes_GridView" runat="server" Font-Size="9pt" Width="100%" BackColor="White" BorderColor="Black"
                                BorderStyle="Solid" BorderWidth="1px" CellPadding="3"
                                AllowSorting="True" EmptyDataText="<span style='color:red'>No data found</span>">
                                <Columns>
                                    <asp:CommandField ShowDeleteButton="True" CausesValidation="False" InsertVisible="False" ShowCancelButton="False" ShowEditButton="True" />
                                </Columns>
                                <HeaderStyle BackColor="#4A3C8C" Font-Bold="True" ForeColor="#F7F7F7" />
                                <RowStyle Height="18px" BackColor="#E7E7FF" ForeColor="#000044" />
                                <AlternatingRowStyle Height="18px" BackColor="#F7F7F7" />
                                <SelectedRowStyle BackColor="#738A9C" Font-Bold="True" ForeColor="#F7F7F7" />
                            </asp:GridView>
                        </td>
                    </tr>
                </table>

                </td>
                <td>Trophies and Prizes comprise a list of 'templates' which describe each
                    award with its trophy and prize. Within these templates there are 'award types':  these indicate 
                    the type of award e.g. Leagues, Competitions, Breaks etc.
                    This page allows the creation and maintenance of these types.<br /> <br />
                    <b>The name describes the type of award</b>.  When showing actual awards, and when
                    maintaining the templates the competition in question is named according to the 
                    name in this table.  There can be variable elements in this name. A variable
                    element is denoted by being bound with square brackets "[]". There are fixed
                    names for the variables, each of which is replaced with a specific element.
                    The permitted elements and their replacements are:<br />
                    <br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[League] - League name.  e.g. Open Snooker, Vets Snooker, Billiards  
                    <br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[Section] - Section within a league. e.g. Division 2, Section 1  
                    <br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[Competition] - KO Competition name.  e.g. Open snooker, Leaonard Oldham Pairs etc  
                    <br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[Position] - Final position in a competition. e.g. Winner, Runner up, semi finalist  
                    <br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[LowHandicap] - Low handicap in breaks ranges.  e.g. -40  
                    <br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[HighHandicap] - High handicap in breaks ranges.  e.g. 40  
                    <br /><br />
                    NOTE: When using these variables it is important that they are relevant and that the appropriate
                          element is used in any templates associated with the type.  The relevances are:
                    <br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[League] uses the selected League to determine the name  
                    <br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[Section] uses the AwardID as a sectionID (see the Sections maintenance)
                    <br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[Competition] uses the AwardID as a CompetitionID (see the competitions maintenance) 
                    <br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[Position] uses the SubID. 1 = Winner, 2 = Runner Up, 3 & 4 = Semi Finalist 
                    <br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[LowHandicap] Low handicap using BreaksCategoriesID.  (See BreaksCategories maintennce)   
                    <br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[HighHandicap] High handicap using BreaksCategoriesID.  (See BreaksCategories maintennce)  

                    <br /><br />
                    The <b>Description</b> is a shortened version of the name without any variables.  It's purpose is to describe a type in these
                    maintenance pages only. 
                    
                    <br /><br />
                    The <b>Stored Procedure is optional</b>. When it exists it is used to generate award recipients
                    for that award type.  It is a database procedure that is invoked by the 'Generate Winners'
                    facility on the Awards page.  It is likely that when adding a new type this procedure will
                    have to be developed and incorporated in the data base.  If this is the case please 
                    contact the web master who will arrange for this to be done.                                      

                    </td>
                    </tr></table>
       <asp:Panel ID="Edit_Panel" runat="server" Visible="false">

            <div id="divEditWinner" style="border: 1px solid #000080; font-family: Arial, Helvetica, sans-serif; font-size: 8Pt; display:block; vertical-align: top; 
                                   text-align: left; position: fixed; background-color: #99CCFF;
                                   top: 330px; left: 100px;
                                   ">
                <table style="width: 100%;">
                    <tr>
                        <td onmousedown="dragStart(event, 'divEditWinner')" 
                            onmouseover="this.style.cursor='pointer';" 
                            style="border-right: #000080 1px solid; border-top: #000080 1px solid; border-left: #000080 1px solid; border-bottom: #000080 1px solid; 
                            background-image: url('../images/menuBarBG.gif');">
                             <strong><asp:Literal ID="EditPanel_Literal" runat="server" Text="Edit/Delete&nbsp;a&nbsp;winner"></asp:Literal></strong></td>
                    </tr>
                </table>

                <table style="font-size:9pt; width:100%; vertical-align: top;">
                    <tr>
                        <td>
                            <div id="Div1" style="font-size:10pt; display:block; text-align: left;">
                                <br />
                                <asp:Literal ID="EditPanel_Literal2" runat="server" Text="Click." /><br />
                                <br />
                                <div style="width:100%; text-align:center">
                                      <asp:Literal ID="EditStatus_Literal" runat="server" Text=""></asp:Literal>
                                </div>  

                                <div>
                                    <asp:HiddenField ID="AwardType" runat="server" Visible="false" />
                                    <table>
                                    <tr>
                                        <td colspan="2" style="text-align:center; font-size:11pt "><b>Name</b></td>
                                    </tr>
                                    <tr>
                                        <td colspan="2" style="text-align:center"> Click one of these to insert a variable at the cursor, or selection.  
                                            <span onmouseover="this.style.cursor='pointer';" onclick="InsertText('[League]')">[League]</span>&nbsp;&nbsp;&nbsp;
                                            <span onmouseover="this.style.cursor='pointer';" onclick="InsertText('[Section]')">[Section]</span>&nbsp;&nbsp;&nbsp;
                                            <span onmouseover="this.style.cursor='pointer';" onclick="InsertText('[Competition]')">[Competition]</span>&nbsp;&nbsp;&nbsp;
                                            <span onmouseover="this.style.cursor='pointer';" onclick="InsertText('[Position]')">[Position]</span>&nbsp;&nbsp;&nbsp;
                                            <span onmouseover="this.style.cursor='pointer';" onclick="InsertText('[LowHandicap]')">[LowHandicap]</span>&nbsp;&nbsp;&nbsp;
                                            <span onmouseover="this.style.cursor='pointer';" onclick="InsertText('[HighHandicap]')">[HighHandicap]</span>&nbsp;&nbsp;&nbsp;
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="2" style="vertical-align:top">
                                            
                                            <br /><asp:TextBox ClientIDMode="Static" ID="Name_TextBox" runat="server" Width="829px"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>Description</th><th>StoredProcedureName</th>    
                                    </tr>
                                    <tr>
                                        <td><asp:TextBox ID="Description_TextBox" runat="server" Width="352px"></asp:TextBox></td>
                                        <td><asp:TextBox ID="StoredProcedureName_TextBox" runat="server" Width="463px"></asp:TextBox></td>
                                    </tr>     
                             </table>
                               <br />
                               <table style="width:100%">
                                 <tr>
                                    <td style="text-align:center">
                                        <asp:Button ID="Submit_Button" runat="server" Text="Submit" />
                                    </td>
                                    <td style="text-align:center">
                                        <asp:Button ID="Cancel_Button" runat="server" Text="Cancel" />
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
    </div>

</asp:Content>
