param (
[Parameter(Mandatory = $true)]
[string]$CommitMessage
)

# === CONFIGURATION ===

$RepoPath = "C:\Users\smial\ProgrammingProjects\DoorCE\DoorCEAppFramework"     # git repo
$LibraryPath = "C:\Users\smial\ProgrammingProjects\DoorCE\DoorCEAppFramework\doorce_style"    # flutter lib
$Branch = "main"

# === HELPER FUNCTION ===

function Run-Step {
param (
[string]$Command
)
Write-Host ">> $Command"
Invoke-Expression $Command
if ($LASTEXITCODE -ne 0) {
Write-Error "Error: $Command"
exit 1
}
}

# === 1. Navigate to repository ===

Set-Location $RepoPath

# === 2. Add library to git ===

Run-Step "git add doorce_style"

# === 3. Commit ===

Run-Step "git commit -m `"$CommitMessage`""

# === 4. Push ===

Run-Step "git push origin $Branch"

# === 5. Navigate to library directory ===

Set-Location $LibraryPath

# === 6. Publish ===

Run-Step "dart pub publish --force"
