output "K8S_CLUSTER_PUBLIC_IPS" {
  value = { for key, instance in aws_instance.K8S_CLUSTER_EC2_INSTANCE : "${local.K8S_EC2_NODE.tags.Name}-${key + 1}" => instance.public_ip }
}
output "K8S_CLUSTER_PRIVATE_IPS" {
  value = { for key, instance in aws_instance.K8S_CLUSTER_EC2_INSTANCE : "${local.K8S_EC2_NODE.tags.Name}-${key + 1}" => instance.private_ip }
}
output "NGINX_PUBLIC_IP" {
  value = aws_instance.NGINX_EC2_INSTANCE.public_ip
}
output "NGINX_PRIVATE_IP" {
  value = aws_instance.NGINX_EC2_INSTANCE.private_ip
}
output "MOSIP_NGINX_SG_ID" {
  value = aws_security_group.security-group["NGINX_SECURITY_GROUP"].id
}
output "MOSIP_K8S_SG_ID" {
  value = aws_security_group.security-group["K8S_SECURITY_GROUP"].id
}
output "MOSIP_K8S_CLUSTER_NODES_PRIVATE_IP_LIST" {
  value = join(",", aws_instance.K8S_CLUSTER_EC2_INSTANCE[*].private_ip)
}
output "MOSIP_PUBLIC_DOMAIN_LIST" {
  value = join(",", concat(
    [local.MAP_DNS_TO_IP.API_DNS.name],
    [for cname in var.DNS_RECORDS : cname.name if contains([cname.records], local.MAP_DNS_TO_IP.API_DNS.name)]
  ))
}
