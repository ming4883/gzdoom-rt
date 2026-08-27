@echo off
rem Creates a directory junction from TARGET to SOURCE.
rem Junctions are zero-cost NTFS reparse points - no disk space, no copying.
rem If TARGET already exists as a junction, it is removed and recreated.
rem If TARGET exists as a real directory, it is left untouched.
set TARGET=%~1
set SOURCE=%~2

if "%TARGET%"=="" exit /b 1
if "%SOURCE%"=="" exit /b 1

rem Remove existing junction if present.
rem rmdir without /S only removes empty dirs and junctions.
if exist "%TARGET%\" rmdir "%TARGET%" 2>nul

rem Create the junction if the target no longer exists.
if not exist "%TARGET%\" (
    mklink /J "%TARGET%" "%SOURCE%" >nul 2>&1
    if %errorlevel% neq 0 (
        echo WARNING: Failed to create junction from "%TARGET%" to "%SOURCE%"
        exit /b 1
    )
    echo Created junction: "%TARGET%" -^> "%SOURCE%"
) else (
    echo "%TARGET%" already exists as a real directory, skipping junction creation.
)

exit /b 0
