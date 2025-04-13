Python Installation Instructions (for those missing Python)
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
If you see an error that Python is not installed, follow these steps:

Download Python 3.10.0

Go to the official Python website.

Download Python 3.10.0 (this version is required for the script to work properly).

Install Python:

Run the downloaded installer.

Important: Make sure to check the option to add Python to your PATH during installation.

Finish the Installation:

Follow the on-screen instructions to complete the installation.

Re-run the Installer:

After installing Python 3.10.0, run the SpeakSee_Installer.bat again to continue setting up SpeakSee.

_____________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________
SpeakSee Installation Guide 🎤👀
Follow these simple steps to install SpeakSee on your Windows PC:
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
1️⃣ Download the Files 📥

Download the SpeakSee folder containing:

SpeakSee.py (main program)

SpeakSee_Installer.bat (automatic installer)

Other files (Icon.png, Button.mp3, etc.)

Make sure all files are in the same folder!

2️⃣ Run the Installer 🖱️

Double-click SpeakSee_Installer.bat 🔒 It will automatically request admin rights (click Yes if prompted).

(No need to manually "Run as Administrator"!)

3️⃣ Wait for Installation ⏳

The installer will:

✔ Check Install of Python (if not already installed)

✔ Download & set up all required packages

✔ Build the SpeakSee.exe file

(This may take a few minutes—grab a coffee! ☕)

4️⃣ Find & Run SpeakSee ✅

After installation, you’ll see:

A dist folder containing SpeakSee.exe

(Optional) A desktop shortcut (if you chose "Y")

🚀 Double-click SpeakSee.exe to launch the app!

🎉 Done! Enjoy SpeakSee! 🔊 Use your voice to search the web & YouTube instantly!

❓ Need Help?

Make sure all files are in the same folder.

If errors occur, restart your PC and try again.

Still stuck? Contact support! 📧

🌟 Pro Tip: Want to move the app? Copy the entire dist folder to keep everything working!

_____________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________

SpeakSee - Voice-Activated Search Assistant
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

SpeakSee is a Windows desktop application that simplifies web and YouTube searches using voice commands. With an intuitive interface and customizable features, it allows users to perform hands-free searches quickly and efficiently.

✨ Features
🎤 Voice-Activated Search - Speak your query to search Bing or YouTube

🖥️ Customizable UI - Change wallpapers, icons, colors, and sounds

🔊 Audio Feedback - Custom sound effects for interactions

🕶️ Dark Mode - Native Windows dark title bar support

📱 Responsive Design - Works in both windowed and fullscreen modes

⚙️ Easy Configuration - Modify all visual and audio elements

🛠️ Technologies Used
Python 3 with Tkinter for the GUI

speech_recognition for voice processing

pyttsx3 for text-to-speech

Pillow for image handling

pygame for sound effects

Windows API for dark mode title bar

📦 Installation
Clone this repository

Install dependencies:

bash
Copy
pip install -r requirements.txt
Run main.py

🎮 Usage
Click the main button or press the mic key to start voice search

Say "YouTube" followed by your query to search YouTube

Say anything else to perform a Bing search

Use the ☰ menu to access settings and customization options

📝 Notes
Requires an active internet connection for voice recognition

Works best with Windows 10/11

All sound/image files should be placed in the project directory

Created by Caleb W. Broussard | Version 1.5
