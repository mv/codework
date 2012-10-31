

sudo launchctl unload /Library/LaunchDaemons/org.jenkins-ci.plist
sudo rm !$
sudo rm -rf /Applications/Jenkins "/Library/Application Support/Jenkins" /Library/Documentation/Jenkins

sudo rm -rf /Users/Shared/Jenkins

sudo dscl . -delete /Users/jenkins
sudo dscl . -delete /Groups/jenkins

