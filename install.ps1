param (
	[switch]$InstallModules
)

# import variables.ps1 and install the appropriate powershell modules for your platform

# install powershell 5 profile

if ($IsWindows)
{
	if (!(test-path "~\Documents\WindowsPowerShell"))
	{
		new-item -itemtype Directory -path "~\Documents\WindowsPowerShell"
	}

	copy-item -path .\Profile.ps1 -destination "~\Documents\WindowsPowerShell"
}

# install powershell core profile
# by using the $profile variable, it places the profile where ever the specific OS needs it to be

if($IsWindows)
{
	if (!(test-path -pathtype leaf -path $home\Documents\PowerShell))
	{
		new-item $home\Documents\PowerShell
	}

	copy-item -path .\Microsoft.PowerShell_profile.ps1 -destination $home\Documents\PowerShell\
}
else
{
	if (!(test-path -pathtype leaf -path $profile))
	{
		new-item $profile -force
		remove-item $profile
	}

	copy-item -path .\Microsoft.PowerShell_profile.ps1 -destination $profile
}

if ($InstallModules)
{
	Import-Module $PSScriptRoot\variables.ps1

	Import-Module $PSScriptRoot\functions.ps1

	if (IsAdmin)
	{
		foreach ($GeneralModule in $GeneralModules)
		{
			Install-Module $GeneralModule
		}

		if ($IsWindows)
		{
			foreach ($WindowsModule in $WindowsModules)
			{
				if ($WindowsModule -eq "PowerLine")
				{
					Install-Module PANSIES -AllowClobber
				}

				Install-Module $WindowsModule
			}
		}
	}
}