function loadDiv(divID) {
    document.getElementById(divID).style.display = "block";
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
