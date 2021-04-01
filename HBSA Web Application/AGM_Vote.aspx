<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/MasterPage.master" CodeBehind="AGM_Vote.aspx.vb" 
    Inherits="HBSA_Web_Application.AGM_Vote" ClientIDMode="Static" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .votingTable {
            border:1px solid black; 
            border-collapse:collapse;
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

    <div style="font-weight: bold; font-size: 16.0pt; line-height: 107%; width: 100%; text-align: center;">VOTING for the AGM</div>

    <p>
        <span style="font-size: 12pt; font-family: Aial,sans-serif;">
            <b>The votes are in, these are the numbers.</b>
        </span>
    </p>

<%--    <asp:UpdatePanel runat="server">
        <ContentTemplate>

            <script type="text/javascript">
                function keepExclusive(caller) {
                    if (caller.checked) {
                        var ix = caller.id.indexOf("_");
                        var prefix = caller.id.substr(0, ix);
                        var suffix = caller.id.substr(ix + 1, 3);
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
            </script>--%>

            <div id="VotingTables" runat="server" style="padding:40px">
                <table class="votingTable" id="Ordinary_Resolutions" runat="server">
                    <tr>
                        <th style="text-align: left;">Ordinary Resolutions</th>
                        <th style="width: 120px;">For</th>
                        <th style="width: 120px;">Against</th>
                        <th style="width: 120px;">Withheld</th>
                    </tr>
                    <tr>
                        <td style="text-align: left;">1.	Acceptance of minutes of 2018/2019 AGM</td>
                        <td>30</td>
                        <td>0</td>
                        <td>3</td>
                    </tr>
                    <tr>
                        <td style="text-align: left;">2.	Approve the Annual Report and Accounts</td>
                        <td>30</td>
                        <td>0</td>
                        <td>3</td>
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
                        <td style="text-align: left;"><b>1.	New qualifying criteria for entering competitions.</b><br />
                            A minimum of 3 games in the current season OR 5 games in the current and last season combined. This does NOT apply to junior snooker competitions. With immediate effect.</td>
                        <td>31</td>
                        <td>1</td>
                        <td>1</td>
                    </tr>
                    <tr>
                        <td style="text-align: left;"><b>2.	The handbook. A smaller handbook is proposed, reducing down to around 40 pages.</b><br />
                            To include last season’s league tables and results. 200 copies to be produced: 1 per team and 1 per premises.</td>
                        <td>33</td>
                        <td>0</td>
                        <td>0</td>
                    </tr>
                    <tr>
                        <td style="text-align: left;"><b>3.	AGM attendance.</b><br />
                            Non-attendance at the AGM will incur a 4-point deduction, starting in 2021.</td>
                        <td>20</td>
                        <td>10</td>
                        <td>3</td>
                    </tr>
                    <tr>
                        <td style="text-align: left;"><b>4.	Late Payments.</b><br />
                            League Entry Fees not received by the November meeting will incur a 4-point deduction. Teams not paying competition entry fees by this date will be scratched. Teams not paying fines by the March meeting will incur a 4-point deduction. With immediate effect.</td>
                        <td>27</td>
                        <td>6</td>
                        <td>0</td>
                    </tr>
                    <tr>
                        <td colspan="4"></td>
                    </tr>
                    <tr>
                        <td style="text-align: left;"><b>5.	Venues for the 2020/2021 Finals fortnight.</b><br />
                            Please tick a box indicating your preferred venue:&nbsp; All at Levels, Mix of Crosland Moor Con and Marsh Lib, or a mix of Levels, Crosland Moor Con and Marsh Lib </td>
                        <td><b>Levels</b><br />
                            10</td>
                        <td><b>Crosland Moor<br />
                            / Marsh Lib</b><br />
                            8</td>
                        <td><b>Mix of all 3 clubs</b><br />
                            15</td>
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
                        <td style="text-align: left;">1.	Secretary – B Keenan</td>
                        <td>32</td>
                        <td>0</td>
                        <td>1</td>
                    </tr>
                    <tr>
                        <td style="text-align: left;">2.	League Secretary – J Bastow</td>
                        <td>33</td>
                        <td>0</td>
                        <td>0</td>
                    </tr>
                    <tr>
                        <td style="text-align: left;">3.	Competition Secretary – P Schofield</td>
                        <td>33</td>
                        <td>0</td>
                        <td>0</td>
                    </tr>
                    <tr>
                        <td style="text-align: left;">4.	Treasurer – D Poutney</td>
                        <td>33</td>
                        <td>0</td>
                        <td>0</td>
                    </tr>
                    <tr>
                        <td style="text-align: left;">5.  Auditors – B Keenan / R Taylor</td>
                        <td>32</td>
                        <td>0</td>
                        <td>1</td>
                    </tr>
                </table>
                <br />
                <br />
            </div>

<%--        </ContentTemplate>
    </asp:UpdatePanel>--%>

</asp:Content>

