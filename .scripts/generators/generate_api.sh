#!bash

gen=./.scripts/generators
source $gen/.pattern_generator/pattern_generator.sh

function configure_internal_paths_from_yaml() {
    local component_name=$1
    internal_path="$(get_from_yaml $component_name pubspec.yaml)/"
    internal_path="$(integrate_relative_path "$internal_path")"
}

function api_template() {
    configure_internal_paths_from_yaml "internal_path_api"
    templates=("$(build_template "$gen/.templates/api/api_template.dart")")
    paths=("${internal_path}${name}.dart")
}

function api() {
    create_template "api_template"
}

function create() {
    echo ""
    printf "Enter api name: "
    read name
    name="${name// /_}"

    api
}

# function parse_read_name() {
#     local name=$1
#     local pname="$(convert_to_pascal_case $name)"
#     local cname="$(convert_to_camel_case $name)"
#     printf "late final ${pname}Api ${cname} = ${pname}Api(this);"
# }

# function read() {
#     local path="$(get_from_yaml "internal_path_api" pubspec.yaml)/"
#     local apis="$(ls ${path}*.dart)"
#     for api in $apis; do
#         local api_path="$(perl -nE "s|.*lib(.*)|import '\1';|; print;" <<< "$api")"
#         echo $api_path
#     done;
#     echo ''
#     for api in $apis; do
#         local api_name="$(perl -nE 's|.*/(.*)\.dart|\1|; print;' <<< "$api")"
#         echo "$(parse_read_name "$api_name")"
#     done;
# }

function list() {
    echo "create -> Generate Api"
    echo "read -> Generate ApiRepository Code by reading all available apis"
}

function help() { list; }

create

