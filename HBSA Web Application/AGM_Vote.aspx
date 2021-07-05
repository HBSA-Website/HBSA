<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/MasterPage.master" CodeBehind="AGM_Vote.aspx.vb"
    Inherits="HBSA_Web_Application.AGM_Vote" ClientIDMode="Static" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="AjaxToolkit" %>


<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .votingTable {
            border:1px solid black; 
            border-collapse:collapse;
             font-weight:normal;
        }
        .votingTable th {
            font-size: 10pt;
            text-align: center;
            border: 1px solid black;
            padding: 10px;
        }
        .votingTable td {
            font-size:10pt;
            text-align:center;
            border:1px solid black; 
            padding:10px;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
    <hr />
    <br />
    <div style="font-weight: bold; font-size: 16.0pt; line-height: 107%; width: 100%; text-align: center;">2021 AGM - VOTING FORM</div>
    <p>
        <span style="color:red; font-size: 12pt; font-family: Aial,sans-serif;">
            <i>Please reply by logging in using your &quot;Club&quot; log-in credentials and completing
                the form on the website by 21<sup>st</sup> July 2021. POSTAL VOTES WILL NOT BE ACCEPTED.</i>
        </span>
    </p>

    <div style="font-weight:normal;" id="ClubSelection" runat="server">
        &nbsp;&nbsp;&nbsp;Select the club you wish to vote on behalf of:&nbsp;&nbsp;&nbsp;&nbsp;
        <asp:DropDownList ID="Club_DropDownList" runat="server" BackColor="#FFFFCC" AutoPostBack="True" Style="text-align: left"></asp:DropDownList>
    </div>

    <asp:Literal ID="Club_Literal" runat="server"/><br />

    <asp:UpdatePanel runat="server">
        <ContentTemplate>

            <script type="text/javascript">
            function keepExclusive(caller) {
                if (caller.checked) {
                    var ix = caller.id.indexOf("_");
                    var prefix = caller.id.substr(0, ix);
                    var suffix = caller.id.substr(ix+1, 3);
                    if (suffix == "For") {
                        document.getElementById(prefix + "_Agn").checked = false;
                        document.getElementById(prefix + "_Abs").checked = false;
                    } else if (suffix == "Agn") {
                        document.getElementById(prefix + "_For").checked = false;
                        document.getElementById(prefix + "_Abs").checked = false;
                    } else {
                        document.getElementById(prefix + "_For").checked = false;
                        document.getElementById(prefix + "_Agn").checked = false;
                    }
                }
            }
            </script>

            <p style="color: red;">
                <asp:Literal ID="Status_Literal2" runat="server"></asp:Literal>
            </p>

            <div id="VotingTables" runat="server">
                <table class="votingTable" id="Ordinary_Resolutions" runat="server">
                    <tr>
                        <th style="text-align: left;">Ordinary Resolutions</th>
                        <th style="width: 120px;">For</th>
                        <th style="width: 120px;">Against</th>
                        <th style="width: 120px;">Withheld</th>
                    </tr>
                    <tr>
                        <td style="text-align: left;">1. Acceptance of minutes of the 2020 AGM<asp:Literal ID="Error01" runat="server" /></td>
                        <td>
                            <asp:CheckBox ID="OrdinaryResolution01_For" runat="server" Text=" " onclick="keepExclusive(this);" /></td>
                        <td>
                            <asp:CheckBox ID="OrdinaryResolution01_Agn" runat="server" Text=" " onclick="keepExclusive(this)" /></td>
                        <td>
                            <asp:CheckBox ID="OrdinaryResolution01_Abs" runat="server" Text=" " onclick="keepExclusive(this)" /></td>
                    </tr>
                    <tr>
                        <td style="text-align: left;">2.	Approve the Annual Report and Accounts<asp:Literal ID="Error02" runat="server" /></td>
                        <td>
                            <asp:CheckBox ID="OrdinaryResolution02_For" runat="server" Text=" " onclick="keepExclusive(this);" /></td>
                        <td>
                            <asp:CheckBox ID="OrdinaryResolution02_Agn" runat="server" Text=" " onclick="keepExclusive(this)" /></td>
                        <td>
                            <asp:CheckBox ID="OrdinaryResolution02_Abs" runat="server" Text=" " onclick="keepExclusive(this)" /></td>
                    </tr>
                </table>
                <br />
                <br />
                <table class="votingTable" id="Special_Resolutions" runat="server">
                    <tr>
                        <th style="text-align: left;">Special Resolutions</th>
                        <th style="width: 120px;">For</th>
                        <th style="text-align: right; width: 120px;">Against</th>
                        <th style="width: 120px;">Withheld</th>
                    </tr>
                    <tr>
                        <td style="text-align: left;"><b>1. Qualifying criteria for entering competitions.</b><asp:Literal ID="Error03" runat="server" /><br />
                            Competition entrants must have played a minimum of 3 games in the current season OR 5 games in the current and last season combined.  (The '3/5 rule'). This applies to all competitions, the only exception being where the entrant is under 18 years of age (and does not play in other leagues or competitions outside of HBSA). In this scenario the '3/5 rule' is waived.</td>
                        <td>
                            <asp:CheckBox ID="SpecialResolution03_For" runat="server" Text=" " onclick="keepExclusive(this);" /></td>
                        <td>
                            <asp:CheckBox ID="SpecialResolution03_Agn" runat="server" Text=" " onclick="keepExclusive(this)" /></td>
                        <td>
                            <asp:CheckBox ID="SpecialResolution03_Abs" runat="server" Text=" " onclick="keepExclusive(this)" /></td>
                    </tr>
                    <tr>
                        <td style="text-align: left;"><b>2.	AGM and meetings attendance.</b><asp:Literal ID="Literal1" runat="server" /><br />
                            If a Club is not represented at the November or March meetings, points deductions will not apply to their Vets team(s).
                            <br />
                            <br />
                            <i>{Clarification: (i) If a Club is not represented at the AGM, points deductions will continue to apply to every team in that Club, including Vets. (ii) This rule is for face to face meetings in 'normal' times } </i>
                        </td>
                        <td>
                            <asp:CheckBox ID="SpecialResolution04_For" runat="server" Text=" " onclick="keepExclusive(this);" /></td>
                        <td>
                            <asp:CheckBox ID="SpecialResolution04_Agn" runat="server" Text=" " onclick="keepExclusive(this)" /></td>
                        <td>
                            <asp:CheckBox ID="SpecialResolution04_Abs" runat="server" Text=" " onclick="keepExclusive(this)" /></td>
                    </tr>
                    <tr>
                        <td style="text-align: left;"><b>3. Match postponements/cancellations.</b><asp:Literal ID="Error04" runat="server" /><br />
                            Matches must be cancelled a minimum of 90 minutes prior to the match start time, otherwise the opposing team has the right to claim the match in full
                        </td>
                        <td>
                            <asp:CheckBox ID="SpecialResolution05_For" runat="server" Text=" " onclick="keepExclusive(this);" /></td>
                        <td>
                            <asp:CheckBox ID="SpecialResolution05_Agn" runat="server" Text=" " onclick="keepExclusive(this)" /></td>
                        <td>
                            <asp:CheckBox ID="SpecialResolution05_Abs" runat="server" Text=" " onclick="keepExclusive(this)" /></td>
                    </tr>
                </table>
                <br />
                <br />
                <table class="votingTable" id="Elections" runat="server">
                    <tr>
                        <th style="text-align: left;">Election or re-Election of Officers</th>
                        <th style="width: 120px;">For</th>
                        <th style="width: 120px;">Against</th>
                        <th style="width: 120px;">Withheld</th>
                    </tr>
                    <tr>
                        <td style="text-align: left;">1. Secretary – R Taylor<asp:Literal ID="Error06" runat="server" /></td>
                        <td>
                            <asp:CheckBox ID="Election06_For" runat="server" Text=" " onclick="keepExclusive(this);" /></td>
                        <td>
                            <asp:CheckBox ID="Election06_Agn" runat="server" Text=" " onclick="keepExclusive(this)" /></td>
                        <td>
                            <asp:CheckBox ID="Election06_Abs" runat="server" Text=" " onclick="keepExclusive(this)" /></td>
                    </tr>
                    <tr>
                        <td style="text-align: left;">2.	League Secretary – J Bastow<asp:Literal ID="Error07" runat="server" /></td>
                        <td>
                            <asp:CheckBox ID="Election07_For" runat="server" Text=" " onclick="keepExclusive(this);" /></td>
                        <td>
                            <asp:CheckBox ID="Election07_Agn" runat="server" Text=" " onclick="keepExclusive(this)" /></td>
                        <td>
                            <asp:CheckBox ID="Election07_Abs" runat="server" Text=" " onclick="keepExclusive(this)" /></td>
                    </tr>
                    <tr>
                        <td style="text-align: left;">3.	Competition Secretary – P Schofield<asp:Literal ID="Error08" runat="server" /></td>
                        <td>
                            <asp:CheckBox ID="Election08_For" runat="server" Text=" " onclick="keepExclusive(this);" /></td>
                        <td>
                            <asp:CheckBox ID="Election08_Agn" runat="server" Text=" " onclick="keepExclusive(this)" /></td>
                        <td>
                            <asp:CheckBox ID="Election08_Abs" runat="server" Text=" " onclick="keepExclusive(this)" /></td>
                    </tr>
                    <tr>
                        <td style="text-align: left;">4.	Treasurer – D Poutney<asp:Literal ID="Error09" runat="server" /></td>
                        <td>
                            <asp:CheckBox ID="Election09_For" runat="server" Text=" " onclick="keepExclusive(this);" /></td>
                        <td>
                            <asp:CheckBox ID="Election90_Agn" runat="server" Text=" " onclick="keepExclusive(this)" /></td>
                        <td>
                            <asp:CheckBox ID="Election90_Abs" runat="server" Text=" " onclick="keepExclusive(this)" /></td>
                    </tr>
                    <tr>
                        <td style="text-align: left;">5.  Auditors – B Keenan / R Taylor<asp:Literal ID="Error10" runat="server" /></td>
                        <td>
                            <asp:CheckBox ID="Election10_For" runat="server" Text=" " onclick="keepExclusive(this);" /></td>
                        <td>
                            <asp:CheckBox ID="Election10_Agn" runat="server" Text=" " onclick="keepExclusive(this)" /></td>
                        <td>
                            <asp:CheckBox ID="Election10_Abs" runat="server" Text=" " onclick="keepExclusive(this)" /></td>
                    </tr>
                </table>
            </div>
            <br />
            <br />
            <p style="text-align: center; color: red">
                <asp:Literal ID="Status_Literal" runat="server"></asp:Literal>
                <br />
                <asp:Button ID="SubmitVote_Button" runat="server" Text="Click here to submit your club's vote." Font-Size="X-Large" />
            </p>


        </ContentTemplate>
    </asp:UpdatePanel>

</asp:Content>
