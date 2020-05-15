# https://hub.docker.com/r/celerative/ghost-s3

  The intention for this image is to run on ECS task with RDS for database, SES as email service, S3 for image storage and CloudFront as CDN (optional).

## Configuration with env variables

### General
  * `NODE_ENV=production`
  * `url=<https://ghost-blog-page.com>`

### AWS RDS databese
  * `database__client=mysql`
  * `database__connection__database=ghost-db`
  * `database__connection__host=<your-db.aws-region.rds.amazonaws.com>`
  * `database__connection__password=<db-password>`
  * `database__connection__port=3306`
  * `database__connection__ssl=true`
  * `database__connection__user=<your-db-user>`
  
### AWS SES
  * `mail__from=<no-reply@your-email.com>`
  * `mail__options__auth__pass=<IAM-SES-user-secret-key>`
  * `mail__options__auth__user=<IAM-SES-user-access-key>`
  * `mail__options__host=<email-smtp.aws-region.amazonaws.com>`
  * `mail__options__port=465`
  * `mail__options__service=SES`
  * `mail__transport=SMTP`

### AWS S3 storage adapter
  * `storage__active=ghost-s3`
  * `storage__ghost-s3__accessKeyId=<IAM-S3-user-access-key>`
  * `storage__ghost-s3__assetHost=<your-CloudFront-CDN-or-DNS-asociated>` (optional)
  * `storage__ghost-s3__bucket=<your-S3-bucket>`
  * `storage__ghost-s3__region=<aws-region>`
  * `storage__ghost-s3__secretAccessKey=<IAM-SES-user-secret-key>`