<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/admin/adminMasterPage.master" CodeBehind="AwardsTemplate.aspx.vb" Inherits="HBSA_Web_Application.AwardsTemplate" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %> 

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

        <div style="text-align:left; width:100%">
        <h3>Awards - Prizes and Trophies Maintenance</h3>
        <asp:ScriptManager ID="ScriptManager1" runat="server">
        </asp:ScriptManager>
        
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

    </script>

        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <ContentTemplate>
 
                <div style="text-align:left;">
                    Trophies and Prizes comprise a list of 'templates' which describe each
                    award with its trophy and prize.<br />
                    There are 'award types':  these indicate the type of award e.g. Leagues, Competitions, Breaks etc.<br />
                    If a new award is needed that isn't covered by the current types a new one 
                    can be created.  If a current type needs a change the existing types can be amended, or even deleted. <br />
                    <a href="AwardTypes.aspx">Click here to go to the page that maintains award types:</a>
                    Each award can optionally include a trophy and will have an associated award.
                    The award will be a trophy, or cash, or both (denoted as prize).<br /><br />
                    This page allows the maintenance of these.  <br /><br />

                    <table>
                        <tr>
                            <td>
                                <div style="border: 1px solid #0000FF; color: #0000FF; background-color: #99CCFF">
                                    <table style="text-align:left">
                                        <tr>
                                            <td style="text-align:left; vertical-align: super;">
                                                <asp:Button ID="CreateTemplate_Button" runat="server" Text="Add a new Tophy/Prize" />
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
                            <asp:GridView ID="AwardsTemplates_GridView" runat="server" Font-Size="9pt" Width="100%" BackColor="White" BorderColor="#E7E7FF"
                                BorderStyle="Solid" BorderWidth="1px" CellPadding="3"
                                AllowSorting="True" EmptyDataText="<span style='color:red'>No data found</span>" AutoGenerateColumns="False">
                                <Columns>
                                    <asp:CommandField ShowDeleteButton="True" CausesValidation="False" InsertVisible="False" 
                                                        ShowCancelButton="False" ShowEditButton="True" />
                                    <asp:BoundField DataField="League Name" HeaderText="League Name" />
                                    <asp:BoundField DataField="Competition" HeaderText="Competition" />
                                    <asp:BoundField DataField="AwardType" HeaderText="AwardType" />
                                    <asp:BoundField DataField="AwardID" HeaderText="AwardID" />
                                    <asp:BoundField DataField="SubID" HeaderText="SubID" />
                                    <asp:BoundField DataField="LeagueID" HeaderText="AwardType" />
                                    <asp:BoundField DataField="Trophy" HeaderText="Trophy" />
                                    <asp:BoundField DataField="Award" HeaderText="Award" />
                                    <asp:CheckBoxField DataField="MultipleWinners" HeaderText="Multiple Winners Allowed?" />
                                    <asp:BoundField DataField="RecipientType" HeaderText="RecipientType" />
                                </Columns>
                                <HeaderStyle BackColor="#4A3C8C" Font-Bold="True" ForeColor="#F7F7F7" />
                                <RowStyle Height="18px" BackColor="#E7E7FF" ForeColor="#000044" />
                                <AlternatingRowStyle Height="18px" BackColor="#F7F7F7" />
                                <SelectedRowStyle BackColor="#738A9C" Font-Bold="True" ForeColor="#F7F7F7" />
                            </asp:GridView>
                        </td>
                    </tr>
                </table>

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
                                <asp:Literal ID="EditPanel_Literal2" runat="server" Text="Click Confirm you wish to remove this winner from the table." /><br />
                                <br />
                                <div style="width:100%; text-align:center">
                                      <asp:Literal ID="EditStatus_Literal" runat="server" Text=""></asp:Literal>
                                      <%--Hidden fields:--%>
                                      <asp:HiddenField ID="AwardType_HiddenField" runat="server"></asp:HiddenField>
                                      <asp:HiddenField ID="AwardID_HiddenField" runat="server"></asp:HiddenField>
                                      <asp:HiddenField ID="SubID_HiddenField" runat="server"></asp:HiddenField>

                                </div>  

                                <div>
                                    <asp:Panel ID="AddPanel" runat="server">
                                    <table>
                                    <tr>
                                        <th>Award Type</th><th>AwardID</th><th>SubID></th>    
                                    </tr>
                                    <tr>
                                        <td><asp:DropDownList ID="AwardType_DropDownList" runat="server" AutoPostBack="true" />
                                        <td><asp:DropDownList ID="AwardID_DropDownList" runat="server"  AutoPostBack="true" /></td>
                                        <td><asp:DropDownList ID="SubID_DropDownList" runat="server" AutoPostBack="true" /></td>
                                    </tr>     
                             </table>
                             </asp:Panel>
                             <asp:Panel ID="EditPanel" runat="server">
                             <table>
                                    <tr>
                                        <th>League</th><th>Competition</th><th>Trophy</th><th>Award</th><th>Multiple Winners</th><th>Recipient</th>
                                    </tr>
                                 <tr>
                                    <td><asp:DropDownList ID="League_DropDownList" runat="server"></asp:DropDownList></td>
                                    <td><asp:Literal ID="Competition_Literal" runat="server"></asp:Literal></td>
                                    <td><asp:TextBox ID="Trophy_TextBox" Width="200px
                                        " runat="server"></asp:TextBox></td>
                                    <td><asp:DropDownList ID="Award_DropDownList" runat="server">
                                            <asp:ListItem Text="Cash" Value="Cash" />
                                            <asp:ListItem Text="Prize" Value="Prize" />
                                            <asp:ListItem Text="Trophy" Value="Trophy"/>
                                        </asp:DropDownList></td>
                                    <td style="vertical-align:top"><asp:CheckBox ID="MultipleWinners_CheckBox" Text=" " runat="server" /></td>
                                    <td><asp:DropDownList ID="Recipient_DropDownList" runat="server">
                                            <asp:ListItem Text="Player" Value="Player" Selected="True" />
                                            <asp:ListItem Text="Team" Value="Team" />
                                        </asp:DropDownList></td>
                                 </tr>
                               </table>
                               </asp:Panel>
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
