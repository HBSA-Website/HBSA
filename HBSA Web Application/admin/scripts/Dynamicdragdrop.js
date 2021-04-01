/*jslint white: true, browser: true, undef: true, nomen: true, eqeqeq: true, plusplus: false, bitwise: true, regexp: true, strict: true, newcap: true, immed: true, maxerr: 14 */
/*global window: false, REDIPS: true */

// define redips_init variable
var redips_init;

// redips initialization
redips_init = function () {
    // reference to the REDIPS.drag
    var rd = REDIPS.drag;
    // initialization
    rd.init();
    // set hover color
    rd.hover.color_td = '#9BB3DA';
    // single element per cell
    rd.drop_option = 'single';
    rd.clone_shiftKey = rd.clone_shiftKey_row = false;

    // Handle dropped event
    rd.myhandler_dropped = function () {
        var obj = rd.obj, 		// current element
			tac = rd.target_cell; // target cell

        var cmd = document.getElementById('dragAction');
        cmd.value = obj.innerText + '|' + tac.id;
        __doPostBack('upPage', '');
    };
};

// add onload event listener
if (window.addEventListener) {
	window.addEventListener('load', redips_init, false);
}
else if (window.attachEvent) {
	window.attachEvent('onload', redips_init);
}