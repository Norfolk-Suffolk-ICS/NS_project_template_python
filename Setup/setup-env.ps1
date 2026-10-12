# Sets up the Python environment for this project.
# Run it from VS Code with the play button (top right), or in a terminal: .\Setup\setup-env.ps1

# Paths (all relative to this Setup folder)
$VenvPath         = Join-Path $PSScriptRoot "..\.venv"
$VenvPython       = Join-Path $VenvPath "Scripts\python.exe"
$ActivationPath   = Join-Path $VenvPath "Scripts\Activate.ps1"
$RequirementsPath = Join-Path $PSScriptRoot "requirements.txt"
$NSPackagesFile   = Join-Path $PSScriptRoot "ns-packages.txt"


# 1. Check Python version (ph_inequalities_statistical_comparison needs Python 3.12 or newer)
$PythonOk = python -c "import sys; print(sys.version_info >= (3, 12))"
if ($PythonOk -ne "True") {
    Write-Output "This project needs Python 3.12 or newer. Your version is:"
    python --version
    Write-Output "Please install Python 3.12+ and run this script again."
    exit 1
}


# 2. Create the virtual environment (offer a clean rebuild if one already exists)
if (Test-Path $VenvPath) {
    # A rebuild removes old packages left over from earlier installs.
    # Running notebook kernels lock files inside .venv, so close all notebooks first.
    $Rebuild = Read-Host "Existing .venv found. Delete it and rebuild from scratch? Close all notebooks first. (y/n)"
    if ($Rebuild -eq "y") {
        Write-Output "Removing old .venv..."
        # -ErrorAction Stop makes a failed delete jump straight to the catch block
        try {
            Remove-Item -Recurse -Force $VenvPath -ErrorAction Stop
        }
        catch {
            Write-Output "Could not delete .venv because some of its files are in use."
            Write-Output "Close VS Code completely (all windows), delete the .venv folder in File Explorer,"
            Write-Output "then reopen VS Code and run this script again."
            exit 1
        }
    }
}

if (-not (Test-Path $VenvPath)) {
    Write-Output "Creating virtual environment at $VenvPath"
    python -m venv $VenvPath
}

# A .venv folder without python.exe is broken (e.g. a half-finished delete)
if (-not (Test-Path $VenvPython)) {
    Write-Output "The .venv folder is broken (python.exe is missing)."
    Write-Output "Close VS Code, delete the .venv folder in File Explorer, then run this script again."
    exit 1
}


# 3. Upgrade pip inside the venv
# Calling the venv's own python.exe makes sure packages go into .venv, not your main Python.
Write-Output "Upgrading pip..."
& $VenvPython -m pip install --upgrade pip


# 4. Install everything in ONE pip call
# pip then sees all version requirements at once and picks versions that work together.
# Installing the two files separately is what caused version conflicts before.
if (-not (Test-Path $RequirementsPath) -or -not (Test-Path $NSPackagesFile)) {
    Write-Output "requirements.txt or ns-packages.txt is missing from the Setup folder. Stopping."
    exit 1
}
Write-Output "Installing packages from requirements.txt and ns-packages.txt..."
& $VenvPython -m pip install --upgrade -r $RequirementsPath -r $NSPackagesFile

# $LASTEXITCODE is pip's result: 0 means success, anything else means it failed
if ($LASTEXITCODE -ne 0) {
    Write-Output "Package installation failed. Scroll up to see pip's error message."
    exit 1
}


# 5. Make sure the NS packages are at their latest GitHub commit
# pip skips a GitHub package if its version number hasn't changed, so force a refresh.
# --no-deps stops it reinstalling numpy, pandas, etc. again.
Write-Output "Refreshing NS packages from GitHub..."
& $VenvPython -m pip install --upgrade --force-reinstall --no-deps -r $NSPackagesFile


# 6. Check for any remaining version conflicts
Write-Output "Checking for conflicts..."
& $VenvPython -m pip check


# 7. Activate the venv in this terminal
. $ActivationPath
Write-Output "Setup finished. In VS Code, select the .venv Python as your notebook kernel."