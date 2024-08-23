$softwareList = @(
    "7zip",
    "adobereader",
    "discord",
    "filezilla",
    "firefox",
    "github-desktop",
    "inkscape",
    "irfanview",
    "mongodb-compass",
    "nvm",
    "obs-studio",
    "openjdk",
    "postman",
    "putty",
    "steam",
    "treesizefree",
    "vlc",
    "vnc-viewer",
    "vscode"
)

foreach ($software in $softwareList) {
    choco install $software -y
}