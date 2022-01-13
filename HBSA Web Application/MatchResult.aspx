<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/MasterPage.master" CodeBehind="MatchResult.aspx.vb" Inherits="HBSA_Web_Application.MatchResult" ClientIDMode="Static" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="AjaxToolkit" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

  <%--Set up references to JQuery libraries etc.--%>  
  <link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css" />
  <script src="https://code.jquery.com/jquery-3.2.1.js" type="text/javascript"></script> 
    <%--//1.12.4.js"></script>--%>
  <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"  type="text/javascript"></script>
    <script type="text/javascript">
        function MatchDateChanged()
        {
            var div = document.getElementById("MatchDateWarning_Div");
            div.innerHTML = "";
            div.style.display = "none";

            var teamSelector = document.getElementById("HomeTeam_DropDownList");
            var homeTeamID = teamSelector.options[teamSelector.selectedIndex].value;
            var matchDate = document.getElementById("matchDate_Textbox").value;
            var fixtureDateSelector = document.getElementById("FixtureDate_DropDownList");
            var fixtureDate = fixtureDateSelector.options[fixtureDateSelector.selectedIndex].text

            if (matchDate != fixtureDate)
                HBSA_Web_Application.CheckMatchDate.CheckMatchDate(homeTeamID, matchDate, OnComplete, OnError);
        }
        function OnComplete(message) {
            if (message != "") {
                var div = document.getElementById("MatchDateWarning_Div");
                div.innerHTML = message;
                div.style.display = "block";
                document.getElementById("matchDate_Textbox").value = "";
            }
        }
        function OnError(result) {
            alert("Error: " + result.get_message());
        }
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

      <asp:ScriptManager ID="ScriptManager1" runat="server">
        <Services>
            <asp:ServiceReference Path="CheckMatchDate.asmx" />
        </Services>
      </asp:ScriptManager> 

  <%--prevent enter key causing postback--%>
  <script type="text/javascript">
      $(document).keypress(function(e)
    {
        if(e.keyCode === 13)
        {
            e.preventDefault();
            return false;
        }
    });
  </script>

    <script type="text/javascript">
        function showHCapMsg(caller) {
            var rect = caller.getBoundingClientRect();
            var HCapMsg = document.getElementById("divHCapMsg");
            HCapMsg.style.position = "absolute";
            HCapMsg.style.top = rect.top + 'px';
            HCapMsg.style.left = (rect.left - 40) + 'px';
            HCapMsg.style.display="block"
        }
    </script>

    <style type="text/css">
        table {
            width:auto; margin-left:auto; margin-right:auto;
            border-collapse:collapse;
            border: 1px solid black;
            text-align:center;
            background-color: #eeFFee;
        }
        td th {
            border: 1px solid black;
            text-align:center;
            padding:4px;
        }
    </style>

  <%--include our own code--%>
  <script src="Scripts/ResultsCardJavaScript.js" type="text/javascript" ></script>

    <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
        <Triggers>
            <asp:AsyncPostBackTrigger ControlID="FixtureDate_DropDownList" EventName="SelectedIndexChanged" />
            <asp:AsyncPostBackTrigger ControlID="Section_DropDownList" EventName="SelectedIndexChanged" />
            <asp:AsyncPostBackTrigger ControlID="HomeTeam_DropDownList" EventName="SelectedIndexChanged" />
            <asp:AsyncPostBackTrigger ControlID="matchDate_Textbox" EventName="TextChanged" />
            <asp:AsyncPostBackTrigger ControlID="Send_Button" />
            <asp:AsyncPostBackTrigger ControlID="Retry_Button" />
            <asp:AsyncPostBackTrigger ControlID="Cancel_Button" />
        </Triggers>
        <ContentTemplate>

            <asp:UpdateProgress runat="server" ID="loadingDiv">
                <ProgressTemplate>
                    <div style="position: fixed; z-index: 1000; left: 46%; margin-top: 100px;">
                        <asp:Image ID="loadingImage" runat="server" ImageUrl="~/images/AjaxLoading.gif" Width="100px" />
                    </div>
                </ProgressTemplate>
            </asp:UpdateProgress>

            <%--preserve session variables as GoDaddy may kill the application after 5 minutes timeout--%>
    <input type="hidden" id="SessionUser" name = "SessionUser" runat="server" />
    <input type="hidden" id="SessionEmail" name = "SessionEmail" runat="server" />
    <input type="hidden" id="SessionPassword" name = "SessionPassword" runat="server" />
    <input type="hidden" id="SessionUserID" name = "SessionUserID" runat="server" />
    <input type="hidden" id="SessionUserName" name = "SessionUserName" runat="server" />
    <input type="hidden" id="SessionAdminEmail" name = "SessionadminDetails" runat="server" />
    <input type="hidden" id="SessionTeamID" name = "SessionTeamID" runat="server" />
    <input type="hidden" id="SessionAwayTeamID" name = "SessionAwayTeamID" runat="server" />
    <input type="hidden" id="SessionMatchResultID" name = "SessionMatchResultID" runat="server" />
    
    <input type="hidden" id="Home_Player_IDs" name = "HomePlayerIDs" runat="server" />
    <input type="hidden" id="Away_Player_IDs" name = "AwayPlayerIDs" runat="server" />

    <div style="font-family: Verdana; font-size: small; color:navy; width:100%; text-align:center; padding: 5px;" >
        <h3>Match Result</h3>
        <asp:Literal ID="status_Literal" runat="server" Mode="PassThrough"  
            Text="To submit or change your match results enter the details, then click 'Check your results card' " /> &nbsp;&nbsp;&nbsp;&nbsp;
            <img src="images/BlueQuestionMark18.bmp" onclick="loadDiv('divHelp');" height="16" onmouseover="this.style.cursor='pointer';" id="IMG1" alt="Help"/>
                <--- Click the question mark for help    
        <br /><br />
   </div>
<div id="CardDiv" runat="server">
  <table style="width:100%"><tr><td>
    <table>

        <tr>
            <td colspan="7" style="font-size: medium; font-weight: bold; color: #000000">Huddersfield Billiards and Snooker Association <asp:Literal ID="League_Literal" runat="server"></asp:Literal>&nbsp;League</td>
        </tr>

        <tr>
            <td class="style1" colspan="2"><strong>Match Fixture Date</strong></td>
            <td class="style17" colspan="3" style="text-align:center"><div style="width:100%;text-align:center;vertical-align:super;"><b>SECTION &gt;</b> 
                    <asp:DropDownList ID="Section_DropDownList" runat="server" BackColor="#FFFFCC" AutoPostBack="True" onchange="showLoading();" /> 
                <b>&lt; SECTION</b></div></td>
            <td class="style1"colspan="2"><strong>Actual Match Date</strong></td>
        </tr>
        
        <tr>
            <td class="style17" colspan="2" rowspan="2">
                <asp:DropDownList ID="FixtureDate_DropDownList" runat="server" Width="130px" BackColor="#FFFFCC" AutoPostBack="True" onchange="showLoading();"></asp:DropDownList>
            </td>
            <td class="style9">Home Team</td>
            <td class="style17" rowspan="9" style="width:20px;background:white;">&nbsp;</td>
            <td class="style9">Away Team</td>
            <td class="style17" colspan="2" rowspan="2">
                <asp:TextBox ID="matchDate_Textbox" runat="server" style="background:#FFFFCC; text-align:center" 
                    Width="84px" onchange="MatchDateChanged();" />
                <%--<asp:Image ID="MatchDate_Image" runat="server" ImageUrl="~/images/Icon-Calendar.png" />--%>
                <AjaxToolkit:CalendarExtender ID="matchDate_CalendarExtender" runat="server" 
                                      TargetControlID="matchDate_Textbox" PopupButtonID="matchDate_Textbox" 
                                      Format="dd MMM yyyy" TodaysDateFormat="d MMM yyyy">
                </AjaxToolkit:CalendarExtender>
                <div id="MatchDateWarning_Div" style="border: 1px solid #000000; display:none; position: fixed; text-align: left; padding: 4px;
                                                      top: 400px; left: 50%; background-color: #FFFFFF;"
                    onmouseover="this.style.cursor='pointer';" onclick="this.innerHTML = ''; this.style.display = 'none';"></div>
            </td>
        </tr>
        
        <tr>
            <td class="style9">
                <asp:DropDownList ID="HomeTeam_DropDownList" runat="server" BackColor="#FFFFCC" AutoPostBack="True" onchange="showLoading();" />
            </td>
            <td class="style9">
                <asp:Literal ID="AwayTeam_Literal" runat="server" text=""/>
            </td>
        </tr>
        <tr>
            <td>
                H&#39;Cap</td>
            <td>
                Score</td>
            <td>
                Home Players&#39; Names</td>
            <td>
                Away Players&#39; Names</td>
            <td>
                H&#39;Cap</td>
            <td>
                Score</td>
        </tr>
        
        <tr >
            <td class="style17">&nbsp;
                <asp:TextBox ID="HomeHcap1_TextBox" runat="server" style="text-align:center;" BackColor="#FFFFCC" Width="32px" ></asp:TextBox>
                <img id="HomeHCapImg1" runat="server" src="images/warning.png" onclick="showHCapMsg(HomeHcap1_TextBox);" height="16" onmouseover="this.style.cursor='pointer';" alt="Help" visible="false"/>
            </td>
            <td class="style17">
                <asp:TextBox ID="HomeScore1_TextBox" runat="server" style="text-align:center;" BackColor="#FFFFCC" Width="32px" ></asp:TextBox>
            </td>
            <td class="style17">
                <asp:DropDownList ID="HomePlayer1_DropDownList" runat="server" BackColor="#FFFFCC" Width="191px" 
                    onmouseover="this.style.cursor='pointer';storePlayerID(this);" onchange ="ddChanged(this);" ></asp:DropDownList>
            </td>
            <td class="style17">
                <asp:DropDownList ID="AwayPlayer1_DropDownList" runat="server" BackColor="#FFFFCC" Width="191px"
                    onmouseover="this.style.cursor='pointer';storePlayerID(this);" onchange ="ddChanged(this);"  ></asp:DropDownList>
            </td>
            <td class="style17">
                <asp:TextBox ID="AwayHcap1_TextBox" runat="server" style="text-align:center;" BackColor="#FFFFCC" Width="32px" ></asp:TextBox>
                <img id="AwayHCapImg1" runat="server" src="images/warning.png" onclick="showHCapMsg(AwayHcap1_TextBox);" height="16" onmouseover="this.style.cursor='pointer';" alt="Help" visible="false"/>
            </td>
            <td class="style17">
                <asp:TextBox ID="AwayScore1_TextBox" runat="server" style="text-align:center;" BackColor="#FFFFCC" Width="32px"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td class="style17" >&nbsp;
                <asp:TextBox ID="HomeHcap2_TextBox" runat="server" style="text-align:center;" BackColor="#FFFFCC" Width="32px"></asp:TextBox>
                <img id="HomeHCapImg2" runat="server" src="images/warning.png" onclick="showHCapMsg(HomeHcap2_TextBox);" height="16" onmouseover="this.style.cursor='pointer';" alt="Help" visible="false"/>
            </td>
            <td class="style17" >
                <asp:TextBox ID="HomeScore2_TextBox" runat="server" style="text-align:center;" BackColor="#FFFFCC" Width="32px"></asp:TextBox>
            </td>
            <td class="style17">
                <asp:DropDownList ID="HomePlayer2_DropDownList" runat="server" BackColor="#FFFFCC" Width="191px"
                    onmouseover="this.style.cursor='pointer';storePlayerID(this);" onchange ="ddChanged(this);" ></asp:DropDownList>
            </td>
            <td class="style17">
                <asp:DropDownList ID="AwayPlayer2_DropDownList" runat="server" BackColor="#FFFFCC" Width="191px"
                    onmouseover="this.style.cursor='pointer';storePlayerID(this);" onchange ="ddChanged(this);" ></asp:DropDownList>
            </td>
            <td class="style17">
                <asp:TextBox ID="AwayHcap2_TextBox" runat="server" style="text-align:center;" BackColor="#FFFFCC" Width="32px"></asp:TextBox>
                <img id="AwayHCapImg2" runat="server" src="images/warning.png" onclick="showHCapMsg(AwayHcap2_TextBox);" height="16" onmouseover="this.style.cursor='pointer';" alt="Help" visible="false"/>
            </td>
            <td class="style17">
                <asp:TextBox ID="AwayScore2_TextBox" runat="server" style="text-align:center;" BackColor="#FFFFCC" Width="32px"></asp:TextBox>
            </td>
        </tr>
        <tr >
            <td class="style17">&nbsp;
                <asp:TextBox ID="HomeHcap3_TextBox" runat="server" style="text-align:center;" BackColor="#FFFFCC" Width="32px"></asp:TextBox>
                <img id="HomeHCapImg3" runat="server" src="images/warning.png" onclick="showHCapMsg(HomeHcap3_TextBox);" height="16" onmouseover="this.style.cursor='pointer';" alt="Help" visible="false"/>
            </td>
            <td class="style17">
                <asp:TextBox ID="HomeScore3_TextBox" runat="server" style="text-align:center;" BackColor="#FFFFCC" Width="32px"></asp:TextBox>
            </td>
            <td class="style17">
                <asp:DropDownList ID="HomePlayer3_DropDownList" runat="server" BackColor="#FFFFCC" Width="191px"
                    onmouseover="this.style.cursor='pointer';storePlayerID(this);" onchange ="ddChanged(this);" ></asp:DropDownList>
            </td>
            <td class="style17">
                <asp:DropDownList ID="AwayPlayer3_DropDownList" runat="server" BackColor="#FFFFCC" Width="191px"
                    onmouseover="this.style.cursor='pointer';storePlayerID(this);" onchange ="ddChanged(this);" ></asp:DropDownList>
            </td>
            <td class="style17">
                <asp:TextBox ID="AwayHcap3_TextBox" runat="server" style="text-align:center;" BackColor="#FFFFCC" Width="32px"></asp:TextBox>
                <img id="AwayHCapImg3" runat="server" src="images/warning.png" onclick="showHCapMsg(AwayHcap3_TextBox);" height="16" onmouseover="this.style.cursor='pointer';" alt="Help" visible="false"/>
            </td>
            <td class="style17">
                <asp:TextBox ID="AwayScore3_TextBox" runat="server" style="text-align:center;" BackColor="#FFFFCC" Width="32px"></asp:TextBox>
            </td>
        </tr>
        <tr >
            <td class="style17">&nbsp;
                <asp:TextBox ID="HomeHcap4_TextBox" runat="server" style="text-align:center;" BackColor="#FFFFCC" Width="32px"></asp:TextBox>
                <img id="HomeHCapImg4" runat="server" src="images/warning.png" onclick="showHCapMsg(HomeHcap4_TextBox);" height="16" onmouseover="this.style.cursor='pointer';" alt="Help" visible="false"/>
            </td>
            <td class="style17">
                <asp:TextBox ID="HomeScore4_TextBox" runat="server" style="text-align:center;" BackColor="#FFFFCC" Width="32px"></asp:TextBox>
            </td>
            <td class="style17">
                <asp:DropDownList ID="HomePlayer4_DropDownList" runat="server" BackColor="#FFFFCC" Width="191px"
                    onmouseover="this.style.cursor='pointer';storePlayerID(this);" onchange ="ddChanged(this);" ></asp:DropDownList>
            </td>
            <td class="style17">
                <asp:DropDownList ID="AwayPlayer4_DropDownList" runat="server" BackColor="#FFFFCC" Width="191px"
                    onmouseover="this.style.cursor='pointer';storePlayerID(this);" onchange ="ddChanged(this);" ></asp:DropDownList>
            </td>
            <td class="style17">
                <asp:TextBox ID="AwayHcap4_TextBox" runat="server" style="text-align:center;" BackColor="#FFFFCC" Width="32px"></asp:TextBox>
                <img id="AwayHCapImg4" runat="server" src="images/warning.png" onclick="showHCapMsg(AwayHcap4_TextBox);" height="16" onmouseover="this.style.cursor='pointer';" alt="Help" visible="false"/>
            </td>
            <td class="style17">
                <asp:TextBox ID="AwayScore4_TextBox" runat="server" style="text-align:center;" BackColor="#FFFFCC" Width="32px"></asp:TextBox>
            </td>
        </tr>
        
        <tr>
            <td class="style17" colspan="3">
                
                <table>
                    
                    <tr >
                        <td colspan="3" style="text-align:left">
                            <span style="color: #006600"><strong>Breaks</strong></span>
                        </td>
                    </tr>

                    <tr>
                        <td colspan="4">
                            <asp:Table ID="webPage_HomeBreaks_Table" runat="server" EnableViewState="true"></asp:Table>
                        </td>
                    </tr>    

                    <tr >
                        <td  colspan="4" style="text-align:left">
                            <span style="font-size: larger; font-style: italic; color: #FF0000">To add a break, select a player, enter the break and click add.</span>
                        </td>
                    </tr>

                    <tr >
                        <td><asp:DropDownList ID="HomeBreakPlayers_DropDownList" runat="server" BackColor="#FFFFCC" Width="191px" ></asp:DropDownList></td>
                        <td><asp:TextBox ID="HomeBreak_TextBox" runat="server" style="text-align:center;" BackColor="#FFFFCC" Width="32px" ></asp:TextBox></td>
                        <td><input class="smallItalic" id="HomeBreakAdd_Button" type="button" value="Add this break" onmouseover="this.style.cursor='pointer'" onclick ="breakAdded(this);"/></td>
                        <td></td>
                    </tr>
            
                </table> 
           
             </td>

            <td style="vertical-align: top; text-align: left" colspan="3">

                <table >
            
                      <tr >
                        <td  colspan="4">
                            <span style="color: #006600"><strong>Breaks</strong></span>
                        </td>
                    </tr>

                    <tr>
                       <td style="text-align:left" colspan="4">
                            <asp:Table ID="webPage_AwayBreaks_Table" runat="server" EnableViewState="true"></asp:Table>
                        </td>
                    </tr>    

                      <tr>
                        <td  colspan="4" style="text-align:left">
                            <span style="font-size: larger; font-style: italic; color: #FF0000">To add a break, select a player, enter the break and click add.</span>
                        </td>
                    </tr>
                    <tr >
                        <td><asp:DropDownList ID="AwayBreakPlayers_DropDownList" runat="server" BackColor="#FFFFCC" Width="191px" ></asp:DropDownList></td>
                        <td><asp:TextBox ID="AwayBreak_TextBox" runat="server" style="text-align:center;" BackColor="#FFFFCC" Width="32px" ></asp:TextBox></td>
                        <td><input class="smallItalic" id="AwayBreakAdd_Button" type="button" value="Add this break" onmouseover="this.style.cursor='pointer'" onclick ="breakAdded(this);"/></td>
                        <td></td>
                    </tr>

                </table> 

            </td>


         </tr>
  
         <tr style="font-weight:bold;">
            <td class="style17" colspan="3" style="font-size:12pt;font-weight:bold">Frames&nbsp;&nbsp;&nbsp; 
                <asp:Literal ID="HomeFrames_Literal" runat="server" Text="0"></asp:Literal>
            </td>
            
            <td class="style17" colspan="3" style="font-size:12pt;font-weight:bold">
                <asp:Literal ID="AwayFrames_Literal" runat="server" Text="0"></asp:Literal>&nbsp;&nbsp; Frames 
            </td>
        </tr>
    </table>
  </td></tr></table>  
    <br />
    <div style="font-family: Verdana; width:100%; text-align:center" >
        <asp:Button ID="Send_Button" runat="server" ForeColor="#004000" 
    Text="Check your results card" Width="231px" style="margin-top: 0px" PostBackUrl="~/MatchResult.aspx" />
    &nbsp;&nbsp;&nbsp;&nbsp;
         <asp:Button ID="Retry_Button" runat="server" Visible="false" ForeColor="#004000" Text="Resend the emails" Width="231px" style="margin-top: 0px" />
    &nbsp;&nbsp;&nbsp;&nbsp;
         <asp:Button ID="Cancel_Button" runat="server" ForeColor="#004000" Text="Cancel" Width="231px" style="margin-top: 0px" />
    <br />
        <asp:Button ID="Recover_Button" runat="server" Text="Recover result for the requested match." visible="false"/>
        <div id="Delete_Result_Div" style="" runat="server" visible="false">
            <input id="Delete_Result_Button" type="button" value="Delete this result" style="width:231px"
                   onclick="loadDiv('divDeleteResult');" onmouseover="this.style.cursor='pointer';" />
        </div>
    </div>


 	<div id="divDeleteResult" style="border: 1px solid #000080; font-family: Arial, Helvetica, sans-serif; font-size: 9Pt; display:none; vertical-align: top; 
                                   text-align: left; position: fixed; background-color: #B5C7DE;
                                   width: 500px; left: 354px; top: 274px;">
                <table style="width: 100%; height: 100%">
                    <tr>
                        <td onmousedown="dragStart(event, 'divDeleteResult')"
                            onmouseover="this.style.cursor='pointer';" 
                            style="height: 8px; border-right: #000080 1px solid; border-top: #000080 1px solid; border-left: #000080 1px solid; border-bottom: #000080 1px solid; 
                            background-image: url(Images/menuBarBG.gif);">
                            <strong>Deleting&nbsp;Match&nbsp;Results</strong></td>
                        <td style="height: 8px; width: 8px; border-right: #000080 1px solid; 
                                        border-top: #000080 1px solid; border-left: #000080 1px solid; 
                                        border-bottom: #000080 1px solid;">
                            <img src="Images/Exit.bmp" onclick="hideDiv('divDeleteResult');" 
                                            onmouseover="this.style.cursor='pointer';" alt="Click to close"/>
                        </td>
                    </tr>
                </table>
                
                <table style="font-size:10pt; width:100%; vertical-align: top;">
                    <tr>
                        <td style=" font-family:Arial; font-size: 10pt; text-align: center;" colspan="2">
                            You are about to remove this match result completely, including any breaks.<br /><br />
                            Click Remove to confirm this deletion, otherwise click Cancel.
                            <span style="color: #FF0000"><asp:Literal ID="DeleteResult_Literal" runat="server"/></span>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:Button ID="Remove_Button" runat="server" Text="Remove this result completely" />
                        </td>
                        <td>    
                            <input id="Cancel_Delete_Result_Button" type="button" value="Cancel" runat="server"
                                   onclick="hideDiv('divDeleteResult');" onmouseover="this.style.cursor='pointer';" />
                        </td>
                    </tr>
                </table>
 	</div>
 </div>
    </ContentTemplate>
        </asp:UpdatePanel>


<div id="divHCapMsg" style="border: 1px solid #000080; font-family: Arial, Helvetica, sans-serif; font-size: 8Pt;  display:none; vertical-align: top; 
                                   top:400px;left:400px;
                                   text-align: left; position: fixed; background-color: #ccffcc;" onclick="hideDiv('divHCapMsg');">
                <table style="width: 100%; height: 100%">
                    <tr>
                        <td onmousedown="dragStart(event, 'divHCapMsg')"
                            onmouseover="this.style.cursor='pointer';" 
                            style="height: 8px; border-right: #000080 1px solid; border-top: #000080 1px solid; border-left: #000080 1px solid; border-bottom: #000080 1px solid; background-image: url(Images/menuBarBG.gif);">
                            <strong>Warning:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</strong></td>
                        <td style="height: 8px; width: 8px; border-right: #000080 1px solid; 
                                        border-top: #000080 1px solid; border-left: #000080 1px solid; 
                                        border-bottom: #000080 1px solid;">
                            <img src="Images/Exit.bmp" onclick="hideDiv('divHCapMsg');" 
                                            onmouseover="this.style.cursor='pointer';" alt="Click to close"/>
                        </td>
                    </tr>
                    <tr>
                        <td>Handicaps cannot be changed.</td>
                    </tr>
                    <tr>
                        <td colspan="2">If the handicap is incorrect <a href="Contact.aspx"> contact the league secretary.</a></td>
                    </tr>
                </table>

 
</div>
 <div id="divHelp" style="border: 1px solid #000080; font-family: Arial, Helvetica, sans-serif; font-size: 8Pt;  display:none; vertical-align: top; 
                                   text-align: left; position: fixed; background-color: #ccffcc;
                                   width:50%; left: 354px; top: 274px; 
                                   ">
                <table style="width: 100%; height: 100%">
                    <tr>
                        <td onmousedown="dragStart(event, 'divHelp')"
                            onmouseover="this.style.cursor='pointer';" 
                            style="height: 8px; border-right: #000080 1px solid; border-top: #000080 1px solid; border-left: #000080 1px solid; border-bottom: #000080 1px solid; background-image: url(Images/menuBarBG.gif);">
                            <strong>Entering&nbsp;Match&nbsp;Results</strong></td>
                        <td style="height: 8px; width: 8px; border-right: #000080 1px solid; 
                                        border-top: #000080 1px solid; border-left: #000080 1px solid; 
                                        border-bottom: #000080 1px solid;">
                            <img src="Images/Exit.bmp" onclick="hideDiv('divHelp');" 
                                            onmouseover="this.style.cursor='pointer';" alt="Click to close"/>
                        </td>
                    </tr>
                </table>
                
                <table style="font-size:9pt; width:100%; vertical-align: top;">
                    <tr>
                        <td style=" font-family:Arial; font-size: 10pt; text-align: left;">
                            <strong>Score card.</strong>
                            <img id = "imageScoreCard" src="Images/PointDownSmall.bmp" 
                                                onclick="swapDiv('helpScoreCard','imageScoreCard');" 
                                                onmouseover="this.style.cursor='pointer';" alt="Expand"/>
                            <br />
                            <div id="helpScoreCard" style="display:block; text-align: left;">
                                <br />
                                    Matches are based on the fixture list, select the fixture date and it will automatically
                                    choose your opponents.  Only those dates when you were/are due to play at home will be offered for selection.<br /><br />
                                    If you actually played the match on a different date you can, if you wish, enter this date in the box provided.<br /><br />
                                    If the match you select has been entered before, you will see the details.  These can be amended if required.<br /><br />
                                    Then enter the individual frame details: This is achieved by selecting a registered player from the drop down list.  When a player is selected
                                    the handicap is inserted for you.  NOTE that handicaps cannot be changed. If you think a handicap is incorrect<a href="Contact.aspx">
                                     contact the league secretary.</a><br /><br />
                                    Note that the players registered for the team are shown.  During the 1st half of the season
                                    players from other teams in the same league in the same club will also be shown if they have not yet played in a match.  One of these
                                    can be selected, and will automatically be transferred to this team. Once a player has played in a match he/she cannot transfer.<br /><br />
                                    If a player was not available to play, then select **no show** and **no opponent** as appropriate.<br /><br />
                                    To record breaks over 25 select the player from that team's selection list, enter the value of the break then click Add.  This can be done as
                                    many times as required, and a player can have several breaks recorded if needed.

                            </div>
                        </td>
                    </tr>
                </table>
  
            </div>


        

</asp:Content>
