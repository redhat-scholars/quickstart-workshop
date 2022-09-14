#!/bin/bash

# Verify we're running as a user with admin permissions
$(oc get subscriptions -n openshift-operators > /dev/null 2>&1)

# Get the last exit code to deterine if user is admin
IS_ADMIN=$(echo $?)

if [ "$IS_ADMIN" -eq "1" ]; then
   echo "Please login as a cluster-admin user an re-run this script"
   exit;
fi

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

echo "Creating workshop namespace/project"
oc new-project green-team

echo "Green cluser setup is complete!"