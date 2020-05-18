# because test-dotnet will return true if the template is installed, then you need to -not each if statement

if (!(test-dotnet -template "psmodule"))
{
	dotnet new -i Microsoft.PowerShell.Standard.Module.Template
}

if (!(test-dotnet -template "mgdesktopgl"))
{
	dotnet new -i "MonoGame.Template.CSharp"
}

if (!(test-dotnet -template "avalonia"))
{
	invoke-webrequest  https://github.com/AvaloniaUI/avalonia-dotnet-templates/archive/master.zip -outfile $home\avalonia.zip
	expand-archive $home\avalonia.zip -DestinationPath $home\.avalonia
	dotnet new --install $home\.avalonia\avalonia-dotnet-templates-master

	rm $home\avalonia.zip
}

# section for dotnet tools

if (!(test-dotnet -tool "dotnet-toast"))
{
	dotnet tool install -g dotnet-toast
}

if (!(test-dotnet -tool "try-convert"))
{
	dotnet tool install -g try-convert
}

if (!(test-dotnet -tool "base64urls"))
{
	dotnet tool install -g base64urls
}

if (!(test-dotnet -tool "coravel-cli"))
{
	dotnet tool install -g coravel-cli
}

if (!(test-dotnet -tool "dotnet-cowsay"))
{
	dotnet tool install -g dotnet-cowsay
}

if (!(test-dotnet -tool "dotnet-doc"))
{
	dotnet tool install -g dotnet-doc
}

if (!(test-dotnet -tool "dotnet-search"))
{
	dotnet tool install -g dotnet-search
}

if (!(test-dotnet -tool "nyancat"))
{
	dotnet tool install -g nyancat
}

if (!(test-dotnet -tool "gtkapp"))
{
	dotnet new --install GtkSharp.Template.CSharp::3.22.25.56
}


