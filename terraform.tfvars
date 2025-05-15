
MONGO_URI = "mongodb+srv://user:1234@tasks.hqybvw0.mongodb.net/?retryWrites=true&w=majority&appName=tasks"

# UPDATE BELOW 3 TOGETHER
vpc_id = "vpc-0f7d87e09b9c9716f"
 # Public subnets from VPC repo
alb_subnet_ids = [ "subnet-07360388073175f79", "subnet-04dad3ccc1bcf325a" ]
 # Private subnets from VPC repo
private_subnet_ids = ["subnet-0fb1eb3cc97fcecc9", "subnet-081fdf048234256cf"]