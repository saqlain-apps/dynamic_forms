#!bash

gen=./.scripts/generators
source $gen/.pattern_generator/pattern_generator.sh

function configure_internal_paths_from_yaml() {
    local component_name=$1
    internal_path="$(get_from_yaml $component_name pubspec.yaml)/"
    internal_path="$(integrate_relative_path "$internal_path")"
}

function bloc_controller_template() {
    configure_internal_paths_from_yaml "internal_path_controller"
    templates=(
        "$(build_template "$gen/.templates/bloc_controller/controller_template.dart")"
        "$(build_template "$gen/.templates/bloc_controller/event_template.dart")"
        "$(build_template "$gen/.templates/bloc_controller/state_template.dart")"
    )
    paths=(
        "${internal_path}${name}/${name}_controller.dart"
        "${internal_path}${name}/${name}_event.dart"
        "${internal_path}${name}/${name}_state.dart"
    )
    directory_paths=("${internal_path}${name}")
}

function bloc_screen_template() {
    configure_internal_paths_from_yaml "internal_path_screen"
    templates=("$(build_template "$gen/.templates/bloc_screen/screen_template.dart")")
    paths=("${internal_path}${name}/${name}_screen.dart")
    directory_paths=("${internal_path}${name}")
}

function bloc() {
    local component=$1
    if [ $component -eq 1 ]
    then
        create_template "bloc_controller_template"
    elif [ $component -eq 2 ]
    then
        create_template "bloc_screen_template"
    elif [ $component -eq 3 ]
    then
        create_template "bloc_controller_template"
        create_template "bloc_screen_template"
    else
        exit 1
    fi
}

function create() {
    echo ""
    local structure
    echo "Choose structure:"
    echo "1. Component Based Structure"
    echo "2. Module/Feature Based Structure"
    read structure
    
    echo ""
    local component
    echo "Choose component:"
    echo "1. Controller"
    echo "2. Screen"
    echo "3. Both"
    read component

    echo ""
    printf "Enter component name: "
    read name
    name="${name// /_}"

    if [ $structure -eq 2 ]
    then
        printf "Enter Module path: "
        read path
    fi

    bloc "$component"
}

create