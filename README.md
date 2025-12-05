# Uptime Monitor - AWS & Terraform Project

## 🚀 Project Overview
The Uptime Monitor project automatically checks if a website is up every 5 minutes and sends an email alert if the site is down.  
Built using AWS, Terraform, and GitHub Actions for full CI/CD automation.

---

## 🛠️ Technical Stack
- **AWS S3**: Stores Terraform remote state  
- **AWS Lambda**: Checks website uptime  
- **AWS CloudWatch / EventBridge**: Triggers Lambda every 5 minutes  
- **AWS SNS**: Sends email alerts if site is down  
- **Terraform**: Infrastructure as Code  
- **GitHub Actions**: CI/CD for automatic deployment on push  

---

## ⚙️ How it Works
1. Terraform provisions all AWS resources:
   - S3 bucket for remote state
   - Lambda function for uptime checks
   - EventBridge rule (or CloudWatch) to trigger Lambda
   - SNS topic for email notifications
2. GitHub Actions workflow:
   - Zips Lambda code on push
   - Runs `terraform init`, `plan`, and `apply` automatically
3. Lambda checks website every 5 minutes. If the site is down, an email is sent.

---

## 📁 Project Structure

uptime-monitor-pro/
├── main.tf # Terraform resources
├── providers.tf # AWS provider config
├── lambda_function.py # Lambda code
├── .github/
│ └── workflows/
│ └── deploy.yml # GitHub Actions workflow
├── README.md # Project documentation
└── .gitignore


---

## 💡 Key Features & Learnings
- CI/CD pipeline fully automates deployment  
- Lambda `.zip` is dynamically generated in workflow  
- Remote state management with S3 ensures safe Terraform runs  
- AWS IAM roles and policies managed via Terraform  
- Automatic email alerts for website downtime  

---

## 📌 How to Use
1. Clone the repo:
```bash
git clone https://github.com/YOUR_USERNAME/uptime-monitor-pro.git

Add AWS credentials to GitHub Secrets:

AWS_ACCESS_KEY_ID

AWS_SECRET_ACCESS_KEY

AWS_REGION

Push changes to main branch → GitHub Actions deploys automatically

