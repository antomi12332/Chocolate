$softwareList = @(
    "git.install",
    "googlechrome",
    "firefox",
    "discord",
    "steam",
    "putty",
    "7zip",
    "github-desktop",
    "vscode",
    "filezilla",
    "intellijidea-community",
    "vlc",
    "nordvpn",
    "obs-studio",
    "virtualbox",
    "python",
    "openjdk",
    "treesizefree",
    "twine",
    "vnc-viewer",
    "vmware-workstation-player"
)

foreach ($software in $softwareList) {
    choco install $software -y
}