# Security & Audit Remediation

### Severity Rating for the given findings (1-5, with 1 being highest severity)
1. RDS instance is publicly accessible
2. S3 bucket 'nimbus-uploads' has public ACLs enabled
3. EC2 security group allows 0.0.0.0/0 on port 22
5. EC2 instance running Ubuntu with 14 Critical CVEs (kernel + openssl)
6. IAM user 'deploy-user' has AdministratorAccess
7. CloudTrail is not enabled in us-east-1

> As per my judgement Client/Customer data needs to be highly secured and needs immediate attention
---
### Remediation Actions
1. RDS instance is publicly accessible
   - change security group rules to allow access only from Instance/Containers Security Group
   - Enable IAM Authentication with DB passwords secured in AWS Secrets Manager with Automatic Rotation enabled for every month or 45 days.
   - Create AWS Config rule to destory resource if launched with public subnets or SG rule having 0.0.0.0/0 and notiify team using SNS

2. S3 bucket 'nimbus-uploads' has public ACLs enabled
   - Disable ACLs and enable bucket policy rules to allow only from trusted sources like EC2
   - If public access is needed create a CloudFront which has public access with WAF rules and point it to S3, keeping bucket private
   - We can use S3 Gateway Endpoints to reduce cost if network is within VPC.

3. EC2 security group allows 0.0.0.0/0 on port 22
   - Change security group rules to allow from only specific IPs
   - Create AWS Config rule to destory resource if launched with public subnets or SG rule having 0.0.0.0/0 and notiify team using SNS

4. EC2 instance running Ubuntu with 14 Critical CVEs (kernel + openssl)
   - Patch the EC2 instance using SSM Patch Baseline with security, critical bugfixes or update all if needed
   - Harden the image and create a GOLIM AMI.
   - If needed create ASG behind ELB and upload certificates in ELB, reducing risk of public access while instance being private
   - Check f SSL certificates are expired, create a new certificate and upload them.
   - Use AWS Certificate Manager if needed to intimate user when certificates expire or to create certificates

5. IAM user 'deploy-user' has AdministratorAccess
   - Reduce the permissions to least previlige by providing access only to services which was needed by user
   - Also limit user write permissions even to needed services
   - Review Access permissions in AWS IAM Access Advisor (needs to enable it)
  
6. CloudTrail is not enabled in us-east-1
   - Enable cloud trail as it helps in auditing about which user made changes to the services within the account
