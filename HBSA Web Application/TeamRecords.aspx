<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/MasterPage.master" CodeBehind="TeamRecords.aspx.vb" Inherits="HBSA_Web_Application.TeamRecords" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

       <script type = "text/javascript">
 
           //this script to detect the export, and load the generatefile page into a iFrame
           //so that ajax doesn't block the file download process
           var prm = Sys.WebForms.PageRequestManager.getInstance();
           prm.add_initializeRequest(InitializeRequest);
           function InitializeRequest(sender, args) {
               if (sender._postBackSettings.sourceElement.id.indexOf("Download_Button") != -1) {
                   var iframe = document.createElement("iframe");
                   iframe.src = "Admin/AdminDownload.aspx?source=TeamResultsData&fileName=TeamResultsData";
                   iframe.style.display = "none";
                   document.body.appendChild(iframe);
               }
           }
    </script>

    <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
       <asp:UpdateProgress runat="server" id="Update_Progress" DisplayAfter="10">
            <ProgressTemplate>
                <div id="Loading" style="position: fixed; left:440px;top:260px">
                    <asp:Image ID="loadingImage" runat="server" ImageUrl="~/images/AjaxLoading.gif" Width="100px" />
                </div>
            </ProgressTemplate>
        </asp:UpdateProgress>

    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
         <ContentTemplate>

           <div style="font-family: Verdana; color:Green; text-align:center; font-size:10pt; background-color: #CCFFCC;";>
            <b>Team record</b><br />
            <br />
            <asp:Literal ID="Selection_Literal" runat="server" Text="Select a league, section and team:"></asp:Literal>
            <br />
            <asp:DropDownList ID="Section_DropDownList" runat="server" BackColor="#FFFFCC" AutoPostBack="True" ></asp:DropDownList>
            &nbsp;&nbsp;&nbsp;
            <asp:DropDownList ID="Team_DropDownList" runat="server" BackColor="#FFFFCC" AutoPostBack="True" ></asp:DropDownList>
        <br />
                  <asp:Button ID="Download_Button" runat="server" Text="Download" Visible="false" />
                  <asp:Literal ID="Download_Literal" runat="server" Text=""></asp:Literal>
            <br />
            <table style="width:auto;margin-left:auto;margin-right:auto;">
                <tr>
                    <td style="vertical-align:top; text-align:center; font-weight:bolder;font-size:14px">
                        <asp:table ID="Points_Table" runat="server" Visible="false">
                            <asp:TableRow>
                                <asp:TableCell>Played</asp:TableCell><asp:TableCell><asp:Literal ID="Played_Literal" runat="server"></asp:Literal></asp:TableCell><asp:TableCell>&nbsp;&nbsp;&nbsp;&nbsp;</asp:TableCell>
                                <asp:TableCell>Won</asp:TableCell><asp:TableCell><asp:Literal ID="Won_Literal" runat="server"></asp:Literal></asp:TableCell><asp:TableCell>&nbsp;&nbsp;&nbsp;&nbsp;</asp:TableCell>
                                <asp:TableCell>Drawn</asp:TableCell><asp:TableCell><asp:Literal ID="Drawn_Literal" runat="server"></asp:Literal></asp:TableCell><asp:TableCell>&nbsp;&nbsp;&nbsp;&nbsp;</asp:TableCell>
                                <asp:TableCell>Lost</asp:TableCell><asp:TableCell><asp:Literal ID="Lost_Literal" runat="server"></asp:Literal></asp:TableCell><asp:TableCell>&nbsp;&nbsp;&nbsp;&nbsp;</asp:TableCell>
                                <asp:TableCell>Points</asp:TableCell><asp:TableCell><asp:Literal ID="Points_Literal" runat="server"></asp:Literal></asp:TableCell>
                            </asp:TableRow>
                        </asp:table>
                    </td>
                </tr>
            </table>
            <table style="width:auto;margin-left:auto;margin-right:auto;">
                <tr>
                    <td style="vertical-align:top; text-align:center;">
                        <asp:GridView ID="Results_GridView" runat="server" BackColor="White" 
                        BorderColor="#CC9966" BorderStyle="Solid" BorderWidth="1px" CellPadding="4" 
                        EnableModelValidation="True" Font-Size="9pt">
                        <AlternatingRowStyle BackColor="#F7F7F7" Height="18px" />
                        <HeaderStyle BackColor="#006600" Font-Bold="True" ForeColor="#FFFFCC" />
                        <RowStyle BackColor="White" ForeColor="#006600" Height="18px" />
                        </asp:GridView>
                    </td>
                </tr>
            </table>
        </div>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
