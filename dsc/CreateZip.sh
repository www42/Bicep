# Create new zip file (overriding if exists)
zip -j dsc/allConfigs.zip dsc/config*.ps1

# List zip file
unzip -l dsc/allConfigs.zip