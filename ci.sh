#/bin/sh

SOURCE_DIR=$(pwd)
cd cppast/external/type_safe
git apply -v $SOURCE_DIR/stdlibcxx_checks.patch && git diff
cd $SOURCE_DIR

mkdir build && cd build
cmake .. -DTINYREFL_BUILD_TESTS=ON
make -j
