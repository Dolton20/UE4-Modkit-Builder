@echo off
SET /p "gameName=game name: "
echo Example Unreal Engine Path: C:\Program Files\Epic Games\UE_4.22\Engine\Binaries\Win64
echo Version must match game version
SET /p "editorPath=Unreal Engine: "
echo Example Version: 4.22
SET /p "editorVersion=Unreal Engine Version: "

:: Create Game Folder
md %gameName%

:: Create cook_assets.bat
echo SET "ddp=%%~dp0" > cook_assets.bat
echo SET "ddp=%%ddp:~0,-1%%" >> cook_assets.bat
echo. >> cook_assets.bat
echo SET /p editorPath= ^< Tools\user_settings\editor_directory.txt >> cook_assets.bat
echo. >> cook_assets.bat
echo del /S %gameName%\*.uasset >> cook_assets.bat
echo del /S %gameName%\*.ubulk >> cook_assets.bat
echo del /S %gameName%\*.uexp >> cook_assets.bat
echo del /S %gameName%\*.umap >> cook_assets.bat
echo del /S %gameName%\*.ufont >> cook_assets.bat
echo. >> cook_assets.bat
echo "%%editorPath%%\UE4Editor-Cmd.exe" "%%ddp%%\UE4Project\%gameName%.uproject" -run=cook -targetplatform=WindowsNoEditor >> cook_assets.bat
echo. >> cook_assets.bat
echo robocopy /job:Tools\configs\copy_cooked_assets >> cook_assets.bat
echo. >> cook_assets.bat
echo robocopy /S Precooked %gameName% >> cook_assets.bat

:: Create package.bat
echo SET /p packageOutput= ^< Tools\user_settings\package_output.txt > package.bat
echo python Tools\py\u4pak.py pack "%%packageOutput%%" %gameName% -p >> package.bat

:: Create pack_compressed.bat
echo cd.. > Tools\pack_compressed.bat
echo python Tools\py\u4pak.py pack "Tools\compressed_pack.pak" %gameName% -z -p >> Tools\pack_compressed.bat

:: Create copy_cooked_assets.rcj
echo /SD:UE4Project\Saved\Cooked\WindowsNoEditor\%gameName%\Content > Tools\configs\copy_cooked_assets.rcj
echo /DD:%gameName%\Content >> Tools\configs\copy_cooked_assets.rcj
echo /s >> Tools\configs\copy_cooked_assets.rcj
echo /XF >> Tools\configs\copy_cooked_assets.rcj
echo Excluded_File_Example.txt >> Tools\configs\copy_cooked_assets.rcj

:: Create editor_directory.txt
echo %editorPath% > Tools\user_settings\editor_directory.txt

:: Create .uproject
del UE4Project\*.uproject
echo { "FileVersion": 3, "EngineAssociation": "%editorVersion%", "Category": "", "Description": "Unreal Engine Modkit", "Modules": [] } > UE4Project\%gameName%.uproject

start cmd /c "echo Before using configure Tools\user_settings\package_output.txt & PAUSE"
del /s setup.bat >nul 2>nul