data "ignition_file" "rclone_config" {
  path = "/root/.config/rclone/rclone.conf"
  content {
    content = templatefile("${path.module}/templates/rclone.conf", {
      client_id      = var.gdrive_oauth.client_id
      client_secret  = var.gdrive_oauth.client_secret
      token          = var.gdrive_oauth.token
      root_folder_id = var.gdrive_oauth.root_folder_id
    })
  }
}
