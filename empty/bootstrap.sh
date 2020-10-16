
PROJECT_ID=$(gcloud config get-value core/project)

# bootstrap.sh --destroy
for arg in "$@"
do
    case $arg in
        -d|--destroy)
        terraform destroy -auto-approve  
        exit 0 
        ;;
    esac
done

# bootstrap.sh
gsutil mb gs://${PROJECT_ID}-anthos-platform-tf-state || true

if [ -f "backend.tf.bak" ]; then
    rm backend.tf
    mv backend.tf.bak backend.tf
fi
if [ -f "terraform.tfvars.bak" ]; then
    rm terraform.tfvars
    mv terraform.tfvars.bak terraform.tfvars
fi
sed -i'.bak' s/PROJECT_ID/${PROJECT_ID}/g backend.tf
sed -i'.bak' s/PROJECT_ID/${PROJECT_ID}/g terraform.tfvars

terraform init 
terraform plan -out=terraform.tfplan 
terraform apply -auto-approve terraform.tfplan 
