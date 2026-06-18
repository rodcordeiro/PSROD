# Repository Guidelines

## Project Structure & Module Organization

This repository contains the `psrod` PowerShell module. The module manifest is `psrod.psd1`, and `psrod.psm1` dot-sources functions from the source folders.

- `Public/Authoral/`: project-owned public commands exported by the module.
- `Public/Imported/`: imported or adapted public commands; keep origin and behavior clear.
- `Public/Modules/`: nested module files, currently including MySQL helpers.
- `Private/`: internal helper scripts and classes not exported as public commands.
- `docs/`: command documentation, usually one Markdown file per exported command.
- `assets/`: images and support scripts used by the module or package metadata.

## Build, Test, and Development Commands

Run commands from the repository root.

- `Import-Module .\psrod.psd1 -Force`: loads the local module for manual validation.
- `Test-ModuleManifest .\psrod.psd1`: validates manifest metadata and dependencies.
- `Invoke-ScriptAnalyzer -Path . -Recurse`: runs the same core static analysis used by CI.
- `Publish-Module -Name .\psrod.psd1 -NuGetApiKey $env:PSG_TOKEN`: publishes the module; use only for release workflows.

Required module dependencies are listed in `psrod.psd1`: `NameIT`, `CredentialManager`, and `PSRabbitMQ`.

## Coding Style & Naming Conventions

Use idiomatic PowerShell with approved verb-noun command names, for example `Get-Weather` or `ConvertTo-MarkdownTable`. Store one public command per `.ps1` file and match the file name to the function name. Keep public functions in `Public/*` and implementation details in `Private/`.

Prefer four-space indentation, clear parameter names, and explicit error handling for external resources, credentials, network calls, and file system changes. Avoid introducing new dependencies unless they are operationally justified and added to the manifest.

## Testing Guidelines

There is no committed test suite at the moment. For changes, at minimum run `Test-ModuleManifest` and `Invoke-ScriptAnalyzer`. When adding tests, prefer Pester and place specs in a dedicated `tests/` folder using `*.Tests.ps1` naming.

## Commit & Pull Request Guidelines

Recent history mixes short descriptive messages (`add new functions`, `docs: Atualizar documentações`) and Conventional Commit style (`chore(deps): ...`). Prefer concise Conventional Commit prefixes such as `feat:`, `fix:`, `docs:`, and `chore:`.

Branches are validated in CI and should follow `<prefix>/<description>`, using prefixes such as `feature`, `fix`, `updates`, `stable`, or `dependabot`.

Pull requests should describe the change, list validation commands run, link related issues when available, and include screenshots only when user-facing visual behavior changes.

## Security & Configuration Tips

Do not commit secrets, API keys, RabbitMQ credentials, or PowerShell Gallery tokens. Use environment variables and GitHub Actions secrets. Review scripts that use credentials, sockets, scheduled tasks, or external services with extra care.
