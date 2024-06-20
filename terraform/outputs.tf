
output "FSxN_management_ip" {
  description = "FSxN Management IP"
  value       = module.fsxontap.fsx_management_management_ip
}

output "FSxN_svm_iscsi_endpoints" {
  description = "FSxN SVM iSCSI endpoints"
  value       = module.fsxontap.fsx_svm_iscsi_endpoints
}

output "FSxN_svm_nfs_endpoints" {
  description = "FSxN SVM iSCSI endpoints"
  value       = module.fsxontap.fsx_svm_nfs_endpoints
}

output "Cloudflare_Tunnel_Server" {
  description = "Cloudflare Tunnel Server Private IP addresses"
  value       = aws_instance.ec2-cloudflare-tunnel.private_ip
}

output "FSxN_file_system_id" {
  value = module.fsxontap.fsx_file_system.id
}

output "FSxN_svm_id" {
  value = module.fsxontap.fsx_svm.id
}

output "FSxN_data_volume" {
  value = {
    id   = module.fsxontap.fsx_data_volume.id
    name = module.fsxontap.fsx_data_volume.name
  }
}
