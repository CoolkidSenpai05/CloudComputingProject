# Quick Start Guide - AWS Infrastructure

Hướng dẫn nhanh để triển khai infrastructure AWS cho SocialEcho.

## Bước 1: Chuẩn bị

1. **Cài đặt Terraform**
   ```powershell
   # Windows với Chocolatey
   choco install terraform
   
   # Hoặc tải từ: https://www.terraform.io/downloads
   ```

2. **Cấu hình AWS Credentials**
   ```powershell
   aws configure
   ```
   Nhập:
   - AWS Access Key ID
   - AWS Secret Access Key  
   - Default region: `us-east-1` (hoặc region bạn muốn)
   - Default output: `json`

## Bước 2: Triển khai

1. **Di chuyển vào thư mục terraform**
   ```powershell
   cd terraform
   ```

2. **Khởi tạo Terraform**
   ```powershell
   terraform init
   ```

3. **Xem kế hoạch triển khai**
   ```powershell
   terraform plan
   ```

4. **Triển khai infrastructure**
   ```powershell
   terraform apply
   ```
   Nhập `yes` khi được hỏi.

## Bước 3: Kiểm tra kết quả

Sau khi triển khai xong, bạn sẽ thấy output:
- **Frontend Public IP**: IP công khai của frontend instance
- **Backend Private IP**: IP riêng của backend instance
- **NAT Gateway IP**: IP của NAT Gateway

## Bước 4: Kết nối đến instances

### Frontend (có Public IP)
```powershell
ssh -i your-key.pem ubuntu@<FRONTEND_PUBLIC_IP>
```

### Backend (không có Public IP)
Backend không có public IP. Để kết nối:
1. SSH vào Frontend trước
2. Từ Frontend, SSH vào Backend bằng private IP

Hoặc sử dụng AWS Systems Manager Session Manager.

## Bước 5: Cấu hình ứng dụng

### Trên Frontend Instance
```bash
# Cài đặt Node.js và dependencies
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs

# Clone và build frontend
cd /var/www
git clone <your-repo>
cd client
npm install
npm run build

# Cấu hình Nginx
sudo nano /etc/nginx/sites-available/default
```

### Trên Backend Instance
```bash
# Cài đặt Node.js
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs

# Clone và cài đặt backend
cd /opt
git clone <your-repo>
cd server
npm install

# Cấu hình environment variables
nano .env

# Chạy ứng dụng với PM2
sudo npm install -g pm2
pm2 start app.js
pm2 save
pm2 startup
```

## Lưu ý quan trọng

1. **Chi phí**: NAT Gateway có chi phí ~$32/tháng + data transfer
2. **Security**: Cập nhật `allowed_ssh_cidr` trong `terraform.tfvars` với IP của bạn
3. **SSH Key**: Tạo key pair trước khi deploy hoặc sử dụng AWS Systems Manager

## Xóa infrastructure

Khi không cần nữa:
```powershell
terraform destroy
```

## Troubleshooting

### Lỗi "No credentials"
```powershell
aws configure
```

### Lỗi "Insufficient permissions"
Đảm bảo IAM user có quyền:
- AmazonVPCFullAccess
- AmazonEC2FullAccess
- AmazonElasticIPFullAccess

### Backend không thể truy cập Internet
- Kiểm tra NAT Gateway status trong AWS Console
- Kiểm tra Route Table của private subnet

