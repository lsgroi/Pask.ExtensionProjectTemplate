<img src="https://raw.githubusercontent.com/lsgroi/Pask/master/Pask.png" align="right"/>

# Pask Extension Project Template

[![Build status](https://ci.appveyor.com/api/projects/status/vqitbskgcp2t6bn3?svg=true)](https://ci.appveyor.com/project/LucaSgroi/pask-extensionprojecttemplate)

Authoring new extensions is much easier with the Visual Studio 2017 [project template](https://marketplace.visualstudio.com/items?itemName=lsgroi.PaskExtension). It adds automatically the basic Pask structure to focus right away on building new tasks and scripts.  

The template will create a C# project as opposite to PowerShell one, which would make more sense. Unfortunately NuGet Package Manager in Visual Studio does not support PowerShell projects at this stage. The extension package will be created by targeting a Nuspec which includes only the relevant `ps1` files; no assembly will be built/included unless told to.

Pask is Copyright &copy; 2017 Luca Sgroi under the [Apache License](LICENSE).