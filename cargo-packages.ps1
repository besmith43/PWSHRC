if (!(Test-CommandExists "cargo.exe"))
{
	Invoke-WebRequest https://static.rust-lang.org/rustup/dist/x86_64-pc-windows-msvc/rustup-init.exe -outfile $home\Downloads\rustup-init.exe

	start-process -FilePath $home\Downloads\rustup-init.exe
}

if (!(Test-CommandExists "bat.exe"))
{
	cargo install bat
}

if (!(Test-CommandExists "broot.exe"))
{
	cargo install broot
}

if (!(Test-CommandExists "coreutils.exe"))
{
	cargo install coreutils
}

if (!(Test-CommandExists "fd.exe"))
{
	cargo install fd-find
}

if (!(Test-CommandExists "rg.exe"))
{
	cargo install ripgrep
}

if (!(Test-CommandExists "sd.exe"))
{
	cargo install sd
}

if (!(Test-CommandExists "termscp.exe"))
{
	cargo install termscp
}

if (!(Test-CommandExists "tokei.exe"))
{
	cargo install tokei
}
