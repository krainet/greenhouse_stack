#!/bin/bash

DATE=`date +%Y%m%d-%H%M`
myHome=$(pwd)

TMP_REPO="${myHome}/deploy_files/tmp"
OLD_REPO="${myHome}/deploy_files/old_tmp"

SETTINGS="${myHome}/config"


DIRS=""


function clear_old_repo {
	echo ""
        echo -ne "::Deleting previous repo/configurations..."
        if [ -d ${TMP_REPO} ]; then
                if [ -d ${OLD_REPO} ]; then
                        rm -r ${OLD_REPO};
                fi
                mv ${TMP_REPO} ${OLD_REPO}
        fi
        echo -e " done "
	echo ""
}

function clone_repo {
	echo ""
        echo -e "::Cloning repository... Wait a sec"
        git clone http://github.com/krainet/greenhouse -b master ${TMP_REPO}/greenhouse_stack
	echo "llegamos"
        rm -rf ${TMP_REPO}/greenhouse_stack/.git*
        echo -en "::Checking merge errors... Wait a sec...  "
        code_errors=`grep -r '<<<<<<< HEAD' ${TMP_REPO}/greenhouse_stack | wc -l `
        if [ "${code_errors}" == "0" ]; then
                echo -e " Done"
        else
                echo ""
                echo -e "::Merge error detected::Exiting "
                exit 1
        fi
	echo ""
}

function build_services {
	echo ""
        echo -en "::Building code and creating Dockerfiles ..."
	cd ${TMP_REPO}/greenhouse_stack/serviceA
	sbt docker:stage 
	cp -r ${TMP_REPO}/greenhouse_stack/serviceA/target/docker/stage/* ${myHome}/greenhouse_services/servicea
	cd ${TMP_REPO}/greenhouse_stack/serviceB
	sbt docker:stage
	cp -r ${TMP_REPO}/greenhouse_stack/serviceB/target/docker/stage/* ${myHome}/greenhouse_services/serviceb
        echo -e " done "
	echo ""
}

function deploy_code {
	echo "::Rebuilding images and deploying changes into stack "
	cd ${TMP_REPO}/greenhouse_stack/
	docker-compose build 
	docker-compose up -d --no-deps
	echo ""
	echo "done"
	echo ""
}


clear_old_repo
clone_repo
build_services
deploy_code


