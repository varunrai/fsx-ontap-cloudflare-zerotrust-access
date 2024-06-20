output "CF_Account_ID" {
  description = "Public IP address of the EC2 instance"
  value       = try(jsondecode(data.http.cloudflare-account-id.response_body).result[0].id, null)
}

output "CF_Account_Token" {
  description = "Public IP address of the EC2 instance"
  value       = try(jsondecode(data.http.cloudflare-tunnel-token.response_body).result, null)
}

output "CFD_ID" {
  value = data.cloudflare_tunnel.aws.id
}
