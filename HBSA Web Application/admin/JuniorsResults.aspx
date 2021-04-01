<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/admin/adminMasterPage.master" CodeBehind="JuniorsResults.aspx.vb"  Inherits="HBSA_Web_Application.JuniorsResults" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <h3>Record Juniors' results</h3>

    Choose the match for which to record frame scores, and Click <u>Edit</u>.<br />
    Enter the frame scores in the boxes<br />
    Click <u>Update</u> to store the scores in the database, or click <u>Cancel.</u><br /><br />
    When all results are in, click this button to promote the winners and runners up to the KO stage.  <asp:Button ID="Button1" runat="server" Text="Promote to KO stage" />
    <asp:Literal ID="Promote_Literal" runat="server"></asp:Literal>
    <br />
    <em><span style="color:red;">NOTE:&nbsp; When this button is clicked, the draw for the semis and final will appear as normal on the Competitions Draw and Results page when selecting Juniors.</span></em><br /><br />

    <asp:GridView ID="GridView1" runat="server" ForeColor="#333333" 
                      AutoGenerateColumns="False">
        <AlternatingRowStyle BackColor="White" ForeColor="#284775" />
        <Columns>
            <asp:CommandField ShowEditButton="True" />
            <asp:BoundField DataField="ID" ReadOnly="True" HeaderText="ID" />
            <asp:BoundField DataField="Division" ReadOnly="True" HeaderText="Div" />
            <asp:BoundField DataField="HomePlayer" HeaderText="Home" ReadOnly="True" />
            <asp:BoundField DataField="AwayPlayer" HeaderText="Away" ReadOnly="True" />
            <asp:BoundField DataField="HomeFrame1" HeaderText="Home 1" ItemStyle-HorizontalAlign="Center" >
                <ItemStyle HorizontalAlign="Center"></ItemStyle>
            </asp:BoundField>
            <asp:BoundField DataField="AwayFrame1" HeaderText="Away 1" ItemStyle-HorizontalAlign="Center" >
                <ItemStyle HorizontalAlign="Center"></ItemStyle>
            </asp:BoundField>
            <asp:BoundField DataField="HomeFrame2" HeaderText="Home 2" ItemStyle-HorizontalAlign="Center" >
                <ItemStyle HorizontalAlign="Center"></ItemStyle>
            </asp:BoundField>
            <asp:BoundField DataField="AwayFrame2" HeaderText="Away 2" ItemStyle-HorizontalAlign="Center" >
                <ItemStyle HorizontalAlign="Center"></ItemStyle>
            </asp:BoundField>
            <asp:BoundField DataField="HomeFrame3" HeaderText="Home 3" ItemStyle-HorizontalAlign="Center" >
                <ItemStyle HorizontalAlign="Center"></ItemStyle>
            </asp:BoundField>
            <asp:BoundField DataField="AwayFrame3" HeaderText="Away 3" ItemStyle-HorizontalAlign="Center" >
                <ItemStyle HorizontalAlign="Center"></ItemStyle>
            </asp:BoundField>
        </Columns>
        <HeaderStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White" />
        <RowStyle BackColor="#F7F6F3" ForeColor="#333333" />
        <SelectedRowStyle BackColor="#E2DED6" Font-Bold="True" ForeColor="#333333" />
        <EditRowStyle BackColor="#999999" />
    </asp:GridView>

</asp:Content>
