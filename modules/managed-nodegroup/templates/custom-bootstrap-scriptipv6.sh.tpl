#!/bin/bash
set -ex

if ! grep -q imageGCHighThresholdPercent /etc/kubernetes/kubelet/kubelet-config.json; then
    jq '. + {"imageGCHighThresholdPercent": ${image_high_threshold_percent}}' /etc/kubernetes/kubelet/kubelet-config.json > /tmp/kubelet-config.json
    mv /tmp/kubelet-config.json /etc/kubernetes/kubelet/kubelet-config.json
fi

if ! grep -q imageGCLowThresholdPercent /etc/kubernetes/kubelet/kubelet-config.json; then
    jq '. + {"imageGCLowThresholdPercent": ${image_low_threshold_percent}}' /etc/kubernetes/kubelet/kubelet-config.json > /tmp/kubelet-config.json
    mv /tmp/kubelet-config.json /etc/kubernetes/kubelet/kubelet-config.json
fi

if ! grep -q eventRecordQPS /etc/kubernetes/kubelet/kubelet-config.json; then
    jq '. + {"eventRecordQPS": ${eventRecordQPS}}' /etc/kubernetes/kubelet/kubelet-config.json > /tmp/kubelet-config.json
    mv /tmp/kubelet-config.json /etc/kubernetes/kubelet/kubelet-config.json
fi

yum update -y
yum install -y vim wget curl

/etc/eks/bootstrap.sh '${cluster_name}' --apiserver-endpoint '${endpoint}' --b64-cluster-ca '${cluster_auth_base64}' --ip-family ipv6 --service-ipv6-cidr $(aws eks describe-cluster --name=${cluster_name} --output=text --query 'cluster.{serviceIpv6Cidr: kubernetesNetworkConfig.serviceIpv6Cidr}')