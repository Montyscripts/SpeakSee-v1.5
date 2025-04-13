@echo off
setlocal enabledelayedexpansion

echo ============================
echo 🔥 SpeakSee + Python Clean Uninstall 🔥
echo ============================

REM Save current directory (folder where this .bat is located)
set "CURRENT_DIR=%~dp0"

echo.
echo 📦 Step 1: Uninstalling all pip packages...
pip freeze > "%CURRENT_DIR%piplist.txt"
for /F "delims=" %%i in (%CURRENT_DIR%piplist.txt) do (
    echo Uninstalling %%i ...
    pip uninstall -y %%i
)
del "%CURRENT_DIR%piplist.txt"

echo.
echo 🧹 Step 2: Cleaning pip cache...
pip cache purge

echo.
echo 🗑️ Step 3: Removing Python environment variables...
setx PYTHONPATH "" >nul

REM Attempt to clean PATH entries with Python
(for /F "tokens=1,* delims==" %%a in ('set PATH') do (
    echo %%b | findstr /I "Python" >nul
    if errorlevel 1 (
        set "newPath=%%b"
        setx PATH "%%b" >nul
    )
)) 2>nul

echo.
echo 💀 Step 4: Killing SpeakSee.exe if running...
taskkill /f /im SpeakSee.exe >nul 2>&1

echo.
echo 🗂️ Step 5: Deleting SpeakSee folder (where this script lives)...

REM Move up to root to safely delete folder
cd /
rmdir /s /q "%CURRENT_DIR%"

echo.
echo 🧨 Step 6: Self-destructing script...

REM Create a temporary self-deletion script
echo @echo off > "%temp%\delete_me.bat"
echo ping 127.0.0.1 -n 3 >nul >> "%temp%\delete_me.bat"
echo del "%~f0" >> "%temp%\delete_me.bat"
echo del "%%~f0" >> "%temp%\delete_me.bat"
echo exit >> "%temp%\delete_me.bat"

REM Run the self-deletion script
call "%temp%\delete_me.bat"

exit
