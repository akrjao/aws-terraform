
---

### Prerequisites & Guidelines:

---

    1. Terraform:
        1.1 Download from : https://developer.hashicorp.com/terraform/install
        1.2 Add its executable path as part of the “path” environment variable
            (refer to the official website for installation instructions)
            
---     

    2. IAM User With Sufficient Privileges:
        2.1 Sign in to your AWS account on https://aws.amazon.com
        2.2 Navigate to: https://console.aws.amazon.com/iam/home#/users/create
        2.3 @ “Step 1 — Specify user details”
            2.3.1 Fill in the “User name” Field (e.g. terraform)
            2.3.2 Click on “Next” Button
        2.4 @ “Step2 — Set permissions”
            2.4.1 Set “Permissions options” to “Attach policies directly”
            2.4.2 In “Permissions policies” panel, search for and, tick “AdministratorAccess”
            2.4.3 Click on “Next” Button
        2.5 @ “Step 3 — Review and create”
            2.5.1 Click on “Create User” Button
            
---  
    3. Generation of “Access Key” and “Secret Key” for Authenticating and Authorizing Terraform on AWS:
        3.1 Navigate to: https://console.aws.amazon.com/iam/home#/users/
        3.2 In “Users” panel, search for and, click on the username of the IAM user created in (Prerequisites & Guidelines - 2.)
        3.3 In “Summary” panel, click on “Create access key”
        3.4 @ “Step 1 — Access key best practices & alternatives”
            3.4.1 Set “Third-party Service” as the “use case”
            3.4.2 Tick “I understand the above recommendation and want to proceed to create an access key.”
            3.4.3 Click on “Next” Button
        3.5 @ “Step 2 — Optional Set description tag”
            3.5.1 Click on “Create access key” button
        3.6 @ “Step 3 — Retrieve access keys”
            3.6.1 Click on “Download .csv file” button
            3.6.2 Click on “Done” button
            
---  

    4. Creation of “TF_VAR_AWS_ACCESS_KEY” and “TF_VAR_AWS_SECRET_KEY” Environment Variables:
        * For (Windows/PowerShell)
            4.1 Open terminal window (IMPORTANT ⇾ as administrator).
            4.2 Replace YOUR_AWS_ACCESS_KEY with “Access Key” from .csv file (Prerequisites & Guidelines 3.), then execute:
                * [Environment]::SetEnvironmentVariable("TF_VAR_AWS_ACCESS_KEY", "YOUR_AWS_ACCESS_KEY", "Machine")
            4.3 Replace YOUR_AWS_SECRET_KEY with “Secret Key” from .csv file (Prerequisites & Guidelines 3.), then execute:
                * [Environment]::SetEnvironmentVariable("TF_VAR_AWS_SECRET_KEY", "YOUR_AWS_SECRET_KEY", "Machine")
        * For (Linux/Bash | macOS/Zsh)
            4.1 Open terminal window
            4.2 Replace YOUR_AWS_ACCESS_KEY with “Access Key” from .csv file (Prerequisites & Guidelines 3.), then execute:
                * export TF_VAR_AWS_ACCESS_KEY="YOUR_AWS_ACCESS_KEY"
            4.3 Replace YOUR_AWS_SECRET_KEY with “Secret Key” from .csv file (Prerequisites & Guidelines 3.), then execute:
                * export TF_VAR_AWS_SECRET_KEY="YOUR_AWS_SECRET_KEY"
                
---

### Key Notes

    1. The "default AWS architecture” and its implementation in Terraform span:
        * “eu-central-1” as the “default” region
        * “us-east-1”, and “ap-southeast-1” as “non-default” regions
        * “ap-southeast-1” as a way to show “regional expansion”.
        * (See Sections ⇾
                * “Default AWS Architecture Provisioning via Terraform - Apply Phase”
                * “Default AWS Architecture Provisioning via Terraform - Destroy Phase”
          )
        * Wether more regions are desired to be included, refer to (Key Notes 2.)

    2. The AWS architecture and its implementation in Terraform:
        * have a dynamic nature, hence, allowing the “expansion/reduction” of the range of “non-default regions” 
        * (See Sections ⇾
                * “Expanded AWS Architecture Provisioning via Terraform - Expansion - Apply Phase”
                * “Expanded AWS Architecture Provisioning via Terraform - Reduction”
                * “Expanded AWS Architecture Provisioning via Terraform - Expansion - Destroy Phase”
          )

    3. “crossover/” directory includes:
        * data (ARNs) that are shared between workspaces/regions for deploying/destroying the AWS architecture via Terraform.
    
    4. “userdata/user_data.sh” file:
        * includes, instructions for: 
            * installing and enabling “Apache HTTP Server”
            * setting up an “index.html” file to display metadata about running EC2 instances
            * showcasing simple backend processing
        * Due to the immense range of Amazon Machine Images (AMIs):
            * user_data.sh has been only tested with (Amazon Linux 2023 AMI)
            * normally, user_data.sh should be adjusted with other types of AMIs

    5. “userdata/static/” directory includes “static files”, which are:
        * uploaded to the “default S3 Bucket”
        * replicated from the “default S3 Bucket” to “backup S3 Buckets” in non-default regions.
        * accessed primarily via a “Cloudfront Distribution”
    
    6. “variables_global.tf” file:
        * contains variables with a global scope — used across all regions.

    7. “variables_global.tfvars” file: 
        * assigns values for variables with a global scope, as defined in the “variables_global.tf” file.

    8. “variables_region.tf” file:
        * contains variables with a regional scope — used in a specific region.
    
    9. “variables_region_<region-code>.tfvars” file: 
        * assigns region-specific values for the variables defined in “variables_region.tf” file.

    10. After deploying the AWS architecture via Terraform, to obtain the Global Accelerator DNS name (Website Entrypoint), execute:
        * Must be located at the “aws” root directory when invoking the following commands

        * terraform workspace select eu-central-1;
        * terraform output website_entrypoint;

        * (Combined Commands):
            * terraform workspace select eu-central-1; terraform output website_entrypoint;
    
---

### Default AWS Architecture Provisioning via Terraform - Apply Phase:

    * Must be located at the “aws” root directory when invoking the following commands

    1. Initialize Terraform:
        * terraform init;
        
    2. Create required workspaces:
        * terraform workspace new eu-central-1;
        * terraform workspace new us-east-1;
        * terraform workspace new ap-southeast-1;
        
    3. Create required S3_Buckets with versioning enabled in non-default regions:
        * terraform workspace select us-east-1;
        * terraform apply -target="null_resource.aws_s3_bucket_arn_setter" -var-file="variables_region_us-east-1.tfvars" -var-file="variables_global.tfvars" -auto-approve -compact-warnings;
        * terraform workspace select ap-southeast-1;
        * terraform apply -target="null_resource.aws_s3_bucket_arn_setter" -var-file="variables_region_ap-southeast-1.tfvars" -var-file="variables_global.tfvars" -auto-approve -compact-warnings;
        
    4. Create resources in the default region:
        * terraform workspace select eu-central-1;
        * terraform apply -var-file="variables_region_eu-central-1.tfvars" -var-file="variables_global.tfvars" -auto-approve;
        
    5. Create resources in non-default regions:
        * terraform workspace select us-east-1;
        * terraform apply -var-file="variables_region_us-east-1.tfvars" -var-file="variables_global.tfvars" -auto-approve;
        * terraform workspace select ap-southeast-1;
        * terraform apply -var-file="variables_region_ap-southeast-1.tfvars" -var-file="variables_global.tfvars" -auto-approve;

    6. Output Global Accelerator DNS name (Website Entrypoint):
        * terraform workspace select eu-central-1;
        * terraform output website_entrypoint;

    * (Combined Commands):
        * terraform init; terraform workspace new eu-central-1; terraform workspace new us-east-1; terraform workspace new ap-southeast-1; terraform workspace select us-east-1; terraform apply -target="null_resource.aws_s3_bucket_arn_setter" -var-file="variables_region_us-east-1.tfvars" -var-file="variables_global.tfvars" -auto-approve -compact-warnings; terraform workspace select ap-southeast-1; terraform apply -target="null_resource.aws_s3_bucket_arn_setter" -var-file="variables_region_ap-southeast-1.tfvars" -var-file="variables_global.tfvars" -auto-approve -compact-warnings; terraform workspace select eu-central-1; terraform apply -var-file="variables_region_eu-central-1.tfvars" -var-file="variables_global.tfvars" -auto-approve; terraform workspace select us-east-1; terraform apply -var-file="variables_region_us-east-1.tfvars" -var-file="variables_global.tfvars" -auto-approve; terraform workspace select ap-southeast-1; terraform apply -var-file="variables_region_ap-southeast-1.tfvars" -var-file="variables_global.tfvars" -auto-approve; terraform workspace select eu-central-1; terraform output website_entrypoint;

---

### Default AWS Architecture Provisioning via Terraform - Destroy Phase:

    * Must be located at the “aws” root directory when invoking the following commands

    1. Destroy resources in non-default regions:
        * terraform workspace select ap-southeast-1;
        * terraform destroy -var-file="variables_region_ap-southeast-1.tfvars" -var-file="variables_global.tfvars" -auto-approve;
        * terraform workspace select us-east-1;
        * terraform destroy -var-file="variables_region_us-east-1.tfvars" -var-file="variables_global.tfvars" -auto-approve;
        
    2. Destroy resources in the default Region:
        * terraform workspace select eu-central-1;
        * terraform destroy -var-file="variables_region_eu-central-1.tfvars" -var-file="variables_global.tfvars" -auto-approve;
        
    3. Delete workspaces:
        * terraform workspace select default;
        * terraform workspace delete ap-southeast-1;
        * terraform workspace delete us-east-1;
        * terraform workspace delete eu-central-1;

    * (Combined Commands):
        * terraform workspace select ap-southeast-1; terraform destroy -var-file="variables_region_ap-southeast-1.tfvars" -var-file="variables_global.tfvars" -auto-approve; terraform workspace select us-east-1; terraform destroy -var-file="variables_region_us-east-1.tfvars" -var-file="variables_global.tfvars" -auto-approve; terraform workspace select eu-central-1; terraform destroy -var-file="variables_region_eu-central-1.tfvars" -var-file="variables_global.tfvars" -auto-approve; terraform workspace select default; terraform workspace delete ap-southeast-1; terraform workspace delete us-east-1; terraform workspace delete eu-central-1;

---

### Expanded AWS Architecture Provisioning via Terraform - Expansion - Apply Phase:


    * Must be located at the “aws” root directory when invoking the following commands
    * Execute the following for “as many non-default regions to expand to”
    * Change <region-code> to the region-code of the desired non-default region

        1. Prepare ".tfvars" file
            1.1 Copy and paste another ".tfvars" file.
            1.2 Rename it, according to the pattern of:
                "variables_region_<region-code>.tfvars"
            1.3 Modify its content accordingly.
                (IMPORTANT ⇾ MUST SET "default" ATTRIBUTE TO "false").
        
        2. Initialize Terraform:
            2.1 Execute:
                * terraform init;
                
        3. Create required workspace:
                * terraform workspace new <region-code>;
                
        4. Create required S3_Bucket with versioning enabled:
            * terraform workspace select <region-name>;
            * terraform apply -target="null_resource.aws_s3_bucket_arn_setter" -var-file="variables_region_<region-name>.tfvars" -var-file="variables_global.tfvars" -auto-approve -compact-warnings;
        
        * (Combined Commands):
            * terraform init; terraform workspace new <region-code>; terraform workspace select <region-name>; terraform apply -target="null_resource.aws_s3_bucket_arn_setter" -var-file="variables_region_<region-name>.tfvars" -var-file="variables_global.tfvars" -auto-approve -compact-warnings;

    * Execute the following “once”:

        5. Carry on with "Default AWS Architecture Provisioning via Terraform - Apply Phase"

    * Execute the following for “as many non-default regions to expand to”:

        6. Create resources in the desired non-default region:
            * terraform workspace select <region-code>;
            * terraform apply -var-file="variables_region_<region-code>.tfvars" -var-file="variables_global.tfvars" -auto-approve;
        
        * (Combined Commands):
            * terraform workspace select <region-code>; terraform apply -var-file="variables_region_<region-code>.tfvars" -var-file="variables_global.tfvars" -auto-approve;

---

### Expanded AWS Architecture Provisioning via Terraform - Reduction:

    * Must be located at the “aws” root directory when invoking the following commands
    * Execute the following for “as many non-default regions to reduce”
    * Change <region-code> to the region-code of the desired non-default region

    1. Destroy resources:
        * terraform workspace select <region-code>;
        * terraform destroy -var-file="variables_region_<region-code>.tfvars" -var-file="variables_global.tfvars" -auto-approve;

    2. Delete workspace:
        * terraform workspace select default;
        * terraform workspace delete <region-code>;

    * (Combined Commands):
        * terraform workspace select <region-code>; terraform destroy -var-file="variables_region_<region-code>.tfvars" -var-file="variables_global.tfvars" -auto-approve; terraform workspace select default; terraform workspace delete <region-code>;

    3. Delete "variables_region_<region-code>.tfvars" file (Optional)

---

### Expanded AWS Architecture Provisioning via Terraform - Destroy Phase:

    * Must be located at the “aws” root directory when invoking the following commands
    * Execute the following for “as many non-default regions to destroy”
    * Change <region-code> to the region-code of the desired non-default region

        1. Destroy resources in the non-default region:
            * terraform workspace select <region-code>;
            * terraform destroy -var-file="variables_region_<region-code>.tfvars" -var-file="variables_global.tfvars" -auto-approve;

        2. Delete workspace:
            * terraform workspace select default;
            * terraform workspace delete <region-code>;

        * (Combined Commands):
            * terraform workspace select <region-code>; terraform destroy -var-file="variables_region_<region-code>.tfvars" -var-file="variables_global.tfvars" -auto-approve; terraform workspace select default; terraform workspace delete <region-code>;

    * Execute the following “once”:

        3. Destroy resources in the default region:
            * terraform workspace select eu-central-1;
            * terraform destroy -var-file="variables_region_eu-central-1.tfvars" -var-file="variables_global.tfvars" -auto-approve;

        3. Delete workspace:
            * terraform workspace select default;
            * terraform workspace delete eu-central-1;

        * (Combined Commands):
            * terraform workspace select eu-central-1; terraform destroy -var-file="variables_region_eu-central-1.tfvars" -var-file="variables_global.tfvars" -auto-approve; terraform workspace select default; terraform workspace delete eu-central-1;

---