@echo off

echo ------------------------------------------
echo git_config.cmd - Git configuration Script
echo ------------------------------------------

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Script config
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

set "GIT_USERNAME=osamucaaaa"
set "GIT_EMAIL=osamucaaaa@gmail.com"

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Clear existing config and attributes files
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:userinput_clearconfig
:: CLEAR GLOBAL CONFIG
echo.
echo Do you want to clear your global config? [y]es or [n]o (default)?
set /p input=
if [%input%]==[y] goto :clear_config
if [%input%]==[n] goto :userinput_clearattributes
if [%input%]==[] goto :userinput_clearattributes
call error %input% is not valid at this time. y or n expected...
goto :userinput_clearconfig

:clear_config
if exist %HOME%\.gitconfig del %HOME%\.gitconfig

:userinput_clearattributes
:: CLEAR GLOBAL ATTRIBUTES
echo.
echo Do you want to clear your global attributes? [y]es or [n]o (default)?
set /p input=
if [%input%]==[y] goto :clear_attributes
if [%input%]==[n] goto :config
if [%input%]==[] goto :config
call error %input% is not valid at this time. y or n expected...
goto :userinput_clearattributes

:clear_attributes
if exist %HOME%\.gitattributes del %HOME%\.gitattributes


:config

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: User ID
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
echo.
echo.
echo --- USER ID ---
echo.
echo Git User: %GIT_USERNAME% (%GIT_EMAIL%)
git config --global user.name "%GIT_USERNAME%"
git config --global user.email "%GIT_EMAIL%"
git config --global commiter.name

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Merge/pull/diff behaviour
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
echo.
echo.
echo --- MERGE/PULL/DIFF BEHAVIOUR ---
echo.
echo Fast-forward settings:
echo   merge -^> true
echo   pull -^> only

git config --global merge.ff true
git config --global pull.ff only

echo.
echo Line endings: Autocrlf turned ON
git config --global core.autocrlf true

:: Display file/change prefixes in diffs that are not as generic as a and b (dafault), but more descriptive.
:: E.g. w and i when comparing (w)orking copy and (i)ndex
git config --global diff.mnemonicprefix true

:: Disable "how to stage/unstage/add" hints given by 'git status'
git config --global advice.statusHints false

echo.
echo Enabled RERERE utility to auto-resolve conflicts

:: Enable recording of resolved conflicts, so that identical hunks can be resolved automatically if they appear again
git config --global rerere.enabled true

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: External tools
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
echo.
echo.
echo --- EXTERNAL TOOLS ---
echo.
echo Text editor: micro
git config --global core.editor micro

:: DIFFTOOL/MERGETOOL
git config --global mergetool.keepBackup false

:p4merge
set "P4_PATH=%programfiles%\Perforce\p4merge.exe"
if not exist "%P4_PATH%" ( goto :meld )
echo Text diff/merge: p4merge
git config --global diff.tool p4merge
git config --global difftool.p4merge.path "%P4_PATH%"
git config --global merge.tool p4merge
git config --global mergetool.p4merge.path "%P4_PATH%"
goto :aliases

:meld
call in-path meld || goto :aliases
echo Text diff/merge: meld

:: Meld as difftool
git config --global diff.tool meld
git config --global difftool.meld.path "%programfiles(x86)%\Meld\Meld.exe"
git config --global difftool.prompt false
git config --global difftool.meld.cmd "meld $LOCAL $REMOTE"

:: Meld as mergetool
git config --global merge.tool meld
git config --global merge.conflictstyle diff3
git config --global mergetool.meld.path "%programfiles(x86)%\Meld\Meld.exe"
git config --global mergetool.meld.cmd "meld $LOCAL $BASE $REMOTE -o $MERGED --diff $BASE $LOCAL --diff $BASE $REMOTE --auto-merge"


:aliases
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Aliases
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

echo.
echo.
echo --- ALIASES ---
echo.
echo   lg		- oneline pretty graph log
echo   last		- last commit -^> more info
echo   st		- short status
echo   amenda	- amend + reuse last message
echo.
echo   a		- add
echo   r		- reset
echo   br		- branch
echo   bra		- all branches
echo   co		- checkout
echo   c		- commit
echo   m		- merge
echo   f		- fetch
echo   pick		- cherry-pick
echo   publish	- push branch + tags + set upstream-branch


:: Aliases that change the desired behaviour
git config --global alias.lg "log --graph '--pretty=format:%%C(auto,bold yellow)%%h %%C(green)%%<(12,trunc)%%aN %%C(cyan)(%%<(8,trunc)%%ar) %%C(reset)%%s%%C(auto)%%gD%% D'"
git config --global alias.st "status -s -b"
git config --global alias.last "log '--pretty=format:%%C(bold yellow)commit %%H%%C(auto)%%n%%C(green)%%aN <%%cE> %%C(cyan)(%%ar) %%n%%C(reset)%%B' --stat -1 HEAD"

:: Aliases that just shorten existing commands
git config --global alias.a add
git config --global alias.r reset
git config --global alias.br branch
git config --global alias.bra "branch -a"
git config --global alias.co checkout
git config --global alias.c commit
git config --global alias.m merge
git config --global alias.f fetch
git config --global alias.pick cherry-pick
git config --global alias.amenda "amend -a -C HEAD"

:: Publish alias (only works with delayed expansion enabled and exclamationpoint escaped)
setlocal enabledelayedexpansion
set "testvar="^^!git push --follow-tags --set-upstream origin \"$(git rev-parse --abbrev-ref HEAD)\"""
setlocal disabledelayedexpansion
git config --global alias.publish %testvar%


:coloring
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Coloring
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

echo.
echo.
echo --- COLORING ---
echo.
echo UI Color: auto
echo.

git config --global color.ui auto
