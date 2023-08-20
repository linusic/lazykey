// ==UserScript==
// @name         Extract CP
// @namespace    http://tampermonkey.net/
// @version      0.1
// @description  none
// @author       __
// @match        *://*/*
// @icon         data:image/gif;base64,R0lGODlhAQABAAAAACH5BAEKAAEALAAAAAABAAEAAAICTAEAOw==
// @grant        none
// ==/UserScript==

function get_current_element(event){
    var x = event.clientX, y = event.clientY,
        dom = document.elementFromPoint(x, y);
    return dom
}

function copyToClip(content) {
    var clipboard = navigator.clipboard
    clipboard.writeText(content);
}

(function() {
    var last_element = null
    var toggle_highlight = false; 
    function highlight(element){
        element.style.outline = '#0000FF solid 3px'
    }
    function remove_hightlight(element){
        element.style.removeProperty('outline')
    }

    var g_dom;
    function track_mouse(event){
        g_dom = get_current_element(event)
        if (g_dom === last_element) {
            return
        }
        if (last_element != null) {
            remove_hightlight(last_element)
        }

        if (toggle_highlight){
            highlight(g_dom);
        }else{
            remove_hightlight(last_element)
        }
        last_element = g_dom
    }

    document.onkeydown = function(event){
        var event = event || window.event;
        
        var is_win_key = event.metaKey 
        
        var is_alt_key = event.altKey 
        var is_shift_key = event.shiftKey 

        
        var user_press_keycode = event.keyCode; 
        if (user_press_keycode == 20){ 
            toggle_highlight = !toggle_highlight;
            if (toggle_highlight) {
                window.onmousemove = track_mouse;
            }else{
                window.onmousemove = null;
                remove_hightlight(last_element);
            }
        }
        else if ( user_press_keycode == 46 ) {  
            if (toggle_highlight) {
                g_dom.remove()
            }
        }

        else if (
            ( is_alt_key && is_shift_key && user_press_keycode == "c".toUpperCase().charCodeAt() ) || (is_win_key && user_press_keycode == "c".toUpperCase().charCodeAt() )
        )
        {
            copyToClip(g_dom.textContent)
        }
        else if(
            ( is_alt_key && is_shift_key && user_press_keycode == "x".toUpperCase().charCodeAt() ) || (is_win_key && user_press_keycode == "x".toUpperCase().charCodeAt() )
        )
        {
            var result = "";
            if (g_dom.id){
                result = `id="${g_dom.id}"`;
            }else if(g_dom.className){
                result = `class="${g_dom.className}"`;
            }else if(g_dom.style){
                result = `style="${g_dom.style}"`;
            }else{
                var len = g_dom.attributes.length;
                var keys = "";
                var values = "";
                for(var i=0;i<len;i++){
                    let it = g_dom.attributes[i];
                    keys += it.localName + "\n"; 
                    values += it.value + "\n"; 
                }
                result = keys + "\n" + values;
            }
            copyToClip(result);
        }
    }
})();
