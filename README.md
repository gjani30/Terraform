         ___        ______     ____ _                 _  ___  
        / \ \      / / ___|   / ___| | ___  _   _  __| |/ _ \ 
       / _ \ \ /\ / /\___ \  | |   | |/ _ \| | | |/ _` | (_) |
      / ___ \ V  V /  ___) | | |___| | (_) | |_| | (_| |\__, |
     /_/   \_\_/\_/  |____/   \____|_|\___/ \__,_|\__,_|  /_/ 
 ----------------------------------------------------------------- 


Hi there! Welcome to AWS Cloud9!

To get started, create some files, play with the terminal,
or visit https://docs.aws.amazon.com/console/cloud9/ for our documentation.

Happy coding!


## Prerequisite

- must create three different S3 buckets for each environment (prod, dev, staging) to store Terraform state file
- execute the below command to deploy the infrastructure
- `` terraform apply -var-file=common.dev.tfvars -no-color -auto-approve ``
- for cleanup, execute the below command to destroy the deployed infrastructure
- `` terraform destroy -var-file=common.dev.tfvars -no-color -auto-approve ``
