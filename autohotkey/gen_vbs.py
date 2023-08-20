# pip install pywin32 pyperclip -i https://pypi.douban.com/simple

from pathlib import Path
import win32com.client as client

shell = client.Dispatch("WScript.Shell")

AHK_EXEC_PATH = r"D:\ide\autohotkey\AutoHotkey64.exe"
YOUR_AHK = r"D:\ahk\mykey.ahk"

AUTO_START_PATH = str(Path.home() / "AppData/Roaming/Microsoft/Windows/Start Menu/Programs/Startup/ahk.vbs")

# fals: no wait 
# Win11 default vbs not support ' ' and must " "  ;  and command line style lang
Path(AUTO_START_PATH).write_text(f"""\
' Shell.ShellExecute(file, [Arguments], [Directory], [Operation], [Show])
Set sh = CreateObject("Shell.Application") 

' call sh.ShellExecute("{AHK_EXEC_PATH}","{YOUR_AHK}",,, 0)
call sh.ShellExecute("{AHK_EXEC_PATH}","{YOUR_AHK}",,"runas", 0)

"""
)

# create shortcut on DeskTop
LINK_PATH = str(Path.home() / "Desktop/ahk.lnk") # suffix must be .lnk or .url
shortcut = shell.CreateShortCut(LINK_PATH)         # link file path
shortcut.TargetPath = AUTO_START_PATH              # source file path
shortcut.save()

print(f"generate to {AUTO_START_PATH}")
