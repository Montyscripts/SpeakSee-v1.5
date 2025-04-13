@echo off
setlocal enabledelayedexpansion

title 🚀 SpeakSee Clean Uninstall - Monty Signature Edition
color 0A

echo ============================
echo 🔥 SpeakSee Clean Uninstall 🔥
echo 🧩 Monty Signature Edition 🧩
echo ============================
echo.

REM Save current directory (folder where this .bat is located)
set "CURRENT_DIR=%~dp0"

echo 📦 Step 1: Uninstalling all pip packages...
echo --------------------------------------------
pip freeze > "%CURRENT_DIR%piplist.txt"
for /F "delims=" %%i in (%CURRENT_DIR%piplist.txt) do (
    echo 🔧 Uninstalling %%i ...
    pip uninstall -y %%i >nul
)
del "%CURRENT_DIR%piplist.txt"
echo ✅ All pip packages removed.
echo.

echo 🧹 Step 2: Cleaning pip cache...
echo --------------------------------
pip cache purge >nul
echo ✅ Pip cache cleaned.
echo.

echo 🗑️ Step 3: Removing Python environment variables...
echo ---------------------------------------------------
setx PYTHONPATH "" >nul
echo ✅ PYTHONPATH cleared.

echo ⚠️ Note: PATH variable not auto-modified for safety.
echo 🚀 Pro Tip: You can manually check your system PATH.
echo Opening Environment Variables window for you...
start rundll32 sysdm.cpl,EditEnvironmentVariables
echo.

echo 💀 Step 4: Killing SpeakSee.exe if running...
echo ---------------------------------------------
taskkill /f /im SpeakSee.exe >nul 2>&1
echo ✅ SpeakSee.exe terminated (if it was running).
echo.

echo 🗂️ Step 5: Preparing to delete SpeakSee folder...
echo -------------------------------------------------
REM Create a temporary self-deletion script
set "DELETE_SCRIPT=%temp%\delete_me.bat"
echo @echo off > "%DELETE_SCRIPT%"
echo ping 127.0.0.1 -n 3 >nul >> "%DELETE_SCRIPT%"
echo rmdir /s /q "%CURRENT_DIR%" >> "%DELETE_SCRIPT%"
echo del "%%~f0" >> "%DELETE_SCRIPT%"
echo exit >> "%DELETE_SCRIPT%"
echo ✅ Self-deletion script prepared.
echo.

echo 🧨 Step 6: Self-destructing like a pro...
echo ------------------------------------------
echo 💡 Tip: If folder remains, make sure no files are in use.
call "%DELETE_SCRIPT%"

exit
