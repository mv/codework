
# Finder shows hidden files
defaults write com.apple.finder AppleShowAllFiles True

# Screen capture format: pdf, png, jpg, gif
defaults write com.apple.screencapture type png

# Software update
defaults write  /Library/Preferences/com.apple.SoftwareUpdate CatalogURL http://172.16.20.252:8088/
defaults delete /Library/Preferences/com.apple.SoftwareUpdate CatalogURL

