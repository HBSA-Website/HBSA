<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/admin/adminMasterPage.master" CodeBehind="Clubs.aspx.vb" Inherits="HBSA_Web_Application.Clubs" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="AjaxToolkit" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div style="text-align: left; width: 100%">
        <h3>Clubs Maintenance</h3>

        <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true"></asp:ScriptManager>

        <asp:UpdateProgress runat="server" ID="Update_Progress" DisplayAfter="10">
            <ProgressTemplate>
                <div id="Loading" style="position: fixed; left: 200px; top: 160px">
                    <asp:Image ID="loadingImage" runat="server" ImageUrl="~/images/AjaxLoading.gif" Width="100px" />
                </div>
            </ProgressTemplate>
        </asp:UpdateProgress>

        <div style="text-align: left; width: 100%">

            <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                <ContentTemplate>
                    <div style="text-align: left;">
                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    <asp:Button ID="Add_Button" runat="server" Text="Add New Club" />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    <asp:Button ID="Emails_Button" runat="server" Text="Get clubs email addresses" />

                        <p>
                            Note that this table can be sorted by clicking on a column heading, when the data will be shown in ascending or 
                        descending sequence of that column (first click is ascending, and subsequent clicks reverse the sequence).
                        </p>

                        <asp:GridView ID="Clubs_GridView" runat="server"
                            EnableModelValidation="True" Font-Size="9pt" BackColor="White" BorderColor="#E7E7FF"
                            BorderStyle="None" BorderWidth="1px" CellPadding="3"
                            DataKeyNames="ID" AllowSorting="True" EmptyDataText="No data found" HeaderStyle-HorizontalAlign="Left">
                            <Columns>
                                <asp:CommandField ShowDeleteButton="True" CausesValidation="False" InsertVisible="False" ShowCancelButton="False" ShowEditButton="True" />
                            </Columns>
                            <HeaderStyle BackColor="#4A3C8C" Font-Bold="True" ForeColor="#F7F7F7" HorizontalAlign="Left" />
                            <RowStyle Height="18px" BackColor="#E7E7FF" ForeColor="#000044" />
                            <AlternatingRowStyle Height="18px" BackColor="#F7F7F7" />
                            <SelectedRowStyle BackColor="#738A9C" Font-Bold="True" ForeColor="#F7F7F7" />
                        </asp:GridView>

                        <asp:Panel ID="Edit_Panel" runat="server" Visible="false">
                            <div id="divEditClub" style="border: 1px solid #000080; font-family: Arial, Helvetica, sans-serif; font-size: 8Pt; display: block; vertical-align: top; text-align: left; position: fixed; background-color: #99CCFF; width: 800px; top: 274px; left: 100px;">
                                <table style="width: 100%; height: 100%">
                                    <tr>
                                        <td onmousedown="dragStart(event, 'divEditClub')"
                                            onmouseover="this.style.cursor='pointer';"
                                            style="height: 8px; border-right: #000080 1px solid; border-top: #000080 1px solid; border-left: #000080 1px solid; border-bottom: #000080 1px solid; background-image: url('../images/menuBarBG.gif');">
                                            <strong>
                                                <asp:Literal ID="EditPanel_Literal" runat="server" Text="Club&nbsp;Details"></asp:Literal></strong></td>
                                    </tr>
                                </table>
                                <table
                                    style="padding: 4px; margin: 4px; font-size: 9pt; width: 100%; vertical-align: top;">
                                    <tr>
                                        <td colspan="5">
                                            <div id="Div1" style="display: block; text-align: left;">
                                                <br />
                                                <div style="width: 100%; text-align: center; font-size: 10pt; color: #000099;">
                                                    <asp:Literal ID="Edit_Literal" runat="server"></asp:Literal>
                                                    <span style="color: red">
                                                        <asp:Literal ID="Err_Literal" runat="server"></asp:Literal></span><br />
                                                </div>
                                                <div class="auto-style1">
                                                    <asp:TextBox ID="ID_TextBox" runat="server" Visible="false"></asp:TextBox>
                                                </div>

                                                <div>
                                                    <table>
                                                        <tr>
                                                            <th style="text-align: right;">Club&nbsp;Name</th>
                                                            <td>
                                                                <asp:TextBox ID="ClubName_TextBox" runat="server" CssClass="txtBox"></asp:TextBox></td>
                                                            <td></td>
                                                            <th style="text-align: right;">Contact&nbsp;Name</th>
                                                            <td>
                                                                <asp:TextBox ID="ContactName_TextBox" runat="server" CssClass="txtBox" Width="160px"></asp:TextBox></td>
                                                        </tr>
                                                        <tr>
                                                            <th style="text-align: right;">Address&nbsp;1</th>
                                                            <td>
                                                                <asp:TextBox ID="Address1_TextBox" runat="server" CssClass="txtBox"></asp:TextBox></td>
                                                            <td></td>
                                                            <th style="text-align: right;">Club&nbsp;Telephone</th>
                                                            <td>
                                                                <asp:TextBox ID="ContactTelephone_TextBox" runat="server" CssClass="txtBox" Width="100px"></asp:TextBox></td>
                                                        </tr>
                                                        <tr>
                                                            <th style="text-align: right;">Address&nbsp;2</th>
                                                            <td>
                                                                <asp:TextBox ID="Address2_TextBox" runat="server" CssClass="txtBox"></asp:TextBox></td>
                                                            <td></td>
                                                            <th style="text-align: right;">Contact&nbsp;Mobile</th>
                                                            <td>
                                                                <asp:TextBox ID="ContactMobile_TextBox" runat="server" CssClass="txtBox" Width="100px"></asp:TextBox></td>
                                                        </tr>
                                                        <tr>
                                                            <th style="text-align: right;">Post&nbsp;Code</th>
                                                            <td>
                                                                <asp:TextBox ID="PostCode_TextBox" runat="server" CssClass="txtBox"></asp:TextBox></td>
                                                        </tr>
                                                        <tr>
                                                            <th style="text-align: right;">Available&nbsp;Tables</th>
                                                            <td>
                                                                <asp:TextBox ID="Tables_TextBox" runat="server" CssClass="txtBox" Width="20px"></asp:TextBox></td>
                                                            <td></td>
                                                            <td style="text-align: right;">Club&nbsp;Login&nbsp;Email</td>
                                                            <td>
                                                                <asp:Label ID="ClubUserEmail_Label" runat="server" CssClass="txtBox" Width="320px"></asp:Label></td>
                                                        </tr>
                                                    </table>
                                                    <br />
                                                    <table style="width: 100%;">
                                                        <tr>
                                                            <td style="text-align: center">
                                                                <asp:Button ID="SubmitPlayer_Button" runat="server" Text="Submit" />
                                                            </td>
                                                            <td style="text-align: center">
                                                                <asp:Button ID="CancelPlayer_Button" runat="server" Text="Cancel" />
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

                        <asp:Panel ID="Emails_Panel" runat="server" Visible="false">
                            <div id="divEmails" style="border: 1px solid #000080; font-family: Arial, Helvetica, sans-serif; font-size: 10Pt; display: block; vertical-align: top; text-align: left; position: fixed; background-color: #99CCFF; width: 800px; top: 274px; left: 100px;">
                                <table style="width: 100%;">
                                    <tr>
                                        <td onmousedown="dragStart(event, 'divEmails')"
                                            onmouseover="this.style.cursor='pointer';"
                                            style="height: 8px; border-right: #000080 1px solid; border-top: #000080 1px solid; border-left: #000080 1px solid; border-bottom: #000080 1px solid; background-image: url('../images/menuBarBG.gif');">
                                            <strong>
                                                <asp:Literal ID="Literal1" runat="server" Text="Club&nbsp;Email&nbsp;Addresses"></asp:Literal></strong></td>
                                    </tr>
                                </table>
                                <div>

                                    <table style="text-align: left">
                                        <tr>
                                            <td style="text-align: right">Select a league: </td>
                                            <td>
                                                <asp:DropDownList ID="League_DropDownList" runat="server" BackColor="#FFFFCC" AutoPostBack="True">
                                                    <asp:ListItem Value="0" Text="ALL" Selected="True" />
                                                </asp:DropDownList>
                                            </td>
                                            <td style="text-align: right" id="sectionCell" runat="server">Select a division/section: </td>
                                            <td>
                                                <asp:DropDownList ID="Section_DropDownList" runat="server" BackColor="#FFFFCC" AutoPostBack="True">
                                                    <asp:ListItem Value="0" Text="ALL" Selected="True" />
                                                </asp:DropDownList>

                                            </td>
                                        </tr>
                                    </table>

                                    <p>
                                        The following is a list of clubs with registered teams: 
                     <br />
                                        <asp:TextBox ID="Emails_TextBox" runat="server" Height="71px" TextMode="MultiLine" Width="785px"></asp:TextBox>
                                        <asp:HyperLink ID="Email_Link" runat="server" Width="790px"> <br />Click here to open your email client with the addresses filled in.<br /> <br />Alternatively right click here, <i>then click "copy email address" or "copy link" to place the email addresses on your clip board</i>. </asp:HyperLink>
                                    </p>
                                    <p>
                                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                         <asp:Button ID="Close_Emails_Button" runat="server" Text="Close this window" />
                                    </p>
                                </div>
                        </asp:Panel>
                    </div>
                </ContentTemplate>
            </asp:UpdatePanel>

        </div>

    </div>


</asp:Content>
