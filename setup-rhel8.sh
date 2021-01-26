#!/usr/bin/env bash

USERNAME="YOUR RHSM USERNAME"
PASSWORD="YOUR RHSM PASSWORD"

if [[ $EUID -ne 0 ]]
then
    echo
    echo "*** MUST RUN AS root ***"
    echo
    exit 1
fi

subscription-manager register \
    --username $USERNAME --password $PASSWORD || exit 1
subscription-manager role --set="Red Hat Enterprise Linux Server"
subscription-manager service-level --set="Self-Support"
subscription-manager usage --set="Development/Test"
subscription-manager attach 

yum -y update
yum -y clean all

