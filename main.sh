cd `dirname $0`
echo 'step0: docker build'
docker build -t hokupod/ruby_fastimage .
echo 'step1: copy to docker container'
if [ $# != 1 ]; then
    echo argument error: $*
    exit 1
fi

cp $1 target/

echo 'step2: start script'
docker run -it --mount type=bind,src=$(pwd),dst=/home hokupod/ruby_fastimage bundle exec ruby main.rb target/$(basename $1)
cd -

echo 'step3: finish script'
