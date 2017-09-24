if (Get-Module -ListAvailable -Name posh-git) {
    Import-Module posh-git
} else {
    Install-Module posh-git -Scope CurrentUser
}