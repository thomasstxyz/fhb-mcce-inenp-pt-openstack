# README.md

Set environment variables.

    export OS_USERNAME=my_user
    export OS_PASSWORD=my_pass
    export OS_PROJECT_ID=1234...
    export TF_VAR_public_key="ssh-rsa ..."

Create infrastructure

    terraform apply -auto-approve

Destroy infrastructure

    terraform destroy -auto-approve
