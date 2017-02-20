Import-Task Restore-NuGetPackages, Clean, Build
Set-Property BuildConfiguration -Value Release

# Synopsis: Default task
Task . Restore-NuGetPackages, Clean, Build, Copy-VSIX

# Synopsis: Copy the Visual Studio Extension Installer to the build output directory
Task Copy-VSIX {
    New-Directory $BuildOutputFullPath | Out-Null
    Copy-Item -Path (Join-Path $SolutionFullPath "Pask.ExtensionProjectTemplateWizard\bin\x86\Release\Pask.ExtensionProjectTemplateWizard.vsix") -Destination $BuildOutputFullPath
}

# Synopsis: Release task
Task Release Restore-NuGetPackages, Clean, Build, Copy-VSIX