#########################################################################################
# [Private Closed]
# => inputsuggestions
# => ...
# ## for PSFZF and other scripts (Note: must Quit and Open AHKv2, instead of Reload AHK)
# set-ExecutionPolicy Unrestricted
# Set-ExecutionPolicy RemoteSigned
# ## Scoop
# iex (new-object net.webclient).downloadstring('https://get.scoop.sh')
# ## Install Tool
# scoop install aria2
# scoop install busybox
# scoop install bat
# scoop install fzf
# scoop install ripgrep
# 
# scoop install git
# scoop bucket add extras    
# scoop install PSFzf
# 
# ## Install autojump & autowalk  (https://github.com/linusic/autojump/blob/master/README.md)
# git clone https://github.com/linusic/autojump.git
# pip install autowalk
# subl ~/.autowalk.cfg   # ... change recursion_depth & recursion_root_list
# aw -a
#
# ## speed up the PWSH (PowerShell Slowly Due to .NET Update)
# Get-ScheduledTask -TaskName '.NET Framework NGEN v4.0.30319 64' | Start-ScheduledTask
#########################################################################################


########## 🧱 Global For PowerShell ( main for RipGrep)
$OutputEncoding = [console]::InputEncoding = [console]::OutputEncoding = [System.Text.Encoding]::GetEncoding(936);

########## for busybox
Get-Alias | ForEach-Object {
    # if ($_.Name -ne "cd")
    if ( ($_.Name -ne "cd") -and ($_.Name -ne "iex") )
    {
        Remove-Item -Path ("Alias:\" + $_.Name) -Force -ErrorAction "SilentlyContinue"
    }
}

########## 🧱 Conda
function get-conda { cmd.exe "/K" D:/miniconda/Scripts/activate.bat D:/miniconda }
Set-Alias conda get-conda

########## 🧱 Command
function cd_c{ cd c:/ }
function cd_d{ cd d:/ }
function cd_e{ cd e:/ }
Set-Alias jc cd_c
Set-Alias jd cd_d
Set-Alias je cd_e

Set-Alias e     explorer.exe
Set-Alias t     taskmgr.exe

function new_clear { "`n" * 100 }
new_clear
Set-Alias clear new_clear

Set-Alias p python
Set-Alias c clip

########## 🧱 VULTR
function vultr_script{ python D:\lab\vultr\vultr\vultr.py $args }
Set-Alias vultr vultr_script

function time_script{ python D:\ahk\hotstr\avg_time.py $args }
Set-Alias time time_script

########## 🧱 autojump
function auto_jump {
    $autojump_script_path = (cd ~ && $pwd.path) + "\AppData\Local\autojump\bin\autojump"

    $args = $args | Out-String
    if (-not $args.StartsWith('-') ) {
        $new_path=(python $autojump_script_path $args)
        if (Test-Path $new_path) {
            cd $new_path
        }
        else {
            echo autojump: directory $args not found
            echo try `autojump --help` for more information
        }
    }
    else{ python "$pwd\autojump" $args }

}

Set-Alias j        auto_jump
$raw_autojump_path = $HOME + "\AppData\Local\autojump\bin\autojump.bat"
Set-Alias autojump $raw_autojump_path

########## 🧱 FZF + PSFZF + RipGrep + Bat
### 🔎 FZF
$Env:FZF_DEFAULT_OPTS='--multi --border=none --bind ctrl-a:select-all,alt-a:deselect-all,alt-n:down,alt-p:up,alt-o:backward-delete-char,alt-h:beginning-of-line,alt-l:end-of-line,alt-j:backward-char,alt-k:forward-char,alt-b:backward-word,alt-f:forward-word --margin=1,0,0,0'


### 🔎 FZF + Bat (File Context Search)
function search(){
    $init_query = ($args | Out-String).Trim()
    subl( rg --line-number --field-match-separator : --no-heading --smart-case "${*:-}" | fzf --query $init_query --delimiter : --preview 'bat --color=always {1}' --preview-window 'up,60%,border-bottom' | python -c "{
        print(':'.join(input().encode('gbk', 'ignore').decode('utf-8', 'ignore').strip().split(':',2)[:2]))
    }" ) | new_clear
}
Set-Alias s search

### 🔎 PSFZF (Ctrl-R) (Depend on "PSReadLineOption" Module)
function clear_history{
    Clear-Content (Get-PSReadLineOption).HistorySavePath
}
Set-Alias clear-history clear_history
Set-Alias fclear        clear_history
Set-Alias fscoop        Invoke-FuzzyScoop
Set-Alias fk            Invoke-FuzzyKillProcess
Set-Alias fkill         Invoke-FuzzyKillProcess


### 🔎 PSFZF (Ctrl+T)(Ctrl+R) (Alt-C)
Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'
# Set-PsFzfOption -TabExpansion Tab
