;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;   AHK V2.0.0  ;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; _____________________________________________________________________
SCRIPT_ROOT_PATH := A_SCRIPTDIR "\"
USER_PATH := "C:\Users\" A_UserName "\"

PYTHON_PATH := "D:\python311\python.exe"
SUBL_PATH := "D:\ide\Sublime\sublime_text.exe"

CLIP_ROOT_DIR := "E:\app\clipboard"

APP_CONFIG_PATH := SCRIPT_ROOT_PATH "config\application.cfg"  ; #h
APP_BACKGROUND_IMAGE_APP := SCRIPT_ROOT_PATH "image\bg.png"
APP_BACKGROUND_IMAGE_FOLDER := SCRIPT_ROOT_PATH "image\bg.png"


;;; Internet Options Hidtory (Win+R and ... Explorer History)
; RunDll32.exe InetCpl.cpl,ClearMyTracksByProcess 1
;;; hiberfil.sys    => sleep
; powercfg -h off
; _____________________________________________________________________

; _____________________________________________________________________ Browser (Vimmum Tab)
CHROME_PATH := "C:\Program Files\Google\Chrome\Application\chrome.exe"
EDGE_PATH := "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
chrome_cmd         := CHROME_PATH " chrome-extension://dbepggeogbaibhgnhhndojpepiihcmeb/pages/completion_engines.html"
chrome_cmd_private := CHROME_PATH  " --incognito"
edge_cmd         := EDGE_PATH " chrome-extension://dbepggeogbaibhgnhhndojpepiihcmeb/pages/blank.html"
edge_cmd_private := EDGE_PATH  " --inprivate"
; ______________
browser_new_tab(){ ; for +t and mouse gesture (MButton)
    if WinActive("ahk_exe chrome.exe ahk_class Chrome_WidgetWin_1")
        Run(chrome_cmd)
    else if WinActive("ahk_exe msedge.exe ahk_class Chrome_WidgetWin_1")
        Run(edge_cmd)
    else ; subl / vsc / ...
        Send("^n")
}
<+t::browser_new_tab

; _____________________________________________________________________ Toggle Window Global Dict
TOGGLE_APP_DICT := Map()
; _____________________________________________________________________

; SetTitleMatchMode 2   ; (default) windows just need contains <WinTitle>
SendMode "Input"
#Hotstring EndChars `t
SetWinDelay -1   

; CoordMode "Caret", "Window"
; ; if for test , maybe change it to "Window"
; CoordMode "Tooltip", "screen"


; 125%  1920x1080
stable_dpi := 96
current_dpi := A_ScreenDPI
screen_scale := current_dpi / stable_dpi
screen_width := A_ScreenWidth / screen_scale
screen_height := A_Screenheight / screen_scale
; _____________________________________________________________________ Python & Subl
choose_python(path){
    return FileExist(path) ? path " " : "python "
}
python := choose_python(PYTHON_PATH)
python_c := python " -c "
subl := SUBL_PATH " "


<!q::
{
    callback := () => Run(SUBL_PATH)
    toggle_window_vis("ahk_class PX_WINDOW_CLASS", callback)
}
>!q::Run(SUBL_PATH)
<^<!q::subl_in_explorer()  ; <!+q not work in ST4 (Safe Mode)
subl_in_explorer(){
    path := explorer_path()
    if not path
        return  ; ; (!path) ? Run(subl) : Run(subl Format('"{1}\tempFile"', path))
    Run(subl Format('"{1}\tempFile"', path)) ; InputBox? No! Commadn Palette => rename in ST
}
; _____________________________________________________________________ Browser & Explorer => URL
>!F5::Reload

>!u:: ; cover <!
>!i:: ; cover <!
>!o:: ; cover <!
>!g::goto_path()
>!c::cp_path()

goto_path()
{
    if WinActive("ahk_exe chrome.exe"){
        Send("{F6}")
        return True
    }else if WinActive("ahk_exe msedge.exe") or WinActive("ahk_exe explorer.exe"){
        Send("{F4}")
        return True
    }else{ ; future ...
        return False
    }
}
cp_path(is_return := 0)
{
    if !goto_path()
        return

    if is_return
        A_Clipboard := ""

    Send("^a")
    Send("^c")
    Send("{ESC 2}")   ; twice for Explorer and Edge

    if is_return
        ClipWait(1)
        return A_Clipboard
}

::fanote::{#}:~:text=    ;  {#} to escape char `#`
; _____________________________________________________________________ remap -> numbers
; Capslock & h::Send "0" ;
; Capslock & j::Send "1"
; Capslock & k::Send "2"
; Capslock & l::Send "3" ;
; Capslock & u::Send "4"
; Capslock & i::Send "5"
; Capslock & o::Send "6"
; Capslock & p::Send "6"
; Capslock & 8::Send "7" ;
; Capslock & 9::Send "8"
; Capslock & 0::Send "9"
; Capslock & m::Send "0" ;
; Capslock & n::Send "0"
; Capslock & Space::Space
; _____________________________________________________________________ 🖥️For Switch Screen (effect below all RAlt)
win_prev(){
    Send "!{ESC}"   ; ←
    try WinActivate("A")
}

win_next(){
    Send "!+{ESC}"  ; →
    try WinActivate("A")
}


>!j::Send("^+{TAB}")
>!k::Send("^{TAB}")

>!+j::
<!WheelUp::win_prev()
>!+k::
<!WheelDown::win_next()

>!l::Send("^g")

;;; jump and re-jump
<!+s::Send "{F12}"  ; F12 is vsc

; _____________________________________________________________________ 💻Terminal
; RUN "wt.exe -F -w _quake pwsh.exe -nologo -window hided"

; edit ahk config by subl
^!.::Run subl SCRIPT_ROOT_PATH "mykey.ahk"

; Suspend
#SuspendExempt
+F4::Suspend  ; Ctrl+Alt+S
#SuspendExempt False

; _____________________________________________________________________ 🧲🧲🧲 ChatGPT
<!CapsLock::
{
    callback := () => Run(python SCRIPT_ROOT_PATH "app\gemini\main.py",, "hide")
    toggle_window_vis("Gemini ahk_class TkTopLevel", callback)
}

; _____________________________________________________________________ 🧲🧲🧲 New Translator
>!CapsLock::
{
    callback := () => Run(python SCRIPT_ROOT_PATH "app\translator\main.py",, "hide")
    toggle_window_vis("Translator ahk_class TkTopLevel", callback)
}

; _____________________________________________________________________ 🧲🧲🧲 M3U8 Downloader GUI
!z::
{
    callback := () => Run(python SCRIPT_ROOT_PATH "app\m3u8_gui\main.py",, "hide")
    toggle_window_vis("M3U8 ahk_class TkTopLevel", callback)
}

; _____________________________________________________________________ 🧲🧲🧲 M3U8 Downloader
+F1::
{
    IB := InputBox("🧲🧲🧲🧲🧲🧲M3U8 PATH", "🧲M3U8 PATH", "w900 h150")
    if IB.Result != "Cancel" {
        CMD := python SCRIPT_ROOT_PATH "tool/m3u8.py am " IB.Value
        RunWait CMD
    }
}
; _____________________________________________________________________ 🧲🧲🧲 Send Input
~^+f::
{
    if not explorer_active()
        return
    IB := InputBox("🧲🧲🧲🧲🧲🧲Input", "🧲Send Input", "w900 h150")
    if IB.Result != "Cancel" {
        Send IB.Value
    }
}

; _____________________________________________________________________ 🧲🧲🧲 Send Key
+F3::
{
    IB := InputBox("🧲🧲🧲🧲🧲🧲Input", "🧲Send Input", "w900 h150")
    if IB.Result != "Cancel" {
        Send IB.Value
    }
}

; _____________________________________________________________________ 🧲🧲🧲 OCR
>!\::
{
    Run "D:\miniconda\envs\clipocr\python.exe " SCRIPT_ROOT_PATH "app\clipocr\main.py",, "hide"
}

; _____________________________________________________________________ 🧲🧲🧲 WIFI
:X:fawifiname::{
    A_Clipboard := ""
    Run(python SCRIPT_ROOT_PATH "tool\wifi.py name",, "Hide")
    ClipWait(2)
    Send("^v")
}
:X:fawifipwd::{
    A_Clipboard := ""
    Run(python SCRIPT_ROOT_PATH "tool\wifi.py pwd",, "Hide")
    ClipWait(2)
    Send("^v")
}
; _____________________________________________________________________ 🧲🧲🧲 Bulk Rename Syntax
+F2::copy_filenames_open_editor()
!F2::Run python SCRIPT_ROOT_PATH "app\rename\bulk_rename.py",, "hide"
#b::Run subl USER_PATH ".rename.log"

white_space := "`n`r`t "  ; include " "
strip(s){
    return Trim(s, white_space)
}
lstrip(s){
    return LTrim(s, white_space)
}
rtrip(s){
    return RTrim(s, white_space)
}
startswith(string, prefix) {
    return SubStr(string, 1, StrLen(prefix)) = prefix
}
endswith(string, suffix) {
    string_len := StrLen(string)
    suffix_len := StrLen(suffix)
    return SubStr(string, string_len - suffix_len + 1, suffix_len) = suffix
}
copy_filenames_open_editor(){
    if not explorer_active()
        return
    A_Clipboard := ""
    SendInput "^+c"
    ClipWait(3)
    Run python SCRIPT_ROOT_PATH "app\rename\open_editor.py",, "hide"
}
explorer_active(){
    hwnd := WinActive("ahk_class CabinetWClass") ; Address: E:\app
    return hwnd
}
explorer_path() {
    if !__hwnd := explorer_active()
        return
    for win in ComObject('Shell.Application').Windows
        try if win && win.hwnd && win.hwnd = __hwnd
            return win.Document.Folder.Self.Path
}


latest_is_image_type := False
latest_image_path := ""
^+v::
{
    if !path := explorer_path()
        return

    if !latest_is_image_type and !strip(A_Clipboard)
        return
    
    if latest_is_image_type and latest_image_path {
        try FileCopy(latest_image_path, path, 0) ; not overwrite,  not change
    } else {
        __file_path := path "\" FormatTime(A_Now, "yyyyMMdd_HHmmss") ".txt"
        if FileExist(__file_path)
            FileDelete(__file_path)
        FileAppend(A_Clipboard, __file_path, "UTF-8")  
    }
    Send("{F5}")
}
; Command Palette for Chrome + Edge
; #HotIf WinActive("ahk_exe chrome.exe") ; Enbale "Quick Commands" => chrome://flags/
; ^+p::Send "^{space}"
; #HotIf
; #HotIf WinActive("ahk_exe msedge.exe")
; ^+p::Send "^q"
; #HotIf


menu_chain(hot_key, interval := 30){
    Send "{RBUTTON}"
    sleep interval
    Send hot_key "{ENTER}"
}
; for browser cache: (chrome + edge)



select_func_for_xbutton2(){ ; XButton2, +z APPSKEY
    switch {
        case WinActive("ahk_exe chrome.exe ahk_class Chrome_WidgetWin_1"): menu_chain("{UP 4}")
        case WinActive("ahk_exe msedge.exe ahk_class Chrome_WidgetWin_1"): menu_chain("{UP 6}")
        case WinActive("ahk_exe sublime_text.exe"): open_folder('explorer.exe /select,', use_file:=true)
        default: return
    }  
}

APPSKEY::
+z::select_func_for_xbutton2 

INSERT::
{
    switch {
        case WinActive("ahk_exe chrome.exe ahk_class Chrome_WidgetWin_1"): copy_url_key := "{UP 2}"
        case WinActive("ahk_exe msedge.exe ahk_class Chrome_WidgetWin_1"): copy_url_key := "{UP 4}"
        default: return Send("{INSERT}")
    }

    A_Clipboard := ""
    menu_chain(copy_url_key)
    ClipWait(0.1)
    if A_Clipboard {
        cache_search_prefix := "https://webcache.googleusercontent.com/search?q=cache:"
        cache_open_tab_cmd := Format("{1} {2}{3}", chrome_cmd_private,cache_search_prefix,A_Clipboard)
        Run(cache_open_tab_cmd)
    }
}

; _____________________________________________________________________ Block All Menu for RALT
; ~RAlt::Send("^{SPACE}")
; >!space::Send("{SPACE 3}") ; avoid block space
>!space::Send "^{space}"

; ~RAlt::Send "^{space}"       ; 🛑IME need open (Ctrl and Ctrl+Space) 💧 drop 4keys: #
*#space::Send "{Ctrl}"     ; BLOCK => IME => ... + win + space

<!space::Send "{ENTER}"
; <^space::Send "{ENTER}"    ;  TODO chrome

; _____________________________________________________________________  HotKey ReMap
^-::Send "^{WheelDown}"
^=::Send "^{WheelUp}"
; mouse wheel
<+n::Send "{WheelDown}"
<+p::Send "{WheelUp}"


>!`;::Send "+{enter}"
<!`;::Send "^{enter}"
; [delete]
<!o::Send "{backspace}"
<!,::Send "^v"
<!j::Send "{left}"
<!k::Send "{right}"
<!n::Send "{down}"  ; .........
<!p::Send "{up}"
<!b::Send "^{left}"
<!f::Send "^{right}"
<!h::Send "{home}"
<!l::Send "{end}"
<!+j::Send "+{left}"
<!+k::Send "+{right}"
<!+n::Send "+{down}"
<!+p::Send "+{up}"
<!+h::Send "+{home}"
<!+l::Send "+{end}"
<!+b::Send "^+{left}"
<!+f::Send "^+{right}"

; [Remap]
<+u::Send "+["
<+i::Send "+]"
<+j::Send "["
<+k::Send "]"
<+f::Send "+'"
<+s::Send "&"
<+d::Send "'"
<+a::Send "+\"
<+c::Send "=+."
<+v::Send "-+."
<+b::Send "\"
<+g::Send "-"
<+m::Send "+-"
<+l::Send "="
<+h::Send "+="
<+w::Send "*"

; [Screen In WindowOS]
^<+space::Send "{F11}"
^<!j::Send "^#{left}"
^<!k::Send "^#{right}"

<+o::Send "^!{tab}"

; _____________________________________________________________________ 🖱️ Replace Mouse
;;; 2:   =>(0,100) =>  (fast, lowest)
;;; "R"  => Relative

; distance := 50
; CapsLock & j::MouseMove(-distance , 0   , 0 , "R") ; ←
; CapsLock & k::MouseMove(distance  , 0   , 0 , "R") ; →
; CapsLock & p::MouseMove(0   , -distance , 0 , "R") ; ↑
; CapsLock & n::MouseMove(0   , distance  , 0 , "R") ; ↓

; ;;; Combinations of three
; #HotIf GetKeyState("Shift", "P")  ;
; CapsLock & j::MouseMove(-distance/3 , 0   , 0 , "R") ; ←
; CapsLock & k::MouseMove(distance/3  , 0   , 0 , "R") ; →
; CapsLock & p::MouseMove(0   , -distance/3 , 0 , "R") ; ↑
; CapsLock & n::MouseMove(0   , distance/3  , 0 , "R") ; ↓
; #HotIf

; CapsLock & h::MouseMove(99999  , 0      , 0 , "R")  ; ←
; CapsLock & l::MouseMove(-99999 , 0      , 0 , "R")  ; →
; CapsLock & b::MouseMove(0      , -99999 , 0 , "R")  ; ↓
; CapsLock & o::MouseMove(0      , 99999  , 0 , "R")  ; ↑
; CapsLock & i::MouseMove(0      , 99999  , 0 , "R")  ; ↑

CapsLock & d::Click
CapsLock & f::Click
CapsLock & g::Click "Right"
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
CapsLock & e::SendEvent "{Click Down}"
CapsLock & r::SendEvent "{Click Up}"
; _____________________________________________________________________ 🛑Terminal Only For [Bash Core] ;;;;; (the Condition must be fully)
#HotIf WinActive("ahk_exe WindowsTerminal.exe") and WinActive("@")
!i::Send "{ESC}{backspace}"
#HotIf
; _____________________________________________________________________ 🛑Terminal Only For [CMD Core] ;;;;;; (the Condition must be fully)
#HotIf WinActive("ahk_exe WindowsTerminal.exe") and not WinActive("@")
; [delete to head]
;^u::Send "{ESC}"
^u::Send "^{Home}"
; [delete to tail]
^k::Send "^{END}"
<!i::Send "^{backspace}"
#HotIf
; _____________________________________________________________________ Windows APP (Not Contain Windows Terminal)
#HotIf not WinActive("ahk_exe WindowsTerminal.exe")
; [Undo]
<!i::Send "^{backspace}"
<!u::Send "^z"
<!+u::Send "^+z"
^u::Send "+{home}{backspace}"
^k::Send "+{end}{backspace}"
; [Copy & Paste]
<!x::Send "^x"
<!c::Send "^c"
<!v::Send "^v"
LALT & 9::Send "{XButton1}"
LALT & 0::Send "{XButton2}"
<![::Send "{PgUp}"
<!]::Send "{PgDn}"
^<!n::Send "^{end}"
^<!p::Send "^{home}"
; [Select]
>!a::Send "^+{home}"
>!e::Send "^+{end}"
; [Screen In WindowOS]
<!d::Send "^{left}^+{right}^c"
!m::Send "{esc}"
<!/::Send "^f"

LAlt & RAlt::Send "{enter}"
RAlt & LAlt::Send "{enter}"
#HotIf

;  _____________________________________________________________________ Toggle WinOS Proxy
>!+1::set_proxy_port()
set_proxy_port()
{    
    IB := InputBox("✈ INPUT LOCAL PROXY PORT", "Proxy Port", "w300 h100")
    if IB.Result = "Cancel" and IB.Value = ""
        return 

    A_Clipboard := ""
    Run python SCRIPT_ROOT_PATH "hotstr\proxy.py 127.0.0.1:" IB.Value,, "hide"
    ClipWait(2)
    Msgbox(A_Clipboard)
}

; _____________________________________________________________________ Toggle WIFI
>!DELETE::
{
    wifi_name := "‏‏‎ ‎"
    If not has_internet()
        RUN "netsh wlan connect name=" wifi_name,, "HIDE"
    else
        RUN "netsh wlan disconnect",, "HIDE"

    TrayTip "🌏 WIFI TOGGLED", "",16 + 32
    Sleep 1000
    TrayTip
}
has_internet(flag:=0x40) {
    Return DllCall("Wininet.dll\InternetGetConnectedState", "Str", flag,"Int",0)
}

open_folder(condition_cmd, use_file:=true)
{
    path := WinGetTitle("A")
    ; by title
    if RegExMatch(path, "\*?\K(.*)\\[^\\]+(?= [-*] )", &path)
    {
        if ( FileExist(path[0]) ){
            use_path := use_file? path[0] : path[1]
            RUN Format('{1}{2}', condition_cmd, use_path) ; path[0] abs path ;     /select,"<file_abs_path>"   => select
        }
        ; else
            ; Run Format('explorer.exe "{1}"', path[1]) ; path[1] <abs_path>
    }
}

; _____________________________________________________________________ for cmd alias
alias_dos_keys := (
    ; only for CMD
    '& doskey cd = cd /D $* '

    '& doskey jc = cd /D C:/ '
    '& doskey jd = cd /D D:/ '
    '& doskey je = cd /D E:/ '
    '& doskey ~  = cd /D %USERPROFILE% '

    '& doskey e = explorer.exe $* '
    '& doskey t = taskmgr '
    '& doskey c = clip.exe '
    '& doskey con = "cmd.exe "/K" D:/miniconda/Scripts/activate.bat D:/miniconda" '
    '& doskey clear = for /L %i in (1,1,100) do @echo. && echo. '
)

; _____________________________________________________________________ for ^+e
choice_for_open_cmd(path, open_mode)
{
    ; NOTE: Tail Space
    ; cmd:
        ; & : meantime
        ; &&: break

    ; cmd_base := 'cmd.exe /K {1}: && cd "{2}" ' alias_dos_keys
    ; /D (also skip driver)
    ; cmd_base := 'cmd.exe /K cd /D {1} ' alias_dos_keys
    cmd_base := 'cmd.exe /K cd /D {1} '

    ;  "echo.    => rep: \n
    cmd  := cmd_base " && for /L %i in (1,1,100) do @echo. && echo. "
    pwsh := cmd_base " && pwsh /nologo"
    wsl  := cmd_base " && wsl"

    if( !DirExist(path) )
        path := "D:/"

    if(open_mode == 0)   ; cmd
        command := Format(cmd, path) ; abs path
    else if(open_mode == 1)   ; pwsh
        command := Format(pwsh, path) ; abs path
    else if(open_mode == 2)   ; wsl
        command := Format(wsl, path) ; abs path

    RUN "wt.exe " command
}

open_cmd(open_mode:=0)
{
    ; by title
    path_obj := WinGetTitle("A")
    ; path_obj[0]: file,
    ; path_obj[1]: dir
    if RegExMatch(path_obj, "\*?\K(.*)\\[^\\]+(?= [-*] )", &path_obj)
    {
        path := path_obj[1]
        if path == A_SCRIPTDIR
            path := "D:/"

        choice_for_open_cmd(path, open_mode)
    }
    else
    {
        if !path := explorer_path()
            path := "D:/" 
        choice_for_open_cmd(path, open_mode)
    }
}

; _____________________________________________________________________ WinAPP
#a::Run "appwiz.cpl"  ; ; App Remove
; #b::Run "::{645ff040-5081-101b-9f08-00aa002f954e}"  ; bin
#i::Run "::{7007acc7-3202-11d1-aad2-00805fc1270e}"  ; ncpa.cpl
#n::Run "Notepad.exe"
#p::RUN "wt.exe powershell.exe " python             ; python console

; edit the select
<+r::
{
    A_Clipboard := ""
    Send "^c"
    ClipWait(2)
    RUN(subl A_Clipboard)
}
<+e::
{
    A_Clipboard := ""
    Send "^c"
    ClipWait(2)

    ; if use explorer (must \ instead of /)
    s := strip(A_Clipboard)
    if startswith(s, "www")
        s := "https://" s
    smart_path := StrReplace(s, "/", "\")
    RUN(Format('explorer "{1}"', smart_path))
}

; _____________________________________________________________________ SHOW/HIDE DESKTOP ICON
control_toggle_visible(control_title, win_title)
{
    ControlGetVisible(control_title, win_title)
    ? ControlHide(control_title, win_title)
    : ControlShow(control_title, win_title)
}

; bind & on system
<+q::toggle_desktop
toggle_desktop()
{
    try{
        control_toggle_visible("SysListView321", "Program Manager")
    } catch {
        control_toggle_visible("SysListView321", "ahk_class WorkerW")
    }
}
toggle_desktop()

; _____________________________________________________________________ 🧱Replace WGestures
; Mouse Gestures
RButton::
{
    allow_distance := 15  ; gt => act
    mousegetpos &x1, &y1
    Keywait "RButton"
    mousegetpos &x2, &y2

    switch {
        ; ←
        case (x1-x2 > allow_distance) and (abs(y1-y2) < x1-x2): send("^#{Left}")
        ; →
        case (x2-x1 > allow_distance) and (abs(y1-y2) < x2-x1): send("^#{Right}")
        ; ↑
        case (abs(x1-x2) < y1-y2) and (y1-y2 > allow_distance): send("{F11}")
        ; ↓
        case (abs(x1-x2) < y2-y1) and (y2-y1 > allow_distance): send("#d")
        ; raw
        default: send("{RButton}")
    }
}

XButton2:: ; ↑
{
    allow_distance := 15
    mousegetpos &x1, &y1
    Keywait "XButton2"
    mousegetpos &x2, &y2

    switch {
        ; ←
        case (x1-x2 > allow_distance) and (abs(y1-y2) < x1-x2): GUI_APP.Show("AutoSize Maximize")
        ; →
        case (x2-x1 > allow_distance) and (abs(y1-y2) < x2-x1): GUI_FD.Show("AutoSize Maximize")
        ; ↓
        case (abs(x1-x2) < y2-y1) and (y2-y1 > allow_distance): Send("#v")
        ; ↑
        case (abs(x1-x2) < y1-y2) and (y1-y2 > allow_distance): select_func_for_xbutton2()
        ; raw
        default: send("{XButton2}")
    }
}

XButton1:: ; ↓
{
    allow_distance := 50
    mousegetpos &x1, &y1
    Keywait "XButton1"
    mousegetpos &x2, &y2

    switch {
        ; → ↓ or ↘
        case (x2-x1 > allow_distance*2) and (y2-y1 > allow_distance): send("^{END}")
        ; → ↑ or ↗
        case (x2-x1 > allow_distance*2) and (y1-y2 > allow_distance): send("^{HOME}")
        ; ←
        case (x1-x2 > allow_distance) and (abs(y1-y2) < x1-x2): win_prev()
        ; →
        case (x2-x1 > allow_distance) and (abs(y1-y2) < x2-x1): win_next()
        ; ↓ (PWSH)
        case (abs(x1-x2) < y2-y1) and (y2-y1 > allow_distance): open_cmd(open_mode:=1)
        ; ↑
        case (abs(x1-x2) < y1-y2) and (y1-y2 > allow_distance): send("^!{tab}")
        ; raw
        default: send("{XButton1}")
    }
}

MButton:: ; ↓
{
    allow_distance := 15
    mousegetpos &x1, &y1
    Keywait "MButton"
    mousegetpos &x2, &y2

    switch {
        ; ↓ → or ↘
        case (x2-x1 > allow_distance * 8) and (y2-y1 > allow_distance * 3): return ; safe (cancel) for ^w
        ; ↓ ← or ↙
        case (x1-x2 > allow_distance * 8) and (y2-y1 > allow_distance * 3): return
        ; ↑ → or ↗
        case (x2-x1 > allow_distance * 8) and (y1-y2 > allow_distance * 3): return
        ; ↑ ← or ↖
        case (x1-x2 > allow_distance * 8) and (y1-y2 > allow_distance * 3): return
        ; ←
        case (x1-x2 > allow_distance) and (abs(y1-y2) < x1-x2): send("^+{TAB}")
        ; →
        case (x2-x1 > allow_distance) and (abs(y1-y2) < x2-x1): send("^{TAB}")
        ; ↓
        case (abs(x1-x2) < y2-y1) and (y2-y1 > allow_distance * 3): Send("^w")
        ; ↑
        case (abs(x1-x2) < y1-y2) and (y1-y2 > allow_distance): browser_new_tab()
        ; raw
        default: Send("^{LBUTTON}")
    }
}

; _____________________________________________________________________ 🧱Hot String For Python
f(file_name,callback_send:="",encoding:="UTF-8")
{
    ClipData := FileRead(file_name, encoding)
    A_Clipboard :=
    A_Clipboard := ClipData
    ClipWait(2)
    Send "^v"

    if callback_send{
        sleep 100
        Send callback_send
    }
}


; _____________________________________________________________________ 🧱Live Template
:X:fahelp::f(SCRIPT_ROOT_PATH "hotstr\help.txt")
:X:fagen::f(SCRIPT_ROOT_PATH "gen_vbs.py")
:X:favbs::f(SCRIPT_ROOT_PATH "gen_vbs.py")

:*x:fdHo::RUN(subl "C:\Windows\System32\drivers\etc\hosts")
:*x:fdPo::RUN(subl Format("C:\Users\{1}\Documents\PowerShell\Microsoft.PowerShell_profile.ps1", A_UserName))
:*x:fdSS::RUN(subl "E:\app\ssr\ss_conf_command\ssr.txt")

; for simple string
:*x:ipip::Run(python "-c `"import httpx, pyperclip as p;result = httpx.get('http://httpbin.org/get').json()['origin'];p.copy(result)`"",, "hide")

; fake data
:*x:fakeuser::fake_data("https://jsonplaceholder.typicode.com/users")       ; ...
:*x:fakepost::fake_data("https://jsonplaceholder.typicode.com/posts")       ; user_id / postid / title / body
:*x:fakealbum::fake_data("https://jsonplaceholder.typicode.com/albums")     ; album_id / postid /  title
:*x:faketodo::fake_data("https://jsonplaceholder.typicode.com/todos")       ; todo_id / postid /  title / completed
:*x:fakecomment::fake_data("https://jsonplaceholder.typicode.com/comments") ; comment_id / postid / email / comment_name / commment_body
:*x:fakephoto::fake_data("https://jsonplaceholder.typicode.com/photos")     ; album_id / postid / title / url / thumbnailUrl

fake_data(fake_data_url){
    A_Clipboard := ""
    ; Run python "-c `"import httpx, pyperclip as p;result = httpx.get('https://jsonplaceholder.typicode.com/users').text;p.copy(result)`"",, "hide"
    ; Run python "-c `"import urllib.request, pyperclip as p; result = urllib.request.urlopen('https://jsonplaceholder.typicode.com/users').read().decode('utf-8'); p.copy(result)`"",, "hide"
    raw_cmd := Format("import urllib.request, pyperclip as p; result = urllib.request.urlopen('{1}').read().decode('utf-8'); p.copy(result)",fake_data_url)
    cmd := Format(python_c '"{1}"',raw_cmd)
    Run cmd,, "hide"
}

::fado:: -i https://pypi.douban.com/simple  ;; DouBan repo for pip
::faqi:: -i https://pypi.tuna.tsinghua.edu.cn/simple ;; TsingHua repo for pip
::faspace::‏‏‎ ‎


;;;;;;;;;;;;;;;;;; ::fafp::print("f`{  = `}")
escape_send_hotstring(hot_string, right_char_count:=0){
    final_send_str := right_char_count
    ? hot_string Format("{HOME}{RIGHT {1}}", right_char_count)
    : hot_string
    SendInput(final_send_str)
}
:RX:fafp::escape_send_hotstring("print(f'{{}  =  {}}')", 9)
:RX:fapip::escape_send_hotstring("pip install -q -U ", 18)
:RX:fapipw::escape_send_hotstring("pip install -U    > nul", 16)
:RX:fapipe::escape_send_hotstring("pip install -U    > nul 2>&1", 16)

::faf::ffmpeg -f concat -safe 0 -i input.txt -c copy output.mp4 ; copy audio / video / ... all stream
::faff::ffmpeg -f concat -safe 0 -i input.txt -c:v copy -c:a copy output.mp4 ; m3u8 => mp4: file '<file_path>' ;  / instead of \ if not ''
::fafff::ffmpeg -f concat -safe 0 -i input.txt -c:v copy -c:a aac output.mp4
::faffft::ffmpeg -f concat -safe 0 -i input.txt -segment_time_metadata 1 -vf select=concatdec_select -af aselect=concatdec_select,aresample=async=1 output.mp4

; ffmpeg -f concat -safe 0 -i input.txt -c:v libx264 -c:a aac output.mp4

;;; audio is fast than video  <=> otherwise  1.5 => -1.5
; ffmpeg -i output.mp4 -itsoffset 1.5 -i output.mp4 -map 0:v -map 1:a -c:v copy -c:a aac output_synced.mp4
; ffmpeg -i 123.mp4 -ss 00:00:03 -t 00:00:02 -c:v copy -c:a copy output.mp4
; ffmpeg -loop 1 -i input.png -t 180 -vf "scale=trunc(iw/2)*2:trunc(ih/2)*2" -c:v libx264 -pix_fmt yuv420p output.mp4
; ffmpeg -i input.mp4 -vf "delogo=x=7:y=22:w=316:h=169:show=0, delogo=x=1591:y=871:w=318:h=169:show=0" -c:a copy ouput.mp4
; mp3 to mp4
; ffmpeg -loop 1 -i "<img_name>.png" -i "<in_name>.mp3" -c:v libx264 -c:a copy -strict experimental -shortest "<out_name>.mp4"

:X:faca::Send("https://webcache.googleusercontent.com/search?q=cache:")

:X:faip::Send("127.0.0.1")
:X:faipip::Send("https://127.0.0.1")

; for pwsh
:X:fauni::Send("uni_str.encode('unicode-escape').decode('utf-8')")
:X:fasort::Send("| & $HOME\scoop\shims\sort.exe -h")
:X:fasortr::Send("| & $HOME\scoop\shims\sort.exe -hr")
:X:fadu::Send(Format("du -h | {1} {2}", python, SCRIPT_ROOT_PATH "tool\sort.py"))
:X:fadur::Send("du -h | & $HOME\scoop\shims\sort.exe -hr")

:X:fati::send("00:00:00")
:X:fara::send("00:00:00-00:00:00")                                 
:X:fadt::send(FormatTime(A_Now, "yyyy-MM-dd"))                     



; for windows HARD PRESS
:*x:tata::Run("taskmgr")
:X:fajs::f(SCRIPT_ROOT_PATH "hotstr\js.py")                        ; tamper(js)
:X:fadebug::f(SCRIPT_ROOT_PATH "hotstr\debug.py")                  ; debug in webbrowser
:X:fapan::f(SCRIPT_ROOT_PATH "hotstr\pan.py")                      ; sense  (bdp)
:X:famain::f(SCRIPT_ROOT_PATH "hotstr\main.py")
:X:faclip::f(SCRIPT_ROOT_PATH "hotstr\clip.py")
:X:fatask::f(SCRIPT_ROOT_PATH "hotstr\taskfind.py")                ; if taskfind can findstr
:X:fadate::f(SCRIPT_ROOT_PATH "hotstr\date.py")                    ; date (Bash)
:X:fadatetime::f(SCRIPT_ROOT_PATH "hotstr\datetime.py")            ; datetime (python)
:X:fatable::f(SCRIPT_ROOT_PATH "hotstr\table.py")                  ; datetable
:X:fapen::f(SCRIPT_ROOT_PATH "hotstr\pen.py")                      ; pendulum
:X:falinsh::f(SCRIPT_ROOT_PATH "hotstr\linsh.py")
:X:falinp::f(SCRIPT_ROOT_PATH "hotstr\linp.py")
:X:fabdtool::f(SCRIPT_ROOT_PATH "hotstr\bdtool.py")
:X:faflask::f(SCRIPT_ROOT_PATH "hotstr\flask.py")
:X:fatrans::f(SCRIPT_ROOT_PATH "tool\old_translator\translate.py") ; translate
:X:famail::f(SCRIPT_ROOT_PATH "hotstr\mail.py")                    ; mail
:X:fareq::f(SCRIPT_ROOT_PATH "hotstr\req.py")                      ; httpx simple
:X:fareq2::f(SCRIPT_ROOT_PATH "hotstr\req2.py")                    ; httpx total
:X:farange::f(SCRIPT_ROOT_PATH "hotstr\range.py")                  ; httpx range video
:X:faproxy::f(SCRIPT_ROOT_PATH "hotstr\proxy.py")                  ; toggle winos proxy, and ALT & 3
:X:fatext::f(SCRIPT_ROOT_PATH "hotstr\text.py")                    ; extract text from html
:X:fawc::f(SCRIPT_ROOT_PATH "hotstr\wc.py")                        ; wordcloud
:X:fajieba::f(SCRIPT_ROOT_PATH "hotstr\jieba.py")                  ; jieba
:X:fahyper::f(SCRIPT_ROOT_PATH "hotstr\hyper.py")                  ; hyper link for MS
:X:facap::f(SCRIPT_ROOT_PATH "hotstr\cap.py")                      ; ddddocr
:X:fazhihu:: f(SCRIPT_ROOT_PATH "hotstr\zhihu.py")                 ; zhihu slide cap
:X:faconf::f(SCRIPT_ROOT_PATH "hotstr\conf.py")                    ; ConfParser
:X:fash::f(SCRIPT_ROOT_PATH "hotstr\sh.py")                        ; all shell bottom show
:X:faexe::f(SCRIPT_ROOT_PATH "hotstr\exe.py")                      ; compile exe
:X:fadeco::f(SCRIPT_ROOT_PATH "hotstr\decorator.py")               ; decorator
:X:fapypi::f(SCRIPT_ROOT_PATH "hotstr\pypi.py")                    ; pypi
:X:fawith::f(SCRIPT_ROOT_PATH "hotstr\with.py")                    ; with
:X:falog::f(SCRIPT_ROOT_PATH "hotstr\log.py")                      ; log
:X:faen::f(SCRIPT_ROOT_PATH "hotstr\en.py")                        ; faen
:X:famd::f(SCRIPT_ROOT_PATH "hotstr\md.py")                        ; famd
:X:faweb::f(SCRIPT_ROOT_PATH "hotstr\web.py")                      ; faweb (webbrowser: chrome --incognito)
:X:fatoml::f(SCRIPT_ROOT_PATH "hotstr\toml.py")                    ; toml template
:X:fabuild::f(SCRIPT_ROOT_PATH "hotstr\build.py")                  ; build pyproject.toml
:X:fatype::f(SCRIPT_ROOT_PATH "hotstr\type.py")                    ; type hint for Literal
:X:fapool::f(SCRIPT_ROOT_PATH "hotstr\pool.py")                    ; proxy pool
:X:favoice::f(SCRIPT_ROOT_PATH "hotstr\voice.py")                  ; pyttsx3
:X:fafast::f(SCRIPT_ROOT_PATH "hotstr\fastapi.py")                 ; fastapi main
:X:fasub::f(SCRIPT_ROOT_PATH "hotstr\sub.py")                      ; sub renew
:X:fafont::f(SCRIPT_ROOT_PATH "hotstr\font.py")                    ; font
:X:fatab::f(SCRIPT_ROOT_PATH "hotstr\tab.py")                      ; tab
:X:faitem::f(SCRIPT_ROOT_PATH "hotstr\item.py")                    ; itemgetter example
:X:fasrt::f(SCRIPT_ROOT_PATH "hotstr\srt.py")                      ; srt
:X:fapuny::f(SCRIPT_ROOT_PATH "hotstr\puny.py")                    ; puny

; ----------------- for rs
:X:rsm::f(SCRIPT_ROOT_PATH "hotstr\rs\main.rs", "{UP}{TAB}")   ; main
:X:rsmain::f(SCRIPT_ROOT_PATH "hotstr\rs\main.rs", "{UP}{TAB}")   ; main

;;;;;; powershell
:X:fatime:: f(SCRIPT_ROOT_PATH "hotstr\avg_time.py")     ; avg time

;;;;;; bigdata
:X:famaven:: f(SCRIPT_ROOT_PATH "hotstr\maven.py")       ; maven
:X:faspark:: f(SCRIPT_ROOT_PATH "hotstr\spark.py")       ; spark
:X:fapyspark:: f(SCRIPT_ROOT_PATH "hotstr\pyspark.py")   ; pyspark
:X:faairflow:: f(SCRIPT_ROOT_PATH "hotstr\airflow.py")   ; airflow

:X:fafa::f(SCRIPT_ROOT_PATH "tool\fafd.py") ; fa+fd
:X:fam3u8::f(SCRIPT_ROOT_PATH "app\m3u8\m3u8_download.py")   ; m3u8
:X:fahigh::f(SCRIPT_ROOT_PATH "app\m3u8\high_download.py")   ; high
:X:faarch::f(SCRIPT_ROOT_PATH "app\m3u8\arch_download.py")   ; arch
:X:faarch1::f(SCRIPT_ROOT_PATH "app\m3u8\arch1_download.py") ; arch
:X:faverge::f(SCRIPT_ROOT_PATH "tool\verge.py")   ; verge

;;; exe
:X:fatoc::Run(SCRIPT_ROOT_PATH "app\toc\toc.exe") ; toc

;;;;;;;;;;;;;;;;;;;;;;;; 🧱Tools For Python
; headers kv-pair string  =>  python-dict format
#u::Run subl "D:\lin\dump-app\U-P\UP.md",, "Hide"
#h::Run subl SCRIPT_ROOT_PATH "config\application.cfg"
#j::Run python SCRIPT_ROOT_PATH "tool\headers_to_dict.py",, "Hide"
#+j::Run python SCRIPT_ROOT_PATH "tool\json_format_mini.py",, "Hide"
#m::Run subl SCRIPT_ROOT_PATH "hotstr\music.py"

; _____________________________________________________________________ 🧲🧲🧲 ^TOGGLE APP
<!w::
{
    callback := () => Run(chrome_cmd)
    toggle_window_vis("ahk_exe chrome.exe ahk_class Chrome_WidgetWin_1", callback)
}
<!+w::Run(chrome_cmd_private) ; anonymous

<!e::
{
    callback := () => Run(edge_cmd)
    toggle_window_vis("ahk_exe msedge.exe ahk_class Chrome_WidgetWin_1", callback)
}
<!+e::Run(edge_cmd_private)

<!1::
{
    callback := () => Run("D:\ide\vscode\Code.exe")
    toggle_window_vis("ahk_exe Code.exe", callback)
}

<!2::
{
    callback := () => Run("E:\app\vlc\vlc.exe")
    toggle_window_vis("ahk_exe vlc.exe ahk_class Qt5QWindowIcon", callback, ["Adjustments and Effects", "Current Media Information", "VLC media player updates"])
}
#HotIf WinActive("ahk_exe vlc.exe")
<!+2::Send("^l") ; toggle vlc playlist
#HotIf

<!3::
#e::
{
    toggle_window_vis("ahk_class CabinetWClass ahk_exe explorer.exe", open_explorer)
}
<!+3::
{
    open_explorer()
}

<!4::
{
    callback := () => Run("D:\ide\pycharm-community\bin\pycharm64.exe")
    toggle_window_vis("ahk_exe pycharm64.exe", callback, exclude_win_titles := "theAwtToolkitWindow")
}

open_explorer(){
    Run "Explorer.exe",,"Max"  ; WinWait OS LANG dynamic
}


!`:: ; replace Terminal: Quake Mode
{
    callback := () => open_cmd(open_mode:=1)
    toggle_window_vis("ahk_class CASCADIA_HOSTING_WINDOW_CLASS", callback)
}

; __________________________________________________________________________________________ ⌨ START GUI
;; ffff (for unique search) ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ^1::GUI_APP.Show("AutoSize Maximize")
; ^2::GUI_FD.Show("AutoSize Maximize")
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  🅰️ APP(FA)
win_close(*){
    WinClose()
}
;;;;;;;;;;;;;;;;;;;;; ^config
app_col_num := 9
app_pad_x := 20
app_pad_y := 1
;;;;;;;;;;;;;;;;;;;;; config$
app_square_grid_w := app_square_grid_h := screen_width/app_col_num - app_pad_x

GUI_APP := Gui("+ToolWindow -Caption", "APP(FA)")
GUI_APP.OnEvent("ContextMenu", win_close)
GUI_APP.OnEvent("Escape", win_close)
GUI_APP.Add("Picture", "x0 y0", APP_BACKGROUND_IMAGE_APP)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 🗂️ DIR(FD)
;;;;;;;;;;;;;;;;;;;;; ^config
font_size := 56 ; will be de-scale
line_height := 2.0
fd_col_num:=3
fd_pad_x:=20
fd_pad_y:=5
;;;;;;;;;;;;;;;;;;;;; config$
rect_font_size := font_size / screen_scale
fd_rect_grid_h := rect_font_size * line_height
fd_rect_grid_w := screen_width/fd_col_num - fd_pad_x

GUI_FD := Gui("+ToolWindow -Caption", "DIR(FD)")
GUI_FD.setFont(Format("s{1} bold", rect_font_size))
; GUI_APP.Opt("AlwaysOnTop -Border")  ; "-Border" => FullScreen
GUI_FD.OnEvent("ContextMenu", win_close)
GUI_FD.OnEvent("Escape", win_close)
GUI_FD.Add("Picture", "x0 y0", APP_BACKGROUND_IMAGE_FOLDER)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 🛑Call
; MButton (only works in AHK GUI)
OnMessage 0x020A, WM_MOUSEWHEEL ; WM_MOUSEWHEEL :=0x020A
app_fd_parse_config()

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Define
add_pic(num,icon_path){
    x := Mod(num,app_col_num) * (app_square_grid_w+app_pad_x)
    y := num//app_col_num * (app_square_grid_w+app_pad_y)
    return GUI_APP.Add( "Picture",FORMAT("x{1} y{2} w{3} h{4} CAqua +BackgroundBlack", x, y, app_square_grid_w,app_square_grid_h),icon_path)
}
add_text(num,content){
    x := Mod(num,fd_col_num) * (fd_rect_grid_w+fd_pad_x)
    y := num//fd_col_num * (fd_rect_grid_h+fd_pad_y)
    return GUI_FD.Add("Text",FORMAT("x{1} y{2} w{3} h{4} CAqua +BackgroundBlack Center", x, y, fd_rect_grid_w,fd_rect_grid_h),content)
}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 🛠️ GUI APP|FD Parse Config
WM_MOUSEWHEEL(wParam, lParam, msg, hwnd)
{
    thisGuiControl := GuiCtrlFromHwnd(hwnd)
    try
        this_gui_control_path := thisGuiControl.path 
    catch
        return
    SplitPath(  ; split only support \ for File,  / for URL
        strreplace(this_gui_control_path, "/", "\"), , &current_dir
    )
    RUN "explorer.exe " current_dir
    WinClose()
}

app_fd_parse_config(){
    __app_config_content := FileRead(APP_CONFIG_PATH, "UTF-8")
    __app_config_index := 0
    __app_config_sep := "------"
    __app_config_is_app := True

    Loop parse, __app_config_content, "`n", "`r"   ; win + unix files
    {
        line := A_LoopField
        if not line
            Continue

        if line == "[app]" {
            __app_config_index := 0
            __app_config_is_app := True
            continue
        }
        else if line  == "[fd]" {
            __app_config_index := 0
            __app_config_is_app := False
            continue
        }

        k_v_pair := StrSplit(line, __app_config_sep)
        path := k_v_pair[1]
        icon_or_text := k_v_pair[2]

        add_item_config(
            __app_config_index,
            path,
            icon_or_text,
            __app_config_is_app
        )
        __app_config_index += 1
    }
}
add_item_config(index, path, icon_or_text, is_app){
    open_event(args*){
        micro_tag := "$USER"
        __path := path
        if InStr(path, micro_tag)
            __path := StrReplace(path, micro_tag, USER_PATH)
        Run("open " __path)
        WinClose()
    }
    ; :*x:fsTr::fsTr
    control_obj := is_app ? add_pic(index,icon_or_text) : add_text(index,icon_or_text)
    control_obj.OnEvent("Click", open_event)
    ; bind for below hwnd  (OnMessage) 👇
    control_obj.path := path
}


get_visible_windows(exclude_window_titles*){
    windows := []
    for this_id in WinGetList(,, "Program Manager") {
        this_ahk_exe := WinGetProcessName(this_id)
        this_title := WinGetTitle(this_id)
        if not this_title
            Continue

        is_continue := False
        for e_w_title in exclude_window_titles
            if this_title == e_w_title{
                is_continue := True
                break
            }
        if is_continue
            continue

        windows.Push([this_ahk_exe, this_title])
    }
    return windows
}
; __________________________________________________________________________________________ END GUI

; _______________________________________________________________________________________________ 🧲🧲🧲 START cliptoy
/*
┌───────────────────────────────────────────────────────────────────────────┐
│ AutoHotkey(V2.0.0+): https://github.com/AutoHotkey/AutoHotkey/releases    │
└───────────────────────────────────────────────────────────────────────────┘
*/
; ________________________________________________________________________________^Standalone cliptoy
; _____________________________________________^Need Config 
SetWinDelay -1
<!s::toggle_cliptoy_gui(unique_title:="ClipBoard_Buffer_Search")   ; toggle(create/show --- hide)
CLIP_ROOT_DIR := "E:\app\clipboard" ; the Root Dir for the app (will auto create 2+1 File, and 1 Dir if not exist)
SUBL_PATH := "D:\ide\Sublime\sublime_text.exe"
clip_editor_path := SUBL_PATH  ; config the editor abs path, eg: C:\Windows\System32\notepad.exe
#c::clip_open_file(clip_editor_path) ; or Syntax in GUI /open

>!1::get_clip_item(-1)
>!2::get_clip_item(-2)
>!3::get_clip_item(-3)
>!4::get_clip_item(-4)
>!5::get_clip_item(-5)

; (Optional) Down cbimg.dll and put into blow dir, the if need (listen: when copy image => auto save into CLIP_IMG_DIR)
; the path can be replaced freely, as long as the path can be found;
; detail => clip_save_image() function
enable_listen_cb_image_and_save := True                        ; True if need, auto save to CLIP_IMG_DIR in CLIP_ROOT_DIR
clip_image_dll_path := A_SCRIPTDIR "\lib\cbimg\dll\cbimg.dll"   ; and special or replace the DLL path
; _____________________________________________Need Config$


; _____________________________________________^Define(No need for modifications, unless customized)
DEBOUNCE_INTERVAL := 5 ; 5ms (Half-OFF => 2 times but accuracy)

screen_scale := A_ScreenDPI / 96 ; stable dpi
screen_width := A_ScreenWidth / screen_scale
screen_height := A_Screenheight / screen_scale

CLIP_ROOT_DIR := StrReplace(CLIP_ROOT_DIR, "/", "\")
CLIP_IMG_DIR := CLIP_ROOT_DIR "\images"
CLIP_TEXT_FILE := CLIP_ROOT_DIR "\clipboard.cb" ; #c
CLIP_TEXT_PIN_FILE := CLIP_ROOT_DIR "\clipboard_pin.cb" 

if not DirExist(CLIP_IMG_DIR)
    DirCreate(CLIP_IMG_DIR) ; ROOT DIR 
if not FileExist(CLIP_TEXT_FILE)
    FileAppend("", CLIP_TEXT_FILE, "UTF-8")  ; FileOpen(CLIP_TEXT_FILE,"w", "UTF-8").Close()
if not FileExist(CLIP_TEXT_PIN_FILE) 
    FileAppend("", CLIP_TEXT_PIN_FILE, "UTF-8")
if not FileExist(clip_image_dll_path)
    enable_listen_cb_image_and_save := False 

clip_block_sep_prefix := clip_block_sep_suffix := "_________________________________________________"
clip_cell_sep := "___________"
white_space := "`n`r`t "  ; include " "

clip_buffer := ListSet()
clip_pin_buffer := clip_file_2_listset(CLIP_TEXT_PIN_FILE)
__file_cache := ListSet()
; OnExit: maybe intrusiveness (SetTimer for them if need)
OnExit clip_buffer_2_file ; Include: Exit/Reload AHK => Auto flush memory to File (Just FileAppend: UTF-8)
OnExit clip_pin_2_file
OnClipboardChange upstream_global_listening

clip_open_file(editor_abs_path := ""){
    exec_cmd := Format('{1} "{2}"', editor_abs_path, CLIP_TEXT_FILE)
    if_succ_cmd := "echo." ; nothing
    if_fail_cmd := Format('{1} "{2}"', "notepad.exe", CLIP_TEXT_FILE)
    cmd := Format("cmd.exe /c {1} && ({2}) || ({3})", exec_cmd, if_succ_cmd, if_fail_cmd)
    Run(cmd,, "Hide") ; "cmd: Keep the same startup approach for sync and async app. "  eg: notepad and subl
}

upstream_global_listening(data_type){
    global latest_is_image_type

    if enable_listen_cb_image_and_save and data_type == 2 {
        latest_is_image_type := True ; to sned !+v
        return clip_save_image()
    }else{
        c := A_Clipboard
        if not Trim(c, white_space)
            return
        clip_buffer.update(RTrim(c, white_space)) ; Just RTrim
        latest_is_image_type := False ; to sned !+v
    }
}
clip_save_image(sleep_ms:=0){
    global latest_image_path 

    img_file_name := FormatTime(A_Now, "yyyyMMdd_HHmmss")
    full_path := CLIP_ROOT_DIR "\images\" img_file_name ".jpg"
    ;;; some screenshot need sleep 1s, otherwise black bg.
    ; sleep sleep_ms ; 
    mod_4_free := DllCall("LoadLibrary", "Str", clip_image_dll_path, "Ptr")
    err := DllCall("cbimg\GetCBImage", "Str", full_path)

    if not err
        latest_image_path := full_path ; to sned !+v

    ;;; ------------------------  check or notify if need
    ; if !Integer(err)
    ;     msgbox("saved into: " full_path)
    ;;; conserve memory if need
    ; DllCall("FreeLibrary", "Ptr", hModule)
    
    ;;; ------------------------ if use python instead of DLL
    ;;; 1. install python + ENG VAR. 2. install pillow module: pip install pillow
    ; py_code := Format("from PIL import ImageGrab; ImageGrab.grabclipboard().save(r'{1}')", full_path)
    ; Run(Format('{1} "{2}"', python_c, py_code),, "Hide")  ; python_c := python " -c "
}

clip_buffer_2_file(*){
    if not clip_buffer.Length
        return
    ; redundancy data can keep latest if <LOAD> from file
    copy_str_len_less_equal_the_num_will_redundancy_store_in_file := 100
    __filter_rule_func(value){
        (__file_cache.in(value) and StrLen(value) > copy_str_len_less_equal_the_num_will_redundancy_store_in_file) ? True : False
    }
    filtered_clip_buffer := clip_buffer.filter( __filter_rule_func ) ; rm dup
    if not filtered_clip_buffer.Length
        return

    title := clip_block_sep_prefix FormatTime(A_Now, "yyyy-MM-dd") clip_block_sep_suffix
    _text := Format("{1}`n{2}`n", title, filtered_clip_buffer.join("`n" clip_cell_sep "`n"))
    FileAppend _text, CLIP_TEXT_FILE, "UTF-8" ; append
}

clip_pin_2_file(*){
    if not clip_pin_buffer.Length
        return FileOpen(CLIP_TEXT_PIN_FILE,"w", "UTF-8").Close() ; empty file content

    title := clip_block_sep_prefix FormatTime(A_Now, "yyyy-MM-dd") clip_block_sep_suffix
    _text := Format("{1}`n{2}`n", title, clip_pin_buffer.join("`n" clip_cell_sep "`n"))

    pin_file := FileOpen(CLIP_TEXT_PIN_FILE,"w", "UTF-8") ; overwrite
    pin_file.Write(_text)
    pin_file.Close() 
}

clip_file_2_listset(file_path){
    file_ls := ListSet()

    _text := FileRead(file_path, "UTF-8")
    if not Trim(_text, white_space)
        return file_ls

    __sep := "!*_~"
    new_str := RegExReplace(_text, clip_block_sep_prefix ".*?" clip_block_sep_suffix, __sep)

    for block in StrSplit(new_str, __sep)
        for cell in StrSplit(block, clip_cell_sep)
            if c := LTrim(RTrim(cell, white_space), "`n`r") ; LTrim only `n`r, keep indent
                file_ls.update(c)
    return file_ls
}

get_clip_item(index){
    if not clip_buffer.Length
        return
    try result := clip_buffer[index]
    if not strip(result)
        return
    A_Clipboard := ""
    A_Clipboard := clip_buffer[index]
    ClipWait
    SendInput "^v"
}

; _____________________________________________Define$

; _____________________________________________^Data Structure
class ListSet{ 
    ; No support nested, push ListSet/Array will be un-packed and auto dedup.
    ; No great performance, may simplify code in scenarios ordered but not repetitive.
    __list := []
    __enum_index := 1

    __New(values*) {
        this.update(values*)
    }
    __Item[start:="",end:=""] {
        get { ; -> value | ListSet
            this.__valid_index(start, end) 
            if  start_or_end := (!(start and end) and (start or end)) ; index
                return this.__list[start_or_end]
            else{
                new_ls := ListSet()
                _len := this.__list.Length
                (start < 0) and (start := _len+start + 1)
                (end < 0) and (end := _len+end + 1)
                for x in this.__list
                    if (A_Index >= start && A_Index <= end)
                        new_ls.update(x)
                return new_ls 
            }
        }
        set { ; -> None (; only support index insert)
            this.__valid_index(start, end)
            if  start_or_end := (!(start and end) and (start or end)) ; index - update
                if not (index := this.in(value))
                    this.__list[start_or_end] := Value
        }
    }
    __valid_index(start:="",end:=""){
        if start == 0 or end == 0
            throw ValueError("Index or Slice must be 1-based", -1)
        (start == "") and (start := 0)
        (end == "") and (end := 0)
        if (Type(start) !== "Integer") or (Type(end) !== "Integer")
            throw ValueError("Index or Slice must be Integer", -1)
        if !start and !end
            throw ValueError("index or slice cannot be empty and must 1-based(support negative)", -1)
    }

    Length { ; -> int
        get => this.__list.Length
    }
    Str {
        get => this.join(",")
    }
    str(){ ; -> str
        return this.join(",")
    }
    Call(&v:=0){
        if this.__enum_index > this.__list.Length {
            this.__enum_index := 1
            return False
        }
        v := this.__list[this.__enum_index]
        this.__enum_index += 1
        return True
    }
    update(values*) ; -> None
    { 
        if (_len := values.Length) == 0
            return
        else if _len == 1 and ((_type := Type(values[1])) == Type(this) or _type == "Array")
            values := values[1]    
        for value in values { ; update value to end
            if index := this.in(value)
                this.__list.RemoveAt(index)
            this.__list.push(value)
        }
    }
    insert(index, force:=True, values*) ; None
    {
        if (_len := values.Length) == 0
            return
        else if _len == 1 and ((_type := Type(values[1])) == Type(this) or _type == "Array")
            values := values[1]    
        ; for value in values {
        loop values.Length{
            value := values[-A_Index]
            if (idx := this.in(value)){
                if not force
                    continue
                this.__list.RemoveAt(idx)
            }
            this.__list.InsertAt(index, value)
        }
    }
    in(value) ; -> int
    { 
        for x in this.__list
            if x == value
                return A_Index
    }
    remove(values*) ; -> int
    { ; NOTE: __rm_count: counts the diff item, not the count of the same element, because ListSet auto distinct
        __rm_count := 0
        if (_len := values.Length) == 0
            return
        else if _len == 1 and ((_type := Type(values[1])) == Type(this) or _type == "Array")
            values := values[1]    
        for value in values { ; update value to end
            if index := this.in(value)
                this.__list.RemoveAt(index), __rm_count += 1
        }
        return __rm_count
    }
    clear() ; -> None
    {
        this.__list := []
    }
    join(sep){ ; -> str
        that := this.__list
        return this.__join_ref(&that, sep)
    }
    sort(asc := True) ; -> None 
    {   ; NOTE: "sort": no return, "sorted": return ListSet) (ListView can sort, so this func no used, performance: poor)
        that := this.__list
        this.__list := this.__sorted_ref(&that, asc := asc)
    }
    filter(func) ; -> ListSet
    { 
        filter_ls := ListSet()
        for x in this.__list
            if !func(x)
                filter_ls.update(x)
        return filter_ls
    }
    map(func) ; -> ListSet
    { ; NOTE: limited functionality, eg: 1,2,3 => 1*0, 2*0, 3*0 => 0
        new_ls := ListSet()
        for x in this.__list
            new_ls.update(func(x))
        return new_ls
    }
    reversed(){ ; -> ListSet
        new_ls := ListSet()
        loop this.__list.Length
            new_ls.update(this.__list.Pop())
        return new_ls
    }
    any(){ ; -> value | None   
        for x in this.__list
            if x
                return x ; or
    }
    __sorted_ref(&arr, asc := True) ; -> ListSet
    {  ; sorted: return a new arr | N: by Num (rather than Str) | D: sep by , | R: reverse | U: Removes duplicate (...)
        mode := "N D,"
        mode .= asc ? "" : " R"
        return StrSplit(Sort(this.__join_ref(&arr, ","), mode),   ",")
    }
    __join_ref(&arr, sep:=",") ; -> str
    {
        _text := ""
        if not arr.Length
            return ""
    
        str := arr[1]
        loop arr.Length-1
            str .= sep arr[A_Index+1]
        return str
    }
}
; _____________________________________________Data Structure$
; ___________________________________________________________________________^Main
create_cliptoy_search_gui(search_gui_title, &__TOGGLE_CLIPTOY_VIS__){
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ^Config 
    width := screen_width / 1.4
    height := screen_height / 1.2

    font_size := 16
    font_name := "Arial" ; others: https://www.autohotkey.com/docs/v2/misc/FontsStandard.htm
    root_font_size := font_size / screen_scale

    edit_font_size := root_font_size + 4
    edit_height := edit_font_size*2
    first_cell_char_max_len := 7

    lv_row_counts := 5000

    syntax_symbol := "/"    
    double_syntax_symbol := syntax_symbol syntax_symbol
    triple_syntax_symbol_anywhere := double_syntax_symbol syntax_symbol

    sep_line_first_col := repeat("_", first_cell_char_max_len - 1)
    sep_line_second_col := repeat("_", 160)

    pin_buffer_sep := repeat("_", 40) "📌👆" repeat("_", 80) 
    buffer_file_sep := repeat("_", 40) "👇📃" repeat("_", 80)
    
    ; Append: real-time GUI-Listen (Default only Copy-Listen)
    ; NOTE: must de-On if GUI __destroy(*)
    OnClipboardChange downstream_gui_listening 

    ; syntax
    title_sep := "|📙"
    QUIT  := syntax_symbol "q"
    RESET := syntax_symbol "reset"
    LOAD  := syntax_symbol "load"
    RE_LOAD := syntax_symbol "reload"
    FLUSH := syntax_symbol "flush"
    BAK  := syntax_symbol "bak"
    OPEN  := syntax_symbol "open"
    SEP   := "sep"
    CLEAR := syntax_symbol "clear"     ; only support delete buffer (all) using Edit Syntax
    CLS := syntax_symbol "cls"         
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Config$    
    mode_2_title := Map()
    pin_blacklist_ls := ListSet(pin_buffer_sep, buffer_file_sep)
    ;;; Define Root GUI
    ; search_gui:= Gui("-Resize -Caption -SysMenu -Parent -Theme -MaximizeBox -hideBox +ToolWindow +Owner", search_gui_title) ; -Parent (for hide)
    search_gui:= Gui("-Resize -Caption +ToolWindow +LastFound", search_gui_title) ; -Parent (for hide)
    ; search_gui:= Gui("", search_gui_title) ; -Parent (for hide)
    search_gui.MarginX := 0
    search_gui.MarginY := 0
    search_gui.setFont(Format("s{1} ",root_font_size), font_name)
    ; search_gui.OnEvent("Escape", __lv_focus) ; edit lose focus
    search_gui.OnEvent("Escape", __hide)
    search_gui.OnEvent("ContextMenu", __hide) ; Maybe TODO(More) CRUD
    ;;; Listview
    title_text := "TEXT" ; will dynamic modify
    search_lv := search_gui.Add("ListView", Format(
        "c09C0C5 +BackgroundBlack w{1} h{2} count{}", width, height-edit_height, lv_row_counts), 
        ["ID", title_text]
    )
    first_cell_pixels := first_cell_char_max_len * root_font_size
    search_lv.ModifyCol(1, "Logical")  ; for sort   eg: (A11 > A2)
    search_lv.ModifyCol(1, first_cell_pixels)
    search_lv.ModifyCol(2, width - 50 - first_cell_pixels)
    search_lv.OnEvent("DoubleClick", __lv_dbclick)
    search_lv.OnNotify(-155, __lv_key_down)
    ;;; Edit
    search_edit := search_gui.AddEdit(Format("c09C0C5 +BackgroundBlack w{1} h{2}", width, edit_height))
    search_edit.setFont("s" edit_font_size)
    search_edit.OnEvent("Change", debounce(__on_change, DEBOUNCE_INTERVAL))
    search_edit.OnNotify(-155, __lv_key_down)
    ;;; Button (Hide)
    search_gui.Add("Button", "Hidden Default", "OK").OnEvent("Click", __lv_or_edit_enter) ; for press ENTER

    ;;; Run pre start
    search_edit.Focus()
    __on_change()
    search_gui.Show(Format("w{1} h{2}", width, height))

    ;;; DOC
    syntax_2_doc := [
        [syntax_symbol,"Syntax Symbol Prefix in Edit & show help, variable in src code: <syntax_symbol>"],
        [double_syntax_symbol,"Focus ListView; Re-Focus Edit press the LV_KEY => /; also <TAB> or <i>/<o>+<ESC>, such as VIM"],
        [triple_syntax_symbol_anywhere,Format("same as {1}, but it not restricted by input position in the Edit. eg: 123///", double_syntax_symbol)],
        [syntax_symbol "reset","Reset all syntax, LV_KEY(means when focus ListView and press) => r"],
        [syntax_symbol "load","The lookup seq is: [File Cache(not Buffer)] <=> [File if not cache] => append to current cells, LV_KEY => a"],
        [syntax_symbol "reload","Forcing re-read from the [File] into the [File Cache(not Buffer)] => append to current cells, LV_KEY => A"],
        [syntax_symbol "clear","Clear clipboard Buffer(WARN:Irreversible), (Buffer: for writing to file; Cache: for reading from file),  LV_KEY() => None"],
        [syntax_symbol "flush","Flush and Clear clipboard Buffer into history file manually=> LV_KEY => None"],
        [syntax_symbol "bak","FileCopy 'clipboard_pin.cb' to 'clipboard_pin.cb.bak' (if not change in SRC Code), LV_KEY() => None"],
        [syntax_symbol "open","Open the data file using Notepad.exe if <clip_editor_path> not change in SRC Code, LV_KEY => None"],
        [syntax_symbol "sep<N>",  "Number of white line for cells separator to be pasted, default <N> is 0, eg: sep0, LV_KEY => None"],
        [sep_line_first_col, sep_line_second_col],
        ["LV_KEY", "means press hotkey in ListView, have the same functionality as EDIT_SYNTAX, but also additional features."],
        ["","t:PIN | T:Un-PIN | a:LOAD | A:Re-LOAD | r:RESET | {DELETE}:Delete Buffer | q:Quit"],
        ["","n:↓ | p:↑ | d:page↓ | u:page↑ | h:head↑ | l:end↓ | i o /:switch focus to Edit"],
        ["","<Enter>: Both (Edit+LV), the <Enter> will auto paste the First Row if no select. such as <Win+V>"],
        ["","the native <CTRL>/<SHIFT> + <HOME>/<END>/... is still universal, more in SRC Code: __lv_key_down"],
        [sep_line_first_col, sep_line_second_col],
        ["NOTE", "the hotkey: re-press the launch hotkey(if not change) => '<!s' will toggle the GUI visible: show/hide"],
        ["",Format("the search: column `ID` is redundant for search(filter) or Sort(Click Header)", syntax_symbol)],
        ["","the click: <Double LButton> can auto Copy and Paste in to your main window such as <WIN+V>"],
        [sep_line_first_col, sep_line_second_col],
        ["IDEA", "https://github.com/linusic/lazykey/blob/main/autohotkey/mykey.ahk"],
    ]

    debounce(fn, delay){
        /* 
            1. last once
            2. refresh timer (close + setTimer)
        */
        close_delay := 0 ; timer in Other Lang
        __inner(*){ ; must in ahk on...
            ; if close_delay
            ;     SetTimer fn, 0 ; 0 is close
            ; close_delay := delay
            SetTimer fn, -delay ; -<int> is once and (auto clear in AHK)
        }
        return __inner
    }

    throttle(fn, delay){
        /* 
            1. first once
            2. lock timer(settimer + timer = "" (next event => auto for 'if not timer')
        */
    }

    __on_change(*){
        cur_input := StrLower(search_edit.Value)
        switch { ; pre easy match (all match -> return; beside HELP, all refresh)
            case not cur_input: return lv_add_all_refresh()
            case cur_input == double_syntax_symbol or InStr(cur_input, triple_syntax_symbol_anywhere): return (__lv_focus(), clear_edit_refresh())
            case cur_input == QUIT: return __destroy()
            case cur_input == RESET: return __reset__()
            case cur_input == FLUSH: return __flush__()
            case cur_input == OPEN: return __open__()
            case cur_input == LOAD: return __load__()
            case cur_input == RE_LOAD: return __reload__()
            case cur_input == BAK: return __bak__()
            case cur_input == CLEAR or cur_input == CLS: return __clear__()
            case RegExMatch(cur_input, Format("{1}{2}(\d+)", syntax_symbol, SEP), &match_obj): return __sep__(match_obj[1])
            case SubStr(cur_input,1,1) == syntax_symbol: return lv_add_some_refresh(LTrim(cur_input, syntax_symbol), syntax_2_doc)
        } ;;; default: no return
        lv_add_some_refresh(cur_input) ; lv append row
    }
    lv_add_all_refresh(){
        need_reversed_arr := get_total_need_reversed_show_ls()
        search_lv.Opt("-Redraw")
        search_lv.delete()
        loop need_reversed_arr.Length
            search_lv.Add(, syntax_symbol A_Index, need_reversed_arr[-A_index])
        search_lv.Opt("+Redraw")            
    }
    lv_add_some_refresh(cur_input, dim_2_arr:=""){
        search_lv.Opt("-Redraw") ;;;;;;;;;;;;;;;;;;;
        search_lv.delete()
        if dim_2_arr { ; just for help (another search way)
            for pair in dim_2_arr{
                _id := pair[1],    _text := pair[2]
                target_text := Format("{1}", _id),    input_regex := "imS)" StrReplace(cur_input, " ", ".*") ; m).*  [\s\S]*
                try 
                    result := RegExMatch(target_text, input_regex)
                catch
                    break
                if result
                    search_lv.Add(, _id, _text)
            }
        }
        else{
            loop (need_reversed_ls := get_total_need_reversed_show_ls()).Length{ ; "text /id")
                id:=syntax_symbol A_Index, text:=need_reversed_ls[-A_Index]
                row := id " " text, all_match := True
                loop parse cur_input," " {
                    if not A_LoopField
                        continue
                    if !Instr(row, A_LoopField) {
                        all_match := False
                        break
                    }
                }
                if all_match
                    search_lv.Add(, id, text)
            }
        }
        search_lv.Opt("+Redraw") ;;;;;;;;;;;;;;;;;;;
    }
    repeat(str, n){
        s := ""
        loop n
            s .= str
        return s
    }
    clear_edit_refresh(){
        search_edit.Value := "", lv_add_all_refresh()
    }
    copy_and_paste_selected_hide(str:=""){ ; below must keep sort
        _sep := repeat("`n", mode_2_title.get("__WHITE_LINE__", 0) + 1)
        if s := Rtrim( str || selected_cells_to_str(_sep), white_space)
            __hide(), __clip_toggle_event_for_paste(s)            
    }
    selected_cells_to_str(sep){
        return lv_get_selected_indexes().map( (row_num)=>lv_get_text_cell(row_num) ).filter( (x)=>pin_blacklist_ls.in(x)?True:False ).join(sep)
    }
    lv_get_selected_indexes(){
        idx_ls := ListSet()
        RowNumber := 0
        Loop {
            RowNumber := search_lv.GetNext(RowNumber)
            if not RowNumber
                break
            idx_ls.update( RowNumber )
        }
        return idx_ls
    }
    lv_get_text_cell(row){
        return RTrim(search_lv.GetText(row,2), white_space)
    } 
    update_title(){
        title_ls := ListSet(title_text)
        for mode,title in mode_2_title
            if not InStr(mode, "__")
                title_ls.update(title)
        search_lv.ModifyCol(2,,title_ls.join(title_sep))
    }
    get_total_need_reversed_show_ls(){
        total_ls := ListSet()
        ; File
        if mode_2_title.Has("LOAD"){
            if not __file_cache.Length
                global __file_cache := clip_file_2_listset(CLIP_TEXT_FILE)
            if __file_cache.Length
                total_ls.update( __file_cache* ),  total_ls.update(buffer_file_sep) ; ---
        }
        ; Buffer
        total_ls.update( clip_buffer* )
        if clip_pin_buffer.Length
            total_ls.update(pin_buffer_sep) ; ---
        ; PIN
        total_ls.update( clip_pin_buffer* )
        return total_ls
    }

    __reset__(){
        mode_2_title.clear(), update_title(), clear_edit_refresh()
    }
    __clear__(){
        clip_buffer.clear(), clear_edit_refresh()
    }
    __flush__(){
        clip_buffer_2_file(), mode_2_title.has("LOAD") && mode_2_title.Delete("LOAD")
        update_title(), __clear__()
    }
    __open__(){
        clip_open_file(clip_editor_path)
        clear_edit_refresh()
    }
    __bak__(){ ; 1 : overwrite
        FileCopy(CLIP_TEXT_FILE, CLIP_TEXT_FILE ".bak", 1)
        FileCopy(CLIP_TEXT_PIN_FILE, CLIP_TEXT_PIN_FILE ".bak", 1)
        clear_edit_refresh()
    }
    __load__(){
        mode_2_title.Set("LOAD","Load FILE"), update_title(), clear_edit_refresh()
    }
    __reload__(){
        global __file_cache := ListSet()
        __load__()
    }
    __sep__(num){
        mode_2_title.Set("__WHITE_LINE__",num), mode_2_title.Set("SEP", "SEP_WHITE_LINE:" num), update_title(), clear_edit_refresh()        
    }
    __pin__(){
        refresh_var := False
        clip_pin_buffer.update(lv_get_selected_indexes().map((i) => lv_get_text_cell(i)).filter(
            ( (&r) => (x)=>pin_blacklist_ls.in(x)?True:(r:=True, False) )(&refresh_var) ; decorator / map <= partial func
        ).reversed()) ; new seq need be reverse to full seq
        if refresh_var
            lv_add_all_refresh()
    }
    __un_pin__(){       
        if not clip_pin_buffer.Length
            return
        if clip_pin_buffer.remove( lv_get_selected_indexes().map((i) => lv_get_text_cell(i)) )
            lv_add_all_refresh()
    }
    __delete_buffer__(){
        if not clip_buffer.Length
            return
        if clip_buffer.remove(lv_get_selected_indexes().map((i) => lv_get_text_cell(i)).filter(
            (text) => not clip_buffer.in(text) ; all => filter => rest in buffer => remove 
        ))
            lv_add_all_refresh()
    }

    __clip_toggle_event_for_paste(paste_text){
        OnClipboardChange upstream_global_listening, 0 ; pause event
        OnClipboardChange downstream_gui_listening, 0 ;
        A_Clipboard := ""
        A_Clipboard := paste_text
        ClipWait
        SendInput "^v"
        OnClipboardChange upstream_global_listening ; continue event
        OnClipboardChange downstream_gui_listening ; 
    }
    downstream_gui_listening(*){
        lv_add_all_refresh()
    }
    __lv_or_edit_enter(*) {
        if not search_lv.GetCount()
            return
        search_lv.GetCount("Selected")
        ? copy_and_paste_selected_hide() ; paste selected
        : copy_and_paste_selected_hide( lv_get_text_cell(1) ) ; auto paste first
    }
    __destroy(*){
        OnClipboardChange(downstream_gui_listening, 0), search_gui.destroy()
    }
    __hide(*){
        search_gui.hide()
        __TOGGLE_CLIPTOY_VIS__ := False
    }
    __lv_focus(*){
        search_lv.Focus()
    }
    __lv_dbclick(lv, row_number){
        if row_number
            copy_and_paste_selected_hide()        
    }
    __lv_key_down(lv, lParam) {
        ; GetKeyName&NumGet:https://www.autohotkey.com/boards/viewtopic.php?t=114432
        switch GetKeyName(Format('vk{:X}', NumGet(lParam, 3 * A_PtrSize, 'UShort'))){
            ;;; move key just rename, the original WIN key can do more (eg: Shift+End/Home)
            case "i", "o", "/": search_edit.Focus()
            ;;;
            case "q": __destroy()
            case "v": __lv_or_edit_enter() ; or <Enter>
            ;;; (all) if right hand:mouse focus LV: Press "a" with left hand instead of "l" is the best choice 
            case "a": GetKeyState("CapsLock", "T") ? __reload__() : __load__()
            case "r": __reset__()
            case "t": GetKeyState("CapsLock", "T") ? __un_pin__() : __pin__()
            case "Delete": __delete_buffer__()
        }
    }
}

win_activate_current_cursor(){
    MouseGetPos(,,&id)
    winactivate(id)
}
toggle_window_vis(win_title, app_start_func, exclude_win_titles := False){
    DetectHiddenWindows True
    SetWinDelay -1

    ; dep class ListSet
    ls := ListSet() 
    if exclude_win_titles
        ls.update(exclude_win_titles)


    ahk_id_arr := []

    for _id in WinGetList(win_title)
        if _id
            if win_title := WinGetTitle(_id){
                ; if exclude_win_titles and win_title == exclude_win_titles
                if exclude_win_titles and ls.in(win_title)
                    continue
                else {
                    ahk_id_arr.push("ahk_id " _id)
                }
            }

    group_name := "AHK_" RegExReplace(win_title, "[^a-zA-Z0-9]", "")  ; not allow start with number 
    for a_id in ahk_id_arr
        GroupAdd(group_name, a_id)
    group_name := "ahk_group " group_name

    if !WinExist(group_name)
        return (app_start_func(), TOGGLE_APP_DICT[group_name] := True)

    winactive(group_name) and TOGGLE_APP_DICT.get(group_name, False) ; be covered but no hide
    ? (WinHide(group_name), TOGGLE_APP_DICT[group_name] := False, win_activate_current_cursor())
    : (WinShow(group_name), Winactivate(group_name), TOGGLE_APP_DICT[group_name] := True)
}

toggle_cliptoy_gui(unique_title:="ClipBoard_Buffer_Search"){ ; toggle(create/show --- hide)
    /*  Unless done intentionally, this is a low-probability event:
        if The interval between script startup/restart and pressing Alt+S (hotkey) is extremely short:
            FIX:  pre-init the global variable (tmp + only once)
            FLAW: History PIN Load need to be manually refreshed by typing a char in "Edit" (only once)
    */
    if !IsSet(clip_buffer) 
        global clip_buffer := ListSet()     ; No impact
    if !IsSet(clip_pin_buffer)               
        global clip_pin_buffer := ListSet() ; Flaw

    static __TOGGLE_CLIPTOY_VIS__ := False ; keep alone
    toggle_window_vis(unique_title,() => create_cliptoy_search_gui(unique_title, &__TOGGLE_CLIPTOY_VIS__))
}
; ___________________________________________________________________________Main$
; ________________________________________________________________________________Standalone cliptoy$
; _______________________________________________________________________________________________ END cliptoy
