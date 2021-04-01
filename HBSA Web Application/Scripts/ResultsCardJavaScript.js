//globals
var oldPlayerID = -1;
var oldPlayerName = "";
var PlayerIDs;
var Breaks;
        
function storePlayerID(ddList) {
    //store selector index before
    oldPlayerID = ddList.options[ddList.selectedIndex].value.split("|")[0];
    oldPlayerName = ddList.options[ddList.selectedIndex].text;
}

function ddChanged(ddList) {

    /* This routine will populate the correct handicap
                         populate the drop down of team players
                         populate the list of break makers.
    */
    //establish some useful variables
    var ddName = ddList.id;
    var HomeAway = ddList.id.substr(0, 4);
    var ddRow = ddList.id.substr(10, 1);
    var currIx = ddList.selectedIndex;
    var ddValues = ddList.options[currIx].value.split("|");
    var newPlayerName = ddList.options[currIx].text;
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
            } else
                if (currIx == 2) {
                    otherDDlist.selectedIndex = 1;
                } else {
                    otherDDlist.selectedIndex = 3;
                }

        } else {
            HomeAway = "Home";
            var otherDDlist = document.getElementById(ddList.id.replace("Away", "Home")); 
            if (currIx == 1) {
                otherDDlist.selectedIndex = 2;
            } else
                if (currIx == 2) {
                    otherDDlist.selectedIndex = 1;
                } else {
                    otherDDlist.selectedIndex = 3;
                }
        }

        //set handicap & score for the other one
        hcapBoxname = HomeAway + "Hcap" + ddRow + "_TextBox";
        ScoreBoxname = HomeAway + "Score" + ddRow + "_TextBox";
        document.getElementById(hcapBoxname).value = "0";
        if (ddValues[0].substr(1, 1) == "1") {
            //set no opponent's score to 2
            document.getElementById(ScoreBoxname).value = "2";
        } else {
            //set no show or Frame Not Played score to 0
            document.getElementById(ScoreBoxname).value = "1";
        }
        document.getElementById(ScoreBoxname).disabled = true;

    } else {

        // populate handicap & score boxes
        document.getElementById(hcapBoxname).value = ddValues[1];
        // document.getElementById(ScoreBoxname).value = "";
        document.getElementById(ScoreBoxname).disabled = false;

        removeBreak(HomeAway, oldPlayerName)

        //Make an entry in the breaks players dropdown list
        var opt = document.createElement("option");
        opt.text = newPlayerName;    // player name
        opt.value = ddValues[0];   // player ID
        var BreaksPlayersDDName = HomeAway + "BreakPlayers_DropDownList";
        var MPList = document.getElementById(BreaksPlayersDDName);
        MPList.options.add(opt);

        // Clear old entry from breaks players dropdown list
        for (var ix = 0; ix < MPList.options.length; ix++) {
            if (oldPlayerID == MPList.options[ix].value) {
                MPList.remove(ix);
                break;
            }
        }
    }
}

function removeBreak(HomeOrAway, PlayersName) {

    //clear breaks table of prev entry if it exists
    var breaksTable = document.getElementById("webPage_" + HomeOrAway + "Breaks_Table"); //document.getElementById(HomeAway + "Breaks_Table");
    for (var ix = 0; ix < breaksTable.rows.length; ix++) {
        if (PlayersName == breaksTable.rows[ix].cells[0].innerText) {
            breaksTable.deleteRow(ix);

            // remove equivalent in hidden element
            var PlayerIDs = document.getElementById(HomeOrAway + "_Player_IDs").value.split("|")
            PlayerIDs.splice(ix, 1);
            document.getElementById(HomeOrAway + "_Player_IDs").value = PlayerIDs;
        }
    }
}

function isValidBreakInteger(str) {
    var n = Math.floor(Number(str));
    return String(n) === str && n >= 25;
}

function breakAdded(breakButton) {

    var HomeAway = breakButton.id.substr(0, 4);
    var PlayerSel = document.getElementById(HomeAway + "BreakPlayers_DropDownList");

    //check player selection
    if (PlayerSel.selectedIndex < 1 ) { 
        //Invalid player...
        window.alert("Please select a player.");
        return;
    }

    //Check Break value
    var Break = document.getElementById(HomeAway + "Break_TextBox").value;
    if (!isValidBreakInteger(Break)) {
        //Invalid break...
        window.alert("The break is invalid.  It must be an integer greater than 24.");
        return;
    }

    //  Add the break to the appropriate breaks table
    
    var breaksTable = document.getElementById("webPage_" + HomeAway + "Breaks_Table");
    var PlayerID = PlayerSel.options[PlayerSel.selectedIndex].value;
    var PlayerName = PlayerSel.options[PlayerSel.selectedIndex].text;

    var rowNo = breaksTable.rows.length;
    var newRow = breaksTable.insertRow(rowNo);
    newRow.id = breaksTable.id + '_r' + rowNo;
    var newCell0 = newRow.insertCell(0);
    newCell0.id = breaksTable.id + '_r' + rowNo + 'c0';
    newCell0.innerHTML = PlayerName;
    var newCell1 = newRow.insertCell(1);
    newCell1.id = breaksTable.id + '_r' + rowNo + 'c1';
    newCell1.innerHTML = document.getElementById(HomeAway + "Break_TextBox").value;
    var newCell2 = newRow.insertCell(2);
    newCell2.id = breaksTable.id + '_r' + rowNo + 'c2';
    newCell2.innerHTML = "<span onmouseover=\"this.style.cursor='pointer';\" onclick=\"deleteBreakRow(this);\"><i><font color=red>remove</font></i></span>";

    //populate the hidden fields (in the same sequence as the table)
    var PlayerIDs = document.getElementById(HomeAway + "_Player_IDs");
    PlayerIDs.value = PlayerIDs.value + PlayerID + "," + newCell1.innerHTML + "|";

    //clear the selector and box
    document.getElementById(HomeAway + "Break_TextBox").value = "";
    PlayerSel.selectedIndex = 0;

    }

function deleteBreakRow(sender) {
    var CellID = sender.offsetParent.id;
    var rowIx = -1;
    var iy;
    var ix;
    for (ix = CellID.length - 1; ix > 2; ix--) {
        if (CellID.substr(ix, 1) == 'c') {
            for (iy = ix - 1; iy > 2; iy--) {
                if (CellID.substr(iy, 1) == 'r') {
                    rowIx = CellID.substr(iy + 1, ix - iy - 1);
                    break;
                }
            }
            break;
        }

    }

    if (rowIx > -1) {
        var breaksTableID = CellID.substr(0, iy - 1);

        var HomeOrAway
        if (breaksTableID.indexOf("ome") !== -1) {
            HomeOrAway = "Home"
        } else {
            HomeOrAway = "Away"
        }

        var breaksTable = document.getElementById(breaksTableID);
        breaksTable.deleteRow(rowIx);

        // remove equivalent in hidden element
        var PlayerIDs = document.getElementById(HomeOrAway + "_Player_IDs").value.split("|")

        PlayerIDs.splice(rowIx, 1);

        document.getElementById(HomeOrAway + "_Player_IDs").value = PlayerIDs.join("|");

    }


}