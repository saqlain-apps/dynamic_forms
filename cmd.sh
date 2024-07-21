#!bash

function generate() {
    code=$1

    if [ -n "$code" ]
    then
        source "./.scripts/generators/generate_$code.sh"
    else
        echo "api -> Generate Api"
        echo "bloc -> Generate Bloc"
        echo "provider -> Generate Provider"
        echo "screen_test -> Generate Screen Test"
    fi
}

function buildApk() {
    launch=$1
    mode=$2
    cmd="flutter build apk --$launch --dart-define-from-file .env --dart-define mode=$mode"
    if [ -n "$3" ]; then
        cmd="$cmd --dart-define $3"
    fi
    echo $cmd
    $cmd
}

function buildIos() {
    launch=$1
    mode=$2
    cmd="flutter build ios --$launch --dart-define-from-file .env --dart-define mode=$mode"
    if [ -n "$3" ]; then
        cmd="$cmd --dart-define $3"
    fi
    echo $cmd
    $cmd
}

function list() {
    echo "generate -> Run Code Generator"
    echo "buildApk <launch: [debug/profile/release]> <mode: [dev/testing/qa/stage/prod]> [additional env params] -> Build Apk"
    echo "buildIos <launch: [debug/profile/release]> <mode: [dev/testing/qa/stage/prod]> [additional env params] -> Build Ios"
}

function help() { list; }

$@
