<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/admin/adminMasterPage.master" CodeBehind="Awards.aspx.vb" Inherits="HBSA_Web_Application.Awards" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .RowHeight {
            height: 31px;
        }

        /*Textbox Watermark*/
        .unwatermarked 
        {
            background-color: #FFFFFF;
            color: black;
        }
        .watermarked
        {
            background-color: #F0F8FF;
            color: gray;
        }
    </style>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

        <div style="text-align:left; width:100%">
        <h3>Awards - Winners Maintenance</h3>
            <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        
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

        function autoComplete1_OnClientPopulating(sender, args) {
            sender.set_contextKey(document.getElementById("<%=AwardType_HiddenField.ClientID%>").value
                          + '|' + document.getElementById("<%=AwardID_HiddenField.ClientID%>").value
                          + '|' + document.getElementById("<%=SubID_HiddenField.ClientID%>").value
                          + '|' + document.getElementById("<%=LeagueID_HiddenField.ClientID%>").value);

        }
        function autoComplete1_OnClientItemSelected (sender, args) {
            document.getElementById("<%=EntrantID_HiddenField.ClientID%>").value = args.get_value();
        }

    </script>

        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <ContentTemplate>
                <div style="text-align:left;">
                    <table>
                        <tr>
                            <td>
                                <div style="border: 1px solid #0000FF; color: #0000FF; background-color: #99CCFF">
                                    <table style="text-align:left">
                                        <tr>
                                            <td style="text-align:right" class="RowHeight">Select an award type:</td>
                                            <td class="RowHeight">
                                                <asp:DropDownList ID="Report_DropDownList" runat="server" BackColor="#FFFFCC" AutoPostBack="true" Width="120px" />
                                            </td>
                                            <td rowspan="3" style="width:400px">
                                                   Note that when the Generate button is clicked it will remove all entries for that award type
                                                   and generate winners for the selected award type. Other types will be left as is. When **All award types** 
                                                   is selected all winners will be removed and all types generated. Any awards
                                                   that were entered manually may need to be entered again (Add a winner)
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="text-align:right" >Generate a new table of winners:</td>
                                            <td style="text-align:left; vertical-align: super;">
                                                <asp:Button ID="Generate_Button" runat="server" Width="120px" Text="Generate" />
                                            </td>
                                        </tr>
                                        <tr id="ExportCells" runat="server" visible="false">
                                            <td> Click this to download the report as a spreadsheet csv file. </td>
                                            <td style="text-align:left; vertical-align: super;">
                                                <asp:Button ID="Export_Button" runat="server" Text="Download" Width="120px" />
                                                &nbsp;&nbsp; </td>
                                        </tr>
                                    </table>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                               <div style="border: 1px solid #0000FF; color: #0000FF; background-color: #99CCFF">
                                    <table style="text-align:left">
                                        <tr>
                                            <td style="text-align:right">Add a winner:</td>
                                            <td style="text-align:left; vertical-align: super;">
                                                <asp:Button ID="AddWinner_Button" runat="server" Width="118px" Text="Add a winner" />
                                                &nbsp;&nbsp; Click this to add a winner manually (for example &quot;Most promising young player&quot;.
                                            </td>
                                        </tr>
                                    </table>
                    </div>

                            </td>
                        </tr>
                    </table>
                </div>
                <p>
                <asp:Literal ID="Status_Literal" runat="server" />
                </p>
                <table>
                    <tr style="vertical-align:top">
                        <td>
                    <asp:GridView ID="Awards_GridView" runat="server"  
                        EnableModelValidation="True" Font-Size="9pt" Width="100%" BackColor="White" BorderColor="#E7E7FF" 
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

       <asp:Panel ID="Edit_Panel" runat="server" Visible="false">
            <div id="divEditWinner" style="border: 1px solid #000080; font-family: Arial, Helvetica, sans-serif; font-size: 8Pt; display:block; vertical-align: top; 
                                   text-align: left; position: fixed; background-color: #99CCFF;
                                   width:640px; top: 330px; left: 100px;
                                   ">
                <table style="width: 100%; height: 100%">
                    <tr>
                        <td onmousedown="dragStart(event, 'divEditWinner')" 
                            onmouseover="this.style.cursor='pointer';" 
                            style="height: 8px; border-right: #000080 1px solid; border-top: #000080 1px solid; border-left: #000080 1px solid; border-bottom: #000080 1px solid; background-image: url('../images/menuBarBG.gif');">
                            <strong>
                                <asp:Literal ID="EditPanel_Literal" runat="server" Text="Edit/Delete&nbsp;a&nbsp;winner"></asp:Literal></strong></td>
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
                                      <asp:HiddenField ID="LeagueID_HiddenField" runat="server"></asp:HiddenField>
                                      <asp:HiddenField ID="EntrantID_HiddenField" runat="server"></asp:HiddenField>
                                      <asp:HiddenField ID="Entrant2ID_HiddenField" runat="server"></asp:HiddenField>

                                      <asp:DropDownList ID="AvailableAwards_DropDownList" runat="server" Visible="false" AutoPostBack="true" />

                                  </div>  

                                  <div>
                                <table>
                                 <tr>
                                     <th>League</th><th>Competition</th><th>Trophy</th><th>Winner</th><th>Award</th>
                                 </tr>
                                 <tr>
                                    <td id="LeagueCell" runat="server"></td>
                                    <td id="CompetitionCell" runat="server"></td>
                                    <td id="TrophyCell" runat="server"></td>
                                    <td>
                                        <asp:TextBox ID="WinnerCell_TextBox" runat="server" Width="287px" />
                                            <ajaxToolkit:AutoCompleteExtender ID="AutoCompleteExtender1" runat="server" 
                                                 TargetControlID="WinnerCell_TextBox" DelimiterCharacters="" 
                                                  MinimumPrefixLength="1" EnableCaching="true" UseContextKey="True"
                                                  OnClientPopulating="autoComplete1_OnClientPopulating"
                                                  OnClientItemSelected="autoComplete1_OnClientItemSelected"
                                                  ServiceMethod="SuggestWinners" CompletionInterval="10"
                                                  CompletionSetCount="20" CompletionListCssClass="completionList" CompletionListItemCssClass="completionLlistItem" CompletionListHighlightedItemCssClass="completionItemHighlighted"></ajaxToolkit:AutoCompleteExtender>
                                              <ajaxToolkit:TextBoxWatermarkExtender ID="TextBoxWatermarkExtender1" 
                                                  runat="server" TargetControlID="WinnerCell_TextBox" 
                                                  WatermarkText="Start entering winner..."
                                                  WatermarkCssClass="watermarked" >

                                        </ajaxToolkit:TextBoxWatermarkExtender>
                                    </td>
                                    <td id="AwardCell" runat="server"></td>
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
