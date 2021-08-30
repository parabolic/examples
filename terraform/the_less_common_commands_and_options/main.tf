locals {
  map = {
    a = 1
    b = 2
    c = 3
  }
}

resource "local_file" "private_key" {
  content  = jsonencode(local.map)
  filename = "./map.json"
}
