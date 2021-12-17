<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/admin/adminMasterPage.master" CodeBehind="NewPlayers.aspx.vb" Inherits="HBSA_Web_Application.NewPlayers" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .BigCheckBox input {
            width: 15px;
            height: 15px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <h3>New players</h3>
    <asp:Literal ID="Status_Literal" runat="server"></asp:Literal><br />

    <asp:GridView ID="NewPlayers_GridView" runat="server" Font-Size="10pt" CellPadding="4"
        EmptyDataText="No new players." ForeColor="#333333" AutoGenerateColumns="True">

        <Columns>
            <asp:CommandField EditText="Change Handicap" InsertVisible="False" ShowCancelButton="False" ShowEditButton="True" />
        </Columns>

        <HeaderStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
        <RowStyle Height="18px" BackColor="#EFF3FB" />
        <AlternatingRowStyle Height="18px" BackColor="White" />

    </asp:GridView>

     <asp:Panel ID="HandicapChange_Panel" runat="server" Visible="false">
            <div id="divHandicapChange" style="border: 1px solid #000080; font-family: Arial, Helvetica, sans-serif; font-size: 11Pt;
                 display: block; vertical-align: top; text-align: left; position: fixed; background-color: #99CCFF; top: 300px; left:50px;">
                <table style="width: 100%; height: 100%">
                    <tr>
                        <td onmousedown="dragStart(event, 'divHandicapChange')"
                            onmouseover="this.style.cursor='pointer';"
                            style="height: 8px; border-right: #000080 1px solid; border-top: #000080 1px solid; border-left: #000080 1px solid; border-bottom: #000080 1px solid; background-image: url('../images/menuBarBG.gif');">
                            <strong>
                                <asp:Literal ID="EditPanel_Literal" runat="server" Text="New&nbsp;Player&nbsp;Handicap"></asp:Literal></strong></td>
                    </tr>
                </table>
                <br />

                <div style="width: 100%; text-align: center; padding: 1px 10px 1px 10px">
                    Enter the new handicap then click Submit.
                <br />
                    Otherwise click cancel<br />
                    <br />
                    Tick to send 'changed handicap' email <asp:CheckBox CssClass="BigCheckBox" ID="SendEmails_CheckBox" runat="server" Text=" to relevant parties." /><br />
                    <br /><asp:Label ID="Player_Label" runat="server" Text="Player Name"></asp:Label>
                    &nbsp;<asp:Label ID="PlayerID_Label" runat="server" Text="PlayerID" Visible="false"></asp:Label>
                    <br /><b>&nbsp;&nbsp;&nbsp;&nbsp;Handicap:</b>&nbsp;&nbsp;&nbsp;&nbsp;
                    <asp:TextBox ID="Handicap_TextBox" runat="server" BackColor="#FFFFCC" Style="text-align: center;" Width="32px"></asp:TextBox>
                    <br />
                    <br />
                    <asp:Button ID="SubmitPlayer_Button" runat="server" Text="Submit" />
                    &nbsp;&nbsp;&nbsp;&nbsp;                           
                    <asp:Button ID="CancelPlayer_Button" runat="server" Text="Cancel" />
                    <br />
                    <span style="color:red"><asp:Literal ID="Error_Literal" runat="server"></asp:Literal></span>
                    <br />

                </div>
            </div>
    </asp:Panel>
</asp:Content>
