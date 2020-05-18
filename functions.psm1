function open-ssh {
	param(
		[ValidateSet("gaming","nas","web")]
		[string]$serverName,
		[string]$IP,
		[string]$Port,
		[string]$username
	)

	if ($serverName -eq $Null)
	{
		$serverName = "gaming"
	}

	switch ($serverName)
	{
		"gaming" {
			$IP = "besmith.synology.me"
			$Port = "8002"
			$username = "blake"
		}
		"nas" {
			$IP = "besmith.synology.me"
			$Port = "22"
			$username = "besmith"
		}
		"web" {
			$IP = "besmith.tech"
			$Port = "22"
			$username = "besmith"
		}
	}

	ssh $IP -p $Port -l $username
}
Export-ModuleMember -function open-ssh

function git-push {
    Param(
		[string]$UpdatedFiles = "*",
        [Parameter(Mandatory=$True)]
        [string]$commit_string
    )
    git add $UpdatedFiles
    git commit -m $commit_string
    git push
}
Export-ModuleMember -function git-push

function git-pull {
    git pull
}
Export-ModuleMember -function git-pull

function git-clone {
	Param(
		[Parameter(Mandatory=$True)]
		[string]$projectName
	)
	git clone ssh://besmith@besmith.synology.me/volume1/Git/$projectName
}
Export-ModuleMember -function git-clone

function dotnet-publish
{
    Param(
        [ValidateSet("win-x64", "linux-x64", "osx-x64", "all")]
        [string]$Platform
    )
    if ($Platform -eq "all")
    {
        dotnet publish -c release -r win-x64 /p:PublishSingleFile=true
        dotnet publish -c release -r osx-x64 /p:PublishSingleFile=true
        dotnet publish -c release -r linux-x64 /p:PublishSingleFile=true
    }
    else
    {
		if ($Platform -eq $Null)
		{
			if ($IsWindows)
			{
				$Platform = "win-x64"
			}
			elseif ($IsLinux)
			{
				$Platform = "linux-x64"
			}
			else
			{
				$Platform = "osx-x64"
			}
		}

        dotnet publish -c release -r $Platform /p:PublishSingleFile=true    
    }
    
}
Export-ModuleMember -function dotnet-publish

function IsAdmin {
	$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
	return ($currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))
}
Export-ModuleMember -function IsAdmin

function New-Admin {
	param (
		[ValidateSet("powershell","pwsh")]
		[string]$Shell = "powershell"
	)

	if ($IsWindows)
	{
		start-process $Shell -verb runas
	}
	else
	{
		start-process pwsh -verb runas
	}
}
Export-ModuleMember -function New-Admin

function install-choco {
	if (IsAdmin)
	{
		Set-ExecutionPolicy Bypass -Scope Process -Force
		iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
	}
	else
	{
		write-host "Please retry with shell using admin privileges" -foregroundcolor Black -backgroundcolor Red
	}
}
Export-ModuleMember -function install-choco

function upgrade-pwsh {
    Invoke-Expression "& { $(Invoke-RestMethod https://aka.ms/install-powershell.ps1) } -UseMSI"
}
Export-ModuleMember -function upgrade-pwsh

function upgrade-dotnet {
    Invoke-Expression "& { $(Invoke-RestMethod https://dot.net/v1/dotnet-install.ps1) } -verbose"
}
Export-ModuleMember -function upgrade-dotnet

function Install-WindowsProgram {
	param (
		[Parameter(Mandatory=$true,Position=0)]
		[string]$WinPackageName,
		[string]$WinCommand,
		[string]$WinPath = ''
	)

	if (!(test-path "C:\ProgramData\chocolatey"))
	{
		start-Process powershell -argumentlist "-ExecutionPolicy Bypass -command {install-choco}" -verb runas
	}
	elseif ($WinPath -ne '')
	{
		if (!(test-path $WinPath))
		{
			start-process choco -argumentlist "install $WinPackageName -y" -verb runas
		}
		else
		{
			write-host 'The Package, '$WinPackageName', is already installed' -foregroundcolor black -backgroundcolor red
		}
	}
	else
	{
		if (!(get-command $WinCommand -erroraction silentlycontinue))
		{
			start-process choco -argumentlist "install $WinPackageName -y" -verb runas
		}
		else
		{
			write-host 'The Package, '$WinPackageName', is already installed' -foregroundcolor black -backgroundcolor red
		}
	}
}
Export-ModuleMember -function Install-WindowsProgram

function Install-LinuxProgram {
	param (
		[Parameter(Mandatory=$true,Position=0)]
		[string]$LinuxPackageName,
		[Parameter(Mandatory=$true,Position=1)]
		[string]$LinuxCommand,
		[ValidateSet("apt","zypper","pacman")]
		[string]$LinuxPackageManager = "apt"
	)

	if (!(get-command $LinuxCommand -erroraction silentlycontinue))
	{
		sudo apt install $LinuxPackageName
	}
	else
	{
		write-host 'The Package, '$LinuxPackageName', is already installed' -foregroundcolor black -backgroundcolor red
	}
}
Export-ModuleMember -function Install-LinuxProgram

function Install-MacProgram {
	param (
		[Parameter(Mandatory=$true,Position=0)]
		[string]$MacPackageName,
		[Parameter(Mandatory=$true,Position=1)]
		[string]$MacCommand
	)

	if (!(get-command "brew" -erroraction silentlycontinue))
	{
		/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	}
	else
	{
		if (!(get-command $MacCommand -erroraction silentlycontinue))
		{
			brew install $MacPackageName
		}
		else
		{
			write-host 'The Package, '$MacPackageName', is already installed' -foregroundcolor black -backgroundcolor red
		}
	}
}
Export-ModuleMember -function Install-MacProgram

# needs to add a function for making programs script simplier

function install-program {
	param (
		[Parameter(Mandatory=$true,Position=0)]
		[string]$PackageName,
		[Parameter(Mandatory=$true,Position=1)]
		[string]$Command,
		[string]$CheckWinPath = ''
	)

	if ($IsWindows)
	{
		if ($CheckWinPath -eq '')
		{
			Install-WindowsProgram -WinPackageName $PackageName -WinCommand $Command
		}
		else
		{
			Install-WindowsProgram -WinPackageName $PackageName -WinCommand $Command -WinPath $CheckWinPath
		}
	}
	elseif ($IsLinux)
	{
		Install-LinuxProgram -LinuxPackageName $PackageName -LinuxCommand $Command 
	}
	else
	{
		# $IsMacOS

		Install-MacProgram -MacPackageName $PackageName -MacCommand $Command
	}
}
Export-ModuleMember -function install-program

# needs to make a function for checking and installing fonts

# see link for help, https://4sysops.com/archives/install-fonts-with-a-powershell-script/

function install-fonts {
	param(
	[Parameter(Mandatory=$true,Position=0)]
	[ValidateNotNull()]
	[array]$pcNames,
	[Parameter(Mandatory=$true,Position=1)]
	[ValidateNotNull()]
	[string]$fontFolder
	)
	$padVal = 20
	$pcLabel = "Connecting To".PadRight($padVal," ")
	$installLabel = "Installing Font".PadRight($padVal," ")
	$errorLabel = "Computer Unavailable".PadRight($padVal," ")
	$openType = "(Open Type)"
	$regPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts"
	$objShell = New-Object -ComObject Shell.Application
	if(!(Test-Path $fontFolder))
	{
		Write-Warning "$fontFolder - Not Found"
	}
	else
	{
		$objFolder = $objShell.namespace($fontFolder)
		foreach ($pcName in $pcNames)
		{
			Try{
				Write-Output "$pcLabel : $pcName"
				$null = Test-Connection $pcName -Count 1 -ErrorAction Stop
				$destination = "\\",$pcname,"\c$\Windows\Fonts" -join ""
				foreach ($file in $objFolder.items())
				{
					$fileType = $($objFolder.getDetailsOf($file, 2))
					if(($fileType -eq "OpenType font file") -or ($fileType -eq "TrueType font file"))
					{
						$fontName = $($objFolder.getDetailsOf($File, 21))
						$regKeyName = $fontName,$openType -join " "
						$regKeyValue = $file.Name
						Write-Output "$installLabel : $regKeyValue"
						Copy-Item $file.Path  $destination
						Invoke-Command -ComputerName $pcName -ScriptBlock { $null = New-ItemProperty -Path $args[0] -Name $args[1] -Value $args[2] -PropertyType String -Force } -ArgumentList $regPath,$regKeyname,$regKeyValue
					}
				}
			}
			catch{
				Write-Warning "$errorLabel : $pcName"
			}
		}
	}
}
Export-ModuleMember -function install-fonts

function l {
	param (
		[string]$directory = "."
	)
	if($IsWindows)
	{
		& 'C:\Program Files\Git\usr\bin\ls.exe' -al $directory
	}
	else
	{
		ls -al $directory
	}
}
Export-ModuleMember -function l

function test-dotnet {
	param (
		[string]$template = '',
		[string]$tool = ''
	)

	if ($template -ne '')
	{
		return $(dotnet new -l | grep $template) -like "*$template*"
	}
	elseif ($tool -ne '')
	{
		return $(dotnet tool list -g | grep $tool) -like "*$tools*"
	}
	else
	{
		return $false
	}
}
Export-ModuleMember -function test-dotnet

function new-sadconsole {
	param (

	)

	dotnet new mgdesktopgl
	dotnet add package sadconsole
}
Export-ModuleMember -function new-sadconsole

function get-stack {
	get-location -stack
}
Export-ModuleMember -function get-stack

function version {
	$psversiontable
}
Export-ModuleMember -function version

function is-workcomputer {
	$hostname = hostname
	$hostname = $hostname.ToLower()
	
	foreach ($workcomp in $workComputers)
	{
		if ($workcomp -eq $hostname)
		{
			return $true
		}
	}

	return $false
}
Export-ModuleMember -function is-workcomputer

function Test-CommandExists {
	param (
		[string]$command
	)

	if (get-command $command -erroraction silentlycontinue)
	{
		reutrn $true
	}
	else
	{
		return $false
	}
}
Export-ModuleMember -function Test-CommandExists

function New-JournalEntry {
	param (
		[ValidateSet('vim','gvim')]
		[string]$editor = 'vim',
		[string]$JournalPath = '\\10.0.1.2\home\Journal',
		[string]$ArchiveName,
		[string]$filemame
	)

	$date = Get-Date

	# get year
	# 4 digit number

	$year = $date.Year

	# get month
	# name of month

	if (!$ArchiveName)
	{
		$ArchiveName = (Get-Culture).DateTimeFormat.GetMonthName($date.Month)
	}

	# get day
	# number.txt

	$day = $date.Day
	$entry_name = "$day.txt"

	# check that the home share is mounted and the Journal folder exists

	if ( -not (test-path -path $JournalPath))
	{
		throw "Journal Folder not mounted"
	}

	# check that year folder is created

	if ( -not (test-path -path "$JournalPath\$year"))
	{
		new-item -itemtype directory -path "$JournalPath\$year" 
	}

	# create file name

	if (!$filename)
	{
		$filename = "$day.txt"
	}
	else
	{
		$filename = "$filename.txt"
	}

	$IsFileDuplicate = 7z l "$JournalPath\$year\$ArchiveName.7z" | grep $filename

	if ($IsFileDuplicate)
	{
		# is a duplicate == true
		$filename = Read-Host -Prompt "Filename $day.txt already exists in the journal.  Please enter a new filename: "
	}

	# open vim or gvim to create file

	if ($editor -eq "vim")
	{
		vim "$JournalPath\$year\$filename"
	}
	else
	{
		gvim "$JournalPath\$year\$filename"
	}

	# wait for vim or gvim to exit
	# testing a theory that powershell won't continue with the script's progression naturally until the editor returns from it's execution.

	#wait-process $editor

	# add text file to 7z

	if (test-path "$JournalPath\$year\$filename" -PathType Leaf)
	{
		7z a -p "$JournalPath\$year\$ArchiveName.7z" "$JournalPath\$year\$filename"
	}
	else
	{
		throw "file $JournalPath\$year\$filename doesn't exist"
	}

	# remove original text file

	remove-item "$JournalPath\$year\$filename"

	# list 7z contents

	7z l "$JournalPath\$year\$ArchiveName.7z"
}
Export-ModuleMember -Function New-JournalEntry
set-alias nje New-JournalEntry -Scope "Global"

function Edit-JournalEntry {
	param (
		[ValidateSet('vim','gvim')]
		[string]$editor = 'vim',
		[string]$JournalPath = '\\10.0.1.2\home\Journal',
		[Parameter(Mandatory=$true)]
		[string]$Archive,
		[Parameter(Mandatory=$true)]
		[string]$File
	)
	
	7z e $Archive $File
	
	vim $File
	
	wait-process -Name vim
	
	7z a -p $Archive $File
	
	7z l $Archive
	
	write-host "Deleting $File" -foregroundcolor yellow
	remove-item $File
}
Export-ModuleMember -Function Edit-JournalEntry
set-alias eje Edit-JournalEntry -Scope "Global"

function Get-JournalEntries {
	param (
		[string]$JournalPath = '\\10.0.1.2\home\Journal',
		[string]$Year = "$($(Get-Date).Year)",
		[string]$Month = "$((Get-Culture).DateTimeFormat.GetMonthName($(Get-Date).Month))"
	)

	7z l "$JournalPath\$Year\$Month.7z"
}
Export-ModuleMember -Function Get-JournalEntries
set-alias  gjes Get-JournalEntries -Scope "Global"


