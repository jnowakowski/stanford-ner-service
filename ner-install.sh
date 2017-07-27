#!/bin/bash
# Full setup for NER service

# Release to download
versionName="stanford-ner-2017-06-09"
zipFile="$versionName.zip"
portNumber=$STANFORD_NER_PORT
workingDirectory="$(pwd)"


# Log to stderr
function log() {
    printf "$1\n" >&2
}

if [[ $portNumber -eq "" ]]; then
    log "ner-install|ERROR|\$STANFORD_NER_PORT not set"
    exit 1
fi

# Get NER source
# If we dont already hav a zipfile, download
test -f "$zipFile"
if [ $? -eq 0 ]; then
    log "Using existing NER zipfile $zipfile"
else
    log "Fetching NER zipfile"
    wget "https://nlp.stanford.edu/software/$zipFile"
fi
# Always unzip from the archive
rm -rf "$versionName"
unzip "$zipFile"


# Make sure we have Java 8
# is default java version 8
executable="java8"
java -version 2>&1 | awk '/version/{print $NF}' | grep '"1.8.'
if [ $? -eq 0 ]; then
    log "Default java is java8"
    executable="java"
else
    # or is java8 installed
    java8 -version
    if [ $? -eq 0 ]; then
        log "java8 found"
    else
        log "need java8"
        sudo yum install java-1.8.0-openjdk.x86_64 -y
    fi
fi
log "Using java executable '$executable'"


# Write server script
serverScript="$workingDirectory/ner-server.sh"
log "Writing server script to $serverScript"
cat << EOF > $serverScript
#!/bin/sh
$executable -mx1000m -cp "$workingDirectory/$versionName/stanford-ner.jar:$workingDirectory/$versionName/lib/*" edu.stanford.nlp.ie.NERServer  -loadClassifier "$workingDirectory/$versionName/classifiers/english.muc.7class.distsim.crf.ser.gz" -port $portNumber -outputFormat inlineXML
EOF

# Write service unit
serviceUnitName="ner.service"
serviceUnit="$workingDirectory/$serviceUnitName"
log "Writing service unit to $serviceUnit"
cat << EOF > $serviceUnit
[Unit]
Description=Stanford NER service

[Service]
ExecStart=$serverScript
Restart=always
Environment=PATH=/usr/bin:/usr/local/bin
WorkingDirectory=$workingDirectory

[Install]
WantedBy=multi-user.target
EOF

# Make executable 
chmod a+x "$serverScript" "$serviceUnit"


# Add service to system and enable
# Do not need to start, will be started either by user or by post-install hook
cp "$serviceUnit" "/etc/systemd/system/"
systemctl enable "$serviceUnitName"

