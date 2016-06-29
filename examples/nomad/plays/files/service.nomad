job "weavedemo" {
  datacenters = ["dc1"]

  constraint {
    attribute = "${attr.kernel.name}"
    value = "linux"
  }

  update {
    stagger = "10s"
    max_parallel = 1
  }

  # - Frontend group #
  group "frontend" {
    count = 1

    restart {
      attempts = 10
      interval = "5m"
      delay = "25s"
      mode = "delay"
    }

    # - Frontend app - #
    task "front-end" {
      driver = "docker"

      config {
        image = "weaveworksdemos/front-end"
        hostname = "front-end.weave.local"
        network_mode = "external"
        dns_servers = ["172.17.0.1"]
        dns_search_domains = ["weave.local."]
      }

      service {
        name = "${TASKGROUP}-front-end"
        tags = ["frontend", "front-end"]
      }

      resources {
        cpu = 100 # 100 Mhz
        memory = 128 # 128Mb
        network {
          mbits = 10
        }
      }
    }
    # - End Frontend app - #

    # - edge-router app - #
    task "edgerouter" {
      driver = "docker"

      config {
        image = "weaveworksdemos/edge-router"
        hostname = "edge-router.weave.local"
        network_mode = "external"
        dns_servers = ["172.17.0.1"]
        dns_search_domains = ["weave.local."]
        port_map = {
          http = 80
          https = 443
        }
      }

      service {
        name = "${TASKGROUP}-edgerouter"
        tags = ["router", "edgerouter"]
      }

      resources {
        cpu = 100 # 100 Mhz
        memory = 128 # 128Mb
        network {
          mbits = 10
          port "http" {
            static = 80
          }
          port "https" {
            static = 443
          }
        }
      }
    }
    # - End edge-router app - #
  }
  # - End frontend group - #

  # - Backend group - #
  group "backend" {
    count = 1

    restart {
      attempts = 10
      interval = "5m"
      delay = "25s"
      mode = "delay"
    }

    # - Accounts app - #
    task "accounts" {
      driver = "docker"

      config {
        image = "weaveworksdemos/accounts"
        hostname = "accounts.weave.local"
        network_mode = "secure"
        dns_servers = ["172.17.0.1"]
        dns_search_domains = ["weave.local."]
      }

      service {
        name = "${TASKGROUP}-accounts"
        tags = ["accounts"]
      }

      resources {
        cpu = 100 # 100 Mhz
        memory = 128 # 128Mb
        network {
          mbits = 10
        }
      }
    }
    # - End Accounts app - #

    # - Catalogue app - #
    task "catalogue" {
      driver = "docker"

      config {
        image = "weaveworksdemos/catalogue"
        hostname = "catalogue.weave.local"
        network_mode = "external"
        dns_servers = ["172.17.0.1"]
        dns_search_domains = ["weave.local."]
      }

      service {
        name = "${TASKGROUP}-catalogue"
        tags = ["frontend", "front-end", "catalogue"]
      }

      resources {
        cpu = 100 # 100 Mhz
        memory = 128 # 128Mb
        network {
          mbits = 10
        }
      }
    }
    # - End Catalogue app - #

    # - Cart app - #
    task "cart" {
      driver = "docker"

      config {
        image = "weaveworksdemos/cart"
        hostname = "cart.weave.local"
        network_mode = "internal"
        dns_servers = ["172.17.0.1"]
        dns_search_domains = ["weave.local."]
      }

      service {
        name = "${TASKGROUP}-cart"
        tags = ["cart"]
      }

      resources {
        cpu = 100 # 100 Mhz
        memory = 128 # 128Mb
        network {
          mbits = 10
        }
      }
    }
    # - End Cart app - #

    # - Orders app - #
    task "orders" {
      driver = "docker"

      config {
        image = "weaveworksdemos/orders"
        hostname = "orders.weave.local"
        network_mode = "internal"
        dns_servers = ["172.17.0.1"]
        dns_search_domains = ["weave.local."]
      }

      service {
        name = "${TASKGROUP}-orders"
        tags = ["orders"]
      }

      resources {
        cpu = 100 # 100 Mhz
        memory = 128 # 128Mb
        network {
          mbits = 10
        }
      }
    }
    # - End Orders app - #

    # - Shipping app - #
    task "shipping" {
      driver = "docker"

      config {
        image = "weaveworksdemos/shipping"
        hostname = "shipping.weave.local"
        network_mode = "backoffice"
        dns_servers = ["172.17.0.1"]
        dns_search_domains = ["weave.local."]
      }

      service {
        name = "${TASKGROUP}-shipping"
        tags = ["shipping"]
      }

      resources {
        cpu = 100 # 100 Mhz
        memory = 128 # 128Mb
        network {
          mbits = 10
        }
      }
    }
    # - End Shipping app - #

    # - Payment app - #
    task "payment" {
      driver = "docker"

      config {
        image = "weaveworksdemos/payment"
        hostname = "payment.weave.local"
        network_mode = "secure"
        dns_servers = ["172.17.0.1"]
        dns_search_domains = ["weave.local."]
      }

      service {
        name = "${TASKGROUP}-payment"
        tags = ["payment"]
      }

      resources {
        cpu = 100 # 100 Mhz
        memory = 128 # 128Mb
        network {
          mbits = 10
        }
      }
    }
    # - End Payment app - #

    # - Login app - #
    task "login" {
      driver = "docker"

      config {
        image = "weaveworksdemos/login"
        hostname = "login.weave.local"
        network_mode = "secure"
        dns_servers = ["172.17.0.1"]
        dns_search_domains = ["weave.local."]
      }

      service {
        name = "${TASKGROUP}-login"
        tags = ["login"]
      }

      resources {
        cpu = 100 # 100 Mhz
        memory = 128 # 128Mb
        network {
          mbits = 10
        }
      }
    }
    # - End Login app - #
  }
  # - End backend group - #

  # - Database group - #
  group "db" {
    count = 1

    restart {
      attempts = 10
      interval = "5m"
      delay = "25s"
      mode = "delay"
    }

    # - RabbitMQ database - #
    task "rabbitmq" {
      driver = "docker"

      config {
        image = "rabbitmq:3"
        network_mode = "backoffice"
      }

      service {
        name = "${TASKGROUP}-rabbitmq"
        tags = ["db"]
      }

      resources {
        cpu = 100 # 100 Mhz
        memory = 128 # 128MB
        network {
          mbits = 10
        }
      }
    }
    # - End RabbitMQ database - #

    # - Accounts database - #
    task "accountsdb" {
      driver = "docker"

      config {
        image = "mongo"
        hostname = "accounts-db.weave.local"
        network_mode = "secure"
      }

      service {
        name = "${TASKGROUP}-accountsdb"
        tags = ["db", "accounts", "accountsdb"]
      }

      resources {
        cpu = 100 # 100 Mhz
        memory = 256 # 256MB
        network {
          mbits = 10
        }
      }
    }
    # - End Accounts database - #

    # - Cart database - #
    task "cartdb" {
      driver = "docker"

      config {
        image = "mongo"
        hostname = "cart-db.weave.local"
        network_mode = "internal"
      }

      service {
        name = "${TASKGROUP}-cartdb"
        tags = ["db", "cart", "cartdb"]
      }

      resources {
        cpu = 100 # 100 Mhz
        memory = 256 # 256MB
        network {
          mbits = 10
        }
      }
    }
    # - End Cart database - #

    # - Orders database - #
    task "ordersdb" {
      driver = "docker"

      config {
        image = "mongo"
        hostname = "orders-db.weave.local"
        network_mode = "internal"
      }

      service {
        name = "${TASKGROUP}-orders"
        tags = ["db", "orders", "ordersdb"]
      }

      resources {
        cpu = 100 # 100 Mhz
        memory = 256 # 256MB
        network {
          mbits = 10
        }
      }
    }
    # - End Orders database - #
  }
  # - End database group - #
}
