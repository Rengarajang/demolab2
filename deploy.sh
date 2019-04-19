configure_aws_cli() { 
aws --version 
aws configure set aws_access_key_id $AWS_ACCESS_KEY_ID 
aws configure set aws_secret_access_key $AWS_SECRET_ACCESS_KEY 
aws configure set default.region $AWS_REGION 
aws configure set default.output json 
echo "Configured AWS CLI." 
}
#configure_aws_cli
AWS_ACCOUNT_ID="624729804591"
AWS_REGION="us-east-1"
AWS_REPOSITORY="dockerdemo"
CLUSTER="ECScluster"
BUILD_NUMBER=$1
TAG="$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$AWS_REPOSITORY:$BUILD_NUMBER"
echo "...$BUILD_NUMBER is the latest build"
echo $TAG
sed -i='' "s|app:latest|$TAG|" docker-compose.yml
/usr/local/bin/docker-compose build
eval $(aws ecr get-login --region $AWS_REGION --no-include-email) 
/usr/bin/docker push $TAG
/usr/local/bin/ecs-cli configure --region us-east-1 --cluster $CLUSTER
/usr/local/bin/ecs-cli compose --project-name nodejs-service service up
