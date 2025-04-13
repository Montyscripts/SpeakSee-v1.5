@echo off
SETLOCAL ENABLEEXTENSIONS
cd /d "%~dp0"

:: ===============================
:: Auto-run as administrator
:: ===============================
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "cmd.exe", "/c cd ""%~sdp0"" && %~s0", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /b
)

echo ########################################################
echo #           SpeakSee Automatic Installer               #
echo # This will automatically:                            #
echo # 1. Install all required packages                     #
echo # 2. Create the SpeakSee executable                    #
echo #                                                      #
echo # Please wait while the installer runs...              #
echo ########################################################

:: ===============================
:: Check internet connection
:: ===============================
echo Checking internet connection...
ping -n 2 google.com >nul
if errorlevel 1 (
    echo Error: No internet connection detected.
    pause
    exit /b 1
)

:: ===============================
:: Check for Python installation
:: ===============================
where python >nul 2>&1
if errorlevel 1 (
    echo Error: Python is not installed. Please install Python from:
    echo https://www.python.org/downloads/
    echo.
    echo Follow the instructions on the Python website to install Python.
    pause
    exit /b 1
)

:: ===============================
:: Upgrade pip, setuptools, and wheel
:: ===============================
echo Upgrading pip, setuptools, and wheel...
python -m pip install --upgrade pip setuptools wheel

:: ===============================
:: Install PyInstaller early
:: ===============================
echo Installing PyInstaller...
python -m pip install pyinstaller

:: ===============================
:: Install PyAudio
:: ===============================
echo Installing PyAudio...
python -m pip install pyaudio

:: ===============================
:: Install required packages
:: ===============================
echo Installing required packages...
python -m pip install -r requirements.txt
if %errorlevel% NEQ 0 (
    echo Failed to install Python packages. Trying manual Pillow installation...

    :: Trying to install Pillow from source
    python -m pip install pillow==9.5.0 --no-binary :all:

    if %errorlevel% NEQ 0 (
        echo ERROR: Failed to install Pillow manually using the source.
        pause
        exit /b 1
    )
)

:: ===============================
:: Create SpeakSee executable
:: ===============================
echo Creating SpeakSee executable...
echo This may take a few minutes...
pyinstaller --onefile --noconsole --icon=Icon.png --add-data "Button.mp3;." --add-data "Click.mp3;." --add-data "Hover.mp3;." --add-data "Icon.png;." --add-data "Wallpaper.png;." --add-data "Button.png;." SpeakSee.py

:: ===============================
:: Check if executable was created
:: ===============================
if not exist "dist\SpeakSee.exe" (
    echo ERROR: Executable creation failed.
    pause
    exit /b 1
)

:: ===============================
:: Done!
:: ===============================
echo.
echo ########################################################
echo #         Installation completed successfully! 🚀      #
echo ########################################################
echo You can now run SpeakSee.exe from the 'dist' folder.
echo.

:: ===============================
:: Ask about desktop shortcut (only if exe exists)
:: ===============================
set /p CREATESHORTCUT="Create desktop shortcut? (Y/N): "
if /i "%CREATESHORTCUT%"=="Y" (
    set "DESKTOP=%USERPROFILE%\Desktop\SpeakSee.lnk"
    set "TARGET=%~dp0dist\SpeakSee.exe"
    set "ICON=%~dp0Icon.png"

    if exist "%TARGET%" (
        echo Creating desktop shortcut...
        set "VBS=%temp%\shortcut.vbs"
        echo Set oWS = WScript.CreateObject("WScript.Shell") > "%VBS%"
        echo sLinkFile = "%DESKTOP%" >> "%VBS%"
        echo Set oLink = oWS.CreateShortcut(sLinkFile) >> "%VBS%"
        echo oLink.TargetPath = "%TARGET%" >> "%VBS%"
        echo oLink.WorkingDirectory = "%~dp0dist" >> "%VBS%"
        echo oLink.IconLocation = "%ICON%" >> "%VBS%"
        echo oLink.Save >> "%VBS%"
        cscript /nologo "%VBS%"
        del "%VBS%"
        echo Shortcut created on your desktop.
    ) else (
        echo ERROR: Cannot create shortcut because SpeakSee.exe was not found.
    )
)

echo.
echo Installation is complete. You can close this window now.
pause
exit /b
