terraform {
  required_providers {
    routeros = {
      source  = "terraform-routeros/routeros"
      version = ">= 1.65.0"
    }
  }
}

provider "routeros" {
  hosturl        = "https://192.168.88.1/rest"     # Стандартный адресс Mirotik роутера
  username       = "admin"
  password       = "Marshal_group"                 # Если это первый логин то нет пароля
  ca_certificate = "/path/to/myCA.crt"
  insecure       = true
}

# --- IPs ---

resource "routeros_ip_address" "wan1" {
  interface = "ether1/WAN1 50Mbps"
  address   = "203.0.113.2/30"
}

resource "routeros_ip_address" "wan2" {
  interface = "ether2/WAN2 100Mbps"
  address   = "198.51.100.2/30"
}

resource "routeros_ip_address" "lan1" {
  interface = "ether3/LAN1"
  address   = "192.168.10.1/24"
}

resource "routeros_ip_address" "lan2" {
  interface = "ether4/LAN2"
  address   = "192.168.20.1/24"
}

# --- NAT (masquerade) ---

resource "routeros_ip_firewall_nat" "masq_wan1" {
  chain         = "srcnat"
  out_interface = "ether1/WAN1 50Mbps"
  action        = "masquerade"
}

resource "routeros_ip_firewall_nat" "masq_wan2" {
  chain         = "srcnat"
  out_interface = "ether2/WAN2 100Mbps"
  action        = "masquerade"
}

# --- Cameraman ---

resource "routeros_ip_firewall_mangle" "video_device" {
  chain            = "prerouting"
  src_address      = "192.168.10.250"
  action           = "mark-routing"
  new_routing_mark = "to-wan2-only"
  passthrough      = false
}

# --- Logic ---

resource "routeros_ip_route" "def_main" {
  dst_address   = "0.0.0.0/0"
  gateway       = "198.51.100.1"
  distance      = 1
  check_gateway = "ping"
}

resource "routeros_ip_route" "def_backup" {
  dst_address   = "0.0.0.0/0"
  gateway       = "203.0.113.1"
  distance      = 2
  check_gateway = "ping"
}

resource "routeros_ip_route" "video_device_only" {
  dst_address   = "0.0.0.0/0"
  gateway       = "198.51.100.1"
  routing_table  = "to-wan2-only"
  distance      = 1
  check_gateway = "ping"
}
