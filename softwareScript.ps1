$softwareList = @(
    "git.install",
    "googlechrome",
    "firefox",
    "discord",
    "steam",
    "magicavoxel",
    "7zip",
    "github-desktop",
    "vscode",
    "filezilla",
    "intellijidea-community",
    "vlc",
    "openvpn",
    "nordvpn",
    "obs-studio",
    "virtualbox",
    "python",
    "openjdk",
    "treesizefree",
    "twine",
    "vnc-viewer"
)

foreach ($software in $softwareList) {
    choco install $software -y
}