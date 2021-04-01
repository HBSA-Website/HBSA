<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/admin/adminMasterPage.master" CodeBehind="Sections.aspx.vb" Inherits="HBSA_Web_Application.Sections" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

           <div style="text-align:left; width:100%">
        <h3>Sections Maintenance</h3>
            <%--        <asp:ScriptManager ID="ScriptManager1" runat="server">
        </asp:ScriptManager>
        <asp:UpdateProgress ID="UpdateProgress1" runat="server" DisplayAfter="1000">
                <ProgressTemplate>Processing, please wait a moment...</ProgressTemplate></asp:UpdateProgress>
        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <ContentTemplate>--%>
                <div style="text-align:left;">
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    <asp:Button ID="Add_Button" runat="server" Text="Add New Division/Section" />
                    <br />
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    <span style="color:red"><asp:Literal ID="Err_Literal" runat="server"></asp:Literal></span>
                     <br />
                    &nbsp;
                    <asp:GridView ID="Sections_GridView" runat="server"  
                        EnableModelValidation="True" Font-Size="9pt" BackColor="White" BorderColor="#E7E7FF" 
                        BorderStyle="None" BorderWidth="1px" CellPadding="3"
                        DataKeyNames="ID" AllowSorting="false" EmptyDataText="No data found" HeaderStyle-HorizontalAlign="Left">
                        <Columns>
                            <asp:CommandField ShowDeleteButton="True" CausesValidation="False" InsertVisible="False" ShowCancelButton="False" ShowEditButton="True" />
                        </Columns>
                        <HeaderStyle BackColor="#4A3C8C" Font-Bold="True" ForeColor="#F7F7F7" HorizontalAlign="Left" />
                        <RowStyle Height="18px" BackColor="#E7E7FF" ForeColor="#000044" />
                        <AlternatingRowStyle Height="18px" BackColor="#F7F7F7" />
                        <SelectedRowStyle BackColor="#738A9C" Font-Bold="True" ForeColor="#F7F7F7" />
                    </asp:GridView>

      <asp:Panel ID="Edit_Panel" runat="server" Visible="false">
            <div id="divEditSection" style="border: 1px solid #000080; font-family: Arial, Helvetica, sans-serif; font-size: 8Pt; display:block; vertical-align: top; 
                                   text-align: left; position: fixed; background-color: #99CCFF;
                                   width:800px; top: 274px; left:100px;
                                   ">
                <table style="width: 100%; height: 100%">
                    <tr>
                        <td onmousedown="dragStart(event, 'divEditSection')" 
                            onmouseover="this.style.cursor='pointer';" 
                            style="height: 8px; border-right: #000080 1px solid; border-top: #000080 1px solid; border-left: #000080 1px solid; border-bottom: #000080 1px solid; background-image: url('../images/menuBarBG.gif');">
                            <strong>
                                <asp:Literal ID="EditPanel_Literal" runat="server" Text="Section&nbsp;Details"></asp:Literal></strong></td>
                    </tr>
                </table>
                <table 
                    style="font-size:9pt; width:100%; vertical-align: top;">
                    <tr>
                        <td colspan="5">
                                <div id="Div1" style="display:block; text-align: left;">
                                <br />
                                    <div style="width:100%; text-align:center; font-size: 10pt; color: #000099;">
                                        <asp:Literal ID="Edit_Literal" runat="server"></asp:Literal><br/><br/>
                                    </div>
                                    <div style="width:100%;">
                                      <asp:TextBox ID="ID_TextBox" runat="server" Visible="false"></asp:TextBox>
                                    </div>  

                                  <div>
                                <table">
                                    <tr>
                                        <th style="text-align:right;">Section&nbsp;Name</th><td><asp:TextBox ID="SectionName_TextBox" runat="server" CssClass="txtBox"></asp:TextBox></td>
                                    </tr>
                                    <tr>
                                        <th style="text-align:right;">League</th><td><asp:DropDownList ID="League_DropDownList" runat="server"></asp:DropDownList></td>
                                    </tr>
                                    <tr>
                                        <th style="text-align:right;">Reversed Matrix?</th><td><asp:CheckBox ID="ReversedMatrix_CheckBox" runat="server" Text=" " /></td>
                                    </tr>
                                    <tr>
                                        <th style="text-align:right;">Assign New Fixtures Grid?</th><td><asp:CheckBox ID="AssignMatrix_CheckBox" runat="server" Text=" " /></td>
                                    </tr>
                               </table>
                                      <br />
                              <table  style="width:100%;">
                                 <tr>
                                    <td style="text-align:center">
                                        <asp:Button ID="SubmitPlayer_Button" runat="server" Text="Submit" />
                                    </td>
                                    <td style="text-align:center">
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


                </div>
            <%--    </ContentTemplate>
        </asp:UpdatePanel>--%>

    </div>

</asp:Content>
