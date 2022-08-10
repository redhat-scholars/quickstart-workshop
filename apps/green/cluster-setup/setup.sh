#!/bin/bash

# Verify we're running as a user with admin permissions
IS_ADMIN=$(oc get subscriptions -n openshift-operators >> /dev/null)

if [ "$IS_ADMIN" -eq "0" ]; then
   echo "Please login as a cluster-admin user an re-run this script"
   exit;
fi

set -e

# Install the OpenShift GitOps operator
echo "Installing OpenShift GitOps Operator..."
oc apply -f subscription.yaml

# Patch the logout redirect URL 😈
echo "Patch OpenShift logout redirect URL..."
oc patch console.config.openshift.io cluster --type merge --patch-file console.patch-file.yaml

echo "Wait for OpenShift GitOps to become ready..."
sleep 60

# Enable SSO-based login for the argocd cluster
echo "Patcing ArgoCD cluster configuration..."
oc patch argocd openshift-gitops --type merge --patch-file argocd.patch-file.yaml -n openshift-gitops
oc adm groups new cluster-admins
oc adm policy add-cluster-role-to-group cluster-admin cluster-admins
oc adm groups add-users cluster-admins opentlc-mgr kubeadmin