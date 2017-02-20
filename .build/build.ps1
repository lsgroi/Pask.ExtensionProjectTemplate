Import-Task Restore-NuGetPackages, Clean, Build
Set-Property BuildConfiguration -Value Release

# Synopsis: Default task
Task . Restore-NuGetPackages, Clean, Build