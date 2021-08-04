<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/admin/adminMasterPage.master" CodeBehind="FixtureGrids.aspx.vb" Inherits="HBSA_Web_Application.FixtureGrids" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="AjaxToolkit" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .CellLeft {
           border-bottom: 2px solid black;
           border-top: 2px solid black;
           border-left: 2px solid black;
        }
        .CellRight {
           border-bottom: 2px solid black;
           border-top: 2px solid black;
           border-right: 2px solid black;
        }
        .CellMiddle {
            border-bottom: 2px solid black;
            border-top: 2px solid black;
        }
        .CellAll {
           border-bottom: 2px solid black;
           border-top: 2px solid black;
           border-right: 2px solid black; 
           border-left: 2px solid black;
        }

    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

<script type = "text/javascript">

    function updateButtonText() {
        var buttonText = document.getElementById("<%=Update_Button.ClientID%>").value;
        var week1 = document.getElementById("<%=Week1_TextBox.ClientID%>").value;
        var week2 = document.getElementById("<%=Week2_TextBox.ClientID%>").value;

        if (buttonText.indexOf("Swap") > -1)
            buttonText = 'Swap week ' + week1 + ' with week ' + week2
        else
            buttonText = 'Move week ' + week1 + ' after week ' + week2

        document.getElementById("<%=Update_Button.ClientID%>").value=buttonText;

    }

</script>

<h2 style="text-align:left;">Fixture Grid</h2>
            
            <asp:ScriptManager ID="ToolkitScriptManager1" runat="server" EnablePageMethods="true" ></asp:ScriptManager>

                    <asp:UpdateProgress runat="server" id="Update_Progress" DisplayAfter="10">
                        <ProgressTemplate>
                            <div id="Loading" style="position: fixed; left:200px;top:160px">
                                <asp:Image ID="loadingImage" runat="server" ImageUrl="~/images/AjaxLoading.gif" Width="100px" />
                            </div>
                        </ProgressTemplate>
                    </asp:UpdateProgress>

        <div style="text-align:left; width:100%">

        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <ContentTemplate>

<input type="hidden" name="_DropDownChanged" id="_DropDownChanged" value="" />

<div style="text-align:left;">

    <asp:Panel ID="Help_Panel" runat="server" Visible="true">
    <div style="padding: 4px; margin: 4px; border: 2px solid #0000FF; position: absolute; top: 200px; left: 100px; width:75%; background-color: #EEFFFF; z-index:90;">
        <asp:Button ID="CloseHelp_Button" Width="99% " runat="server" Text="Close this window / Start working" />
    <p>
        This routine allows the fixtures to be arranged for a specific section or league. Previous to using this page the teams will have been assigned to sections and given a number. This sets a section with a list of teams, each with an assigned number starting at 1, and stepping up by 1 to the number of teams in the section. A section will also have a list of fixture dates each with an assigned week number.   
    </p>
    <p>
        To start, choose a section or league to work with. This will show the fixtures grid with a row for each week. Each row will show the home and away team numbers for each fixture. The 2nd half of the season is shown but locked as each fixture is the same as the 1st half with the home and away teams reversed. The teams can be changed by selecting a different team number from the drop down list. When this is done, the same team in the 2nd half in the same week number plus half the number of weeks in the season, is also changed. This can be repeated as often as required until the fixtures are all changed. 
    </p>
    <p>
        If it is required that the 2nd half of the season is not the reverse of the 1st half, tick the box named Unlock 2nd half. Then when changes are made, they are not reflected in the 2nd half.  Changes must be made manually as required to the 2nd half.
    </p>
    <p>
        Changes made here are not put into the database until the Save button is clicked.  Therefore the grid can be manipulated until it is ready.  When it is 
        ready Click the Check Grid button.  This will check to see if each team has both an away and home fixture against each of the other teams.  
        Further changes can be made as necessary.  When the Save button is clicked, the grid will be checked, and if it is OK the grid will be stored in
        the database.  Navigate to the main web site >> Leagues >> Fixtures to see the actual fixtures.
    </p>
    <p>
        Whilst manipulating the grid there are three other buttons:
        <br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Refresh Grid - This will refresh the grid from the fixtures grid on the database
        <br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Reset Grid - This will make a new grid from the default matrix for this section's size
        <br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Swap the Grid - This will swap the 1st and 2nd halves of the grid (swap the homes and aways)

    </p>
    </div>
    </asp:Panel>
    Choose the section to work with. <br />
    <br />
    <asp:DropDownList ID="Section_DropDownList" runat="server" AutoPostBack="True" OnSelectedIndexChanged="Section_DropDownList_SelectedIndexChanged" BackColor="#FFFFCC"></asp:DropDownList>
      &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;For details and some help click the Question mark to the right...<asp:ImageButton ID="Help_Button" runat="server" ImageUrl="~/images/BlueQuestionMark18.bmp" />
                                <--- Click the question mark for help   
    <br />       
</div>
<asp:Panel ID="Grid_Panel" Visible="false" runat="server">
    <table>
        <tr style="vertical-align:top;">
            <td><asp:Literal ID="Check_Message" runat="server">&nbsp;</asp:Literal></td>
        </tr>
        <tr style="vertical-align:top;">
            <td><asp:Table ID="FixtureGrid_Table" runat="server" CellSpacing="0" CellPadding="2" EnableViewState="false"></asp:Table></td>
            <td>
                <asp:CheckBox ID="Unlock_CheckBox" runat="server" Text="Unlock 2nd half" AutoPostBack="true" />
                <br /><br />
                <asp:Button ID="CheckGrid_Button" runat="server" Text="Check Grid" Width="120px" ToolTip="This will check the grid to ensure each team has a home and away fixture with each of th eother teams." />
                <br /><br />
                <asp:Button ID="Refresh_Button" runat="server" Text="Refresh Grid" Width="120px" ToolTip="This will refresh the grid from the fixtures grid on the database" />
                <br /><br />
                <asp:Button ID="Restart_Button" runat="server" Text="Reset Grid" Width="120px" ToolTip="This will make a new grid from the default matrix for this section" />
                <br /><br />
                <asp:Button ID="Reverse_Button" runat="server" Text="Reverse the Grid" Width="120px" ToolTip="This will swap the 1st and 2nd halves of the grid (swap the homes and aways)" />
                <br /><br />
                <asp:Button ID="Save_Button" runat="server" Text="Save" width="120px"/>
                <br /><br />
                <asp:Button ID="Move_Button" runat="server" Text="Move Week" width="120px"/>
                <br /><br />
                <asp:Button ID="Swap_Button" runat="server" Text="Swap Weeks" width="120px"/>
                
            </td>
        </tr>
    </table>
    
</asp:Panel>

<asp:UpdatePanel ID="Weeks_Panel" runat="server" Visible="false">
    <ContentTemplate>
    <div style="padding: 5px; border: 2px solid #0000FF; position: absolute; top: 400px; left: 800px; background-color: #EEFFFF; text-align:center; font-size:10pt; z-index:99;">
        <asp:Literal ID="Weeks_Literal" runat="server" Text="<b>Move a week after another</b>"/>
        <table>
            <tr>
                <td style="text-align:right;"><asp:Literal ID="Week1_Literal1" runat="server" Text="Enter Week to Move:" /></td>
                <td><asp:TextBox ID="Week1_TextBox" runat="server" Width="16px" Height="16px" onkeyup="updateButtonText();"></asp:TextBox></td>
                <td style="text-align:right;"><asp:Literal ID="Week2_Literal2" runat="server" Text="Enter&nbsp;Week&nbsp;after&nbsp;which&nbsp;to&nbsp;move&nbsp;to:" /></td>
                <td><asp:TextBox ID="Week2_TextBox" runat="server" Width="16px" Height="16px" onkeyup="updateButtonText();"></asp:TextBox></td>
            </tr>
            <tr><td colspan="4"></td></tr>
            <tr>
                <td colspan="2" style="text-align:center;"><asp:Button ID="Update_Button" runat="server" Text="Move week 1 after week 2" Font-Size="12px" /></td>
                <td colspan="2" style="text-align:center;"><asp:Button ID="Cancel_Button" runat="server" Text="Cancel" Font-Size="12px" /></td>
            </tr>
        </table>
    </div>
</ContentTemplate>
</asp:UpdatePanel>


    </ContentTemplate>
            </asp:UpdatePanel>
            </div>


</asp:Content>
