# Here is the full example of creating an EFS Access Point with a fixed path in EFS (/custom-path-for-pvc), where:

# Create a custom Access Point with a fixed path in EFS (/custom-path-for-pvc)
# Create a PersistentVolume (PV) using this Access Point
# Create a PersistentVolumeClaim (PVC) that uses this PV
# This solution isolates the volume and allows full control over the path, permissions, UID, GID
# Don't forget about the corresponding security group (allow port 2049 to EKS workers)

resource "aws_efs_file_system" "example" {
  creation_token = "efs-for-custom-pvc"
}

resource "aws_efs_mount_target" "example" {
  file_system_id  = aws_efs_file_system.example.id
  subnet_id       = "subnet-xxxxxxxx"
  security_groups = ["sg-xxxxxxxx"]
}

resource "aws_efs_access_point" "custom_ap" {
  file_system_id = aws_efs_file_system.example.id

  root_directory {
    path = "/custom-path-for-pvc"
    creation_info {
      owner_gid   = 1000
      owner_uid   = 1000
      permissions = "750"
    }
  }

  posix_user {
    gid = 1000
    uid = 1000
  }
}
