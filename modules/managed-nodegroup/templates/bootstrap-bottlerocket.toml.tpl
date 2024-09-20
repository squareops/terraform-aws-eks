[settings.kubernetes]
cluster-name = "${cluster_name}"
api-server = "${cluster_endpoint}"
cluster-certificate = "${cluster_ca_data}"
max-pods = ${managed_ng_pod_capacity}

image-gc-high-threshold-percent = ${image_high_threshold_percent}
image-gc-low-threshold-percent = ${image_low_threshold_percent}
event-qps = ${eventRecordQPS}


# Enable kernel lockdown in "integrity" mode.
# This prevents modifications to the running kernel, even by privileged users.
[settings.kernel]
lockdown = "integrity"


[settings.host-containers.admin]
enabled = ${admin_container_enabled}


# The control host container provides out-of-band access via SSM.
# It is enabled by default, and can be disabled if you do not expect to use SSM.
# This could leave you with no way to access the API and change settings on an existing node!
[settings.host-containers.control]
enabled = ${enable_control_container}