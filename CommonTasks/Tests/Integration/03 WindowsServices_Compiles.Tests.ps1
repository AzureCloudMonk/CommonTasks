$configData = Import-LocalizedData -BaseDirectory $PSScriptRoot\Assets -FileName Config1.psd1 -SupportedCommand New-Object, ConvertTo-SecureString -ErrorAction Stop
$moduleName = $env:BHProjectName

Remove-Module -Name $env:BHProjectName -ErrorAction SilentlyContinue -Force
Import-Module -Name $env:BHProjectName -ErrorAction Stop

Import-Module -Name Datum

Describe 'WindowsServices DSC Resource compiles' -Tags 'FunctionalQuality' {
    It 'WindowsFeatures Compiles' {
        configuration Config_WindowsFeatures {

            Import-DscResource -ModuleName CommonTasks
        
            node localhost_WindowsServices {
                WindowsFeatures xwindowsFeatures {
                    Name = $ConfigurationData.WindowsFeatures.Name
                }
            }
        }
        
        { Config_WindowsFeatures -ConfigurationData $configData -OutputPath $env:BHBuildOutput -ErrorAction Stop } | Should -Not -Throw
    }

    It 'WindowsServices should have created a mof file' {
        $mofFile = Get-Item -Path $env:BHBuildOutput\localhost_WindowsServices.mof -ErrorAction SilentlyContinue
        $mofFile | Should -BeOfType System.IO.FileInfo        
    }
}