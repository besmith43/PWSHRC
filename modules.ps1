if ($IsWindows -and $PSVersionTable.PSEdition -eq "Desktop")
{
	foreach ($WindowsModule in $WindowsModules)
	{
		import-module $WindowsModule -erroraction silentlycontinue
	}
}

if ($IsLinux)
{
	foreach ($LinuxModule in $LinuxModules)
	{
		import-module $LinuxModule -erroraction silentlycontinue
	}
}

foreach ($GeneralModule in $GeneralModules)
{
	import-module $GeneralModule -erroraction silentlycontinue
}

if ($env:computername -eq "HEND001B-D03" -and $PSVersionTable.PSEdition -eq "Desktop")
{
	foreach($WorkModule in $WorkModules)
	{
		import-module $WorkModule -erroraction silentlycontinue
	}
}

# these will be imported by all instances of powershell

import-module posh-docker -erroraction silentlycontinue

import-module posh-git -erroraction silentlycontinue


