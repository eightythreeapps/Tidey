#!/bin/sh

#  ci_pre_xcodebuild.sh
#  Tidey
#
#  Created by Ben Reed on 02/05/2023.
#  
if [ $CI ];
then
    echo "CI build"
    echo "Updating Tidal API Key from environment"
    plutil -replace TidalDiscoveryAPISubscriptionKeyPrimary -string "$OCP_APIM_SUBSCRIPTION_KEY" $CI_PROJECT_FILE_PATH/**/Info.plist
fi
