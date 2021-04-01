<%@ Page Title="" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" Inherits="HBSA_Web_Application.Results" CodeBehind="Results.aspx.vb" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
    <asp:UpdateProgress runat="server" ID="Update_Progress" DisplayAfter="10">
        <ProgressTemplate>
            <div id="Loading" style="position: fixed; left: 440px; top: 260px">
                <asp:Image ID="loadingImage" runat="server" ImageUrl="~/images/AjaxLoading.gif" Width="100px" />
            </div>
        </ProgressTemplate>
    </asp:UpdateProgress>

    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>

            <div style="font-family: Verdana; color: Green; text-align: center; font-size: 10pt; background-color: #CCFFCC;">
                <b>Results</b><br />
                Missing results can be found under <a href="MissingResults.aspx">League &gt;&gt; MissingResults</a><br />
                <span style="color: #000099">
                    <asp:Literal ID="Selection_Literal" runat="server" Text="Select a league and section, then optionally a date and/or a team then click Show Results."></asp:Literal>
                </span>
                <br />
                <asp:DropDownList ID="Section_DropDownList" runat="server" BackColor="#FFFFCC" AutoPostBack="True"></asp:DropDownList>
                &nbsp;&nbsp;&nbsp;
            <asp:DropDownList ID="MatchDate_DropDownList" runat="server" BackColor="#FFFFCC"></asp:DropDownList>
                &nbsp;&nbsp;&nbsp;
            <asp:DropDownList ID="Team_DropDownList" runat="server" BackColor="#FFFFCC"></asp:DropDownList>
                &nbsp;&nbsp;&nbsp;
            <asp:Button ID="Get_Button" runat="server" Text="Show Results" />
                <br />
                <br />
                <table style="width: auto; margin-left:auto;margin-right:auto;">
                    <tr>
                        <td style="vertical-align: top; text-align: center">
                            <asp:GridView ID="Results_GridView" runat="server" BackColor="White"
                                BorderColor="#CC9966" BorderStyle="Solid" BorderWidth="1px" CellPadding="4"
                                EnableModelValidation="True" Font-Size="9pt" AutoGenerateColumns="False" Width="640px">
                                <%--<AlternatingRowStyle BackColor="#F7F7F7" Height="18px" />--%>
                                <HeaderStyle BackColor="#006600" Font-Bold="True" ForeColor="#FFFFCC" />
                                <RowStyle BackColor="White" ForeColor="#006600" Height="18px" />
                                <%--<SelectedRowStyle BackColor="#FFCC66" Font-Bold="True" ForeColor="#663399" />--%>
                                <Columns>
                                    <asp:CommandField ButtonType="Button" ControlStyle-Height="18px" ItemStyle-Width="72px"
                                        ControlStyle-Width="80px" ControlStyle-Font-Size="7pt" ControlStyle-ForeColor="#004400"
                                        SelectText="Score Card" ShowCancelButton="False" ShowSelectButton="True">
                                        <ControlStyle Font-Size="7pt" ForeColor="#004400" Height="18px" Width="70px"></ControlStyle>
                                        <ItemStyle Width="72px"></ItemStyle>
                                    </asp:CommandField>
                                    <asp:BoundField DataField="FixtureDate" HeaderText="Fixture Date" ItemStyle-Width="80px">
                                        <ItemStyle Width="80px"></ItemStyle>
                                    </asp:BoundField>
                                    <asp:BoundField DataField="Home" HeaderText="Home Team" ItemStyle-HorizontalAlign="Right">
                                        <ItemStyle HorizontalAlign="Right"></ItemStyle>
                                    </asp:BoundField>
                                    <asp:BoundField DataField="hFrames" HeaderText="" ItemStyle-Width="20px">
                                        <ItemStyle Width="20px"></ItemStyle>
                                    </asp:BoundField>
                                    <asp:BoundField DataField="aFrames" HeaderText="" ItemStyle-Width="20px">
                                        <ItemStyle Width="20px"></ItemStyle>
                                    </asp:BoundField>
                                    <asp:BoundField DataField="Away" HeaderText="Away Team"
                                        ItemStyle-HorizontalAlign="Left"></asp:BoundField>
                                    <asp:BoundField DataField="Match Date" HeaderText="Match Date" ItemStyle-Width="80px">
                                        <ItemStyle Width="80px"></ItemStyle>
                                    </asp:BoundField>
                                </Columns>
                            </asp:GridView>
                        </td>
                    </tr>
                </table>

                <asp:UpdatePanel ID="ScoreCard_Panel" runat="server" Visible="false">
                    <ContentTemplate>

                         <style type="text/css">
                             #resultCardTable td {
                                 border: 1px solid black;
                                 padding: 5px;
                             }
                             .resultRow {
                                 height: 16.5pt;
                                 color:Maroon;
                                 font-size: 10.0pt;
                                 font-weight: bold;
                                 text-align:center;
                                 vertical-align: middle;
                             }
                        </style>

                       <div id="divResultCard"
                            onmousedown="dragStart(event, 'divResultCard')"
                            onmouseover="this.style.cursor='pointer';"
                            style="position: fixed; border: none; top: 300px; left: 300px; color:black;">
                            
                           <table id="resultCardTable" style="width:auto; margin-left:auto; margin-right:auto;
                                          text-align: center; border:1px solid black; border-collapse: collapse; background-color: #eeFFee;">
                                <colgroup>
                                    <col style="width: 40px" />
                                    <col style="width: 40px" />
                                    <col style="width: 150px" />
                                    <col style="width: 0px" />
                                    <col style="width: 150px" />
                                    <col style="width: 40px; text-align:center;" />
                                    <col style="width: 40px" />
                                </colgroup>

                                <tr>
                                    <td style="font-weight:bold;text-align:center;" colspan="7" >
                                        <asp:Literal ID="League_Literal" runat="server"></asp:Literal></td>
<%--                                    <td>
                                        <asp:Button ID="Close_Button1" runat="server" Text="Close" /></td>--%>
                                </tr>
                                <tr>
                                    <td  colspan="2">
                                        <strong>Fixture date</strong></td>
                                    <td style="text-align: center;font-weight:bold;" colspan="3">
                                        SECTION &gt;&nbsp;&nbsp;&nbsp;<asp:Literal ID="Section_Literal" Text=" " runat="server"></asp:Literal>&nbsp;&nbsp;&nbsp;&nbsp;&lt; SECTION</td>
                                    <td colspan="2">
                                        <strong>Match date</strong></td>
                                </tr>
                                <tr>
                                    <td colspan="2"><asp:Literal ID="FixtureDate_Literal" runat="server">01 Jan 1900</asp:Literal></td>
                                    <td style="font-weight:bold;"><asp:Literal ID="HomeTeam_Literal" runat="server">Home Team</asp:Literal></td>
                                    <td rowspan="7"></td>
                                    <td style="font-weight:bold;"><asp:Literal ID="AwayTeam_Literal" runat="server">Away Team</asp:Literal></td>
                                    <td colspan="2"><asp:Literal ID="MatchDate_Literal" runat="server">01 Jan 1900</asp:Literal></td>
                                </tr>
                                <tr style="font-weight:bold;">
                                    <td>H&#39;Cap</td>
                                    <td>Score</td>
                                    <td>Home Players</td>
                                    <td>Away Players</td>
                                    <td>H&#39;Cap</td>
                                    <td>Score</td>
                                </tr>
                                <tr>
                                    <td><asp:Literal ID="HomeHcap1_Literal" runat="server">&nbsp;</asp:Literal></td>
                                    <td><asp:Literal ID="HomeScore1_Literal" runat="server">&nbsp;</asp:Literal></td>
                                    <td><asp:Literal ID="HomePlayer1_Literal" runat="server">&nbsp;</asp:Literal></td>
                                    <td><asp:Literal ID="AwayPlayer1_Literal" runat="server">&nbsp;</asp:Literal></td>
                                    <td><asp:Literal ID="AwayHcap1_Literal" runat="server">&nbsp;</asp:Literal></td>
                                    <td><asp:Literal ID="AwayScore1_Literal" runat="server">&nbsp;</asp:Literal></td>
                                </tr>
                                <tr>
                                    <td><asp:Literal ID="HomeHcap2_Literal" runat="server">&nbsp;</asp:Literal></td>
                                    <td><asp:Literal ID="HomeScore2_Literal" runat="server">&nbsp;</asp:Literal></td>
                                    <td><asp:Literal ID="HomePlayer2_Literal" runat="server">&nbsp;</asp:Literal></td>
                                    <td><asp:Literal ID="AwayPlayer2_Literal" runat="server">&nbsp;</asp:Literal></td>
                                    <td><asp:Literal ID="AwayHcap2_Literal" runat="server">&nbsp;</asp:Literal></td>
                                    <td><asp:Literal ID="AwayScore2_Literal" runat="server">&nbsp;</asp:Literal></td>
                                </tr>
                                <tr>
                                    <td><asp:Literal ID="HomeHcap3_Literal" runat="server">&nbsp;</asp:Literal></td>
                                    <td><asp:Literal ID="HomeScore3_Literal" runat="server">&nbsp;</asp:Literal></td>
                                    <td><asp:Literal ID="HomePlayer3_Literal" runat="server">&nbsp;</asp:Literal></td>
                                    <td><asp:Literal ID="AwayPlayer3_Literal" runat="server">&nbsp;</asp:Literal></td>
                                    <td><asp:Literal ID="AwayHcap3_Literal" runat="server">&nbsp;</asp:Literal></td>
                                    <td><asp:Literal ID="AwayScore3_Literal" runat="server">&nbsp;</asp:Literal></td>
                                </tr>
                                <tr>
                                    <td><asp:Literal ID="HomeHcap4_Literal" runat="server">&nbsp;</asp:Literal></td>
                                    <td><asp:Literal ID="HomeScore4_Literal" runat="server">&nbsp;</asp:Literal></td>
                                    <td><asp:Literal ID="HomePlayer4_Literal" runat="server">&nbsp;</asp:Literal></td>
                                    <td><asp:Literal ID="AwayPlayer4_Literal" runat="server">&nbsp;</asp:Literal></td>
                                    <td><asp:Literal ID="AwayHcap4_Literal" runat="server">&nbsp;</asp:Literal></td>
                                    <td><asp:Literal ID="AwayScore4_Literal" runat="server">&nbsp;</asp:Literal></td>
                                </tr>
                                <tr>
                                    <td style="vertical-align:top;text-align:left;" colspan="3">
                                        <span style="color: #006600;font-weight:bold;">Breaks</span>
                                        <asp:GridView ID="HomeBreaks_GridView" runat="server" CellPadding="4" Font-Size="10pt" 
                                                      GridLines="None" ShowHeader="False" ForeColor="#333333">
                                        </asp:GridView>
                                    </td>
                                    <td style="vertical-align: top;text-align:left;" colspan="3">
                                        <span style="color: #006600; font-weight:bold;">Breaks</span>
                                        <asp:GridView ID="AwayBreaks_GridView" runat="server" CellPadding="4" 
                                            GridLines="None" ShowHeader="False" Font-Size="8pt" ForeColor="#333333" BorderStyle="None">
                                        </asp:GridView>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="3" class="resultRow" style="text-align:left;">
                                        <asp:Button ID="Close_Button1" runat="server" Text="Close" />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                        Frames&nbsp;&nbsp;&nbsp; 
                                        <asp:Literal ID="HomeFrames_Literal" runat="server" Text="0"></asp:Literal>
                                    </td>

                                    <td></td>
                                    <td colspan="3" class="resultRow" style="text-align:right;">
                                        <asp:Literal ID="AwayFrames_Literal" runat="server" Text="0"></asp:Literal>
                                            &nbsp;&nbsp; Frames&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<asp:Button ID="Close_Button2" runat="server" Text="Close" />
                                </tr>
                            </table>

                        </div>
                    </ContentTemplate>
                </asp:UpdatePanel>

            </div>

        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>

