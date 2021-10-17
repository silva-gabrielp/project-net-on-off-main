$Global:Current_Folder = split-path $MyInvocation.MyCommand.Path

[System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms')  				| out-null
[System.Reflection.Assembly]::LoadWithPartialName('presentationframework') 				| out-null
[System.Reflection.Assembly]::LoadFrom("MahApps.Metro.dll")       				| out-null
[System.Reflection.Assembly]::LoadFrom("MahApps.Metro.IconPacks.dll")      | out-null

function LoadXml ($global:filename)
{
    $XamlLoader=(New-Object System.Xml.XmlDocument)
    $XamlLoader.Load($filename)
    return $XamlLoader
}

# Load MainWindow
$XamlMainWindow=LoadXml("$Current_Folder\net.xaml")
$Reader=(New-Object System.Xml.XmlNodeReader $XamlMainWindow)
$Form=[Windows.Markup.XamlReader]::Load($Reader)

[System.Windows.Forms.Application]::EnableVisualStyles()

$btnLigar = $form.FindName("btnLigar")
$btnDesligar = $form.FindName("btnDesligar")
$statusEthernet = $form.FindName("statusEthernet")
$statusWifi = $form.FindName("statusWifi")

$btnLigar.Add_Click({
    Get-NetAdapter -Name Ethernet | ? status -eq disabled | Enable-NetAdapter -Confirm:$false

    $statusEthernet.Text = "Ativo"
    $statusEthernet.Foreground = "Green"
    $statusWifi.Text = "Ativo"
    $statusWifi.Foreground = "Green"
})

$btnDesligar.Add_Click({
    
    Disable-NetAdapter -Name Ethernet -Confirm:$false
    # Get-NetAdapter -Name Ethernet | ? Status -eq enable | Disable-NetAdapter -Confirm:$false

    $statusEthernet.Text = "Parado"
    $statusEthernet.Foreground = "Red"
    $statusWifi.Text = "Parado"
    $statusWifi.Foreground = "Red"
})

$Form.ShowDialog() | Out-Null