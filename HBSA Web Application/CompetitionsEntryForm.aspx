<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/MasterPage.master" CodeBehind="CompetitionsEntryForm.aspx.vb" 
         Inherits="HBSA_Web_Application.CompetitionsEntryForm" validateRequest="false" ClientIDMode="Static" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="AjaxToolkit" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .auto-style3 {
            font-size: 9pt;
            font-style: italic;
            color:red;
        }
 
        .auto-style4 {
            font-size: 9pt;
            color: #0033CC;
            border-left-color: #A0A0A0;
            border-right-color: #C0C0C0;
            border-top-color: #A0A0A0;
            border-bottom-color: #C0C0C0;
            padding: 1px;
        }

        .auto-style5 {
            width: 100%;
        }

    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div style="font-family: Verdana; color:darkgrey; text-align:center; background-color:white; font-size: 11pt;">
        <b>Huddersfield Billiards &amp; Snooker Association<br />
            <asp:Literal ID="Season_Literal" runat="server"></asp:Literal>&nbsp;Competitions Entry Form<br />
        ENTRIES ACCEPTED SUBJECT TO HBSA LEAGUE RULES</b>
        <br />
        
        <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true"></asp:ScriptManager>

        <asp:UpdateProgress runat="server" id="Update_Progress" DisplayAfter="10">
            <ProgressTemplate>
                <div id="Loading" style="position: fixed; left:440px;top:260px">
                    <asp:Image ID="loadingImage" runat="server" ImageUrl="~/images/AjaxLoading.gif" Width="100px" />
                </div>
            </ProgressTemplate>
        </asp:UpdateProgress>
        <hr />

            <asp:Literal ID="Head_Literal" runat="server"></asp:Literal>

        <hr />
        <div style="text-align: left">
            <asp:Literal ID="Club_Selector_Literal" runat="server"></asp:Literal><br />
        </div>

        <div style="text-align: left">
            <br />
            <asp:DropDownList ID="Club_DropDownList" runat="server" BackColor="#FFFFCC" AutoPostBack="True" style="text-align:left"></asp:DropDownList>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<asp:Literal ID="Club_WIP_Literal" runat="server"></asp:Literal> 
            <br />
                    <%--<asp:ImageButton ID="PayPal_Button0" runat="server" ImageUrl="https://www.paypalobjects.com/en_GB/i/btn/btn_paynowCC_LG.gif" Visible="False" />--%>
        </div>
                    <a href="InfoPage.aspx?Subject=Competition%20Entry%20Form%20Help&Title=Competition%20Entry%20Form%20Help">Help - Click here for help with Competition Entries and Payments etc.</a>
        <hr />
    <asp:UpdatePanel ID="CompetitionsPanel" runat="server" Visible="false">
        <ContentTemplate>
      <table style="text-align:left; vertical-align:top; " class="auto-style5" >
            <tr>
                <td colspan="4" style="text-align:left;"><b>Select a Competition</b>
                    <i> (Select and work through each competition.)</i></td>
                <td></td>
            </tr>
            <tr style="vertical-align: top;">
                <td style="font-size: 11px; width:400px;">
                    
                    <asp:GridView ID="Competitions_GridView" runat="server"
                                    BorderStyle="Solid" BorderWidth="1px" CellPadding="2" ShowHeader="false"
                                    AllowSorting="false" EmptyDataText="Click Add a team" Font-Size="8pt">
                                    <Columns>
                                        <asp:CommandField ShowSelectButton="True" />
                                    </Columns>
                                    <AlternatingRowStyle BackColor="#F7F7F7" HorizontalAlign="Left" />
                                    <HeaderStyle BackColor="#333333" Font-Bold="True" ForeColor="#FFFFCC" Height="0px" />
                                    <RowStyle BackColor="White" ForeColor="#333333" HorizontalAlign="Left" />
                                    <SelectedRowStyle BackColor="#FFCC66" Font-Bold="True" ForeColor="#663399" />
                                </asp:GridView>
                    <div style="text-align:center; font-size:8pt; color:blue">
                        <asp:Literal ID="Comment_Literal" runat="server"></asp:Literal><br />
                        <asp:Literal ID="Fee_Literal" runat="server"></asp:Literal>
                    </div>
                    <br /><br />
                    <asp:Button ID="Show_Button" runat="server" Text="Show all entry form details"/>
                                     <br /><br />
                </td>

                <td style="text-align:left"> Select Entrants.<br />
                                  <asp:Literal ID="NonClub_Literal" runat="server"><i>Note only this club's players are shown.  To see all players in the league tick the ALL box.</i><br /></asp:Literal>

                                  <asp:CheckBox ID="Entrants_CheckBox" runat="server" Text="ALL  " Visible="false" autopostback="true" Font-Size="10pt" />
                                  <asp:DropDownList ID="Entrants_DropDownList" runat="server" Visible="false" autopostback="true" />
                                  <asp:Literal ID="SortBy_Literal" runat="server" Visible="false">Sort By</asp:Literal>
                                  <asp:DropDownList ID="SortBy_DropDownList" runat="server" AutoPostBack="true" Visible="false">
                                        <asp:ListItem Value="0">Surname</asp:ListItem>
                                        <asp:ListItem Value="1" Selected="True">First Name</asp:ListItem>
                                  </asp:DropDownList>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                  <asp:CheckBox ID="Entrant2_CheckBox" runat="server" Text="ALL   " Visible="false" autopostback="true" Font-Size="10pt" />
                                  <asp:DropDownList ID="Entrant2_DropDownList" runat="server" Visible="false" autopostback="true" />
                                 <br />
                                 <span class="auto-style3">NOTE: ALL entrants must have at least a telephone number, or an email address.</span>

                           		<div id="divHCapMsg" runat="server" 
                                       style="border: 1px solid #000080; font-family: Arial, Helvetica, sans-serif; font-size: 10Pt;  display:block;
				                       text-align: left; color:red; background-color: #ccffcc; position: relative;" onclick="hideDiv(this);">
								    <strong>Warning:</strong><br />
                                       <asp:Literal ID="notQualified_Literal" runat="server"></asp:Literal>
								</div>


                                 <br />
                                 <asp:GridView ID="Entrants_GridView" runat="server"
                                    BorderStyle="Solid" BorderWidth="1px" CellPadding="2" EmptyDataText="Select an entrant" Font-Size="8pt"
                                    AutoGenerateDeleteButton="True" AutoGenerateColumns="False">
                                    <AlternatingRowStyle BackColor="#F7F7F7" HorizontalAlign="Left" />
                                     <Columns>
                                         <asp:BoundField DataField="EntrantID" HeaderText="ID" />
                                         <asp:BoundField DataField="Entrant" HeaderText="Entrant" />
                                         <asp:TemplateField HeaderText="TelNo">
                                             <ItemTemplate>
                                                 <asp:TextBox ID="TelNo_TextBox" runat="server" MaxLength="20" Width="80px"></asp:TextBox>
                                             </ItemTemplate>
                                             <ControlStyle Font-Size="9pt" ForeColor="#333333" />
                                         </asp:TemplateField>
                                         <asp:TemplateField HeaderText="Email">
                                             <ItemTemplate>
                                                 <asp:TextBox ID="Email_TextBox" runat="server" Width="260px"></asp:TextBox>
                                             </ItemTemplate>
                                             <ControlStyle Font-Size="9pt" ForeColor="#333333" />
                                         </asp:TemplateField>
                                     </Columns>
                                    <HeaderStyle BackColor="#333333" Font-Bold="True" ForeColor="#FFFFCC" />
                                    <RowStyle BackColor="White" ForeColor="#333333" HorizontalAlign="Left" />
                                    <SelectedRowStyle BackColor="#FFCC66" Font-Bold="True" ForeColor="#663399" />
                                </asp:GridView>
                    <br />
                    <asp:Button ID="SaveCompetition_Button" runat="server" Text="Save this competition entry" /><br />
                    <span class="auto-style4"><asp:Literal ID="SaveCompetition_Literal" Text="" runat="server"></asp:Literal></span>
                 </td>
            </tr>
			<tr>
                <td colspan="4" style="vertical-align:top;" class="privacy"><asp:CheckBox ID="privacyCheckBox" text=" " runat="server" TextAlign="Left" Checked="True" Font-Size="12
                    pt"/>
				Tick this box to indicate that you give consent for the HBSA to record personal data as shown on this form, and that you have the express permission to do so for all persons named on this form.</td>
	        </tr>

            <tr>
                <td colspan="4" class="auto-style4" style="font-size: 10pt;">
                        When all competitions have been checked, and are as required, click this button:
                 <br />
                 <asp:Button ID="submitEntryForm_Button" runat="server" Text="Submit the entry form." Font-Size="Large" Width="205px" />
                        <a href="InfoPage.aspx?Subject=Competition%20Entry%20Form%20Help&amp;Title=Competition%20Entry%20Form%20Help">Help - Click here for help with Competition Entries and Payments etc.</a><br />
                    <span><asp:Literal ID="Submit_Literal" runat="server"></asp:Literal></span>
                  <br />
                    <%--<asp:ImageButton ID="PayPal_Button" runat="server" ImageUrl="https://www.paypalobjects.com/en_GB/i/btn/btn_paynowCC_LG.gif" Visible="False" />--%>
                </td>
            </tr>
        </table>
        </ContentTemplate>
    </asp:UpdatePanel>


</div>
    </asp:Content>
