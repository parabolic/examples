resource "random_integer" "this" {
  min = 1
  max = 5
}

resource "random_pet" "name" {
  length = 1
  prefix = random_integer.this.id
}
