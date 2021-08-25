<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Menu.aspx.vb" Inherits="HBSA_Web_Application.Menu" ClientIDMode="Static" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <style type="text/css">
        .MenuDiv {
            max-height: 99999px; 
            width: auto; 
            margin: 0px; 
            padding: 2px; 
            font-family: Verdana; 
            font-size: 11pt;
        }
        .InLineMenuDiv{
            display: none; 
            margin-left: 30px;
        }
        .SubMenuDiv{
            position: fixed; 
            display: none; 
            margin-left: 10px;
        }

        .MenuTable {
            padding: 15px;
            border: thin solid #000000;
            border-collapse: collapse;
            background-color: #B5C7DE;
            color: #284E98;
        }
        .MenuTd{
            padding: 5px;
        }
        a {
            background-color: #B5C7DE;
            color: #284E98;
            text-decoration: none;
        }

            a:hover {
                text-decoration: underline;
                background-color: #284E98;
                color: white;
            }
    </style>
    <script type="text/javascript">
        function loadMenuDiv(divID, ContainerDivID) {
            hideMenuDiv();
            if (divID != "") {
                document.getElementById(divID).style.display = "block";
                document.getElementById(ContainerDivID).style.display = "block";
            }
        }

        function loadMenu_InLineDiv(divID, ContainerDivID) {
            hideMenu_InLineDiv();
            if (divID != "") {
                if (document.getElementById(divID).style.display == "block")
                    document.getElementById(divID).style.display = "none";
                else
                    document.getElementById(divID).style.display = "block";
                document.getElementById(ContainerDivID).style.display = "block";
            }
        }

        function hideMenuDiv() {
            hideMenu_InLineDiv();
            var divs = document.getElementsByTagName("div");
            for (var i = 0; i < divs.length; i++) {
                if (divs[i].id.length > 8)
                    if (divs[i].id.substr(0, 8) == "SubMenu_")
                        divs[i].style.display = "none";
            } 
        }

        function hideMenu_InLineDiv() {
            var divs = document.getElementsByTagName("div");
            for (var i = 0; i < divs.length; i++) {
                if (divs[i].id.length > 8)
                    if (divs[i].id.substr(0, 15) == "SubMenu_InLine_")
                        divs[i].style.display = "none";
            }
        }
    </script>

    <form id="form1" runat="server">
        <div class="MenuDiv">
            <table id="Menu_Div" class="MenuTable" >
                <tr>
                    <td>
                        <div id="Menu_Home"
                            onclick="loadMenuDiv('SubMenu_Home_Div','Menu_Home');" onmouseover="this.style.cursor='pointer';loadMenuDiv('SubMenu_Home_Div','Menu_Home');">
                            &nbsp;Home,&nbsp;Pages >> &nbsp;|
                        </div>
                        <div id="SubMenu_Home_Div" class="SubMenuDiv">
                            <table class="MenuTable">
                                <tr>
                                    <td class="MenuTd"><a href="~/Home.aspx" runat="server">Main site</a></td>
                                </tr>
                                <tr>
                                    <td class="MenuTd"><a href="adminHome.aspx" runat="server">Admin Home</a></td>
                                </tr>
                            </table>
                        </div>
                    </td>
                    <td>
                        <div id="Menu_Content"
                            onclick="loadMenuDiv('SubMenu_Content_Div','Menu_Content');" onmouseover="this.style.cursor='pointer';loadMenuDiv('SubMenu_Content_Div','Menu_Content');">
                            &nbsp;Web&nbsp;Content >> &nbsp;|
                        </div>
                        <div id="SubMenu_Content_Div" class="SubMenuDiv">
                            <table class="MenuTable">
                                <tr>
                                    <td class="MenuTd"><a href="EditHomePage.aspx" runat="server">Manage Home Page</a></td>
                                </tr>
                                <tr>
                                    <td class="MenuTd"><a href="ContentManager.aspx" runat="server">Manage Content</a></td>
                                </tr>
                                <tr>
                                    <td class="MenuTd"><a href="PictureGalleryManager.aspx" runat="server">Picture Gallery Manager</a></td>
                                </tr>
                                <tr>
                                    <td class="MenuTd"><a href="DocumentManager.aspx" runat="server">Documents Manager</a></td>
                                </tr>
                                <tr>
                                    <td class="MenuTd"><a href="Adverts.aspx" runat="server">Advertisements</a></td>
                                </tr>
                            </table>
                        </div>
                    </td>
                    <td>
                        <div id="Menu_Reports"
                            onclick="loadMenuDiv('SubMenu_Reports_Div','Menu_Reports');" onmouseover="this.style.cursor='pointer';loadMenuDiv('SubMenu_Reports_Div','Menu_Reports');">
                            &nbsp;Reports >> &nbsp;|
                        </div>
                        <div id="SubMenu_Reports_Div" class="SubMenuDiv">
                            <table class="MenuTable">
                                <tr>
                                    <td class="MenuTd"><a href="TaggedPlayers.aspx">Tagged Players</a></td>
                                </tr>
                                <tr>
                                    <td class="MenuTd"><a href="EmailMonitor.aspx">Email Monitor</a></td>
                                </tr>
                                <tr>
                                    <td class="MenuTd"><a href="LastSixMatches.aspx">Last Six Matches</a></td>
                                </tr>
                                <tr>
                                    <td class="MenuTd"><a href="../TrophiesAndPrizes.aspx">Trophies and Prizes</a></td>
                                </tr>
                                <tr>
                                    <td class="MenuTd"><a href="ActivityLog.aspx">Activity Log</a></td>
                                </tr>
                                <tr>
                                    <td class="MenuTd"><a href="PrivacyReports.aspx">Privacy acceptance reports</a></td>
                                </tr>
                                <tr>
                                    <td class="MenuTd"><a href="ClubsWithoutClubLogin.aspx">Clubs Without Club Login report</a></td>
                                </tr>
                                <tr>
                                    <td class="MenuTd"><a href="EntryFormsNewPlayers.aspx">Entry Forms New Players report</a></td>
                                </tr>
                                <tr>
                                    <td class="MenuTd"><a href="AGMVotesReports.aspx">AGM Votes</a></td>
                                </tr>
                                <tr>
                                    <td class="MenuTd"><a href="C19Compliance.aspx">Covid 19 Compliance report</a></td>
                                </tr>
                                <tr>
                                    <td class="MenuTd"><a href="ContactsReport.aspx">Contacts Report (Download)</a></td>
                                </tr>
                            </table>
                        </div>
                    </td>


                    <td>
                        <div id="Menu_Maintenance"
                            onclick="loadMenuDiv('SubMenu_Maintenance_Div','Menu_Maintenance');" onmouseover="this.style.cursor='pointer';loadMenuDiv('SubMenu_Maintenance_Div','Menu_Maintenance');">
                            &nbsp;Maintenance >> &nbsp;|
                        </div>
                        <div id="SubMenu_Maintenance_Div" class="SubMenuDiv">
                            <table class="MenuTable">
                                <tr>
                                    <td class="MenuTd"><a href="Clubs.aspx">Clubs</a></td>
                                </tr>
                                <tr>
                                    <td class="MenuTd"><a href="Players.aspx">Players</a></td>
                                </tr>
                                <tr>
                                    <td class="MenuTd"><a href="Leagues.aspx">Leagues / Handicap limits</a></td>
                                </tr>
                                <tr>
                                    <td class="MenuTd"><a href="Sections.aspx">Divisions/Sections</a></td>
                                </tr>
                                <tr>
                                    <td class="MenuTd"><a href="Teams.aspx">Teams</a></td>
                                </tr>
                                <tr>
                                    <td class="MenuTd"><a href="EmailAddresses.aspx">Email addresses and Telephone Nos</a></td>
                                </tr>
                                <tr>
                                    <td class="MenuTd">
                                        <div id="Menu_InLine_Awards_Div"
                                            onclick="loadMenu_InLineDiv('SubMenu_InLine_Awards_Div','Menu_Maintenance');"
                                            onmouseover="this.style.cursor='pointer'; loadMenu_InLineDiv('SubMenu_InLine_Awards_Div','Menu_Maintenance');">
                                            <a>Awards (Trophies, Prizes etc.) >> &nbsp;</a>
                                        </div>
                                        <div id="SubMenu_InLine_Awards_Div" class="InLineMenuDiv">
                                            <table class="MenuTable">
                                                <tr>
                                                    <td class="MenuTd"><a href="Awards.aspx">Awards Recipients</a></td>
                                                </tr>
                                                <tr>
                                                    <td class="MenuTd"><a href="AwardsTypes.aspx">Awards types and their names etc.</a></td>
                                                </tr>
                                                <tr>
                                                    <td class="MenuTd"><a href="AwardsTemplate.aspx">Awards templates - Competitions, Trophies & Prizes</a></td>
                                                </tr>
                                                <tr>
                                                    <td class="MenuTd"><a href="BreaksCategories.aspx">Maintain Breaks Categories for High Break awards</a></td>
                                                </tr>
                                                <tr>
                                                    <td class="MenuTd"><a href="Leagues.aspx">Handicap limits (Leagues)</a></td>
                                                </tr>
                                            </table>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="MenuTd">
                                        <div id="Menu_InLine_CloseSeason_Div"
                                            onclick =                               "loadMenu_InLineDiv('SubMenu_InLine_CloseSeason_Div','Menu_InLine_CloseSeason_Div');" 
                                            onmouseover="this.style.cursor='pointer';loadMenu_InLineDiv('SubMenu_InLine_CloseSeason_Div','Menu_InLine_CloseSeason_Div');">
                                            <a>Between Seasons >> &nbsp;</a>
                                        </div>
                                        <div id="SubMenu_InLine_CloseSeason_Div" class="InLineMenuDiv">
                                            <table class="MenuTable">
                                                <tr>
                                                    <td class="MenuTd"><a href="CloseSeason.aspx">CloseSeason Recipients</a></td>
                                                </tr>
                                                <tr>
                                                    <td class="MenuTd"><a href="BetweenSeasons.aspx">Between Seasons</a></td>
                                                </tr>
                                                <tr>
                                                    <td class="MenuTd"><a href="FixtureDates.aspx">Fixture Dates </a></td>
                                                </tr>
                                                <tr>
                                                    <td class="MenuTd"><a href="FixtureGrids.aspx">Fixture Grids </a></td>
                                                </tr>
                                                <tr>
                                                    <td class="MenuTd"><a href="ArrangeTeamsInSections.aspx">Arrange Teams In Sections </a></td>
                                                </tr>
                                                <tr>
                                                    <td class="MenuTd"><a href="LookForTooManyHomeFixtures.aspx">Look for too many home fixtures </a></td>
                                                </tr>
                                            </table>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="MenuTd"><a href="Money.aspx">Debts and Payments</a></td>
                                </tr>
                            </table>
                        </div>
                    </td>






                </tr>


            </table>
        </div>
        <div onmouseover="hideMenuDiv();">
            <br />
            <br />
            <br />
            <br />
            Content data
        </div>
    </form>
</body>
</html>
