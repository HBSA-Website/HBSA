function loadDiv(divID) {
    if ((divID != 'loading') && (divID != 'updating')) {
        var perCent
        if (divID == 'cfgHelp1') {
            perCent = 8 / 100;
        }
        else {
            perCent = 15 / 100;
        }
        // calc left as 15 % of page width
        var divLeft = document.documentElement.clientWidth * perCent;
        // calc top as 15 % of page height
        var divTop = document.documentElement.clientHeight * perCent;
        document.getElementById(divID).style.top = divTop;
        document.getElementById(divID).style.left = divLeft;
    }
    document.getElementById(divID).style.display = "block";
    if (divID == 'loading') {
        //ensure animated loading gif runs after post back
        setTimeout('document.images["imgLoading"].src="Images/loading.gif"', 200);
    }
    else if (divID == 'updating') {
        setTimeout('document.images["imgupdating"].src="Images/loading.gif"', 200);
    }
}

function hideDiv(divID) {
    document.getElementById(divID).style.display = "none";
}

function loadMenuDiv(divID, ContainerDivID) {

    hideMenuDiv();

    if (divID != "") {

        document.getElementById(divID).style.display = "block";
        document.getElementById(ContainerDivID).style.display = "block";
    }
}

function hideMainMenus() {

    hideMenuDiv();
    var div = document.getElementById("leftMenuDiv");
    div.style.display = "none";
    div = document.getElementById("rightMenuDiv");
    div.style.display = "none";
}

function hideMenuDiv() {

    var divs = document.getElementsByTagName("div");
    for (var i = 0; i < divs.length; i++) {
        if (divs[i].id.length > 8)
            if (divs[i].id.substr(0, 8) == "SubMenu_")
                divs[i].style.display = "none";
    }

}

function loadInfoDiv(divID, ID, DetailType) {
    HBSA_Web_Application.ActiveTableDetail.GetDetail(ID, DetailType, OnComplete, OnError, divID);
}
function OnComplete(HTML, divID) {
    var div = document.getElementById(divID);
    div.innerHTML = HTML;
    div.style.display = "block";
}
function OnError(result) {
    alert("Error: " + result.get_message());
}
