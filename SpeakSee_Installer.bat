@echo off
:: SpeakSee Automatic Installer
:: This batch file will auto-elevate to admin and install everything needed

:: Check if we're already running as admin, if not relaunch as admin
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    echo Requesting administrator privileges...
    set UACScript=%temp%\~getadmin.vbs
    echo Set UAC = CreateObject^("Shell.Application"^) > "%UACScript%"
    echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%UACScript%"
    "%temp%\~getadmin.vbs"
    del "%UACScript%"
    exit /B
)

:: Set up console window
title SpeakSee Automatic Installer
color 0a
mode con: cols=80 lines=30

:: Display welcome message
echo ########################################################
echo #           SpeakSee Automatic Installer               #
echo # This will automatically:                             #
echo # 1. Install Python if needed                          #
echo # 2. Install all required packages                     #
echo # 3. Create the SpeakSee executable                    #
echo #                                                      #
echo # Please wait while the installer runs...              #
echo ########################################################
echo.

:: Set error handling
setlocal enabledelayedexpansion
set "PYTHONURL=https://www.python.org/ftp/python/3.9.7/python-3.9.7-amd64.exe"
set "PYTHONINSTALLER=%temp%\python_installer.exe"
set "SUCCESS=1"

:: Function to display error and pause
:error
echo ERROR: %~1
echo.
pause
exit /b 1

:: Check if Python is installed
where python >nul 2>&1
if %errorLevel% neq 0 (
    echo Python not found. Installing Python...
    echo.
    
    :: Download Python installer
    echo Downloading Python installer...
    powershell -Command "(New-Object Net.WebClient).DownloadFile('%PYTHONURL%', '%PYTHONINSTALLER%')"
    if not exist "%PYTHONINSTALLER%" (
        call :error "Failed to download Python installer"
        set "SUCCESS=0"
        goto :install_end
    )
    
    :: Install Python silently with pip and add to PATH
    echo Installing Python (this may take a few minutes)...
    start /wait "" "%PYTHONINSTALLER%" /quiet InstallAllUsers=1 PrependPath=1 Include_pip=1
    del "%PYTHONINSTALLER%"
    
    :: Verify Python installation
    where python >nul 2>&1
    if %errorLevel% neq 0 (
        call :error "Python installation failed. Please install Python manually from python.org"
        set "SUCCESS=0"
        goto :install_end
    )
    echo Python installed successfully.
    echo.
) else (
    echo Python is already installed.
    echo.
)

:: Refresh PATH to ensure Python is available
for /f "tokens=2*" %%a in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v Path ^| findstr /i "Path"') do (
    set "SYSTEMPATH=%%b"
)
set "PATH=%SYSTEMPATH%"

:: Check if pip is available
python -m pip --version >nul 2>&1
if %errorLevel% neq 0 (
    call :error "pip not found. Please ensure Python is installed correctly."
    set "SUCCESS=0"
    goto :install_end
)

:: Install required packages
echo Installing required Python packages...
echo This may take a few minutes depending on your internet speed...
echo.

:: Upgrade pip first
python -m pip install --upgrade pip --disable-pip-version-check
if %errorLevel% neq 0 (
    call :error "Failed to upgrade pip"
    set "SUCCESS=0"
    goto :install_end
)

:: Install packages with progress feedback
echo Installing PyInstaller...
python -m pip install pyinstaller --disable-pip-version-check
if %errorLevel% neq 0 set "SUCCESS=0"

echo Installing Pillow (for image handling)...
python -m pip install pillow --disable-pip-version-check
if %errorLevel% neq 0 set "SUCCESS=0"

echo Installing pyttsx3 (for text-to-speech)...
python -m pip install pyttsx3 --disable-pip-version-check
if %errorLevel% neq 0 set "SUCCESS=0"

echo Installing SpeechRecognition...
python -m pip install SpeechRecognition --disable-pip-version-check
if %errorLevel% neq 0 set "SUCCESS=0"

echo Installing screeninfo...
python -m pip install screeninfo --disable-pip-version-check
if %errorLevel% neq 0 set "SUCCESS=0"

echo Installing pygame (for sound effects)...
python -m pip install pygame --disable-pip-version-check
if %errorLevel% neq 0 set "SUCCESS=0"

if "%SUCCESS%"=="0" (
    call :error "Some packages failed to install. The application may not work properly."
    goto :install_end
)

echo.
echo All Python packages installed successfully.
echo.

:: Check for required files
if not exist "SpeakSee.py" (
    call :error "SpeakSee.py not found in the current directory."
    set "SUCCESS=0"
    goto :install_end
)

:: Create list of missing files
set "MISSINGFILES="
if not exist "Icon.png" set "MISSINGFILES=!MISSINGFILES! Icon.png"
if not exist "Button.mp3" set "MISSINGFILES=!MISSINGFILES! Button.mp3"
if not exist "Click.mp3" set "MISSINGFILES=!MISSINGFILES! Click.mp3"
if not exist "Hover.mp3" set "MISSINGFILES=!MISSINGFILES! Hover.mp3"
if not exist "Wallpaper.png" set "MISSINGFILES=!MISSINGFILES! Wallpaper.png"
if not exist "Button.png" set "MISSINGFILES=!MISSINGFILES! Button.png"

if not "!MISSINGFILES!"=="" (
    echo WARNING: The following files are missing:!MISSINGFILES!
    echo Some features may not work properly.
    echo.
)

:: Run PyInstaller
echo Creating SpeakSee executable...
echo This may take a few minutes...
echo.

pyinstaller --onefile --noconsole --icon=Icon.png --add-data "Button.mp3;." --add-data "Click.mp3;." --add-data "Hover.mp3;." --add-data "icon.png;." --add-data "Wallpaper.png;." --add-data "Button.png;." SpeakSee.py

if not exist "dist\SpeakSee.exe" (
    call :error "Executable creation failed. Please check for errors above."
    set "SUCCESS=0"
    goto :install_end
)

:install_end
if "%SUCCESS%"=="1" (
    echo.
    echo ########################################################
    echo #               INSTALLATION COMPLETE!                 #
    echo #                                                     #
    echo # The SpeakSee executable has been created in the      #
    echo # 'dist' folder.                                      #
    echo #                                                     #
    echo # You can now run SpeakSee.exe to use the application. #
    echo ########################################################
    
    :: Create desktop shortcut
    set "DESKTOP=%USERPROFILE%\Desktop\SpeakSee.lnk"
    set "TARGET=%~dp0dist\SpeakSee.exe"
    set "ICON=%~dp0Icon.png"
    
    echo.
    set /p CREATESHORTCUT="Create desktop shortcut? (Y/N): "
    if /i "%CREATESHORTCUT%"=="Y" (
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
    )
)

echo.
echo Installation process finished.
echo You can close this window now.
pause
