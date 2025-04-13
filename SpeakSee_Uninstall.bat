@echo off
setlocal enabledelayedexpansion

title 🚀 SpeakSee Clean Uninstall - Monty Ultra Edition
color 0A

:: ========== ASCII Banner ==========
echo.
echo =====================================================
echo 🔥🔥🔥 SpeakSee Clean Uninstall - Monty Ultra Edition 🔥🔥🔥
echo =====================================================
echo        .-"      "-.
echo       /            \
echo      |              |
echo      |,  .-.  .-.  ,|
echo      | )(_o/  \o_)( |
echo      |/     /\     \|
echo      (_     ^^     _)
echo       \__|IIIIII|__/
echo        | \IIIIII/ |
echo        \          /
echo         `--------`
echo =====================================================
echo.

:: ========== Fake Loading Effect ==========
call :loading "Initializing sequence"
call :loading "Establishing connection with uninstall core"
call :loading "Preparing environment cleanup"

:: ========== Save current directory ==========
set "CURRENT_DIR=%~dp0"

:: ========== Step 1: Uninstall pip packages ==========
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

call :loading "Sweeping pip dust"

:: ========== Step 2: Clean pip cache ==========
echo 🧹 Step 2: Cleaning pip cache...
echo --------------------------------
pip cache purge >nul
echo ✅ Pip cache cleaned.
echo.

:: ========== Step 3: Remove Python env vars ==========
echo 🗑️ Step 3: Removing Python environment variables...
echo ---------------------------------------------------
setx PYTHONPATH "" >nul
echo ✅ PYTHONPATH cleared.

echo ⚠️  PATH variable not auto-modified for safety.
echo 🚀 Pro Tip: You can manually check your system PATH.
echo Opening Environment Variables window for you...
start rundll32 sysdm.cpl,EditEnvironmentVariables
echo.

call :loading "Purging traces of environment links"

:: ========== Step 4: Kill SpeakSee.exe if running ==========
echo 💀 Step 4: Terminating SpeakSee.exe if running...
echo -------------------------------------------------
taskkill /f /im SpeakSee.exe >nul 2>&1
echo ✅ SpeakSee.exe terminated (if it was running).
echo.

call :loading "Verifying termination protocol"

:: ========== Step 5: Prepare self-destruct ==========
echo 🗂️ Step 5: Preparing to delete SpeakSee folder...
echo -------------------------------------------------
set "DELETE_SCRIPT=%temp%\delete_me.bat"
echo @echo off > "%DELETE_SCRIPT%"
echo ping 127.0.0.1 -n 3 >nul >> "%DELETE_SCRIPT%"
echo rmdir /s /q "%CURRENT_DIR%" >> "%DELETE_SCRIPT%"
echo del "%%~f0" >> "%DELETE_SCRIPT%"
echo exit >> "%DELETE_SCRIPT%"
echo ✅ Self-deletion script prepared.
echo.

:: ========== Mission Accomplished Screen ==========
call :loading "Finalizing operation"
echo.
echo ============================
echo ✅ Mission Accomplished ✅
echo ============================
echo SpeakSee and its dependencies have been terminated.
echo System is clean. Python remains intact.
echo Stay legendary. 🖤
echo.

:: ========== Step 6: Self-destruct ==========
echo 🧨 Step 6: Self-destructing like a pro...
echo ------------------------------------------
call "%DELETE_SCRIPT%"

exit

:: ========== Loading Function ==========
:loading
setlocal
set "message=%~1"
set "dots="
for /L %%i in (1,1,3) do (
    set "dots=!dots!."
    <nul set /p ="%message%!dots! "
    ping 127.0.0.1 -n 1 >nul
)
echo Done!
endlocal
exit /b
