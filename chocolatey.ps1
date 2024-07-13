$softwareList = @(
    "7zip",
    "adobereader",
    "discord",
    "filezilla",
    "firefox",
    "freecad",
    "github-desktop",
    "icue",
    "inkscape",
    "irfanview",
    "mongodb-compass",
    "nordvpn",
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