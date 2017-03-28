Import-Task Clean, Pack-Nuspec, Test-Pester, Push-Local, Version-BuildServer, Push

# Synopsis: Default task
Task . Clean, Pack-Nuspec, Test, Push-Local

# Synopsis: Run all automated tests
Task Test Pack-Nuspec, Test-Pester

# Synopsis: Release task
Task Release Version-BuildServer, Clean, Pack-Nuspec, Test, Push