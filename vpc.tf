resource "aws_vpc" "test" {
  cidr_block = "172.32.0.0/16"
}

resource "aws_subnet" "test_a" {
  vpc_id            = "${aws_vpc.test.id}"
  availability_zone = "${var.aws_region}a"
  cidr_block        = "172.32.0.0/24"
}

resource "aws_subnet" "test_b" {
  vpc_id            = "${aws_vpc.test.id}"
  availability_zone = "${var.aws_region}b"
  cidr_block        = "172.32.1.0/24"
}

resource "aws_route_table_association" "test_a" {
  subnet_id = "${aws_subnet.test_a.id}"
  route_table_id = "${aws_vpc.test.main_route_table_id}"
}

resource "aws_route_table_association" "test_b" {
  subnet_id = "${aws_subnet.test_b.id}"
  route_table_id = "${aws_vpc.test.main_route_table_id}"
}

resource "aws_internet_gateway" "test_gateway" {
  vpc_id = "${aws_vpc.test.id}"
}

resource "aws_route" "internet_gateway_route" {
  route_table_id = "${aws_vpc.test.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = "${aws_internet_gateway.test_gateway.id}"
}
