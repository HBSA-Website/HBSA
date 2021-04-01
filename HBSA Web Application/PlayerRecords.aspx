<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/MasterPage.master" CodeBehind="PlayerRecords.aspx.vb" Inherits="HBSA_Web_Application.PlayerRecords" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="AjaxToolkit" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div style="font-family: Verdana; color:Green; text-align:center; font-size:10pt; background-color: #CCFFCC" >
            <b>Players' Records</b><br />
        <asp:ScriptManager ID="ToolkitScriptManager1" runat="server" EnablePageMethods="true" ></asp:ScriptManager>

            <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                <ContentTemplate>

    <script type = "text/javascript">

        function autoComplete1_OnClientPopulating(sender, args) {
            sender.set_contextKey(document.getElementById("<%=League_DropDownList.ClientID%>").value);
        }
    </script>
                    <asp:UpdateProgress runat="server" id="Update_Progress" DisplayAfter="10">
                        <ProgressTemplate>
                            <div id="Loading" style="position: fixed; left:200px;top:160px">
                                <asp:Image ID="loadingImage" runat="server" ImageUrl="~/images/AjaxLoading.gif" Width="100px" />
                            </div>
                        </ProgressTemplate>
                    </asp:UpdateProgress>


            <br />
            Selection criteria:
            <br />

    <table style="width:auto; margin-left:auto; margin-right:auto">
        <tr>
            <td style="vertical-align:top; text-align:center">
            <table>
                <tr>
                    <th style="padding:4px;">League</th>
                    <th style="padding:4px;">Season</th>
                    <th style="padding:4px;">Player name</th>
                </tr>
                <tr>
                    <td style="padding:4px;"><asp:DropDownList ID="League_DropDownList" runat="server" BackColor="#FFFFCC" AutoPostBack="True" ></asp:DropDownList></td>
                    <td style="padding:4px;"><asp:DropDownList ID="Season_DropDownList" runat="server" BackColor="#FFFFCC"></asp:DropDownList></td>
                    <td style="padding:4px;">
                        <asp:TextBox ID="Name_TextBox" runat="server" BackColor="#FFFFCC" Height="16px" Width="248px" ></asp:TextBox>
                            <AjaxToolkit:AutoCompleteExtender ID="AutoCompleteExtender1" runat="server" TargetControlID="Name_TextBox" DelimiterCharacters="" 
                                               OnClientPopulating="autoComplete1_OnClientPopulating"
                                               MinimumPrefixLength="1" EnableCaching="true" UseContextKey="True"
                                               ServiceMethod="SuggestPlayers" CompletionInterval="10"
                                               CompletionSetCount="20" CompletionListCssClass="completionList" CompletionListItemCssClass="completionLlistItem" CompletionListHighlightedItemCssClass="completionItemHighlighted"></AjaxToolkit:AutoCompleteExtender>

                    </td>
                    <td style="padding:4px;"><asp:Button ID="GetRecords_Button" runat="server" Text="Get the records" Height="20px" Font-Size="9pt" /></td>
                </tr>
            </table>

            </td>
        </tr>
    </table>
    <span style="color:red"><asp:Literal ID="Error_Literal" runat="server"></asp:Literal></span>
        <br />
           <table style="width:auto; margin-left:auto; margin-right:auto">
                <tr>
                        <td>
                            <asp:GridView ID="PlayerRecords_GridView" runat="server" AllowPaging="True" BackColor="White" BorderColor="#CC9966" BorderStyle="Solid" BorderWidth="1px" CellPadding="4" EmptyDataText="No records found for the given criteria." EnableModelValidation="True" Font-Size="9pt" PageSize="10" Width="600px">
                                <AlternatingRowStyle BackColor="#F7F7F7" Height="18px" />
                                <HeaderStyle BackColor="#006600" Font-Bold="True" ForeColor="#FFFFCC" />
                                <RowStyle BackColor="White" ForeColor="#006600" Height="18px" />
                                <PagerSettings mode="NumericFirstLast" PageButtonCount="10" Position="TopAndBottom" />
                                <PagerTemplate>
                                    <div class="pager">
                                        <div style="width: 600px">
                                            <table style="width:600px">
                                                <tr>
                                                    <td style="text-align:left; vertical-align:bottom; width:66%;">
                                                        <asp:ImageButton ID="PagerFirst_Button" runat="server" AlternateText="Click this to navigate to the first page" CommandArgument="First" ImageUrl="~/images/BlueCircle-First.png" OnCommand="PagerCommand" ToolTip="Click to go to the first page" />
                                                        <asp:ImageButton ID="PagerPrev_Button" runat="server" AlternateText="Click this to navigate to the previous page" CommandArgument="Prev" ImageUrl="~/Images/BlueCircle-Previous.png" OnCommand="PagerCommand" ToolTip="Click to go to the previous page" />
                                                        <span>Page:
                                                        <asp:DropDownList ID="PagerPages_DropDown" runat="server" AutoPostBack="True" OnSelectedIndexChanged="PagerDD_SelectedIndexChanged" ToolTip="Select to go directly to a page" />
                                                        <asp:Literal ID="PageCount_Label" runat="server" />
                                                        <asp:ImageButton ID="PagerNext_Button" runat="server" AlternateText="Click this to navigate to the next page" CommandArgument="Next" ImageUrl="~/Images/BlueCircle-Next.png" OnCommand="PagerCommand" ToolTip="Click to go to the next page" />
                                                        <asp:ImageButton ID="PagerLast_Button" runat="server" AlternateText="Click this to navigate to the last page" CommandArgument="Last" ImageUrl="~/Images/BlueCircle-Last.png" OnCommand="PagerCommand" ToolTip="Click to go to the last page" />
                                                        </span></td>
                                                    <td style="text-align:right; vertical-align:middle">Rows per page:
                                                        <asp:DropDownList ID="RowsPerPage_DropDown" runat="server" AutoPostBack="True" OnSelectedIndexChanged="RowsPerPage_SelectedIndexChanged" ToolTip="Select another page size" />
                                                    </td>
                                                </tr>
                                            </table>
                                            </span>
                                        </div>
                                    </div>
                                </PagerTemplate>
                            </asp:GridView>
                        </td>
                </tr>
            </table>

                </ContentTemplate>
            </asp:UpdatePanel>
        </div>

</asp:Content>
