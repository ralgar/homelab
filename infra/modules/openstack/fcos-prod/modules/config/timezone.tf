data "ignition_link" "timezone" {
    path = "/etc/localtime"
    target = "../usr/share/zoneinfo/America/Vancouver"
}
