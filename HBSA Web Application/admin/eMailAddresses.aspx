<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/admin/adminMasterPage.master" CodeBehind="EmailAddresses.aspx.vb" Inherits="HBSA_Web_Application.EmailAddresses" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">



    <div style="text-align:left; width:100%;">
       
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>

                    <asp:UpdateProgress runat="server" id="Update_Progress" DisplayAfter="10">
                        <ProgressTemplate>
                            <div id="Loading" style="position: fixed; left:35%;top:200px">
                                <asp:Image ID="loadingImage" runat="server" ImageUrl="~/images/AjaxLoading.gif" Width="100px" />
                            </div>
                        </ProgressTemplate>
                    </asp:UpdateProgress>
 
        <div style="text-align:left; width:100%">
    
            <h3>Email Addresses</h3>

            <asp:UpdatePanel ID="UpdatePanel1" runat="server">

                <ContentTemplate>

                    <table style="border: 1px solid black">
                        <tr>
                            <td>Current Email Address: </td>
                            <td>
                                <asp:TextBox ID="CurrentEmail_TextBox" runat="server" Width="256px"  />
                            </td>
                            <td>
                                <asp:Button ID="FindEmailAddresses_Button" runat="server" ForeColor="Blue" BackColor="DarkGray" Text="Find all instances of this address." Width="684px"  />
                            </td>
                         </tr>
                         <tr id="NewEmailAddress" runat="server" visible="false">
                            <td>New Email address: </td>
                            <td>
                                <asp:TextBox ID="NewEmailAddress_TextBox" runat="server" Width="256px" />
                            </td>
                            <td>
                                <asp:Button ID="ChangeAddress_Button" runat="server" ForeColor="Blue" BackColor="DarkGray" Text="Replace all instances of the Old Email address with the new Email Address" Width="684
                                    px"  />
                            </td>
                        </tr>
                    </table>
                      
                    <asp:Literal ID="Status_Literal" runat="server"></asp:Literal>
                    
                    <asp:GridView ID="EmailAddresses_GridView" runat="server" Font-Size="9pt" BackColor="White" BorderColor="Black" 
                        BorderStyle="Solid" BorderWidth="1px" CellPadding="6"
                        EmptyDataText="Cannot find any instances of this email address">
                        <Columns>
                            <asp:CommandField CausesValidation="False" InsertVisible="False" ShowCancelButton="False" SelectText="Details" ShowSelectButton="True" />
                        </Columns>
                        <HeaderStyle BackColor="#4A3C8C" Font-Bold="True" ForeColor="#F7F7F7" />
                        <RowStyle Height="18px" BackColor="#E7E7FF" ForeColor="#000044" />
                        <AlternatingRowStyle Height="18px" BackColor="#F7F7F7" />
                    </asp:GridView>

                    <asp:Panel ID="Email_Panel" runat="server" Visible="false">
                        <div id="Email_Div" style="position:fixed; top: 300px; left: 60px; background-color: #CCFFFF; border-style: solid; border-width: 1px; padding: 4px; table-layout: fixed; border-spacing: 2px;">
                            <asp:Button ID="Close_Button" runat="server" Text="Close this window" style="width: 158px" /><br /><br />
                            <asp:Literal ID="EmailAddress_Literal" runat="server">Email: Details</asp:Literal>
                            <table>
                                <tr>
                                    <td>
                                        <asp:GridView ID="EmailAddressDetail_GridView" runat="server" Font-Size="9pt" BackColor="White" BorderColor="Black" 
                                                        BorderStyle="Solid" BorderWidth="1px" CellPadding="2"
                                                        EmptyDataText="Cannot find any data for this table">
                                                <HeaderStyle BackColor="#4A3C8C" Font-Bold="True" ForeColor="#F7F7F7" />
                                                <RowStyle Height="18px" BackColor="#E7E7FF" ForeColor="#000044" />
                                                <AlternatingRowStyle Height="18px" BackColor="#F7F7F7" />
                                        </asp:GridView>
                                    </td>
                                </tr>
                            </table>
                        </div>

                    </asp:Panel>
                
                </ContentTemplate>

            </asp:UpdatePanel>

            <h3>Phone Numbers</h3>

            <asp:UpdatePanel ID="UpdatePanel2" runat="server">

                <ContentTemplate>

                    <table style="border:1px solid black">
                        <tr>
                            <td>Current Phone Number: </td>
                            <td>
                                <asp:TextBox ID="CurrentPhoneNo_TextBox" runat="server" Width="256px"  />
                            </td>
                            <td>
                                <asp:Button ID="FindPhoneNos_Button" runat="server" Text="Find all instances of this phone number." ForeColor="Blue" BackColor="DarkGray" Width="698px"  />
                            </td>
                         </tr>
                         <tr id="NewPhoneNo" runat="server" visible="false">
                            <td>New Phone Number: </td>
                            <td>
                                <asp:TextBox ID="NewPhoneNo_TextBox" runat="server" Width="256px" />
                            </td>
                            <td>
                                <asp:Button ID="ChangePhoneNo_Button" runat="server" ForeColor="Blue" BackColor="DarkGray" Text="Replace all instances of the Old Phone Number with the new Phone Number" Width="698px"  />
                            </td>
                        </tr>
                    </table>
                      
                    <asp:Literal ID="PhoneNoStatus_Literal" runat="server"></asp:Literal>
                    
                    <asp:GridView ID="PhoneNos_GridView" runat="server" Font-Size="9pt" BackColor="White" BorderColor="Black" 
                        BorderStyle="Solid" BorderWidth="1px" CellPadding="6"
                        EmptyDataText="Cannot find any instances of this Phone Number">
                        <Columns>
                            <asp:CommandField CausesValidation="False" InsertVisible="False" ShowCancelButton="False" SelectText="Details" ShowSelectButton="True" />
                        </Columns>
                        <HeaderStyle BackColor="#4A3C8C" Font-Bold="True" ForeColor="#F7F7F7" />
                        <RowStyle Height="18px" BackColor="#E7E7FF" ForeColor="#000044" />
                        <AlternatingRowStyle Height="18px" BackColor="#F7F7F7" />
                    </asp:GridView>

                    <asp:Panel ID="PhoneNo_Panel" runat="server" Visible="false">
                        <div id="PhoneNo_Div" style="position:fixed; top: 300px; left: 60px; background-color: #CCFFFF; border-style: solid; border-width: 1px; padding: 4px; table-layout: fixed; border-spacing: 2px;">
                            <asp:Button ID="PhoneNoClose_Button" runat="server" Text="Close this window" style="width: 158px" /><br /><br />
                            <asp:Literal ID="PhoneNo_Literal" runat="server">PhoneNo: Details</asp:Literal>
                            <table>
                                <tr>
                                    <td>
                                        <asp:GridView ID="PhoneNoDetail_GridView" runat="server" Font-Size="9pt" BackColor="White" BorderColor="Black" 
                                                        BorderStyle="Solid" BorderWidth="1px" CellPadding="2"
                                                        EmptyDataText="Cannot find any data for this table">
                                                <HeaderStyle BackColor="#4A3C8C" Font-Bold="True" ForeColor="#F7F7F7" />
                                                <RowStyle Height="18px" BackColor="#E7E7FF" ForeColor="#000044" />
                                                <AlternatingRowStyle Height="18px" BackColor="#F7F7F7" />
                                        </asp:GridView>
                                    </td>
                                </tr>
                            </table>
                        </div>

                    </asp:Panel>
                
                </ContentTemplate>

            </asp:UpdatePanel>

       </div>
    </div>
</asp:Content>
