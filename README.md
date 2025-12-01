# Strapi CMS Deployment on AWS using Terraform

Automated deployment of Strapi Headless CMS on AWS EC2 using Infrastructure as Code (Terraform).

## 🚀 Live Deployment

- **API Endpoint**: http://3.130.101.183:1337/api
- **Admin Panel**: http://3.130.101.183:1337/admin
- **Health Check**: http://3.130.101.183:1337/_health

## 📋 Project Overview

This project demonstrates Infrastructure as Code (IaC) principles by automating the complete deployment of Strapi CMS on AWS. The infrastructure is defined, provisioned, and managed entirely through Terraform.

## 🏗️ Architecture

### Infrastructure Components

- **Compute**: AWS EC2 instance (c7i-flex.large)
- **Operating System**: Ubuntu 22.04 LTS
- **Runtime**: Node.js 20.x
- **Database**: SQLite (embedded)
- **Process Manager**: PM2
- **Networking**: 
  - Elastic IP (persistent public IP)
  - Security Group (firewall rules)
  - VPC (default)

### Architecture Diagram

```
┌─────────────────────────────────────────┐
│           Internet                      │
└──────────────┬──────────────────────────┘
               │
               ▼
┌─────────────────────────────────────────┐
│      Elastic IP (3.130.101.183)         │
└──────────────┬──────────────────────────┘
               │
               ▼
┌─────────────────────────────────────────┐
│       Security Group                    │
│  - Port 22 (SSH)                        │
│  - Port 1337 (Strapi)                   │
│  - Port 80 (HTTP)                       │
└──────────────┬──────────────────────────┘
               │
               ▼
┌─────────────────────────────────────────┐
│    EC2 Instance (c7i-flex.large)        │
│  ┌───────────────────────────────────┐  │
│  │   Strapi CMS (Node.js 20.x)       │  │
│  │   - Admin Panel (:1337/admin)     │  │
│  │   - API Endpoints (:1337/api)     │  │
│  │   - SQLite Database               │  │
│  │   - PM2 Process Manager           │  │
│  └───────────────────────────────────┘  │
└─────────────────────────────────────────┘
```

## 📁 Project Structure

```
strapi-terraform-aws/
├── main.tf                 # Main Terraform configuration
├── variables.tf            # Input variables
├── outputs.tf              # Output values
├── terraform.tfvars        # Variable values (excluded from git)
├── scripts/
│   └── install_strapi.sh   # Strapi installation script
├── README.md               # This file
└── .gitignore              # Git ignore rules
```

## 🛠️ Technologies Used

- **Infrastructure as Code**: Terraform
- **Cloud Provider**: AWS (Amazon Web Services)
- **CMS**: Strapi v5.31.2
- **Runtime**: Node.js v20.19.6
- **Database**: SQLite
- **Process Manager**: PM2
- **Operating System**: Ubuntu 22.04 LTS

## 📦 Prerequisites

Before deploying, ensure you have:

1. **AWS Account** with appropriate permissions
2. **AWS CLI** configured with credentials
3. **Terraform** installed (v1.0+)
4. **SSH Key Pair** created in AWS

## 🚀 Deployment Instructions

### Step 1: Clone the Repository

```bash
git clone <your-repo-url>
cd strapi-terraform-aws
```

### Step 2: Configure Variables

Update `terraform.tfvars` with your values:

```hcl
aws_region     = "us-east-2"
key_name       = "your-key-name"
admin_email    = "your-email@example.com"
admin_password = "YourSecurePassword123!"
instance_type  = "c7i-flex.large"
my_ip          = "your-ip/32"  # For SSH access
```

### Step 3: Initialize Terraform

```bash
terraform init
```

### Step 4: Review the Plan

```bash
terraform plan
```

### Step 5: Deploy Infrastructure

```bash
terraform apply
```

Type `yes` when prompted. Deployment takes approximately 10-15 minutes.

### Step 6: Access Your Deployment

After deployment completes, Terraform will output:

```
strapi_public_ip = "3.130.101.183"
strapi_admin_url = "http://3.130.101.183:1337/admin"
strapi_api_url = "http://3.130.101.183:1337/api"
ssh_command = "ssh -i strapi-key-new.pem ubuntu@3.130.101.183"
```

## 🔧 Configuration Details

### Security Group Rules

| Port | Protocol | Source | Purpose |
|------|----------|--------|---------|
| 22 | TCP | Your IP | SSH access |
| 1337 | TCP | 0.0.0.0/0 | Strapi application |
| 80 | TCP | 0.0.0.0/0 | HTTP (optional) |

### EC2 Instance Specifications

- **Instance Type**: c7i-flex.large
- **vCPUs**: 2
- **Memory**: 4 GB RAM
- **Storage**: 20 GB GP3 SSD
- **Network**: Enhanced networking enabled

### Strapi Configuration

- **Version**: 5.31.2
- **Database**: SQLite (file-based)
- **Environment**: Production
- **Port**: 1337
- **Host**: 0.0.0.0 (all interfaces)

## 📊 API Endpoints

### Base URL
```
http://3.130.101.183:1337
```

### Available Endpoints

- **Admin Panel**: `/admin`
- **API Base**: `/api`
- **Health Check**: `/_health`
- **Documentation**: `/documentation` (if enabled)

### Example API Request

```bash
# Get all content (after creating content types)
curl http://3.130.101.183:1337/api/articles

# Health check
curl http://3.130.101.183:1337/_health
```

## 🔐 Security Considerations

### Implemented Security Measures

1. **SSH Access**: Restricted to specific IP addresses
2. **Secrets Management**: Sensitive variables marked as sensitive
3. **Random Keys**: Auto-generated secure keys for Strapi
4. **HTTPS**: Recommended for production (not implemented in this demo)

### Production Recommendations

- Use AWS Secrets Manager for credentials
- Implement SSL/TLS certificates
- Use RDS instead of SQLite for production
- Enable CloudWatch monitoring
- Implement backup strategy
- Use private subnets with NAT gateway

## 💰 Cost Estimation

### Monthly Costs (us-east-2)

| Resource | Cost |
|----------|------|
| EC2 c7i-flex.large | ~$70/month |
| Elastic IP (attached) | Free |
| EBS Storage (20GB GP3) | ~$2/month |
| Data Transfer | Variable |
| **Total** | **~$72/month** |

### Cost Optimization

- Use t3.small for development (~$15/month)
- Stop instance when not in use
- Use Reserved Instances for long-term deployments

## 🧹 Cleanup

To destroy all resources and stop charges:

```bash
terraform destroy
```

Type `yes` when prompted. This will delete:
- EC2 instance
- Elastic IP
- Security Group

## 🐛 Troubleshooting

### Issue: Strapi not accessible

**Solution**: Wait 10-15 minutes for installation to complete. Check logs:

```bash
ssh -i strapi-key-new.pem ubuntu@3.130.101.183
tail -f /var/log/user-data.log
```

### Issue: SSH connection refused

**Solution**: Check security group allows your IP:

```bash
curl ifconfig.me  # Get your current IP
# Update my_ip in terraform.tfvars
terraform apply
```

### Issue: Build failed (out of memory)

**Solution**: Use larger instance type (c7i-flex.large or t3.medium)

## 📚 Additional Resources

- [Strapi Documentation](https://docs.strapi.io/)
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [AWS EC2 Documentation](https://docs.aws.amazon.com/ec2/)

## 👤 Author

**Your Name**
- GitHub: [@yourusername](https://github.com/yourusername)
- Email: your-email@example.com

## 📝 License

This project is for educational purposes as part of an assignment.

## 🙏 Acknowledgments

- Strapi team for the excellent headless CMS
- HashiCorp for Terraform
- AWS for cloud infrastructure

---

**Note**: Remember to update `terraform.tfvars` with your actual values before deployment and never commit sensitive credentials to version control.
