resource "aws_fsx_ontap_volume" "fsxn_data_volume" {
  name                       = "${var.fsxn_volume_name_prefix}_data"
  junction_path              = "/${var.fsxn_volume_name_prefix}_data"
  security_style             = var.fsxn_volume_security_style
  size_in_megabytes          = 500000
  snapshot_policy            = "default"
  storage_efficiency_enabled = true
  storage_virtual_machine_id = aws_fsx_ontap_storage_virtual_machine.fsxsvm01.id
  skip_final_backup          = true
  tiering_policy {
    name = "SNAPSHOT_ONLY"
  }
}
