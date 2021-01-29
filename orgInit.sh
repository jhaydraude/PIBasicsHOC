#!/bin/bash
sfdx force:org:create -f config/project-scratch-def.json  --setdefaultusername -d 1 -a TSTDeploy

#Install LMA Package
sfdx force:package:install -p 04t30000001DWL0 -w 20 -u TSTDeploy

#Install App Analytics Package v 1.7
sfdx force:package:install -p 04t3i000002KWaC -w 20 -u TSTDeploy

#Insert Sample Data
sfdx force:data:tree:import -p ./demoAssets/data/plan.json -u TSTDeploy

#Push Source
sfdx force:source:push -f -u TSTDeploy

#Grant Permission
sfdx force:user:permset:assign -n AppAnalytics -u TSTDeploy

#Assign Integration User Permissions
sfdx force:apex:execute -f ./demoAssets/scripts/AssignIntegrationUserPerms.apex  -u TSTDeploy

#Push TCRM assets
sfdx force:source:deploy -p wave-app/main/default/wave/ -u TSTDeploy

#Open Org
sfdx force:org:open 
