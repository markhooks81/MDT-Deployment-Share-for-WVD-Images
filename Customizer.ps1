<################################################################################### 
    AIB Customizer Script by Mark hooks mark.hooks@microsoft.com
    Updated 6/16/2020

    This script does the following:

    1) Download & Expand the Deployment Share
    2) Start the MDT LiteTouch Process to create custom WVD Image
        
####################################################################################>


####Script Variables##################################################################
    $ImageLogFile = "C:\windows\temp\ImageBuild.log"
    $BuildArtifacts = "C:\temp"
    $DeploymentShareSAS = "<ENTER MDT DEPLOYMENT SHARE SAS URI HERE>"
#######################################################################################

###Image Build Logging###############################################################
    Start-Transcript -Path $ImageLogFile
#####################################################################################

###Download Deployment Share############################################################

    New-Item -Path 'C:\temp' -ItemType Directory -Force | Out-Null
    Invoke-WebRequest -Uri $DeploymentShareSAS -OutFile "c:\temp\DeploymentShare.zip"

#########################################################################################


###Expand Build Artifacts####################################################################################

    Expand-Archive -Path ($BuildArtifacts + "\DeploymentShare.zip") -DestinationPath C:\ -Force
    Write-Host "Extracted DeploymentShare.zip to " "C:\DeploymentShare"

##############################################################################################################

####Call MDT Deployment LiteTouch############################################################

    $installargs = "C:\DeploymentShare\Scripts\LiteTouch.vbs"
    Write-Host 'Running MDT LiteTouch Task Sequence'
    Start-Process -FilePath cscript -Wait -ArgumentList $installargs

#################################################################################################

Write-Host "AIB PowerShell Script Complete"
Stop-Transcript
# Complete
