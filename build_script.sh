tag=`date +"v0.4.0.%M%H%d%m%y"`
echo $tag
CODE_FOLDER=teamserver/trunk
svn up $CODE_FOLDER 
docker build    --build-arg BUILD_PATH=$CODE_FOLDER --build-arg CF_BUILDPACK=v4.12.0   --tag etisalat.openshift.com/cws:$tag .
