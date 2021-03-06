function Get-FileEncoding {
	[CmdletBinding()] Param ([Parameter(Mandatory = $True, ValueFromPipelineByPropertyName = $True)] [string]$Path)

	[byte[]]$byte = get-content -Encoding byte -ReadCount 4 -TotalCount 4 -Path $Path

	if ($byte[0] -eq 0xef -and $byte[1] -eq 0xbb -and $byte[2] -eq 0xbf) {
		Write-Output 'UTF8'
	} elseif ($byte[0] -eq 0xfe -and $byte[1] -eq 0xff) {
		Write-Output 'Unicode'
	} elseif ($byte[0] -eq 0 -and $byte[1] -eq 0 -and $byte[2] -eq 0xfe -and $byte[3] -eq 0xff) {
		Write-Output 'UTF32'
	} else {
		Write-Output 'UTF8'
	}
}
if (!(Select-String -SimpleMatch "$PSScriptRoot/Powershell/powershell.ps1" -Path $PROFILE)) {
	$profileEncoding = Get-FileEncoding "$PROFILE"
	echo "`n$PSScriptRoot/Powershell/powershell.ps1" | Out-File -Append -Encoding $profileEncoding -NoClobber -FilePath $PROFILE
}
if (!(Test-Path $HOME/.gitconfig)) {
	$GitFriendlyPath = "$PSScriptRoot\git".Replace("\", "\\")
	echo "[include]" | Out-File -Encoding UTF8 -FilePath $HOME/.gitconfig
	echo "	path = $GitFriendlyPath\\gitconfig-base" | Out-File -Append -NoClobber -Encoding UTF8 -FilePath $HOME/.gitconfig
	echo "	path = $GitFriendlyPath\\gitconfig-windows" | Out-File -Append -NoClobber -Encoding UTF8 -FilePath $HOME/.gitconfig
	$ODGitRoot = $HOME.Replace("\", "\\")
	echo "[url `"$ODGitRoot\\OneDrive\\dev\\git\\`"]" | Out-File -Append -NoClobber -Encoding UTF8 -FilePath $HOME/.gitconfig
	echo "	insteadOf = od://" | Out-File -Append -NoClobber -Encoding UTF8 -FilePath $HOME/.gitconfig
}
if (!(Test-Path $HOME/.editorconfig)) {
	#TODO - symbolic link, once tools support it without elevation
	Copy-Item $PSScriptRoot/editorconfig $HOME/.editorconfig
}