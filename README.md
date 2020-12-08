# eVOLVERCLI
A Command-Line Interface for the eVOLVER Continuous Culture Framework

eVOLVER CLI v0.3 Read Me

The eVOLVER CLI is designed to facilitate use of the eVOLVER scripts usually called in through a terminal command and querying user input through a bash script for MacOS and Linux, and a batch script for Windows.

WARNING: It is highly recommended you review the code of these scripts in an IDE and make sure you understand what you are running.

It is recommended you fork and clone. I am a relative novice when it comes to Git, but my understanding it that Git automatically verifies hashes. If concerns remain, you can check signatures using the git log.ShowSignature configuration setting.

Current Functions Covered
Logging OD and Temperature Calibrations
Running Experiments (custom_script.py MUST be set up appropriately before initiating a run; hopefully queried input from users can be parsed into the python scripts in a future release)
Opening the Electron Shell
Opening the Graphing Utility

The scripts contain silenced lines for user-queried input for those who may have multiple eVOLVERs/changing variables. I have not had a test to adequately debug thesee or the Windows batch script as of 12/08/2020.

These scripts are easily adaptable to whatever setup you are using and modification may be necessary.
If you have any questions or issues, please post on eVOLVER forum or GitHub.
