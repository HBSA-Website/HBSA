<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/mobile/mobileMaster.Master" ClientIDMode="Static" CodeBehind="MatchResult.aspx.vb" Inherits="HBSA_Web_Application.MatchResult1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

  <%--Set up references to JQuery libraries etc.--%>  
  <link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css" />
  <script src="https://code.jquery.com/jquery-3.2.1.js" type="text/javascript"></script> 
    <%--//1.12.4.js"></script>--%>
  <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"  type="text/javascript"></script>
    <%--HTML5 datepicker with textbox code--%>
    <script type="text/javascript">
        var months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
        function DateBoxClicked(datePicker, dateBox) {
            datePicker.hidden = false;
            dateBox.hidden = true;
            datePicker.value = ConvertDateString(dateBox.value);
            datePicker.click();
        }
        function DatePickerChanged(dateBox, datePicker) {
            d = new Date(datePicker.value);
            dy = d.getDate();
            mn = d.getMonth();
            yy = d.getFullYear();
            dateBox.value = dy + " " + months[mn] + " " + yy;
            dateBox.hidden = false;
            datePicker.hidden = true;
        }
        function ConvertDateString(str) {
            var ix = str.indexOf(" ");
            var dd = str.substring(0, ix);
            var iy = str.indexOf(" ", ix + 1);
            var MMM = str.substring(ix + 1, iy);
            var MM = months.indexOf(MMM) + 1;
            var yyyy = str.substring(iy + 1);
            var mm = MM.toString();
            if (MM < 10) {
                mm = "0" + mm;
            }
            return yyyy + '-' + mm + '-' + dd;
        }
    </script>
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
    <%--include our own code--%>
     <script type="text/javascript"> 
        <!--#include file="~/Scripts/ResultsCardJavaScript.js"-->
         //function storePlayerID(ddList) {
         //    //store selected index before in a hidden input
         //    document.getElementById("previousDropDownIndex").value = ddList.selectedIndex;
         //}
         /* This routine will populate the correct handicap
                              populate the drop down of team players
                              populate the list of break makers.
         */
         //establish some useful variables
         var HomeAway = ddList.id.substr(0, 4);
         var ddRow = ddList.id.substr(10, 1);
         var currIx = ddList.selectedIndex;
         var ddValues = ddList.options[currIx].value.split("|");
         var hcapBoxname = HomeAway + "Hcap" + ddRow + "_TextBox";
         var ScoreBoxname = HomeAway + "Score" + ddRow + "_TextBox";

         // look for no show/no opponent
         if (ddValues[0].substr(0, 1) == "-") {
             //set handicap to zero
             document.getElementById(hcapBoxname).value = "0";
             if (ddValues[0].substr(1, 1) == "2") {
                 //set no opponent's score to 2
                 document.getElementById(ScoreBoxname).value = "2";
             } else {
                 //set no show or Frame Not Played score to 0
                 document.getElementById(ScoreBoxname).value = "1";
             }
             document.getElementById(ScoreBoxname).disabled = true;

             //swap selected index of other no opponent/no show to the other "player"
             if (HomeAway == "Home") {
                 HomeAway = "Away";
                 var otherDDlist = document.getElementById(ddList.id.replace("Home", "Away"));
                 if (currIx == 1) {
                     otherDDlist.selectedIndex = 2;
                 } else {
                     otherDDlist.selectedIndex = 1;
                 }
             } else {
                 HomeAway = "Home";
                 var otherDDlist = document.getElementById(ddList.id.replace("Away", "Home"));
                 if (currIx == 1) {
                     otherDDlist.selectedIndex = 2;
                 } else {
                     otherDDlist.selectedIndex = 1;
                 }
             }

             //set handicap & score for the other one
             hcapBoxname = HomeAway + "Hcap" + ddRow + "_TextBox";
             ScoreBoxname = HomeAway + "Score" + ddRow + "_TextBox";
             document.getElementById(hcapBoxname).value = "0";
             if (ddValues[0].substr(1, 1) == "2") {
                 document.getElementById(ScoreBoxname).value = "2";
             } else {
                 //set no show or Frame Not Played score to 0
                 document.getElementById(ScoreBoxname).value = "1";
             }
             document.getElementById(ScoreBoxname).disabled = true;

         } else {

             // populate handicap & score boxes
             document.getElementById(hcapBoxname).value = ddValues[1];
             document.getElementById(ScoreBoxname).disabled = false;
         }

     </script>
    <%--Show handicap message--%>
    <script type="text/javascript">
       function showHCapMsg(caller) {
           var rect = caller.getBoundingClientRect();
           var HCapMsg = document.getElementById("divHCapMsg");
           HCapMsg.style.position = "absolute";
           HCapMsg.style.top = rect.top + 'px';
           HCapMsg.style.left = (rect.left - 40) + 'px';
           HCapMsg.style.display = "block"
       }
    </script>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="SmallHeader">
        <asp:Literal ID="MatchDetails_Literal" runat="server" />
        <asp:Literal ID="Frame_Literal1" runat="server" />
        <asp:Literal ID="Frame_Literal2" runat="server" />
        <asp:Literal ID="Frame_Literal3" runat="server" />
        <asp:Literal ID="Frame_Literal4" runat="server" />
        <asp:Literal ID="MatchBreaks_Literal" runat="server" />
        <asp:Literal ID="Result_Literal" runat="server" />
    </div>

    <div id="MessageDiv" runat="server" visible="false">

    </div>

  <div id="PanelsDiv" runat="server">

    <asp:Panel ID="Match_Panel" runat="server" Visible="true">
        <table>
            <tr>
                <td>Section:</td>
                <td><asp:DropDownList ID="Section_DropDownList" runat="server" AutoPostBack="true"/></td>
            </tr>
            <tr>
                <td>Home Team:</td>
                <td><asp:DropDownList ID="HomeTeam_DropDownList" runat="server" AutoPostBack="true"></asp:DropDownList></td>
            </tr>
            <tr>
                <td>Fixture Date:</td>
                <td><asp:DropDownList ID="FixtureDate_DropDownList" runat="server" AutoPostBack="True" ></asp:DropDownList>
                    <asp:Literal ID="Fixture_Literal" runat="server"></asp:Literal>
                </td>
            </tr>
            <tr>
                <td>Away Team:</td>
                <td><asp:textbox ID="AwayTeam_Literal" runat="server"></asp:textbox></td>
            </tr>
            <tr>
                <td>Date Played:</td>
                <td>
                    <input type="date" id="DatePicker" style="width:80px;" onchange="DatePickerChanged(MatchDate_Textbox,this);" hidden="hidden" />
                    <asp:TextBox ID="MatchDate_Textbox" runat="server" onclick="DateBoxClicked(DatePicker,this);" Width="240px" />
                    <span style="font-size:smaller; font-style:italic">Touch/Click to change</span>
                </td>
            </tr>
            <tr>
                <td></td>
                <td><asp:Button ID="Next_Button0" runat="server" Text="Next >" Visible="false"/></td>
            </tr>
        </table>
    </asp:Panel>

    <asp:Panel ID="Frame1_Panel" runat="server" Visible="false">
        <table>
            <tr>
                <td>Frame&nbsp;1</td>
               <td style="text-align: center">Player</td>
                <td>H'cap</td>
                <td>Score</td>
            </tr>
            <tr>
                <td>Home</td>
                <td><asp:DropDownList ID="HomePlayer1_DropDownList" runat="server" AutoPostBack="true"
                                      onmouseover="this.style.cursor='pointer';" onchange ="ddChanged(this);" /></td>
                <td><asp:TextBox ID="HomeHcap1_TextBox" runat="server" CssClass="HcapScore" />
                    <img id="HomeHCapImg1" runat="server" src="../images/warning.png" onclick="showHCapMsg(HomeHcap1_TextBox);" height="32" onmouseover="this.style.cursor='pointer';" alt="Help" visible="false"/>

                </td>
                <td><asp:TextBox ID="HomeScore1_TextBox" runat="server" CssClass="HcapScore" /></td>
            </tr>
            <tr>
                <td>Away</td>
                <td><asp:DropDownList ID="AwayPlayer1_DropDownList" runat="server"
                                      onmouseover="this.style.cursor='pointer';" onchange ="ddChanged(this);" /></td>
                <td><asp:TextBox ID="AwayHcap1_TextBox" runat="server" CssClass="HcapScore" />
                    <img id="AwayHCapImg1" runat="server" src="../images/warning.png" onclick="showHCapMsg(AwayHcap1_TextBox);" height="32" onmouseover="this.style.cursor='pointer';" alt="Help" visible="false"/>
              
                </td>
                <td><asp:TextBox ID="AwayScore1_TextBox" runat="server" CssClass="HcapScore" /></td>
            </tr>
        </table>
        <table>    
            <tr> 
                <td></td>
                <td style="text-align:right;"><asp:Button ID="Prev_Button1" runat="server" Text="< Prev" Visible="true"/></td>
                <td></td>
                <td><asp:Button ID="Next_Button1" runat="server" Text="Next >" Visible="true"/></td>
            </tr>
        </table>
    </asp:Panel>
    <asp:Panel ID="Frame2_Panel" runat="server" Visible="false">
        <table>
            <tr>
                <td>Frame&nbsp;2</td>
               <td style="text-align: center">Player</td>
                <td>H'cap</td>
                <td>Score</td>
            </tr>
            <tr>
                <td>Home</td>
                <td><asp:DropDownList ID="HomePlayer2_DropDownList" runat="server"
                                      onmouseover="this.style.cursor='pointer';" onchange ="ddChanged(this);" /></td>
                <td><asp:TextBox ID="HomeHcap2_TextBox" runat="server" CssClass="HcapScore" />
                    <img id="HomeHCapImg2" runat="server" src="../images/warning.png" onclick="showHCapMsg(HomeHcap2_TextBox);" height="32" onmouseover="this.style.cursor='pointer';" alt="Help" visible="false"/>

                </td>
                <td><asp:TextBox ID="HomeScore2_TextBox" runat="server" CssClass="HcapScore" /></td>
            </tr>
            <tr>
                <td>Away</td>
                <td><asp:DropDownList ID="AwayPlayer2_DropDownList" runat="server"
                                      onmouseover="this.style.cursor='pointer';" onchange ="ddChanged(this);" /></td>
                <td><asp:TextBox ID="AwayHcap2_TextBox" runat="server" CssClass="HcapScore" />
                    <img id="AwayHCapImg2" runat="server" src="../images/warning.png" onclick="showHCapMsg(AwayHcap2_TextBox);" height="32" onmouseover="this.style.cursor='pointer';" alt="Help" visible="false"/>
                </td>
                <td><asp:TextBox ID="AwayScore2_TextBox" runat="server" CssClass="HcapScore" /></td>
            </tr>
        </table>
        <table>    
            <tr> 
                <td></td>
                <td style="text-align:right;"><asp:Button ID="Prev_Button2" runat="server" Text="< Prev" Visible="true"/></td>
                <td></td>
                <td><asp:Button ID="Next_Button2" runat="server" Text="Next >" Visible="true"/></td>
            </tr>
        </table>
    </asp:Panel>
    <asp:Panel ID="Frame3_Panel" runat="server" Visible="false">
        <table>
            <tr>
                <td>Frame&nbsp;3</td>
               <td style="text-align: center">Player</td>
                <td>H'cap</td>
                <td>Score</td>
            </tr>
            <tr>
                <td>Home</td>
                <td><asp:DropDownList ID="HomePlayer3_DropDownList" runat="server"
                                      onmouseover="this.style.cursor='pointer';" onchange ="ddChanged(this);" /></td>
                <td><asp:TextBox ID="HomeHcap3_TextBox" runat="server" CssClass="HcapScore" />
                    <img id="HomeHCapImg3" runat="server" src="../images/warning.png" onclick="showHCapMsg(HomeHcap3_TextBox);" height="32" onmouseover="this.style.cursor='pointer';" alt="Help" visible="false"/>
                </td>
                <td><asp:TextBox ID="HomeScore3_TextBox" runat="server" CssClass="HcapScore" /></td>
            </tr>
            <tr>
                <td>Away</td>
                <td><asp:DropDownList ID="AwayPlayer3_DropDownList" runat="server"
                                      onmouseover="this.style.cursor='pointer';" onchange ="ddChanged(this);" /></td>
                <td><asp:TextBox ID="AwayHcap3_TextBox" runat="server" CssClass="HcapScore" />
                    <img id="AwayHCapImg3" runat="server" src="../images/warning.png" onclick="showHCapMsg(AwayHcap3_TextBox);" height="32" onmouseover="this.style.cursor='pointer';" alt="Help" visible="false"/>
                </td>
                <td><asp:TextBox ID="AwayScore3_TextBox" runat="server" CssClass="HcapScore" /></td>
            </tr>
        </table>
        <table>    
            <tr> 
                <td></td>
                <td style="text-align:right;"><asp:Button ID="Prev_Button3" runat="server" Text="< Prev" Visible="true"/></td>
                <td></td>
                <td><asp:Button ID="Next_Button3" runat="server" Text="Next >" Visible="true"/></td>
            </tr>
        </table>
    </asp:Panel>
    <asp:Panel ID="Frame4_Panel" runat="server" Visible="false">
        <table>
            <tr>
                <td>Frame&nbsp;4</td>
               <td style="text-align: center">Player</td>
                <td>H'cap</td>
                <td>Score</td>
            </tr>
            <tr>
                <td>Home</td>
                <td><asp:DropDownList ID="HomePlayer4_DropDownList" runat="server"
                                      onmouseover="this.style.cursor='pointer';" onchange ="ddChanged(this);" /></td>
                <td><asp:TextBox ID="HomeHcap4_TextBox" runat="server" CssClass="HcapScore" />
                    <img id="HomeHCapImg4" runat="server" src="../images/warning.png" onclick="showHCapMsg(HomeHcap4_TextBox);" height="32" onmouseover="this.style.cursor='pointer';" alt="Help" visible="false"/>
                </td>
                <td><asp:TextBox ID="HomeScore4_TextBox" runat="server" CssClass="HcapScore" /></td>
            </tr>
            <tr>
                <td>Away</td>
                <td><asp:DropDownList ID="AwayPlayer4_DropDownList" runat="server"
                                      onmouseover="this.style.cursor='pointer';" onchange ="ddChanged(this);" /></td>
                <td><asp:TextBox ID="AwayHcap4_TextBox" runat="server" CssClass="HcapScore" />
                    <img id="AwayHCapImg4" runat="server" src="../images/warning.png" onclick="showHCapMsg(AwayHcap4_TextBox);" height="32" onmouseover="this.style.cursor='pointer';" alt="Help" visible="false"/>
                </td>
                <td><asp:TextBox ID="AwayScore4_TextBox" runat="server" CssClass="HcapScore" /></td>
            </tr>
        </table>
        <table>    
            <tr> 
                <td></td>
                <td style="text-align:right;"><asp:Button ID="Prev_Button4" runat="server" Text="< Prev" Visible="true"/></td>
                <td></td>
                <td><asp:Button ID="Next_Button4" runat="server" Text="Next >" Visible="true"/></td>
            </tr>
        </table>
    </asp:Panel>

    <asp:Panel ID="Breaks_Panel" runat="server" Visible="false">
                <table>
                    
                    <tr >
                        <td colspan="3" style="text-align:left">
                            <strong>Breaks</strong>
                        </td>
                    </tr>

                    <tr>
                        <td colspan="3">
                            <asp:GridView ID="Breaks_GridView" runat="server" CssClass="gridView" HorizontalAlign="Center" CellPadding="4" ShowHeader="False">
                                <Columns>
                                    <asp:CommandField ShowDeleteButton="True" />
                                </Columns>
                                <HeaderStyle Height="0" />
                                <RowStyle CssClass="gridViewRow"/>
                                <AlternatingRowStyle CssClass="gridViewAlt" />
                            </asp:GridView>

                        </td>
                    </tr>    

                    <tr >
                        <td  colspan="3">
                            <span style="font-size: larger; font-style: italic; color: #FF0000">To add a break, select a player, enter the break and click Add this break.</span>
                        </td>
                    </tr>

                    <tr >
                        <td><asp:DropDownList ID="BreakPlayers_DropDownList" runat="server" ></asp:DropDownList></td>
                        <td><asp:TextBox ID="Break_TextBox" runat="server" Cssclass="scoreBox" ></asp:TextBox></td>
                        <td><asp:button id="BreakAdd_Button" runat="server" text="Add this break" onmouseover="this.style.cursor='pointer'"/></td>
                    </tr>
            
                    <tr id="breakErrorRow" runat="server" visible="true">
                        <td colspan="3">
                            <span style="color: #FF0000"><asp:Literal ID="Breaks_Literal" runat="server"></asp:Literal></span>
                        </td>
                    </tr>
                </table> 

        <table>
             <tr> 
                <td style="text-align:right;"><asp:Button ID="Prev_Button5" runat="server" Text="< Prev" Visible="true"/></td>
                <td></td>
                <td><asp:Button ID="Next_Button5" runat="server" Text="Next >" Visible="true"/></td>
            </tr>
       </table>
    </asp:Panel>
 
    <div id="AdminActionsDiv" runat="server" class="CentredDiv">
        <div id="Delete_Result_Div" style="" runat="server" visible="false">
            <input id="Delete_Result_Button" type="button" value="Delete this result" 
                onclick="loadDiv('divDeleteResult');" onmouseover="this.style.cursor='pointer';" />
        </div>
 	    <div id="divDeleteResult" style="display:none;">
                
                <table>
                    <tr>
                        <td text-align: center;" colspan="2">
                            You are about to remove this match result completely, including any breaks.<br /><br />
                            Click Remove to confirm this deletion, otherwise click Cancel.
                            <p style="color: #FF0000"><asp:Literal ID="DeleteResult_Literal" runat="server"/></p>
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
        <asp:Button ID="Recover_Button" runat="server" Text="Recover result for the requested match." visible="false"/>
    </div>


    <asp:Panel ID="SubmitResult_Panel" runat="server" Visible="false">

        <table>
             <tr> 
                <td style="text-align:center;"><asp:Button ID="Prev_Button6" runat="server" Text="< Prev" Visible="true"/></td>
                <td></td>
                <td>&nbsp;&nbsp;</td>
            </tr>
       </table>

            <div  style="text-align:center;">
                <asp:Literal ID="status_Literal" runat="server"></asp:Literal><br />

                <asp:Button ID="Send_Button" runat="server" Text="Check your results card" />
                <br />
                <asp:Button ID="Cancel_Button" runat="server" Text="Cancel" />
                <br />
                <asp:Button ID="Retry_Button" runat="server" Visible="false" Text="Resend the emails" />
            </div>

      </asp:Panel>
  
  </div>

    <%--preserve session variables as GoDaddy may kill the application after 5 minutes timeout--%>
    <input type="hidden" id="SessionUser" name = "SessionUser" runat="server" />
    <input type="hidden" id="SessionEmail" name = "SessionEmail" runat="server" />
    <input type="hidden" id="SessionPassword" name = "SessionPassword" runat="server" />
    <input type="hidden" id="SessionUserID" name = "SessionUserID" runat="server" />
    <input type="hidden" id="SessionUserName" name = "SessionUserName" runat="server" />
    <input type="hidden" id="SessionAdminEmail" name = "SessionAdminEmail" runat="server" />
    <input type="hidden" id="SessionTeamID" name = "SessionTeamID" runat="server" />
    <input type="hidden" id="SessionAwayTeamID" name = "SessionAwayTeamID" runat="server" />
    <input type="hidden" id="SessionMatchResultID" name = "SessionMatchResultID" runat="server" />
    <input type="hidden" id="HomeFrames" name = "HomeFrames" runat="server" />
    <input type="hidden" id="AwayFrames" name = "AwayFrames" runat="server" />
    <input type="hidden" id="SessionBreaksTable" name = "SessionBreaksTable" runat="server" />

    <div id="divHCapMsg" style="display:none; color: #000000; background-color: #FFFFFF; font-size: 24px;" onclick="this.style.display='none';" onmouseover="this.style.cursor='pointer';" ">
                <table>
                    <tr>
                        <td background-image: url(Images/menuBarBG.gif);">
                            <strong>Warning:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</strong></td>
                        <td>
                            <img src="Images/Exit.bmp" alt="Click to close"/>
                        </td>
                    </tr>
                    <tr>
                        <td>Handicaps cannot be changed.</td>
                    </tr>
                    <tr>
                        <td colspan="2">If the handicap is incorrect <a href="../Contact.aspx"> contact the league secretary.</a></td>
                    </tr>
                </table>

 
</div>

</asp:Content>
