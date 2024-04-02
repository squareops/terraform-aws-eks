MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="==MYBOUNDARY=="

--==MYBOUNDARY==
Content-Type: text/x-shellscript; charset="us-ascii"

#!/bin/bash
set -ex

if ! grep -q imageGCHighThresholdPercent /etc/kubernetes/kubelet/kubelet-config.json;
then
    sed -i '/"apiVersion*/a \ \ "imageGCHighThresholdPercent": ${image_high_threshold_percent},' /etc/kubernetes/kubelet/kubelet-config.json
fi

if ! grep -q imageGCLowThresholdPercent /etc/kubernetes/kubelet/kubelet-config.json;
then
    sed -i '/"imageGCHigh*/a \ \ "imageGCLowThresholdPercent": ${image_low_threshold_percent},' /etc/kubernetes/kubelet/kubelet-config.json
fi

if ! grep -q eventRecordQPS /etc/kubernetes/kubelet/kubelet-config.json;
then
    sed -i '/"imageGCLow*/a \ \ "eventRecordQPS": ${eventRecordQPS},' /etc/kubernetes/kubelet/kubelet-config.json
fi

yum update -y && yum install vim wget curl -y


/etc/eks/bootstrap.sh '${cluster_name}'  --apiserver-endpoint '${endpoint}' --b64-cluster-ca '${cluster_auth_base64}' --use-max-pods false --kubelet-extra-args '--max-pods=${managed_ng_pod_capacity}'


--==MYBOUNDARY==--
