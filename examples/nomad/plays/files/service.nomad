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

  group "frontend" {
    count = 1

    restart {
      attempts = 10
      interval = "5m"
      delay = "25s"
      mode = "delay"
    }

    task "front-end" {
      driver = "docker"

      config {
        image = "weaveworksdemos/front-end"
        hostname = "front-end"
        network_mode = "external"
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
  }

  group "backend" {
    count = 1

    restart {
      attempts = 10
      interval = "5m"
      delay = "25s"
      mode = "delay"
    }

    task "catalogue" {
      driver = "docker"

      config {
        image = "weaveworksdemos/catalogue"
        hostname = "catalogue"
        network_mode = "external"
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

    task "cart" {
      driver = "docker"

      config {
        image = "weaveworksdemos/cart"
        hostname = "cart"
        network_mode = "internal"
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

    task "orders" {
      driver = "docker"

      config {
        image = "weaveworksdemos/orders"
        hostname = "orders"
        network_mode = "internal"
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

    task "shipping" {
      driver = "docker"

      config {
        image = "weaveworksdemos/shipping"
        hostname = "shipping"
        network_mode = "backoffice"
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

    task "payment" {
      driver = "docker"

      config {
        image = "weaveworksdemos/payment"
        hostname = "payment"
        network_mode = "secure"
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

    task "login" {
      driver = "docker"

      config {
        image = "weaveworksdemos/login"
        hostname = "login"
        network_mode = "secure"
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
  }

  group "db" {
    count = 1

    restart {
      attempts = 10
      interval = "5m"
      delay = "25s"
      mode = "delay"
    }

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

    task "accountsdb" {
      driver = "docker"

      config {
        image = "mongo"
        hostname = "accounts-db"
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

    task "cartdb" {
      driver = "docker"

      config {
        image = "mongo"
        hostname = "cart-db"
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

    task "ordersdb" {
      driver = "docker"

      config {
        image = "mongo"
        hostname = "orders-db"
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
  }
}
