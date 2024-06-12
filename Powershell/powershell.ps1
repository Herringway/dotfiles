& "$PSScriptRoot\LoadModules.ps1"
function global:PromptWriteErrorInfo() {
    if ($global:GitPromptValues.DollarQuestion) { return }

    if ($global:GitPromptValues.LastExitCode) {
        " `e[31m(" + $global:GitPromptValues.LastExitCode + ")`e[0m"
    }
    else {
        " `e[31m!`e[0m"
    }
}
$global:GitPromptSettings.DefaultPromptBeforeSuffix.Text = '$(PromptWriteErrorInfo)'
$global:GitPromptSettings.DefaultPromptPath.ForegroundColor = 0x008CFF
Set-Alias subl 'C:\Program Files\Sublime Text\subl.exe'
[Console]::OutputEncoding = [Text.UTF8Encoding]::UTF8
