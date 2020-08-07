set -eu -o pipefail
trap 'echo "ERROR: line no = $LINENO, exit status = $?" >&2; exit 1' ERR

if test $# -ne 1 -a $# -ne 2; then
    echo argument error: $*
    exit 1
fi

cd $(dirname $0) || exit 1

if test $DISABLE_BUILD_CONTAINER -ne 1; then
    echo 'step0: docker build'
    docker build -t hokupod/ruby_fastimage .
fi

echo 'step1: copy to docker container'
cp $1 target/

echo 'step2: start script'
if test $# -eq 1; then
    docker run -it --mount type=bind,src=$(pwd),dst=/home hokupod/ruby_fastimage bundle exec ruby main.rb target/$(basename $1)
elif test $# -eq 2; then
    docker run -it --mount type=bind,src=$(pwd),dst=/home hokupod/ruby_fastimage bundle exec ruby main.rb target/$(basename $1) $2
fi

echo 'step3: finish script'
echo "       output to $(dirname $0)/dest/$(basename $1)"
echo 'step4: return to your work dir'
cd - || exit 1

exit 0
