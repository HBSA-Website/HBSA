<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/MasterPage.master" CodeBehind="UnseasonedPlayers.aspx.vb"
    Inherits="HBSA_Web_Application.UnseasonedPlayers" ClientIDMode="Static" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="AjaxToolkit" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">


    <script type="text/javascript">

        function autoComplete1_OnClientPopulating(sender, args) {
            sender.set_contextKey(document.getElementById("<%=Section_DropDownList.ClientID%>").value + '|' + document.getElementById("<%=Club_DropDownList.ClientID%>").value);
        }

    </script>

    <h3 style="text-align: center">Unseasoned Players Report</h3>

    <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true"></asp:ScriptManager>

    <asp:UpdateProgress runat="server" ID="Update_Progress" DisplayAfter="10">
        <ProgressTemplate>
            <div id="Loading" style="position: fixed; left: 440px; top: 260px">
                <asp:Image ID="loadingImage" runat="server" ImageUrl="~/images/AjaxLoading.gif" Width="100px" />
            </div>
        </ProgressTemplate>
    </asp:UpdateProgress>

    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>

            <style type="text/css">
                #tbl1 td {
                    padding: 4px;
                }

                #tbl2 td {
                    padding: 4px;
                }

                #UnseasonedPlayers_GridView td {
                    padding: 4px;
                }
            </style>

            <div style="text-align: center; width: auto; margin-left: auto; margin-right: auto;">
                <div style="text-align: left">
                    This report shows details of unseasoned players, and their current record and handicap(s).<br />
                    <br />
                    It shows the last date that the player recorded a match result, 
                        his/her name and his/her handicap that was used for up to the last 6 matches.<br />
                    <br />
                    Then the playing record for those matches followed by any action needed with respect to the handicap,
                        and the new handicap if it has been changed, or soon will be.<br />
                    <br />
                </div>
            </div>

            <table style="width: auto; margin-left: auto; margin-right: auto; background: #CCFFCC; border: 1px solid black">
                <tr>
                    <td>
                        <table id="tbl1" style="text-align: left">
                            <tr>
                                <td style="text-align: right">Select a division/section or league:</td>
                                <td>
                                    <asp:DropDownList ID="Section_DropDownList" runat="server" BackColor="#FFFFCC" AutoPostBack="True" />
                                </td>
                                <td style="text-align: center">
                                    <asp:CheckBox ID="ActionNeeded_CheckBox" runat="server" Text="Only show players whose handicap due to change." TextAlign="Left" Checked="True" />
                                </td>
                            </tr>
                            <tr>
                                <td style="text-align: right">Select a club: </td>
                                <td>
                                    <asp:DropDownList ID="Club_DropDownList" runat="server" BackColor="#FFFFCC" AutoPostBack="True" />
                                </td>
                                <td style="text-align: center">
                                    <asp:Button ID="GetReport_Button" runat="server" Text="Report" />
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td style="font-size: larger; font-weight: bold; text-align: center">&nbsp;&nbsp;AND / OR&nbsp;&nbsp;</td>
                </tr>
                <tr>
                    <td>
                        <table id="tbl2" style="text-align: left">
                            <tr>
                                <td colspan="2">Enter the start of a player&#39;s surname and/or the start of a player&#39;s christian name: </td>
                            </tr>
                            <tr>
                                <td style="text-align: right">Select the required player, and click Report</td>
                                <td>
                                    <asp:TextBox ID="Player_TextBox" runat="server" BackColor="#FFFFCC" Width="193px" Height="18px"></asp:TextBox>
                                    <ajaxToolkit:AutoCompleteExtender ID="AutoCompleteExtender1" runat="server" TargetControlID="Player_TextBox" DelimiterCharacters=""
                                        MinimumPrefixLength="1" EnableCaching="false" UseContextKey="true"
                                        ServiceMethod="SuggestPlayers" CompletionInterval="10"
                                        OnClientPopulating="autoComplete1_OnClientPopulating"
                                        CompletionSetCount="20" CompletionListCssClass="completionList" CompletionListItemCssClass="completionLlistItem" CompletionListHighlightedItemCssClass="completionItemHighlighted">
                                    </ajaxToolkit:AutoCompleteExtender>
                                </td>
                                <td>
                                    <asp:Button ID="GetByName_Button" runat="server" Text="Report" /></td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>


            <br />
            <table style="width: auto; margin-left: auto; margin-right: auto;">
                <tr>
                    <td>
                        <asp:GridView ID="UnseasonedPlayers_GridView" runat="server" BackColor="White" EmptyDataText="There are no unseasoned players for the selection criteria given."
                            BorderColor="#CC9966" BorderStyle="Solid" BorderWidth="1px" CellPadding="4" Font-Size="9pt">
                            <AlternatingRowStyle BackColor="#F7F7F7" HorizontalAlign="Left" />
                            <HeaderStyle BackColor="#006600" Font-Bold="True" ForeColor="#FFFFCC" />
                            <RowStyle BackColor="White" ForeColor="#006600" HorizontalAlign="Left" />
                        </asp:GridView>
                    </td>
                </tr>
            </table>

        </ContentTemplate>
    </asp:UpdatePanel>

</asp:Content>
