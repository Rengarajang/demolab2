configure_aws_cli() { 
aws --version 
aws configure set aws_access_key_id $AWS_ACCESS_KEY_ID 
aws configure set aws_secret_access_key $AWS_SECRET_ACCESS_KEY 
aws configure set default.region $AWS_REGION 
aws configure set default.output json 
echo "Configured AWS CLI." 
}
#configure_aws_cli
AWS_REPOSITORY="dockerdemo"
CLUSTER="ECScluster"
TAG=$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$AWS_REPOSITORY:$BUILD_NUMBER
sed -i='' "s|app:latest|$TAG|" docker-compose.yml
docker-compose build
eval $(aws ecr get-login --region $AWS_REGION --no-include-email) 
docker push $TAG
ecs-cli configure --region us-east-1 --cluster $CLUSTER
ecs-cli compose --project-name nodejs-service service up
