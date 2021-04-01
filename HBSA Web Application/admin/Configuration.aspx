<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/admin/adminMasterPage.master" CodeBehind="Configuration.aspx.vb" Inherits="HBSA_Web_Application.Configuration" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .txtBox {}
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <h3>Maintain Configuration</h3>
    <a href ="Settings.aspx">Click here to go to settings (preferred method of maintaining configuration).</a><br />
    <asp:LinkButton ID="Start_LinkButton" runat="server">Otherwise click here to use these configuration parameters.</asp:LinkButton>
    <p style="color: #FF6600">
        WARNING:<br />
        These items are critical to the operation of this web site.  If they are incorrectly changed, or deleted it could
        cause the system to crash or misbehave.<br />
        Therefore only make changes that you are confident will have the desired effect.
    </p>

    <asp:Panel ID="Main_Panel" runat="server" Visible="false">
    
        <asp:Button ID="Insert_Button" runat="server" Text="Add a new Configuration Item" /><br />

        <asp:Panel ID="Edit_Panel" runat="server" Visible="false">
        
        <div style="width:65%; border-style: solid; border-width: 3px; border-color:blue;">
            <asp:Literal ID="Edit_Literal" runat="server">Enter the new details</asp:Literal>&nbsp;then click Submit.
        <table style="">
            <tr>
                <td style="text-align:right; font-size:10pt">Configuration key: </td>
                <td><asp:TextBox ID="Key_TextBox" runat="server" CssClass="txtBox" Width="300px"></asp:TextBox></td>
            </tr>
            <tr>
                <td style="text-align:right;font-size:10pt">Value: </td>
                <td><asp:TextBox ID="Value_TextBox" runat="server" CssClass="txtBox" Width="500px"></asp:TextBox></td>
            </tr>
        </table>
        <p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<asp:Button ID="Submit_Button" runat="server" Text="Submit" />
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<asp:Button ID="Cancel_Button" runat="server" Text="Cancel" />
            </p>
        </div>
    </asp:Panel>
    
    <span style="color:red;"><asp:Literal ID="Error_Literal" runat="server"></asp:Literal></span>
    <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" ForeColor="#333333" GridLines="None">
        <AlternatingRowStyle BackColor="White" />
        <Columns>
            <asp:CommandField ShowDeleteButton="True" ShowEditButton="True" />
            <asp:BoundField DataField="Key" HeaderText="Key" SortExpression="Key" />
            <asp:BoundField DataField="Value" HeaderText="value" SortExpression="value" />
        </Columns>

        <EditRowStyle BackColor="#FFCC99" />
        <HeaderStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
        <RowStyle BackColor="#EFF3FB" />
        <SelectedRowStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
    </asp:GridView>
    </asp:Panel>

</asp:Content>
