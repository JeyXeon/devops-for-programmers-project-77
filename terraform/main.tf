# Сеть
resource "yandex_vpc_network" "web_network" {
  name = "web-network"
}

resource "yandex_vpc_subnet" "web_subnet" {
  name           = "web-subnet"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.web_network.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

# Группа безопасности
resource "yandex_vpc_security_group" "web_sg" {
  name        = "web-sg"
  network_id  = yandex_vpc_network.web_network.id

  ingress {
    protocol       = "TCP"
    port           = 80
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol       = "TCP"
    port           = 443
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol       = "TCP"
    port           = 22
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol       = "TCP"
    port           = 3000
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol       = "ANY"
    from_port      = 0
    to_port        = 65535
    v4_cidr_blocks = ["0.0.0.0/0"]
    description    = "Outbound traffic"
  }
}

# ВМ
resource "yandex_compute_instance" "web_server" {
  count       = 2
  name        = "web-server-${count.index + 1}"
  platform_id = "standard-v1"
  zone        = var.yc_zone

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd81hgrcv6lsnkremf32"
      size     = 10
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.web_subnet.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.web_sg.id]
  }

  metadata = {
    ssh-keys = "ubuntu:${var.yc_vm_ssh_key}"
  }
}

# SSL-сертификат
resource "yandex_cm_certificate" "existing_cert" {
  name = "mitynedima-cert"
}

# ALB
resource "yandex_alb_load_balancer" "web_alb" {
  name               = "web-alb"
  security_group_ids = [yandex_vpc_security_group.web_sg.id]
  network_id         = yandex_vpc_network.web_network.id

  allocation_policy {
    location {
      zone_id   = var.yc_zone
      subnet_id = yandex_vpc_subnet.web_subnet.id
    }
  }

  # HTTPS-листенер
  listener {
    name = "https-listener"
    endpoint {
      address {
        external_ipv4_address {}
      }
      ports = [443]
    }
    tls {
      default_handler {
        certificate_ids = [yandex_cm_certificate.existing_cert.id]
        http_handler {
          http_router_id = yandex_alb_http_router.web_router.id
        }
      }
    }
  }
}

# HTTP-роутер
resource "yandex_alb_http_router" "web_router" {
  name = "web-router"
}

# Виртуальный хост
resource "yandex_alb_virtual_host" "web_vhost" {
  name           = "web-vhost"
  http_router_id = yandex_alb_http_router.web_router.id
  authority      = [var.yc_domain]

  route {
    name = "web-route"
    http_route {
      http_route_action {
        backend_group_id = yandex_alb_backend_group.web_backend.id
      }
    }
  }
}

# Бэкенд-группа
resource "yandex_alb_backend_group" "web_backend" {
  name = "web-backend-group"

  http_backend {
    name             = "web-backend"
    weight           = 1
    port             = 3000
    target_group_ids = [yandex_alb_target_group.web_servers.id]
    
    healthcheck {
      timeout  = "10s"
      interval = "2s"
      http_healthcheck {
        path = "/"
      }
    }
  }
}

# Целевая группа
resource "yandex_alb_target_group" "web_servers" {
  name = "web-target-group"

  dynamic "target" {
    for_each = yandex_compute_instance.web_server
    content {
      subnet_id  = yandex_vpc_subnet.web_subnet.id
      ip_address = target.value.network_interface.0.ip_address
    }
  }
}

# Outputs
output "alb_external_ip" {
  value = try(yandex_alb_load_balancer.web_alb.listener[0].endpoint[0].address[0].external_ipv4_address[0].address, "")
}

output "web_servers_ips" {
  value = {
    for instance in yandex_compute_instance.web_server :
    instance.name => instance.network_interface.0.nat_ip_address
  }
}

# Монитор доступности сервера
resource "datadog_monitor" "web_server_status" {
  name    = "[Web] Server Status - {{host.name}}"
  type    = "service check"
  query   = "\"datadog.agent.up\".over(\"env:production\",\"service:redmine\").by(\"host\").last(2).count_by_status()"
  message = "Web server {{host.name}} is down!"

  monitor_thresholds {
    critical = 1
    warning  = 1
  }
}

# Монитор нагрузки CPU
resource "datadog_monitor" "web_cpu_usage" {
  name    = "[Web] High CPU Usage - {{host.name}}"
  type    = "metric alert"
  query   = "avg(last_5m):avg:system.cpu.user{env:production,service:redmine} by {host} > 80"
  message = "High CPU usage detected on {{host.name}}"

  monitor_thresholds {
    critical = 80
    warning  = 70
  }
}

resource "local_file" "ansible_inventory" {
  filename = "../ansible/inventory.ini"
  content = templatefile("inventory.tftpl", {
    web_servers_ips = {
      for instance in yandex_compute_instance.web_server :
      instance.name => instance.network_interface.0.nat_ip_address
    }
  })
}
