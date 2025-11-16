# AWS Infrastructure Setup cho SocialEcho

Cấu hình Terraform để tạo infrastructure AWS cho dự án SocialEcho với:
- 2 VPC riêng biệt (Public cho Frontend, Private cho Backend)
- EC2 instances (Frontend có public IP, Backend không có public IP)
- NAT Gateway để Backend có thể truy cập Internet an toàn

## Kiến trúc

```
Public VPC (10.0.0.0/16)
├── Public Subnet (10.0.1.0/24)
│   ├── Internet Gateway
│   └── Frontend EC2 (có Public IP)
│       └── Security Group: HTTP(80), HTTPS(443), SSH(22)
│
Private VPC (10.1.0.0/16)
├── Private Subnet (10.1.1.0/24)
│   └── Backend EC2 (không có Public IP)
│       └── Security Group: Port 3000, 8000 từ Frontend, SSH(22)
└── NAT Subnet (10.1.2.0/24)
    ├── NAT Gateway
    └── Internet Gateway (chỉ cho NAT Gateway)
│
VPC Peering Connection
└── Kết nối Public VPC ↔ Private VPC để Frontend và Backend giao tiếp
```

## Yêu cầu

1. **AWS Account** với quyền tạo VPC, EC2, NAT Gateway
2. **Terraform** >= 1.0
3. **AWS CLI** đã được cấu hình với credentials

## Cài đặt

### 1. Cài đặt Terraform

**Windows:**
```powershell
# Sử dụng Chocolatey
choco install terraform

# Hoặc tải từ https://www.terraform.io/downloads
```

**Linux/Mac:**
```bash
# Sử dụng package manager
brew install terraform  # Mac
# hoặc
sudo apt-get install terraform  # Ubuntu/Debian
```

### 2. Cấu hình AWS Credentials

```bash
aws configure
```

Nhập:
- AWS Access Key ID
- AWS Secret Access Key
- Default region (ví dụ: us-east-1)
- Default output format (json)

### 3. Tùy chỉnh biến (Optional)

Copy file example và chỉnh sửa:
```bash
cp terraform.tfvars.example terraform.tfvars
```

Chỉnh sửa `terraform.tfvars` với các giá trị phù hợp:
- `aws_region`: Region AWS bạn muốn sử dụng
- `allowed_ssh_cidr`: IP của bạn để giới hạn SSH access (ví dụ: "YOUR_IP/32")

## Sử dụng

### 1. Khởi tạo Terraform

```bash
cd terraform
terraform init
```

### 2. Xem kế hoạch triển khai

```bash
terraform plan
```

### 3. Triển khai infrastructure

```bash
terraform apply
```

Nhập `yes` khi được hỏi xác nhận.

### 4. Xem thông tin output

Sau khi triển khai xong, Terraform sẽ hiển thị:
- Public IP của Frontend instance
- Private IP của Backend instance
- NAT Gateway IP
- SSH commands để kết nối

Hoặc xem lại bất cứ lúc nào:
```bash
terraform output
```

### 5. Xóa infrastructure

```bash
terraform destroy
```

## Kết nối đến EC2 Instances

### Frontend Instance (có Public IP)

```bash
ssh -i your-key.pem ubuntu@<FRONTEND_PUBLIC_IP>
```

### Backend Instance (không có Public IP)

Backend instance không có public IP, bạn cần:
1. **Qua Bastion Host**: Tạo một bastion host trong Public VPC và SSH qua đó
2. **Qua VPN**: Kết nối VPN đến VPC
3. **Qua Systems Manager Session Manager**: Sử dụng AWS Systems Manager

## Cấu hình Security Groups

### Frontend Security Group
- **Inbound**: HTTP (80), HTTPS (443), SSH (22)
- **Outbound**: All traffic

### Backend Security Group
- **Inbound**: 
  - Port 3000, 8000 từ Frontend Security Group
  - SSH (22) từ allowed CIDR
- **Outbound**: All traffic (qua NAT Gateway)

## Lưu ý quan trọng

1. **Chi phí**: NAT Gateway có chi phí ~$0.045/giờ + data transfer. Xem [AWS Pricing](https://aws.amazon.com/vpc/pricing/)

2. **SSH Key**: Bạn cần tạo và sử dụng SSH key pair trước khi tạo instances. Có thể thêm vào Terraform config:
   ```hcl
   resource "aws_key_pair" "deployer" {
     key_name   = "deployer-key"
     public_key = file("~/.ssh/id_rsa.pub")
   }
   ```

3. **Kết nối giữa VPCs**: Hiện tại Frontend và Backend ở 2 VPC khác nhau. Để kết nối:
   - Sử dụng VPC Peering
   - Hoặc đặt cả 2 trong cùng 1 VPC với subnets khác nhau (khuyến nghị)

4. **Database**: Nếu cần database, có thể thêm RDS instance trong Private VPC

## Troubleshooting

### Lỗi: "No credentials found"
```bash
aws configure
```

### Lỗi: "Insufficient permissions"
Kiểm tra IAM user/role có đủ quyền:
- AmazonVPCFullAccess
- AmazonEC2FullAccess
- AmazonElasticIPFullAccess

### Backend không thể truy cập Internet
- Kiểm tra NAT Gateway đã running
- Kiểm tra Route Table của private subnet trỏ đến NAT Gateway
- Kiểm tra Security Group cho phép outbound traffic

## Tùy chỉnh thêm

### VPC Peering đã được cấu hình

VPC Peering đã được tự động thiết lập trong `main.tf` để Frontend và Backend có thể giao tiếp với nhau. Route tables đã được cấu hình để cho phép traffic giữa 2 VPCs.

### Thêm RDS Database

Có thể thêm RDS instance trong Private VPC để Backend kết nối.

## Tài liệu tham khảo

- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [AWS VPC Documentation](https://docs.aws.amazon.com/vpc/)
- [AWS NAT Gateway](https://docs.aws.amazon.com/vpc/latest/userguide/vpc-nat-gateway.html)

