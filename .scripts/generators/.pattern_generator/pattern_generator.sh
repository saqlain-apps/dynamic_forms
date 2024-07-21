#!bash

function parse_yaml {
    local prefix=$2
    local s='[[:space:]]*' w='[a-zA-Z0-9_]*' fs=$(echo @|tr @ '\034')
    sed -ne "s|^\($s\):|\1|" \
        -e 's|`||g;s|\$||g;' \
        -e "s|^\($s\)\($w\)$s:$s[\"']\(.*\)[\"']$s\$|\1$fs\2$fs\3|p" \
        -e "s|^\($s\)\($w\)$s:$s\(.*\)$s\$|\1$fs\2$fs\3|p"  $1 |
    awk -F$fs '{
        indent = length($1)/2;
        vname[indent] = $2;
        for (i in vname) {if (i > indent) {delete vname[i]}}
        if (length($3) > 0) {
            vn=""; for (i=0; i<indent; i++) {vn=(vn)(vname[i])("_")}
            gsub(/\s*#.*$/, "", $3); # Remove comments
            gsub(/^[ \t]+/, "", $3); gsub(/[ \t]+$/, "", $3);
            printf("%s%s%s=\"%s\"\n", "'$prefix'",vn, $2, $3);
        }
    }'
}

function get_from_yaml() {
    local key=$1
    local yaml=$2
    yaml=$(parse_yaml pubspec.yaml)
    yaml=$(sed "s|[^ ]*=|local &|" <<< "$yaml")
    eval $yaml
    echo "${!key}"
}

function convert_to_pascal_case() {
    local str=$1
    local pascal_case=$(perl -nE 'say join "", map {ucfirst lc} split /[^[:alnum:]]+/' <<< "$str")
    echo "$pascal_case"
}

function convert_to_camel_case() {
    local str=$1
    local camel_case=$(convert_to_pascal_case "$str")
    camel_case="$(tr '[:upper:]' '[:lower:]' <<< ${camel_case:0:1})${camel_case:1}"
    echo "$camel_case"
}

function readfile() {
    local filename=$1
    local file="$(<"${filename}")"
    echo "$file"
}

function substitute() {
    local pattern=$1
    local sub=$2
    local source=$3
    local modified=$(sed "s|${pattern}|${sub}|g" <<< "$source")
    echo "$modified"
}

function set_basepath() {
    basepath="$(pwd)"
}

function create_directory_paths() {
    local i
    for i in "${!directory_paths[@]}"
    do
        directory_paths[i]="${basepath}/${directory_paths[i]}"
        mkdir "${directory_paths[i]}"
    done
}

function create_paths() {
    local i
    for i in "${!paths[@]}"
    do
        paths[i]="${basepath}/${paths[i]}"
        touch "${paths[i]}"
    done
}

function configure_paths() {
    set_basepath
    create_directory_paths
    create_paths
}

function output_template() {
    local i
    for i in "${!paths[@]}"
    do
        printf "${templates[i]}" >> "${paths[i]}"
    done
}

function output() {
    configure_paths
    output_template
}

function configure_template() {
    local template="$2"
    local name="$1"
    local pascal_name="$(convert_to_pascal_case $name)"

    template="$(substitute "<name>" "${name}" "$template")"
    template="$(substitute "<Name>" "${pascal_name}" "$template")"

    if [ -n "$components_path" ]
    then
        template="$(substitute "<path>" "${components_path}" "$template")"
    fi

    echo "$template"
}

function build_template() {
    local template=$1
    template="$(readfile "$template")"
    template="$(configure_template $name "$template")"
    echo "$template"
}

function integrate_relative_path() {
    local internal_path=$1
    if [ -n "$path" ]
    then
        internal_path="${path}/${internal_path}"
    fi
    echo "$internal_path"
}

function create_template() {
    exc=$1
    $exc
    output
}