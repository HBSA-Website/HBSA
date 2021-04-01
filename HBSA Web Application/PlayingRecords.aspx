<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/MasterPage.master" CodeBehind="PlayingRecords.aspx.vb" Inherits="HBSA_Web_Application.PlayingRecords" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div style="font-family: Verdana; font-size:10pt; color:Green; text-align:center; background-color:#ccffcc">
        <b>This season&#39;s playing records</b><br />
                <br /><span style="font-size:10pt">
        Select a league and/or a section, and/or a club, and/or a team and/or a player:
        </span>

        <br />
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        
           <script type="text/javascript">

               //this script to detect the export, and load the generatefile page into a iFrame
               //so that ajax doesn't block the file download process
               var prm = Sys.WebForms.PageRequestManager.getInstance();
               prm.add_initializeRequest(InitializeRequest);
               function InitializeRequest(sender, args) {
                   if (sender._postBackSettings.sourceElement.id.indexOf("Export_Button") != -1) {
                       var iframe = document.createElement("iframe");
                       iframe.src = "CreateAndDownloadFile.aspx?source=PlayingRecordsTable&fileName=Playing Records";
                       iframe.style.display = "none";
                       document.body.appendChild(iframe);
                   }
               }

               function autoComplete1_OnClientPopulating(sender, args) {
                   sender.set_contextKey(document.getElementById('<%=Section_DropDownList.ClientID%>').value + '|' + document.getElementById('<%=Clubs_DropDownList.ClientID%>').value);
               }

    </script> 

                   <asp:UpdateProgress runat="server" id="Update_Progress" DisplayAfter="10">
                        <ProgressTemplate>
                            <div id="Loading" style="position: fixed; left:50%;top:300px">
                                <asp:Image ID="loadingImage" runat="server" ImageUrl="~/images/AjaxLoading.gif" Width="100px" />
                            </div>
                        </ProgressTemplate>
                    </asp:UpdateProgress>

        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <ContentTemplate>
                <asp:DropDownList ID="Section_DropDownList" runat="server" BackColor="#FFFFCC" AutoPostBack="True" >
                </asp:DropDownList>
                &nbsp;&nbsp;&nbsp;
                <asp:DropDownList ID="Clubs_DropDownList" runat="server" BackColor="#FFFFCC" AutoPostBack="True" >
                </asp:DropDownList>
                &nbsp;&nbsp;&nbsp;
                <asp:DropDownList ID="Team_DropDownList" runat="server" BackColor="#FFFFCC" AutoPostBack="True" >
                </asp:DropDownList>
                &nbsp;&nbsp;&nbsp;<asp:TextBox ID="Player_TextBox" runat="server" BackColor="#FFFFCC"></asp:TextBox>
                                        <ajaxToolkit:AutoCompleteExtender ID="AutoCompleteExtender1" runat="server" TargetControlID="Player_TextBox" DelimiterCharacters="" 
                                             MinimumPrefixLength="1" EnableCaching="true" UseContextKey="True"
                                              OnClientPopulating="autoComplete1_OnClientPopulating"
                                              ServiceMethod="SuggestPlayers" CompletionInterval="10"
                                              CompletionSetCount="20" CompletionListCssClass="completionList" CompletionListItemCssClass="completionLlistItem" CompletionListHighlightedItemCssClass="completionItemHighlighted"></ajaxToolkit:AutoCompleteExtender>

                <br />
                <asp:CheckBox ID="Tagged_CheckBox" runat="server" Text="Tagged players." AutoPostBack="True" />
                &nbsp;&nbsp;&nbsp;<asp:CheckBox ID="Over70_CheckBox" runat="server" Text="Players over 70 (80 for Vets)." AutoPostBack="True" />
                &nbsp;&nbsp;&nbsp;<asp:CheckBox ID="Details_CheckBox" runat="server" Text="Show match details." AutoPostBack="True" />
                <br />
                <asp:Button ID="Get_Button" runat="server" Text="Show selected records" />
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                <asp:Button ID="Export_Button" runat="server" Text="Download as csv file" Visible="false" />        
                <br />
                <asp:Literal ID="Status_Literal" runat="server"></asp:Literal>
                <br />
                <div style="text-align: center; width: 100%">
                    <table style="width:auto; margin-left:auto; margin-right:auto;">
                        <tr>
                            <td style="vertical-align:top; text-align:center">
                                <asp:GridView ID="Records_GridView" runat="server" BackColor="White" 
                                        BorderColor="#CC9966" BorderStyle="Solid" BorderWidth="1px" CellPadding="4" 
                                        EnableModelValidation="True" Font-Size="9pt" EnableViewState="False" >
                                    <AlternatingRowStyle BackColor="#F7F7F7" />
                                    <HeaderStyle BackColor="#006600" Font-Bold="True" ForeColor="#FFFFCC" />
                                    <RowStyle BackColor="White" ForeColor="#006600" />
                                    <SelectedRowStyle BackColor="#FFCC66" Font-Bold="True" ForeColor="#663399" />
                                </asp:GridView>
                            </td>
                        </tr>
                    </table>
                </div>
            </ContentTemplate>
        </asp:UpdatePanel>
&nbsp;</div>
</asp:Content>
