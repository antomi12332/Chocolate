$softwareList = @(
    "7zip",
    "adobereader",
    "discord",
    "filezilla",
    "firefox",
    "github-desktop",
    "graphviz",
    "icue",
    "inkscape",
    "irfanview",
    "k-litecodecpackfull",
    "mongodb-compass",
    "nordvpn",
    "nvm",
    "obs-studio",
    "openjdk",
    "postman",
    "putty",
    "steam",
    "treesizefree",
    "xmind"
    "vlc",
    "vnc-viewer",
    "vscode"
)

foreach ($software in $softwareList) {
    choco install $software -y
}