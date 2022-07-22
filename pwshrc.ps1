import-module $home\Documents\PWSH\variables.psm1

import-module $home\Documents\PWSH\functions.psm1

import-module $home\Documents\PWSH\modules.ps1

import-module $home\Documents\PWSH\aliases.psm1

 # run only on command
#import-module $home\Documents\PWSH\programs.ps1

#import-module $home\Documents\PWSH\dotnet-packages.ps1

set-systemAlias

#if (Test-CommandExists Set-PowerLinePrompt)
#{
	#if ($IsWindows -or $IsLinux)
	#{
		#Set-PowerLinePrompt -SetCurrentDirectory -RestoreVirtualTerminal -Newline -Timestamp -Colors "#00DDFF", "#0066FF"
	#}	
#}

if (Test-CommandExists oh-my-posh)
{
	oh-my-posh --init --shell pwsh --config C:\Users\besmi\onedrive\gist\custom-night-owl.omp.json | Invoke-Expression
}

if ($env:computername -eq "NerdGaming")
{
	E:\Bin\connect-nasshares.ps1
}


clear
