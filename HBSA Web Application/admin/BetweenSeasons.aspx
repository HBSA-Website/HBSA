<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/admin/adminMasterPage.master" CodeBehind="BetweenSeasons.aspx.vb" Inherits="HBSA_Web_Application.BetweenSeasons" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        table {
            border-width: 1px;
            border-spacing: 2px;
            border-style: outset;
            border-color: gray;
            border-collapse: collapse;
            background-color: white;
        }

        td {
            border-width: 1px;
            padding: 1px;
            border-style: inset;
            border-color: gray;
            background-color: white;
            -moz-border-radius:;
        }

        .auto-style1 {
            font-family: Verdana;
            font-weight: bold;
            font-size: small;
            color: #FF0000;
        }

        .auto-style2 {
            color: #FF0000;
        }

        .auto-style3 {
            color: #FF0000;
            font-style: italic;
            font-weight: bold;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <h3>Between Seasons</h3>

    <asp:Panel ID="Introduction_Panel" runat="server" Visible="true">
  <div style="text-align:left;">

    These are several housekeeping functions to perform between seasons:<br /><span style="color:red"><asp:Literal ID="Err_Literal" runat="server"></asp:Literal></span>
                   <br />
    <table style="border: 1px solid #000000; vertical-align: top; text-align: left; width: 800px">
        <tr style="vertical-align:top;">
            <td style="width:20px;">1.</td><td style="width:200px;">Back up the season just finished.</td>
            <td>It is essential that a back up of the database be taken before this is started, and that it is preserved for
                                                                       the future. To do this contact the web master who will do it, and inform you when it is complete.  The web master will
                                                                       secure the backups and also send you a copy for safe keeping.
                                                                    </td>
        </tr>
        <tr  style="vertical-align:top;">
            <td>2.</td><td>Close off the season just finished.<br /><br />&nbsp;&nbsp;&nbsp;&nbsp;<asp:Button ID="CloseSeason_Button" runat="server" Text="Close the season" width="120px" /></td>
            <td>This will add the players records for the season just ended to the table which contains historic player records.<br /><br />
                It will do the same for players breaks.<br /><br />
                It will analyse the players' records from the season just finished and prepare the handicaps report.  This data will be 
                placed in a table to enable a revised handicaps report to be made available to the main web site during the next season, 
                and also to this facility.<br /><br />
                The "close season" flag will be set to enable routines for organising fixtures, sections, teams, players etc prior to the new season's start.<br /><br />
                This routine can be initiated as often as is required until the last step has been completed.  It must not be done after that until the next season has closed.
            </td>
        </tr>
        <tr style="vertical-align:top;">
            <td>3.</td><td>Prepare new handicaps.<br /><br />&nbsp;&nbsp;&nbsp;&nbsp;<asp:Button ID="Handicaps_Button" runat="server" Text="Handicaps" width="120px" /></td>
            <td>This will enable a panel to show handicaps reports (produced in step 2), and offer a facility to update the players records with the new handicaps.&nbsp; If it is required to change some or all of the handicaps other than by this automatic process, that canbe done in the normal manner by using the Players Maintenance page.                                                           
                                                      </td>
        </tr>
        <tr style="vertical-align:top;">
            <td>4.</td><td>Prepare Player Tags.<br /><br />&nbsp;&nbsp;&nbsp;&nbsp;<asp:Button ID="Player_Tags_Button" runat="server" Text="Apply new tags" width="120px" /></td>
            <td>This will examine all players and match them to their previous seasons' playing records.  It will then set each players' tag to the number of seasons required 
                to class the player as "seasoned". Within each of these seasons the player must play the minimum required matches (currently 6).

            </td>
        </tr>
        <tr style="vertical-align:top;">
            <td>5.</td><td>Setup Entry Forms.<br /><br />&nbsp;&nbsp;&nbsp;&nbsp;<asp:Button ID="SetupEntryForms_Button" runat="server" Text="Set up Entry Forms" width="120px" /></td>
            <td>When the player handicaps and tags have been processed, establish the on-line entry forms for the new season.</td>
        </tr>
        <tr style="vertical-align:top;">
            <td>6.</td><td>Entry Forms.<br /><br />&nbsp;&nbsp;&nbsp;&nbsp;<asp:Button ID="EntryForms_Button" runat="server" Text="Apply Entry Forms" width="120px" /></td>
            <td>When the player handicaps and tags have been processed <span class="auto-style2">and all the entry forms are in</span>, Apply the entry forms for the new season.<br />
                <br />
                <span class="auto-style3">If any adjustments (caused by new/lost clubs/teams etc) are needed for the league/section structures make these after applying the entry forms data.</span><br /><br /> To do this click the button to the left.<br /><br />
                When this is done use the maintenance procedures to mange any club, team and or player details. Then set up the Fixture dates for each league/section, then the Fixture Grids. Then use the Arrange Teams In Sections facility to move teams between sections and fixtures. Use the Look for too many home fixtures facility to ensure two teams are not set for the same table.            
            </td>
        </tr>
        <tr style="vertical-align:top;">
            <td>7.</td><td>Start a new season.<br /><br />&nbsp;&nbsp;&nbsp;&nbsp;<asp:Button ID="Start_Season_Button" runat="server" Text="Start new season" width="120px" /></td>
            <td>When step 6 is complete, and all fixtures teams and sections are as desired use this step.<br />
                <br />
                This will clear down ALL results, breaks, logs etc. and set the system ready to start a new season.<br /><br />
                It will clear the "close season" flag, thus enabling normal season functions and disabling close season functions<br /><br />
                <span class="auto-style1">DO NOT PERFORM STEP 2 after this until the new season has ended.</span>                                                           
            </td>
        </tr>
    </table>

  </div>
    </asp:Panel>

    <asp:Panel ID="Season_Panel" runat="server" Visible="false">

        <div style="border: thin solid #0000FF; background-color: #CCFFFF; width:400px; position:absolute; top:200px;left:200px">
            <br /><br />
            <asp:Literal ID="Season_Literal" runat="server"></asp:Literal>
            <br /><br />
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<asp:Button ID="Confirm_Button" runat="server" Text="Confirm" />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<asp:Button ID="Cancel_Button" runat="server" Text="Cancel" />
            <br /><br />
        </div>

    </asp:Panel>

    <asp:Panel ID="Handicaps_Panel" runat="server" Visible="false">

        <div style="border: thin solid #0000FF; background-color: #CCFFFF; position:absolute; top:200px;left:125px;">
            <br />
                <div style="text-align:left;">
                     <table style="text-align:left">
                            <tr>
                                <td style="vertical-align:top; text-align:right">Select a division/section or league:</td>
                                <td style="vertical-align:top;">
                                    <asp:DropDownList ID="Section_DropDownList" runat="server" BackColor="#FFFFCC" AutoPostBack="True" />
                                </td>
                                <td style="vertical-align:top;"><asp:Button ID="Close_Button" runat="server" Text="Close" /></td>
                                <td><asp:Button ID="Update_Button" runat="server" Text="Update players' handicaps" /><br />
                                    NOTE: This will update the handicaps for those players selected/shown here.
                                </td>
                            </tr>
                        </table>
                    <asp:GridView ID="Teams_GridView" runat="server"  
                        EnableModelValidation="True" Font-Size="9pt" BackColor="White" BorderColor="#E7E7FF" 
                        BorderStyle="None" BorderWidth="1px" CellPadding="3"
                        EmptyDataText="<span style='color:red'>No Handicaps to change (no match results).</span>" HeaderStyle-HorizontalAlign="Left">
                        <HeaderStyle BackColor="#4A3C8C" Font-Bold="True" ForeColor="#F7F7F7" HorizontalAlign="Left" />
                        <RowStyle Height="18px" BackColor="#E7E7FF" ForeColor="#000044" />
                        <AlternatingRowStyle Height="18px" BackColor="#F7F7F7" />
                        <SelectedRowStyle BackColor="#738A9C" Font-Bold="True" ForeColor="#F7F7F7" />
                    </asp:GridView>

                 </div>
            
            <br />
        </div>

    </asp:Panel>

   <asp:Panel ID="Confirm_Panel" runat="server" Visible="false">

        <div style="padding: 8px; border: thin solid #0000FF; background-color: #CCFFFF; width:400px; position:absolute; top:240px; left:300px">
            <br />
            <asp:Literal ID="Confirm_Literal" runat="server"></asp:Literal>
            <br /><br />
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<asp:Button ID="ConfirmApply_Button" runat="server" Text="Confirm" />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<asp:Button ID="ApplyTags_Cancel_Button" runat="server" Text="Cancel" />
            <br /><br />
        </div>

    </asp:Panel>

   <asp:Panel ID="ClubsWithoutPrivacyAccepted_Panel" runat="server" Visible="false">

        <div style="padding: 8px; border: thin solid #0000FF; background-color: #CCFFFF; position:absolute; top:340px; left:100px">
            <br />
            The following clubs have not accepted the Privacy Policy, therefore any <span style="color:red">teams and players registered with them have not been entered</span> into the leagues.<br /><br />
            Provided the season has not been started it is possible to go to the online entry form, accept the policy and submit the form again.<br />
            Then return here and Apply the entry forms again.<br /><br />
            Click 'Close this dialogue' at the bottom of the table.
            <br /><br />
                   <asp:GridView ID="ClubsWithoutPrivacyAccepted_GridView" runat="server"  
                        Font-Size="9pt" BackColor="White" BorderColor="#E7E7FF" 
                        BorderStyle="None" BorderWidth="1px" CellPadding="3"
                        EmptyDataText="None" HeaderStyle-HorizontalAlign="Left">
                        <HeaderStyle BackColor="#4A3C8C" Font-Bold="True" ForeColor="#F7F7F7" HorizontalAlign="Left" />
                        <RowStyle Height="18px" BackColor="#E7E7FF" ForeColor="#000044" />
                        <AlternatingRowStyle Height="18px" BackColor="#F7F7F7" />
                        <SelectedRowStyle BackColor="#738A9C" Font-Bold="True" ForeColor="#F7F7F7" />
                    </asp:GridView>
            <br />
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<asp:Button ID="ClubsWithoutPrivacyAccepted_Button" runat="server" Text="Close this dialogue" />
            <br /><br />
        </div>

    </asp:Panel>

</asp:Content>
