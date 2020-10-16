
PROJECT_ID=$(gcloud config get-value core/project)

export PROJECT_NUMBER=$(gcloud projects describe ${PROJECT_ID} --format 'value(projectNumber)')
gcloud services enable cloudbuild.googleapis.com
gcloud services enable containeranalysis.googleapis.com
gcloud projects add-iam-policy-binding ${PROJECT_ID} --member serviceAccount:${PROJECT_NUMBER}@cloudbuild.gserviceaccount.com --role roles/owner
gcloud projects add-iam-policy-binding ${PROJECT_ID} --member serviceAccount:${PROJECT_NUMBER}@cloudbuild.gserviceaccount.com --role roles/containeranalysis.admin


# bootstrap.sh --destroy
for arg in "$@"
do
    case $arg in
        -d|--destroy)
        gcloud builds submit --substitutions=_PROJECT_ID=${PROJECT_ID} --config cloudbuild-destroy.yaml
        exit 0 
        ;;
    esac
done

# bootstrap.sh
gcloud builds submit --substitutions=_PROJECT_ID=${PROJECT_ID} 
