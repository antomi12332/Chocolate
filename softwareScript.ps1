$softwareList = @(
    "7zip",
    "adobereader",
    "discord",
    "filezilla",
    "firefox",
    "git.install",
    "github-desktop",
    "googlechrome",
    "inkscape",
    "intellijidea-community",
    "irfanview",
    "k-litecodecpackfull",
    "nordvpn",
    "obs-studio",
    "openjdk",
    "putty",
    "python",
    "steam",
    "treesizefree",
    "twine",
    "virtualbox",
    "vlc",
    "vmware-workstation-player"
    "vnc-viewer",
    "vscode",
)

foreach ($software in $softwareList) {
    choco install $software -y
}