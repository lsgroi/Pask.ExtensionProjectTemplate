Set-Property GitHubOwner -Value "lsgroi"
Set-Property GitHubRepo -Value $ProjectName
Set-Property ReleaseAssetPattern -Value "Pask.ExtensionProjectTemplate"

Import-Task Restore-NuGetPackages, Clean, Build, Version-Assemblies, Version-BuildServer, New-GitHubRelease

Set-Property BuildConfiguration -Value Release
Set-Property Version -Value (Get-SemanticVersion "0.17.0")
Set-Property ExcludeAssemblyInfo  -Value @("Pask.ExtensionProjectTemplate\AssemblyInfo.cs")

# Synopsis: Default task
Task . Restore-NuGetPackages, Clean, Build, Copy-VSIX

# Synopsis: Release task
Task Release Version-BuildServer, Restore-NuGetPackages, Clean, Version-Assemblies, Version-VSIXManifest, Build, Copy-VSIX, New-GitHubRelease

# Synopsis: Copy the Visual Studio Extension Installer to the build output directory
Task Copy-VSIX {
    New-Directory $BuildOutputFullPath | Out-Null
    $Source = Join-Path $SolutionFullPath "Pask.ExtensionProjectTemplateWizard\bin\x86\Release\Pask.ExtensionProjectTemplateWizard.vsix"
    $Destination = $BuildOutputFullPath
    "Copying {0} to $Destination" -f (Split-Path $Source -Leaf)
    Copy-Item -Path (Join-Path $SolutionFullPath "Pask.ExtensionProjectTemplateWizard\bin\x86\Release\Pask.ExtensionProjectTemplateWizard.vsix") -Destination $BuildOutputFullPath
}

# Synopsis: Apply the current version to the VSIX manifest
Task Version-VSIXManifest {
    $VSIXManifestFile = Join-Path $SolutionFullPath "Pask.ExtensionProjectTemplateWizard\source.extension.vsixmanifest"
    "Applying {0} to {1}" -f $Version.SemVer, (Split-Path $VSIXManifestFile -Leaf)
    [xml]$VSIXManifest = Get-Content $VSIXManifestFile
    $VSIXManifest.PackageManifest.Metadata.Identity.Version = $Version.SemVer
    $VSIXManifest.Save($VSIXManifestFile)

    $VSTemplateFile = Join-Path $SolutionFullPath "Pask.ExtensionProjectTemplate\Pask.ExtensionProjectTemplate.vstemplate"
    $AssemblyVersion = "{0}.0.0.0" -f $Version.Major
    "Applying {0} to {1}" -f $AssemblyVersion, (Split-Path $VSTemplateFile -Leaf)
    [xml]$VSTemplate = Get-Content $VSTemplateFile
    $Assembly = $VSTemplate.VSTemplate.WizardExtension.Assembly -split ", "
    $Assembly[1] = "Version={0}" -f $AssemblyVersion
    $VSTemplate.VSTemplate.WizardExtension.Assembly = $Assembly -join ", "
    $VSTemplate.Save($VSTemplateFile)
}