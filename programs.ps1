# this script is designed to test and install if possible minimumly required applications for software development.  It will also add in several additional applications like firefox and vlc

install-program -PackageName dotnet-sdk -Command dotnet

install-program -PackageName git -Command git

install-program -PackageName vim -Command vim

install-program -PackageName pwsh -Command pwsh

install-program -PackageName fzf -Command fzf

install-program -PackageName steam -Command steam

if ($IsWindows)
{
	.\windows\programs.ps1
}
elseif ($IsLinux)
{
	.\linux\programs.ps1
}
else # IsMacOS
{
	.\macos\programs.ps1
}



