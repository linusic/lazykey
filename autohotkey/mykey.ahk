;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
;;;;;;;;;;;;;;;;;;;;;;;;;   AHK V2.0.0  ;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SCRIPT_ROOT_PATH := A_SCRIPTDIR "\"

PYTHON_PATH := "D:\python310\python.exe"
SUBL_PATH := "D:\ide\Sublime\sublime_text.exe"

CLIP_PATH := "E:\app\clipboard" ; #c

APP_CONFIG_PATH := SCRIPT_ROOT_PATH "config\application.cfg"  ; #h
APP_BACKGROUND_IMAGE_APP := SCRIPT_ROOT_PATH "image\bg.png"
APP_BACKGROUND_IMAGE_FOLDER := SCRIPT_ROOT_PATH "image\bg.png"

; SetTitleMatchMode 2   ; (default) windows just need contains <WinTitle>
SendMode "Input"
#Hotstring EndChars `t

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Python
choose_python(_python_path)
{
    if FileExist(_python_path)
        _python := _python_path " "
    else
        _python := "python "
    return _python
}
python := choose_python(PYTHON_PATH)
python_c := python " -c "
subl := SUBL_PATH " "


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Browser & Explorer => URL
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
cp_path()
{
    if !goto_path()
        return
    Send("^a")
    Send("^c")
    Send("{ESC 2}")   ; twice for Explorer and Edge
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; remap -> numbers
Capslock & h::Send "0" ;
Capslock & j::Send "1"
Capslock & k::Send "2"
Capslock & l::Send "3" ; 
Capslock & u::Send "4"
Capslock & i::Send "5"
Capslock & o::Send "6"
Capslock & p::Send "6"
Capslock & 8::Send "7" ; 
Capslock & 9::Send "8"
Capslock & 0::Send "9"
Capslock & m::Send "0" ; 
Capslock & n::Send "0" 

Capslock & Space::Space
;;;;;;;;;;;;;;;;;;;;; 🖥️For Switch Screen (effect below all RAlt)
win_prev(){ 
    Send "!{ESC}"   ; ←
    if WinActive("A")    ;  tooltip WinActive("A") 
        WinActivate("A")
}

win_next(){
    Send "!+{ESC}"  ; →
    if WinActive("A")
        WinActivate("A")
}

>!j::win_prev()
>!k::win_next()


;;; jump and re-jump
<!s::Send "{F12}"  ; F12 is vsc
LALT & 9::Send "{XButton1}"
LALT & 0::Send "{XButton2}"

;;;;;;;;;;;;;;;;;;;;; 💻Terminal
; RUN "wt.exe -F -w _quake pwsh.exe -nologo -window minimized"

; edit ahk config by subl
^!.::Run subl SCRIPT_ROOT_PATH "mykey.ahk",,"Hide"

; Suspend
#SuspendExempt
+F4::Suspend  ; Ctrl+Alt+S
#SuspendExempt False

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 🧲🧲🧲 ChatGPT
<!CapsLock::
{
    static __PALM_TOGGLE_REF := False
    __palm_callback := () => Run(python SCRIPT_ROOT_PATH "app\palm\main.py",, "hide")
    toggle_window(
        "PaLM ahk_class TkTopLevel", 
        &__PALM_TOGGLE_REF,
        __palm_callback
    )
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 🧲🧲🧲 New Translator
>!CapsLock::
{
    static __TRANSLATOR_TOGGLE_REF := False

    __trans_callback := () => Run(python SCRIPT_ROOT_PATH "app\translator\main.py",, "hide")
    toggle_window(
        "Translator ahk_class TkTopLevel", 
        &__TRANSLATOR_TOGGLE_REF,
        __trans_callback
    )
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 🧲🧲🧲 M3U8 Downloader
+F1::
{
    IB := InputBox("🧲🧲🧲🧲🧲🧲M3U8 PATH", "🧲M3U8 PATH", "w900 h150")
    if IB.Result != "Cancel" {
        CMD := python SCRIPT_ROOT_PATH "tool/m3u8.py am " IB.Value
        RunWait CMD
    }
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 🧲🧲🧲 Send Input
+F2::
{
    IB := InputBox("🧲🧲🧲🧲🧲🧲Input", "🧲Send Input", "w900 h150")
    if IB.Result != "Cancel" {
        Send IB.Value
    }
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 🧲🧲🧲 OCR
<!\::
{
    Run python SCRIPT_ROOT_PATH "app\clipocr\main.py",, "hide"
}


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 🧲🧲🧲For A_Clipboard
clip_file_path := CLIP_PATH "/clipboard.cb"

clip_cache := ""
OnClipboardChange clipboard_change
clipboard_change(event:="")
{
    global clip_cache
    if RegExReplace(A_Clipboard, "\s", "") {  ; remove all white char
        clip_cache := clip_cache "`n------`n" A_Clipboard
    }
}


OnExit clip_cache_dump
clip_cache_dump(ExitReason, ExitCode)
{
    if clip_cache {
        title := "`n`n🛑🛑🛑[" FormatTime(A_Now, "yyyy-MM-dd") "]`n"
        FileAppend title clip_cache , clip_file_path, "UTF-8"
    }
}

#c::Run(subl clip_file_path ,,"Hide")
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
CoordMode "Caret", "Window"
; if for test , maybe change it to "Window"
CoordMode "Tooltip", "screen"

;;;;;;;;;;;;;;;;;;;;;;;;; Block All Menu for RALT
~RAlt::Send "^{space}"       ; 🛑IME need open (Ctrl and Ctrl+Space) 💧 drop 4keys: #
*#space::Send "{Ctrl}"     ; BLOCK => IME => ... + win + space

<!space::Send "{ENTER}"

;;;;;;;;;;;;;;;;;;;;;;;;;  HotKey ReMap
^-::Send "^{WheelDown}"
^=::Send "^{WheelUp}"
; mouse wheel
<+n::Send "{WheelDown}"
<+p::Send "{WheelUp}"


<!`;::Send "+{enter}"
>!`;::Send "!{enter}"
; [delete]
<!o::Send "{backspace}"
<!,::Send "^v"
<!j::Send "{left}"
<!k::Send "{right}"
<!n::Send "{down}"
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
<+t::Send "\n"
<+w::Send "*"

; [Screen In WindowOS]
^<+space::Send "{F11}"
^<!j::Send "^#{left}"
^<!k::Send "^#{right}"

<+o::Send "^!{tab}"
<!z::
<+z::Send "#z"

; mmmm ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 🖱️ Replace Mouse
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
; mmmm ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 🖱️ Replace Mouse


;;;;;;;;;;;;;;; 🛑Terminal Only For [Bash Core] ;;;;; (the Condition must be fully)
#HotIf WinActive("ahk_exe WindowsTerminal.exe") and WinActive("@")
!i::Send "{ESC}{backspace}"
#HotIf

;;;;;;;;;;;;;;; 🛑Terminal Only For [CMD Core] ;;;;;; (the Condition must be fully)
#HotIf WinActive("ahk_exe WindowsTerminal.exe") and not WinActive("@")
; [delete to head]
;^u::Send "{ESC}"
^u::Send "^{Home}"
; [delete to tail]
^k::Send "^{END}"
<!i::Send "^{backspace}"
#HotIf

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Windows APP (Not Contain Windows Terminal)
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
<![::Send "{PgUp}"
<!]::Send "{PgDn}"
^<!n::Send "^{end}"
^<!p::Send "^{home}"
; [Select]
<!a::Send "^+{home}"
~<!e::Send "^+{end}"
; [Screen In WindowOS]
<!d::Send "^{left}^+{right}^c"
<!m::Send "{esc}"
<!/::Send "^f"

LAlt & RAlt::Send "{esc}"
#HotIf

>!2::Send "^{Tab}"
>!1::Send "^+{Tab}"

;;;;;;;; Toggle WinOS Proxy
set_proxy_port(port := -1)
{
    A_Clipboard := ""

    if (port == -1) {
        Run python SCRIPT_ROOT_PATH "hotstr\proxy.py 127.0.0.1:8080",, "hide"
    } else {
        IB := InputBox("✈ INPUT LOCAL PROXY PORT", "Proxy Port", "w300 h100")

        if IB.Result != "Cancel" {
            Run python SCRIPT_ROOT_PATH "hotstr\proxy.py 127.0.0.1:" IB.Value,, "hide"
        }
    }
    ClipWait(1)

    TrayTip A_Clipboard, "",16 + 32
    Sleep 1000
    TrayTip ; no args => rep hide
}

LALT & 3::set_proxy_port()
RALT & 3::set_proxy_port("by input")

;;;;  Toggle WIFI
RALT & DELETE::
{
    wifi_name := "‏‏‎ ‎"

    If not has_internet()
    {
        RUN "netsh wlan connect name=" wifi_name,, "HIDE"
    }else{
        RUN "netsh wlan disconnect",, "HIDE"
    }

    TrayTip "🌏 WIFI TOGGLED", "",16 + 32
    Sleep 1000
    TrayTip
}
has_internet(flag:=0x40) {
    Return DllCall("Wininet.dll\InternetGetConnectedState", "Str", flag,"Int",0)
}


;;; for ^+e
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
    else
    {
    }
}


;;; for cmd alias
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
    '& doskey conda = "cmd.exe "/K" D:/miniconda/Scripts/activate.bat D:/miniconda" '
    '& doskey clear = for /L %i in (1,1,100) do @echo. && echo. '
)


;;; cccc   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;     for ^+e
choice_for_open_cmd(path, open_mode)
{
    ; NOTE: Tail Space
    ; cmd:
        ; & : meantime
        ; &&: break

    ; cmd_base := 'cmd.exe /K {1}: && cd "{2}" ' alias_dos_keys
    ; /D (also skip driver)
    cmd_base := 'cmd.exe /K cd /D {1} ' alias_dos_keys


    ;  "echo.    => rep: \n
    cmd  := cmd_base " && for /L %i in (1,1,100) do @echo. && echo. "
    pwsh := cmd_base " && pwsh /nologo"
    wsl  := cmd_base " && wsl"


    if( !DirExist(path) ){
        path := "D:/"
    }

    if(open_mode == 0) {  ; cmd
        command := Format(cmd, path) ; abs path
    }
    else if(open_mode == 1) {  ; pwsh
        command := Format(pwsh, path) ; abs path
    }
    else if(open_mode == 2) {  ; wsl
        command := Format(wsl, path) ; abs path
    }

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

        if path == A_SCRIPTDIR {
            path := "D:/"
        }

        choice_for_open_cmd(path, open_mode)
    }
    else
    {
        try{
            raw_path := ControlGetText("ToolbarWindow324", "A")    ; 324 is dynamic, maybe changed by the system update
            ;  for EN Lang OS
            path := SubStr(raw_path, 10)  ; eg: rest => "E:\music\KR" 
            ; for CN Lang OS
            if not DirExist(path)  
                path := SubStr(raw_path, 5)  ; Address: E:\music\KR  => E:\music\KR
        }
        catch as Err
        {
            path := "D:/"  ; if not, then cd "D:/"
        }
        choice_for_open_cmd(path, open_mode)
    }
}

^+e::
{
    condition_cmd := 'explorer.exe /select,'
    open_folder(condition_cmd, use_file:=true)
}


;;;;;; WinAPP
; App Remove
#a::Run "appwiz.cpl"
; Bin
#b::Run "::{645ff040-5081-101b-9f08-00aa002f954e}"
; Internet  (; Run "ncpa.cpl"    )
#i::Run "::{7007acc7-3202-11d1-aad2-00805fc1270e}"  ; more fast
; notepad
#n::Run "Notepad.exe"
; Python.exe
#p::RUN "wt.exe powershell.exe " python
; explorer.exe
#e::fullscreen_explorer()
fullscreen_explorer()
{
    Run "Explorer.exe"
    sleep 600
    Send "{F11}"
}

; edit the select
<+r::
{
    A_Clipboard := ""
    Send "^c"
    ; sleep(70)
    ClipWait(1)
    RUN(subl A_Clipboard,, "Hide")
}
<+e::
{
    A_Clipboard := ""
    Send "^c"
    ; sleep(70)
    ClipWait(1)

    ; if use explorer (must \ instead of /)
    smart_path := StrReplace(A_Clipboard, "/", "\")
    RUN("explorer " smart_path)
}


;;;;;;;;; SHOW/HIDE DESKTOP ICON
control_visible(control_title, win_title)
{
    ; control_title : control's Title / ClassNN / HWND
    ; win_title     : window's Title
    is_visible := ControlGetVisible(control_title, win_title)
    return is_visible
}
control_show(control_title, win_title)
{
    if control_visible(control_title, win_title){
        ControlHide(control_title, win_title)
    }
}
control_hide(control_title, win_title)
{
    if not control_visible(control_title, win_title){
        ControlShow(control_title, win_title)
    }
}
control_toggle_visible(control_title, win_title)
{
    if control_visible(control_title, win_title){
        ControlHide(control_title, win_title)
    }else{
        ControlShow(control_title, win_title)
    }

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


;📕📕📕📕📕📕📕📕📕📕📕📕📕📕📕📕📕📕📕📕📕Translate
server_is_running(pid)
{
    if pid == 0 {
        return False
    }

    A_Clipboard := ""

    RUN python SCRIPT_ROOT_PATH "hotstr\taskfind.py python " pid ,, "Hide"  ; behind python is findstr "python" | findstr "<pid>"
    ClipWait(3)

    result := A_Clipboard == 1 ? True : False
    return result
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 🧱Replace WGestures
; Mouse Gestures
RButton::
{
    allow_distance := 15  ; gt => act
    mousegetpos &x1, &y1
    Keywait "RButton"
    mousegetpos &x2, &y2

    if (x1-x2 > allow_distance and abs(y1-y2) < (x1-x2) )       ; ← :x2 < x1
        send "^#{Left}"
    else if (x2-x1> allow_distance and abs(y1-y2) < (x2-x1) )   ; → :x2 < x1
        send "^#{Right}"
    else if (abs(x1-x2) < (y1-y2) and (y1-y2) > allow_distance) ; ↑ :y2 < y1
        send "{F11}"
    else if (abs(x1-x2) < (y2-y1) and (y2-y1) > allow_distance) ; ↓ :y2 > y1
        send "#d"
    else   ; No Move
        send "{RButton}"
}

XButton2:: ; ↑
{
    allow_distance := 15
    mousegetpos &x1, &y1
    Keywait "XButton2"
    mousegetpos &x2, &y2

    if (x1-x2 > allow_distance and abs(y1-y2) < (x1-x2) )       ; ← :x2 < x1
    {
        GUI_APP.Show("AutoSize Maximize")
    }
    else if (x2-x1> allow_distance and abs(y1-y2) < (x2-x1) )   ; → :x2 < x1
    {
        GUI_FD.Show("AutoSize Maximize")
    }
    else if (abs(x1-x2) < (y2-y1) and (y2-y1) > allow_distance) ; ↓ :y2 > y1
    {
        ; open_cmd(open_mode:=2) ; wsl
        ; open_cmd(open_mode:=0) ; cmd
        Send "#v"
    }
    else if (abs(x1-x2) < (y1-y2) and (y1-y2) > allow_distance) ; ↑ :y2 < y1
    {   ; ^+e
        condition_cmd := 'explorer.exe /select,'
        open_folder(condition_cmd, use_file:=true)
    }
    else   ; No Move
        send "{XButton2}"
}

XButton1:: ; ↓
{
    allow_distance := 50
    mousegetpos &x1, &y1
    Keywait "XButton1"
    mousegetpos &x2, &y2

    if ( x2-x1 > allow_distance*2 )  and ( y2-y1 > allow_distance ) ; → ↓ or ↘
        send "^{END}"
    else if ( (x2-x1 > allow_distance*2) and (y1-y2 > allow_distance) ) ; → ↑ or ↗
        send "^{HOME}"
    else if (x1-x2 > allow_distance and abs(y1-y2) < (x1-x2) )  ; ← :x2 < x1
        win_prev()
    else if (x2-x1> allow_distance and abs(y1-y2) < (x2-x1) )   ; → :x2 < x1
        win_next()
    else if (abs(x1-x2) < (y2-y1) and (y2-y1) > allow_distance) ; ↓ :y2 > y1
        open_cmd(open_mode:=1) ; powershell
    else if (abs(x1-x2) < (y1-y2) and (y1-y2) > allow_distance) ; ↑ :y2 < y1
        fullscreen_explorer()
    else   ; No Move
        send "{XButton1}"
}


MButton:: ; ↓
{
    allow_distance := 15
    mousegetpos &x1, &y1
    Keywait "MButton"
    mousegetpos &x2, &y2

    if (x1-x2 > allow_distance and abs(y1-y2) < (x1-x2) )       ; ← :x2 < x1
    {
        ; Send "{backspace}"
        send "^+{TAB}"
    }
    else if (x2-x1> allow_distance and abs(y1-y2) < (x2-x1) )   ; → :x2 < x1
    {
        ; Send "^v"
        send "^{TAB}"
    }
    else if (abs(x1-x2) < (y2-y1) and (y2-y1) > allow_distance * 3) ; ↓ :y2 > y1 (pretect)
    {
        Send "^w"
    }
    else if (abs(x1-x2) < (y1-y2) and (y1-y2) > allow_distance) ; ↑ :y2 < y1
    {
        Send "^c"
    }
    else   ; No Move
    {
        Send "^{LBUTTON}"
    }
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 🧱Hot String For Python
; https://wyagd001.github.io/v2/docs/Hotstrings.htm#Options

f(file_name,callback_send:="",encoding:="UTF-8")
{
    ClipData := FileRead(file_name, encoding)
    A_Clipboard :=
    A_Clipboard := ClipData
    ClipWait(2)
    Send "^v"

    if callback_send
        sleep 50
        Send callback_send
}


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 🧱Live Template
:X:fahelp::f(SCRIPT_ROOT_PATH "hotstr\help.txt")
:X:fagen::f(SCRIPT_ROOT_PATH "gen_vbs.py")
:X:favbs::f(SCRIPT_ROOT_PATH "gen_vbs.py")

; for simple string
::ipip::
{
    A_Clipboard := ""
    Run python "-c `"import httpx, pyperclip as p;result = httpx.get('http://httpbin.org/get').json()['origin'];p.copy(result)`"",, "hide"

    ClipWait(5)
    Send A_Clipboard
}


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
    raw_cmd := Format(
        "import urllib.request, pyperclip as p; result = urllib.request.urlopen('{1}').read().decode('utf-8'); p.copy(result)",
        fake_data_url
    )
    cmd := Format(
        python_c '"{1}"',
        raw_cmd
    )
    ; Inputbox ,,,cmd
    Run cmd,, "hide"
    ClipWait(5)
    Send "^v"
}



; ::faen::.encode("utf-8")
; ::fade::.decode("utf-8")
::fado:: -i https://pypi.douban.com/simple  ;; DouBan repo for pip
::faqi:: -i https://pypi.tuna.tsinghua.edu.cn/simple ;; TsingHua repo for pip
::faspace::‏‏‎ ‎
:X:faip::Send("127.0.0.1")


; for windows HARD PRESS
:*x:tata::Run("taskmgr")
:X:fajs::f(SCRIPT_ROOT_PATH "hotstr\js.py")        ; tamper(js)
:X:fadebug::f(SCRIPT_ROOT_PATH "hotstr\debug.py")  ; debug in webbrowser
:X:fapan::f(SCRIPT_ROOT_PATH "hotstr\pan.py")      ; sense  (bdp)
:X:famain::f(SCRIPT_ROOT_PATH "hotstr\main.py")
:X:faclip::f(SCRIPT_ROOT_PATH "hotstr\clip.py")
:X:fatask::f(SCRIPT_ROOT_PATH "hotstr\taskfind.py") ; if taskfind can findstr
:X:fadt::send(FormatTime(A_Now, "yyyy-MM-dd"))   ; by AHK
:X:fadate::f(SCRIPT_ROOT_PATH "hotstr\date.py")    ; date (Bash)
:X:fadatetime::f(SCRIPT_ROOT_PATH "hotstr\datetime.py")    ; datetime (python)
:X:fatable::f(SCRIPT_ROOT_PATH "hotstr\table.py")  ; datetable
:X:fapen::f(SCRIPT_ROOT_PATH "hotstr\pen.py")      ; pendulum
:X:falinsh::f(SCRIPT_ROOT_PATH "hotstr\linsh.py")
:X:falinp::f(SCRIPT_ROOT_PATH "hotstr\linp.py")
:X:fabdtool::f(SCRIPT_ROOT_PATH "hotstr\bdtool.py")
:X:faflask::f(SCRIPT_ROOT_PATH "hotstr\flask.py")
:X:fafastapi::f(SCRIPT_ROOT_PATH "hotstr\fastapi.py")     ; translate main
:X:fatrans::f(SCRIPT_ROOT_PATH "tool\old_translator\translate.py") ; translate
:X:famail::f(SCRIPT_ROOT_PATH "hotstr\mail.py")    ; mail
:X:fareq::f(SCRIPT_ROOT_PATH "hotstr\req.py")      ; httpx
:X:faproxy::f(SCRIPT_ROOT_PATH "hotstr\proxy.py")  ; toggle winos proxy, and ALT & 3
:X:fatext::f(SCRIPT_ROOT_PATH "hotstr\text.py")    ; extract text from html
:X:fawc::f(SCRIPT_ROOT_PATH "hotstr\wc.py")        ; wordcloud
:X:fajieba::f(SCRIPT_ROOT_PATH "hotstr\jieba.py")  ; jieba
:X:fahyper::f(SCRIPT_ROOT_PATH "hotstr\hyper.py")  ; hyper link for MS
:X:facap::f(SCRIPT_ROOT_PATH "hotstr\cap.py")      ; ddddocr
:X:fazhihu:: f(SCRIPT_ROOT_PATH "hotstr\zhihu.py") ; zhihu slide cap
:X:faconf::f(SCRIPT_ROOT_PATH "hotstr\conf.py")    ; ConfParser
:X:fash::f(SCRIPT_ROOT_PATH "hotstr\sh.py")        ; all shell bottom show
:X:faexe::f(SCRIPT_ROOT_PATH "hotstr\exe.py")      ; compile exe
:X:fadeco::f(SCRIPT_ROOT_PATH "hotstr\decorator.py") ; decorator
:X:fapypi::f(SCRIPT_ROOT_PATH "hotstr\pypi.py")    ; pypi
:X:fawith::f(SCRIPT_ROOT_PATH "hotstr\with.py")   ; with
:X:falog::f(SCRIPT_ROOT_PATH "hotstr\log.py")   ; log
:X:faen::f(SCRIPT_ROOT_PATH "hotstr\en.py")   ; faen
:X:famd::f(SCRIPT_ROOT_PATH "hotstr\md.py")   ; famd
:X:faweb::f(SCRIPT_ROOT_PATH "hotstr\web.py")   ; faweb (webbrowser: chrome --incognito)
:X:fatoml::f(SCRIPT_ROOT_PATH "hotstr\toml.py")   ; toml template

; ----------------- for rs
:X:rsm::f(SCRIPT_ROOT_PATH "hotstr\rs\main.rs", "{UP}{TAB}")   ; main
:X:rsmain::f(SCRIPT_ROOT_PATH "hotstr\rs\main.rs", "{UP}{TAB}")   ; main


;;;;;; powershell
:X:fatime:: f(SCRIPT_ROOT_PATH "hotstr\avg_time.py")      ; avg time

;;;;;; bigdata
:X:famaven:: f(SCRIPT_ROOT_PATH "hotstr\maven.py")       ; maven
:X:faspark:: f(SCRIPT_ROOT_PATH "hotstr\spark.py")       ; spark
:X:fapyspark:: f(SCRIPT_ROOT_PATH "hotstr\pyspark.py")   ; pyspark
:X:faairflow:: f(SCRIPT_ROOT_PATH "hotstr\airflow.py")   ; airflow


:X:fafa::f(SCRIPT_ROOT_PATH "tool\fafd.py") ; fa+fd
:X:fam3u8::f(SCRIPT_ROOT_PATH "app\m3u8\m3u8_download.py")   ; m3u8
:X:fahigh::f(SCRIPT_ROOT_PATH "app\m3u8\high_download.py")   ; high
:X:faarch::f(SCRIPT_ROOT_PATH "app\m3u8\arch_download.py")   ; arch
:X:faarch1::f(SCRIPT_ROOT_PATH "app\m3u8\arch1_download.py")   ; arch
:X:faverge::f(SCRIPT_ROOT_PATH "tool\verge.py")   ; verge

;;;;;;;;;;;;;;;;;;;;;;;; 🧱Tools For Python
; headers kv-pair string  =>  python-dict format
#h::Run subl SCRIPT_ROOT_PATH "config\application.cfg",,"Hide"
#j::Run python SCRIPT_ROOT_PATH "tool\headers_to_dict.py",, "Hide"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 🧱Hot String For WinAPP (Global FA)  (No GUI)
!t::run_pwsh()
>!P::run_pwsh()
!`::
{
    static __TERMINAL_TOGGLE_REF := False
    toggle_window(
        "ahk_class CASCADIA_HOSTING_WINDOW_CLASS", 
        &__TERMINAL_TOGGLE_REF,
        run_pwsh
    )
}

run_pwsh(){
    ; if (A_IsAdmin) {
    ;     Run("wt.exe pwsh.exe /nologo")
    ; } else {
    ;     ; Run("*RunAs wt.exe pwsh.exe /nologo")
    ;     Run("pwsh /nologo")
    ; }
    open_cmd(open_mode:=1) ; powershell
}

toggle_window(win_title, &toggle_variable_ref, app_start_func){
    DetectHiddenWindows True
    if !WinExist(win_title){
        app_start_func()
        toggle_variable_ref := True
        return
    }
    if toggle_variable_ref {
        WinHide(win_title)
        toggle_variable_ref := False
    }
    else{
        WinShow(win_title)
        Winactivate(win_title)
        toggle_variable_ref := True
    }
}

~<!w::
:*x:fach::Run(
    "C:\Program Files\Google\Chrome\Application\chrome.exe"
    " --start-fullscreen chrome-extension://dbepggeogbaibhgnhhndojpepiihcmeb/pages/completion_engines.html"
)

; anonymous
<!+w::
:*x:fach::Run(
    "C:\Program Files\Google\Chrome\Application\chrome.exe"
    " --incognito www.google.com"
)

^e::
:*x:faed::Run("C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe")

<!q::
:*x:fasb::Run(subl)

; ;;;;;;;;;;; 📄File (No GUI)
:*x:fdHo::RUN(subl "C:\Windows\System32\drivers\etc\hosts")
:*x:fdPo::RUN(subl "C:\Users\96338\Documents\PowerShell\Microsoft.PowerShell_profile.ps1")
:*x:fdSS::RUN(subl "E:\app\ssr\ss_conf_command\ssr.txt")


;; ffff ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ⌨ KeyMap For (FA and FD)
^1::{
    GUI_APP.Show("AutoSize Maximize")
}
^2::{
    GUI_FD.Show("AutoSize Maximize")
}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  🅰️ APP(FA)
win_close(*){
    WinClose()
}

GUI_APP := Gui("+Resize", "APP(FA)")
; GUI_APP.Opt("AlwaysOnTop -Border")  ; "-Border" => FullScreend

GUI_APP.OnEvent("ContextMenu", win_close)
GUI_APP.OnEvent("Escape", win_close)

GUI_APP.Add("Picture", "x0 y0", APP_BACKGROUND_IMAGE_APP)

GUI_APP.setFont("s15 bold")
GUI_APP.MarginY := -2
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 🗂️ DIR(FD)
GUI_FD := Gui("+Resize", "DIR(FD)")
; GUI_APP.Opt("AlwaysOnTop -Border")  ; "-Border" => FullScreen
GUI_FD.OnEvent("ContextMenu", win_close)
GUI_FD.OnEvent("Escape", win_close)
GUI_FD.Add("Picture", "x0 y0", APP_BACKGROUND_IMAGE_FOLDER)

GUI_FD.setFont("s45 bold")
GUI_FD.MarginY := -2
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
add_pic(num,icon_path, pix:=130,pad_x:=18,pad_y:=1,col_num:=9){
    ; num 0-based
    x := Mod(num,col_num) * (pix+pad_x)
    y := num//col_num * (pix+pad_y)

    return GUI_APP.Add(  ;; 👆GUI_APP (Global)
        "Picture",
        FORMAT("x{1} y{2} w{3} h{4} CAqua +BackgroundBlack", x, y, pix,pix),
        icon_path
    )
}

add_text(num,content, pix_w:=422, pix_h:=80,pad_x:=20,pad_y:=5,col_num:=3){
    ; num 1-based
    x := Mod(num,col_num) * (pix_w+pad_x)
    y := num//col_num * (pix_h+pad_y) ; 16th: next line  (15 per line)

    return GUI_FD.Add( ;; 👆GUI_FD (Global)
        "Text",
        FORMAT("x{1} y{2} w{3} h{4} CAqua +BackgroundBlack Center", x, y, pix_w,pix_h),
        content
    )
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 🛠️ GUI APP|FD Parse Config
add_item_config(index, path, icon_or_text, is_app)
{
    open_event(args*){
        micro_tag := "$USER"
        __path := path
        if InStr(path, micro_tag)
            __path := StrReplace(path, micro_tag, "C:\Users\" A_UserName)
        Run("open " __path) 
        WinClose()

        ; Error: Failed attempt to launch program or document:
        ; Action: <`"E:/app/Clash.Verge/Clash Verge.exe`">
    }
    ; :*x:fsTr::fsTr
    control_obj := is_app ? add_pic(index,icon_or_text) : add_text(index,icon_or_text)
    control_obj.OnEvent("Click", open_event)
    ; bind for below hwnd  (OnMessage) 👇
    control_obj.path := path
}
; MButton (only works in AHK GUI)
OnMessage 0x020A, WM_MOUSEWHEEL   ; WM_MOUSEWHEEL := 0x020A 🖱 
WM_MOUSEWHEEL(wParam, lParam, msg, hwnd)
{   
    thisGuiControl := GuiCtrlFromHwnd(hwnd)

    try
        this_gui_control_path := thisGuiControl.path  ; 👆
    catch
        return

    SplitPath(  ; split only support \ for File,  / for URL
        strreplace(this_gui_control_path, "/", "\"), , &current_dir
    )
    RUN "explorer.exe " current_dir
    WinClose()
}

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

