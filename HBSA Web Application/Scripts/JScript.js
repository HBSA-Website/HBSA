function showHidePassword(imgCtl, PasswordCtlID) {

    if (imgCtl.src.indexOf("Closed") > 0) {
        document.getElementById(PasswordCtlID).type = 'text';
        imgCtl.src = imgCtl.src.replace("Closed", "Open");
        imgCtl.alt = imgCtl.alt.replace("show", "hide");
        imgCtl.title = imgCtl.alt.replace("show", "hide");
    } else {
        document.getElementById(PasswordCtlID).type = 'password';
        imgCtl.src = imgCtl.src.replace("Open", "Closed");
        imgCtl.alt = imgCtl.alt.replace("hide", "show");
        imgCtl.title = imgCtl.alt.replace("hide", "show");
    }
}

function showLoading() {
    document.getElementById("loadingDiv").style.display = "block";
}

//Master page menus
function loadMenuDiv(divID, ContainerDivID) {

    hideMenuDiv();

    if (divID != "") {

        document.getElementById(divID).style.display = "block";
        document.getElementById(ContainerDivID).style.display = "block";

    }
}

function hideMenuDiv() {

    var divs = document.getElementsByTagName("div");
    for (var i = 0; i < divs.length; i++) {
        if (divs[i].id.length > 8)
            if (divs[i].id.substr(0, 8) == "SubMenu_")
                divs[i].style.display = "none";
    }

}


var dragObj = new Object();
dragObj.zIndex = 0;

function dragStart(event, id) {

    var el;
    var x, y;

    // If an element id was given, find it. Otherwise use the element being
    // clicked on.

    if (id)
        dragObj.elNode = document.getElementById(id);
    else {
            dragObj.elNode = window.event.srcElement;

            if (dragObj.elNode.nodeType == 3)
            dragObj.elNode = dragObj.elNode.parentNode;
    }

    // Get cursor position with respect to the page.

    x = window.event.clientX + document.documentElement.scrollLeft
      + document.body.scrollLeft;
    y = window.event.clientY + document.documentElement.scrollTop
      + document.body.scrollTop;

    // Save starting positions of cursor and element.

    dragObj.cursorStartX = x;
    dragObj.cursorStartY = y;
    dragObj.elStartLeft = parseInt(dragObj.elNode.style.left, 10);
    dragObj.elStartTop = parseInt(dragObj.elNode.style.top, 10);

    if (isNaN(dragObj.elStartLeft)) dragObj.elStartLeft = 0;
    if (isNaN(dragObj.elStartTop)) dragObj.elStartTop = 0;


    dragObj.elNode.style.zIndex = ++dragObj.zIndex;

    // Capture mousemove and mouseup events on the page.

        document.addEventListener("mousemove", dragGo, true);
        document.addEventListener("mouseup", dragStop, true);
        event.preventDefault();

}

function dragGo(event) {

    var x, y;

    // Get cursor position with respect to the page.

    x = window.event.clientX + document.documentElement.scrollLeft
      + document.body.scrollLeft;
    y = window.event.clientY + document.documentElement.scrollTop
      + document.body.scrollTop;
    

    dragObj.elNode.style.left = (dragObj.elStartLeft + x - dragObj.cursorStartX) + "px";
    dragObj.elNode.style.top = (dragObj.elStartTop + y - dragObj.cursorStartY) + "px";

    event.preventDefault();
}

function dragStop(event) {

         document.removeEventListener("mousemove", dragGo, true);
        document.removeEventListener("mouseup", dragStop, true);
    
}

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
function swapDiv(divID, imgID) {

    if (document.getElementById(imgID).src.search("PointUpSmall") != -1) {
        document.getElementById(divID).style.display = "none";
        document.getElementById(imgID).src = "../Images/PointDownSmall.bmp";
    }
    else {
        document.getElementById(divID).style.display = "block";
        document.getElementById(imgID).src = "../Images/PointUpSmall.bmp";
    }
}

function loadDivTip(event, head, txt) {
    var ct, cl, ww, wh, dw, dh;

    //populate the div to ensure we get sizes
    document.getElementById('divTipHead').innerHTML = head;
    document.getElementById('divTipDetl').innerHTML = txt;
    document.getElementById('divTip').style.display = "";

    //get fixed posn of calling cell in the visible window
    cl = window.event.clientX; //+ document.documentElement.scrollLeft + document.body.scrollLeft;
    ct = window.event.clientY; //+ document.documentElement.scrollTop  + document.body.scrollTop;
    //get browser window limits
    ww = document.documentElement.offsetWidth;
    wh = document.documentElement.offsetHeight;
    //get div dimensions
    dw = document.getElementById('divTip').clientWidth;
    dh = document.getElementById('divTip').clientHeight;

    if (dw <= (ww - cl - 10) && dh <= (wh - ct + 10)) { //fits naturally - place to the right & up
        document.getElementById('divTip').style.left = cl + 10 + document.documentElement.scrollLeft;
        document.getElementById('divTip').style.top = ct - 10 + document.documentElement.scrollTop;
    }
    else
        if (dw <= (ww - cl - 10)) { //fits width only - place it up from bottom & to the right
            document.getElementById('divTip').style.left = cl + 10 + document.documentElement.scrollLeft;
            document.getElementById('divTip').style.top = wh - 10 - dh + document.documentElement.scrollTop;
        }
        else
            if (dh <= (wh - ct - 10)) { //fits depth only - place it below & in from the right
                document.getElementById('divTip').style.left = ww - dw - 10 + document.documentElement.scrollLeft;
                document.getElementById('divTip').style.top = ct + 10 + document.documentElement.scrollTop;
            }
            else { // doesnt fit around the cell - try up and left
                document.getElementById('divTip').style.left = cl - dw - 10 + document.documentElement.scrollLeft;
                document.getElementById('divTip').style.top = ct - dh - 10 + document.documentElement.scrollTop;
            }
    if (document.getElementById('divTip').style.left.charAt(0) == '-') {
        document.getElementById('divTip').style.left = 0
    }
    if (document.getElementById('divTip').style.top.charAt(0) == '-') {
        document.getElementById('divTip').style.top = 0
    }
}
function hideDivTip() {
    document.getElementById('divTip').style.display = "none";
}

function SelectAll(id) {
    var frm = document.forms[0];
    for (i = 0; i < frm.elements.length; i++) {
        if (frm.elements[i].type == "checkbox") {
            frm.elements[i].checked = document.getElementById(id).checked;
        }
    }
}

/*
 Global objects to hold movePanel information.

var movePanelObj = new Object();
var movePanelAtts = new Object();
movePanelObj.zIndex = 0;

function movePanelStart(event, id, inputId) {

    var el;
    var x, y;

    movePanelAtts = document.getElementById(inputId);

    // If an element id was given, find it. Otherwise use the element being
    // clicked on.

    if (id)
        movePanelObj.elNode = document.getElementById(id);
    else {
        if (browser.isIE)
            movePanelObj.elNode = window.event.srcElement;
        if (browser.isNS)
            movePanelObj.elNode = event.target;

        // If this is a text node, use its parent element.

        if (movePanelObj.elNode.nodeType == 3)
            movePanelObj.elNode = movePanelObj.elNode.parentNode;
    }

    // Get cursor position with respect to the page.

    if (browser.isIE) {
        x = window.event.clientX + document.documentElement.scrollLeft
      + document.body.scrollLeft;
        y = window.event.clientY + document.documentElement.scrollTop
      + document.body.scrollTop;
    }
    if (browser.isNS) {
        x = event.clientX + window.scrollX;
        y = event.clientY + window.scrollY;
    }

    // Save starting positions of cursor and element.

    movePanelObj.cursorStartX = x;
    movePanelObj.cursorStartY = y;
    movePanelObj.elStartLeft = parseInt(movePanelObj.elNode.style.left, 10);
    movePanelObj.elStartTop = parseInt(movePanelObj.elNode.style.top, 10);

    if (isNaN(movePanelObj.elStartLeft)) movePanelObj.elStartLeft = 0;
    if (isNaN(movePanelObj.elStartTop)) movePanelObj.elStartTop = 0;


    movePanelObj.elNode.style.zIndex = ++movePanelObj.zIndex;

    // Capture mousemove and mouseup events on the page.

    if (browser.isIE) {
        document.attachEvent("onmousemove", movePanelGo);
        document.attachEvent("onmouseup", movePanelStop);
        window.event.cancelBubble = true;
        window.event.returnValue = false;
    }
    if (browser.isNS) {
        document.addEventListener("mousemove", movePanelGo, true);
        document.addEventListener("mouseup", movePanelStop, true);
        event.preventDefault();
    }
}

function movePanelGo(event) {

    var x, y;

    // Get cursor position with respect to the page.

    if (browser.isIE) {
        x = window.event.clientX + document.documentElement.scrollLeft
      + document.body.scrollLeft;
        y = window.event.clientY + document.documentElement.scrollTop
      + document.body.scrollTop;
    }
    if (browser.isNS) {
        x = event.clientX + window.scrollX;
        y = event.clientY + window.scrollY;
    }

    // Move movePanel element by the same amount the cursor has moved.

    movePanelObj.elNode.style.left = (movePanelObj.elStartLeft + x - movePanelObj.cursorStartX) + "px";
    movePanelObj.elNode.style.top = (movePanelObj.elStartTop + y - movePanelObj.cursorStartY) + "px";

    //store the location for retention
    movePanelAtts.value = movePanelObj.elNode.style.left + movePanelObj.elNode.style.top;

    if (browser.isIE) {
        window.event.cancelBubble = true;
        window.event.returnValue = false;
    }
    if (browser.isNS)
        event.preventDefault();
}

function movePanelStop(event) {

    // Stop capturing mousemove and mouseup events.

    if (browser.isIE) {
        document.detachEvent("onmousemove", movePanelGo);
        document.detachEvent("onmouseup", movePanelStop);
    }
    if (browser.isNS) {
        document.removeEventListener("mousemove", movePanelGo, true);
        document.removeEventListener("mouseup", movePanelStop, true);
    }
}
*/