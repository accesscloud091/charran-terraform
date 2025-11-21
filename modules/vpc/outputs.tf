output "vpc_id" {
   value = aws_vpc.vpc.id
}

output "private_subnet1" {
    value = aws_subnet.pvt_subnet1.id
}

output "private_subnet2" {
    value = aws_subnet.pvt_subnet2.id

}
output "private_subnet3" {
    value = aws_subnet.pvt_subnet3.id
  
}

output "public_subnet2" {
    value = aws_subnet.public_subnet2.id
  
}

output "public_subnet1" {
    value = aws_subnet.public_subnet1.id
  
}
output "public_subnet3" {
    value = aws_subnet.public_subnet3.id
  
}