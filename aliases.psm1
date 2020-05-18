function set-systemAlias {

	if ($IsWindows)
	{
		if (test-path "~\AppData\local\Programs\VSCodium")
		{
			set-alias c "~\AppData\local\Programs\VSCodium\VSCodium.exe" -scope "Global"
		}

		if (test-path "C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\Common7\IDE")
		{
			set-alias vs "C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\Common7\IDE\devenv.exe" -scope "Global"
		}

		if (test-path "C:\Program Files\Git\usr\bin")
		{
			set-alias -name "touch" -value "C:\Program Files\Git\usr\bin\touch.exe" -scope "Global"
			set-alias -name "less" -value "C:\Program Files\Git\usr\bin\less.exe" -scope "Global"
			set-alias -name "grep" -value "C:\Program Files\Git\usr\bin\grep.exe" -scope "Global"
			set-alias -name "awk" -value "C:\Program Files\Git\usr\bin\awk.exe" -scope "Global"
		}

		if (test-path "C:\Program Files\7-Zip")
		{
			set-alias -name "7z" -value "C:\Program Files\7-Zip\7z.exe" -scope "Global"
		}	

		if (test-path "C:\Program Files\Mono")
		{
			set-alias -name "mono" -value "C:\Program Files\Mono\bin\mono.exe" -scope "Global"
			set-alias -name "dmcs" -value "C:\Program Files\Mono\bin\dmcs.exe" -scope "Global"
		}
	}
	elseif ($IsLinux)
	{

	}
	elseif ($IsMacOS)
	{

	}
	else
	{
		# This should never get called
	}

	set-alias up-pwsh upgrade-pwsh -scope "Global"
	set-alias up-dotnet upgrade-dotnet -scope "Global"
	set-alias gpush git-push -scope "Global"
	set-alias gpull git-pull -scope "Global"
	set-alias gclone git-clone -scope "Global"
	set-alias dirs get-stack -scope "Global"

}
Export-ModuleMember -function set-systemAlias