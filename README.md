# Project introduction

This is a clean, minimal template repository for starting new Python projects in SCC's remote desktop, with sensible defaults for structure, environment setup and packaging. This template has a suggested project structure with 4 main directories:

- **Data**: This is where all your data for analysis will/should be stored.
- **Notebooks**: This is where all your Python/R notebooks for analysis should be stored.
- **SQL**: This is where your SQL query files should be stored.
- **Setup**: This folder holds all the files related to Python setup and Snowflake integration.

> ⚠️ Note - Please do not rename or move the 'Setup' folder or any files within it.

<br>

## Requirements

- **Python 3.12 or newer.** The setup script checks this and stops with a message if your version is older.

## Steps to set up the Snowflake extension in VS Code

**(To be done only once, the very first time you set up VS Code and Snowflake)**

1. Click Extensions on the left-most bar of your VS Code screen.
2. Search for 'snowflake' and install it.
3. Once installed, paste in your account identifier/URL (you can find this in your account details on Snowflake) and click continue.
4. Select 'Single-sign-on' as the Auth Method.
5. Type in the username/email address you use to log in to Snowflake, and you are good to go.
6. You should see options like Databases and Applications on your bottom-left panel, similar to what you see on Snowflake in the browser.

## Steps for Python setup

**(To be done each time you create a new repository using this template)**

1. In VS Code, on the left-hand tab, click "Explorer". Go to the `Setup` directory and open the file `connections.toml.example`
2. Rename the file to `connections.toml`. This ensures your personal details (email) will not be pushed to GitHub.
3. Replace both the `user` fields with your datahub/Snowflake email address and save.
4. Now go back to the `Setup` directory and open the file `setup-env.ps1`
5. Click the play button at the top right of the PowerShell file. This runs the script.
6. Keep an eye on your terminal window:
   - If a `.venv` already exists, it asks whether to delete and rebuild it. Type 'y' for a clean install (recommended if you've had package errors), or 'n' to keep it.
7. When it finishes, select the `.venv` Python as the kernel in your notebook and start on your project.

## Virtual environment

- It is always recommended to use a virtual environment in any analytical product.
- This allows another person to replicate, review, contribute to, and run your project using the same underlying code packages.

## Setup directory explained

This directory contains all the files you need for Python setup and integration with Snowflake.

1. `setup-env.ps1` is the core setup file. It:
   - Checks you have Python 3.12 or newer.
   - Checks for a virtual environment at `.\.venv`
     - If one is found, it offers to delete and rebuild it.
     - If not found, one is created.
   - Upgrades pip.
   - Installs the packages in `requirements.txt` and `ns-packages.txt` together, so their versions are compatible.
   - Refreshes the NS packages so you always get their latest version from GitHub.
   - Checks for any remaining version conflicts and activates the environment.

2. `connections.toml`: the information in this file is used to connect to Snowflake and use datasets stored in Snowflake directly in VS Code.

> ⚠️ Note - Please update the 'user' field in the file with your username/email.

## NS Packages

The setup script installs these internal packages from GitHub:

- **NS_utils** is an internal Python library designed for reuse by analysts within the Norfolk and Suffolk (NS) Intelligence Function. It holds NS-IF plotting styles and utility functions (Snowflake connection, notebook export, etc.). For more info read the README here --> [NS utils](https://github.com/Norfolk-Suffolk-ICS/NS_utils/blob/main/README.md)
- **ph_inequalities_statistical_comparison** produces automated statistical comparison across inequalities and groups, using either a crude or standardised approach. For more info see --> [ph_inequalities_statistical_comparison](https://github.com/Norfolk-Suffolk-ICS/ph_inequalities_statistical_comparison)

To add another internal package, add its `git+https://...` link as a new line in `Setup/ns-packages.txt` and re-run `setup-env.ps1`.

## Explaining the files

1. `.gitignore` --> A plain text file that tells Git which files or directories to ignore, meaning they won't be tracked, committed or pushed.
2. `README.md` --> Readme file for the repository (not related to Python setup). Its contents are displayed on the GitHub repository page.
3. `connections.toml` --> toml file to establish a connection with Snowflake.
4. `requirements.txt` --> Lists the general Python packages your project depends on. No version numbers are set, so new projects get the latest compatible versions.
5. `ns-packages.txt` --> Lists the internal NS packages to install from GitHub.
6. `setup-env.ps1` --> The main setup file (see "Setup directory explained" above).
7. `example_analysis.ipynb` --> Example of connecting to Snowflake, loading data from SQL or a file, and using the NS plotting themes.
8. `example_inequalities.ipynb` --> Example of using `ph_inequalities_statistical_comparison` with Snowflake data to compare proportions across inequality groups. Uses `SQL/query.sql`.
9. `query.sql` --> Example SQL query used by `example_inequalities.ipynb`.

## Keeping a record of exact versions

Because `requirements.txt` has no version numbers, it's a good idea to save a snapshot once your project works:

```
pip freeze > Setup/requirements-lock.txt
```

If an update ever breaks something, `pip install -r Setup/requirements-lock.txt` puts you back to exactly those versions.

<hr>