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

    # - Catalogue app - #
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
    # - End Catalogue app - #

    # - Cart app - #
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
    # - End Cart app - #

    # - Orders app - #
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
    # - End Orders app - #

    # - Shipping app - #
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
    # - End Shipping app - #

    # - Payment app - #
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
    # - End Payment app - #

    # - Login app - #
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
    # - End Accounts database - #

    # - Cart database - #
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
    # - End Cart database - #

    # - Orders database - #
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
    # - End Orders database - #
  }
  # - End database group - #
}
