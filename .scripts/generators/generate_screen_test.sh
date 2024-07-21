#!bash

gen=./.scripts/generators
source $gen/.pattern_generator/pattern_generator.sh

function screen_test_template() {
    templates=("$(build_template "$gen/.templates/screen_test/screen_test_template.dart")")
    paths=("test/unit_tests/${name}_screen_tests/${name}_screen_tests.dart")
    directory_paths=("test/unit_tests/${name}_screen_tests")
}

function screen_test() {
    create_template "screen_test_template"
}

function create() {
    echo ""
    printf "Enter screen name: "
    read name
    name="${name// /_}"

    screen_test
}

create
