
MONGO_URI = "mongodb+srv://user:1234@tasks.hqybvw0.mongodb.net/?retryWrites=true&w=majority&appName=tasks"

# UPDATE BELOW 3 TOGETHER
vpc_id = "vpc-06cfad845136a0aa6"
# Public subnets from VPC repo
alb_subnet_ids = ["subnet-0b240798efee00b9f", "subnet-08e4b825cbf4d58e0"]
# Private subnets from VPC repo
private_subnet_ids = ["subnet-0241183bda2c71fcc", "subnet-077ad3e2693ec3ddd"]

name_prefix = "taskmgr"