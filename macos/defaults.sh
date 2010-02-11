
# Finder shows hidden files
defaults write com.apple.finder AppleShowAllFiles True

# Screen capture format: pdf, png, jpg, gif
defaults write com.apple.screencapture type png

# Software update

## User
defaults write  ~/Library/Preferences/com.apple.SoftwareUpdate CatalogURL http://172.16.20.252:8088/
defaults write  ~/Library/Preferences/com.apple.SoftwareUpdate CatalogURL http://swscan.apple.com:8088/content/catalogs/index.sucatalog
defaults delete ~/Library/Preferences/com.apple.SoftwareUpdate CatalogURL

## Global
sudo defaults write  /Library/Preferences/com.apple.SoftwareUpdate CatalogURL http://172.16.20.252:8088/
sudo defaults write  /Library/Preferences/com.apple.SoftwareUpdate CatalogURL http://swscan.apple.com:8088/content/catalogs/index.sucatalog
sudo defaults delete /Library/Preferences/com.apple.SoftwareUpdate CatalogURL

