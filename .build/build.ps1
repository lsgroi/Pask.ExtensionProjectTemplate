Import-Task Restore-NuGetPackages, Clean, Build, Version-Assemblies, Version-BuildServer

Set-Property BuildConfiguration -Value Release
Set-Property Version -Value (Get-SemanticVersion "0.4.0")
Set-Property ExcludeAssemblyInfo  -Value @("Pask.ExtensionProjectTemplate\AssemblyInfo.cs")

# Synopsis: Default task
Task . Restore-NuGetPackages, Clean, Build, Copy-VSIX

# Synopsis: Release task
Task Release Version-BuildServer, Restore-NuGetPackages, Clean, Version-Assemblies, Version-VSIXManifest, Build, Copy-VSIX

# Synopsis: Copy the Visual Studio Extension Installer to the build output directory
Task Copy-VSIX {
    New-Directory $BuildOutputFullPath | Out-Null
    Copy-Item -Path (Join-Path $SolutionFullPath "Pask.ExtensionProjectTemplateWizard\bin\x86\Release\Pask.ExtensionProjectTemplateWizard.vsix") -Destination $BuildOutputFullPath
}

# Synopsis: Apply the current version to the VSIX manifest
Task Version-VSIXManifest {
    $VSIXManifestFile = Join-Path $SolutionFullPath "Pask.ExtensionProjectTemplateWizard\source.extension.vsixmanifest"
    [xml]$VSIXManifest = Get-Content $VSIXManifestFile
    $VSIXManifest.PackageManifest.Metadata.Identity.Version = $Version.SemVer
    $VSIXManifest.Save($VSIXManifestFile)
    $VSTemplateFile = Join-Path $SolutionFullPath "Pask.ExtensionProjectTemplate\Pask.ExtensionProjectTemplate.vstemplate"
    [xml]$VSTemplate = Get-Content $VSTemplateFile
    $Assembly = $VSTemplate.VSTemplate.WizardExtension.Assembly -split ", "
    $Assembly[1] = "Version=$($Version.Major).0.0.0"
    $VSTemplate.VSTemplate.WizardExtension.Assembly = $Assembly -join ", "
    $VSTemplate.Save($VSTemplateFile)
}