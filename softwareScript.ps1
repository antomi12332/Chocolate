$softwareList = @(
    "7zip",
    "adobereader",
    "discord",
    "filezilla",
    "firefox",
    "git.install",
    "github-desktop",
    "googlechrome",
    "graphviz",
    "intellijidea-community",
    "irfanview",
    "k-litecodecpackfull",
    "mongodb-compass",
    "mtputty",
    "nordvpn",
    "nvm",
    "obs-studio",
    "openjdk",
    "putty",
    "python",
    "steam",
    "treesizefree",
    "twine",
    "vlc",
    "vnc-viewer",
    "vscode"
)

foreach ($software in $softwareList) {
    choco install $software -y
}