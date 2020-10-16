
PROJECT_ID=$(gcloud config get-value core/project)


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
