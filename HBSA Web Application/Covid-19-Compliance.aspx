<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/MasterPage.master" CodeBehind="Covid-19-Compliance.aspx.vb" Inherits="HBSA_Web_Application.Covid_19_Compliance" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .votingTable {
            border: 1px solid black;
            border-collapse: collapse;
        }

            .votingTable th {
                font-size: 10pt;
                text-align: center;
                border: 1px solid black;
                padding: 10px;
            }

            .votingTable td {
                font-size: 10pt;
                text-align: center;
                border: 1px solid black;
                padding: 10px;
            }

        ul {
            margin-bottom: 0cm;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div style="font-size: 14pt; font-family: Aial,sans-serif; text-align: center">
        <br />
        <b>Further information required from Clubs as a condition of League restarting.</b>
    </div>
    <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
    <asp:UpdatePanel runat="server">
        <ContentTemplate>
            <div id="VotingTables" runat="server" style="padding: 40px">
                <table>
                    <tr><td style="vertical-align: top; font-size: larger;">
                             Choose a club to view it's compliance form:&nbsp;&nbsp;&nbsp;&nbsp;
                              <asp:DropDownList ID="ClubID_DropDownList" runat="server" AutoPostBack="true"></asp:DropDownList>
                    </td></tr>
                </table>
                <br />

                <table class="votingTable" id="Special_Resolutions" runat="server">
                    <tr>
                        <td style="text-align: left;">
                            <p>
                                <span>1.&nbsp; It is very important that the answers given represent all the different parties involved.&nbsp; Please could you confirm that <b>as the Club representative</b> completing this form you have:&nbsp;</span>
                            </p>
                            <ul style="margin-top: 0cm">
                                <li><span>Read the EPSB League restart guidelines in full <a href="https://apc01.safelinks.protection.outlook.com/?url=https%3A%2F%2Fwww.epsb.co.uk%2Fwp-content%2Fuploads%2FEPSB-Return-to-Play-Guidance-on-restarting-league-snooker-v.2.pdf&amp;data=02%7C01%7C%7Cf13f00e6ec564d14bd7508d83ab430ec%7C84df9e7fe9f640afb435aaaaaaaaaaaa%7C1%7C0%7C637323892870945300&amp;sdata=MLMuP12kDQxbYzlbWzEu3K%2FjzVGy2tihnFcFsYMhQ5E%3D&amp;reserved=0">https://www.epsb.co.uk/wp-content/uploads/EPSB-Return-to-Play-Guidance-on-restarting-league-snooker-v.2.pdf</a></span></li>
                                <li><span>Passed a copy of the EPSB guidelines to Club officials and to team captains/ players</span></li>
                                <li><span>Consulted with an authorised official at your Club and with your team captain(s) / players prior to responding on issues affecting them&nbsp;</span></li>
                            </ul>
                        </td>
                        <td>
                            <asp:RadioButtonList ID="Check1" runat="server" RepeatLayout="Flow" AutoPostBack="true">
                                <asp:ListItem>Confirm&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</asp:ListItem>
                                <asp:ListItem>Unable to confirm</asp:ListItem>
                            </asp:RadioButtonList>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: left;">
                            <p>
                                2.&nbsp;&nbsp;We have recent confirmation your Club is COVID-19 secure, thank you.&nbsp; In light of EPSB guidelines on social distancing (which are more onerous for smaller Clubs in HBSA)&nbsp;<strong>please can you also confirm that:</strong>
                            </p>
                            <ul>
                                <li>Bearing in mind the small floor areas in some Clubs, that on match nights, the numbers in different rooms will be managed to 
                                    ensure social distancing is fully respected.<br />
                                </li>
                                <li>pectators will be distanced from each other and from both players (NOT the table) by at least 2 metres at all times.&nbsp; If in smaller Clubs there 
                                    is limited room around the table(s) and this is not possible, then you will not permit any spectators.<br />
                                </li>
                                <li>Players will have a designated area allocated, away from match tables.<br />
                                </li>
                                <li>If necessary to maintain social distancing, numbers in the Club as a whole will be limited (even if this means some 
                                    players being denied entry until their match is due to start, and others being asked to leave after their match is finished).</li>
                                <li>You have considered how rules will be enforced and who will enforce rules on match nights.</li>
                            </ul>
                        </td>
                        <td>
                            <asp:RadioButtonList ID="Check2" runat="server" RepeatLayout="Flow" AutoPostBack="true">
                                <asp:ListItem>Confirm&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</asp:ListItem>
                                <asp:ListItem>Unable to confirm</asp:ListItem>
                            </asp:RadioButtonList>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: left;">
                            <p>3a.&nbsp; <b>Team captains </b>have a duty of care to their players which includes being a role model for all elements of the EPSB league start up guidelines.&nbsp; Please confirm that <b>the Team captains in your Club</b> have agreed to the following:</p>
                            <ul>
                                <li>To follow EPSB guidelines for league start up, with particular attention to standards of hygiene, maintaining social distancing at all times and to adhering strictly to the rules at the Club they are playing in. Ensuring the players in their team do the same.</li>
                                <li>To speak with the opposing team in advance of every match to ensure both teams are aware of specific Club rules and are fully prepared for the match</li>
                                <li>To ensure players know what order they are playing in, in advance of games, with suggested arrival and leaving times.</li>
                                <li>To arrange travel to venues in accordance with Government guidelines, for the safety of team players. This includes travelling separately where possible to away games and where this is not possible, ensuring face-masks are worn when in close proximity</li>
                                <li>At away matches, you will adhere fully to the rules of the Club you are visiting. You acknowledge that this could mean fewer spectators than normal, or no spectators at all. You agree that you will not challenge home team players or staff at the Club, about their rules or create difficulties for them.</li>
                            </ul>
                        </td>
                        <td>
                            <asp:RadioButtonList ID="Check3" runat="server" RepeatLayout="Flow" AutoPostBack="true">
                                <asp:ListItem>Confirm&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</asp:ListItem>
                                <asp:ListItem>Unable to confirm</asp:ListItem>
                            </asp:RadioButtonList>
                        </td>
                    </tr>

                    <tr>
                        <td style="text-align: left;">
                            <p>
                                <span>3b.&nbsp;If there are any teams at your Club that you have been unable to contact or to get the necessary assurance from, please list them here.  Please note that these teams will be automatically excluded from the 2020/21 season.</span>
                            </p>
                        </td>
                        <td>
                            <asp:TextBox ID="TextBox3" runat="server" Height="130px" MaxLength="2000" TextMode="MultiLine" Width="260px"></asp:TextBox>
                        </td>
                    </tr>


                    <tr>
                        <td style="text-align: left;"><span style="font-size: 11.0pt; font-family: arial,sans-serif; font-family: Calibri; color: black; ">4.&nbsp; <b>To the Club representative completing this form.&nbsp; </b>Do you personally have or are you aware of any concerns regarding the safety of your Club in regard to COVID-19 and its ability to conform to EPSB league restart guidelines? (If yes please add details in the text box here).</span></td>
                        <td>
                            <asp:RadioButtonList ID="Check4" runat="server" RepeatLayout="Flow" AutoPostBack="true">
                                <asp:ListItem>No Concerns&nbsp;&nbsp;&nbsp;&nbsp;</asp:ListItem>
                                <asp:ListItem>Yes, Concerned</asp:ListItem>
                            </asp:RadioButtonList>
                            <br />
                            <asp:TextBox ID="TextBox4" runat="server" Height="99px" MaxLength="2000" TextMode="MultiLine" Width="260px"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: left;">
                            <p>
                                <span>5.&nbsp; <b>To the Club representative completing this form.&nbsp; </b>If there are there any teams at your Club that wish to withdraw from the League as a result of these guidelines or if there is anything else you wish to tell us, please state this here.&nbsp; (If there is anything you would rather share confidentially please contact the League Secretary separately).</span>
                            </p>
                        </td>
                        <td>
                            <asp:TextBox ID="TextBox5" runat="server" Height="130px" MaxLength="2000" TextMode="MultiLine" Width="260px"></asp:TextBox>
                        </td>
                    </tr>
                </table>
            </div>
<%--            <div style="text-align: center;">
                In submitting this form, you are responding on behalf of yourself, your Club and the players at your Club.  This means that your responses may be shared with Club officials and players at your Club, on request.  
            <br />
                <br />
                HBSA will make key decisions based on your responses.PRESS “SUBMIT” IF YOU ARE HAPPY TO PROCEED ON THIS BASIS:<br />
                <br />
                <asp:Label ID="DisabledSubmit_Label" runat="server" Text="Cannot submit until all radio buttons have one or the other option chosen." ForeColor="Red"></asp:Label><br />
                <asp:Button ID="Submit_Button" runat="server" Text="SUBMIT" Height="77px" Width="579px" BackColor="#66FFCC" Font-Bold="True" Font-Size="14pt" enabled="false" /><br />
                <br />
                <span style='color: red;font-size:larger;font-weight:bold;'>
                    <asp:Literal ID="Status_Literal" runat="server"></asp:Literal><br />
                </span>
            </div>--%>

        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
