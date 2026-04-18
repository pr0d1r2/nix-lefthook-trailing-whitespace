#!/usr/bin/env bats

setup() {
    load "${BATS_LIB_PATH}/bats-support/load.bash"
    load "${BATS_LIB_PATH}/bats-assert/load.bash"

    TMP="$BATS_TEST_TMPDIR"
}

@test "no args exits 0" {
    run lefthook-trailing-whitespace
    assert_success
}

@test "non-existent file is skipped" {
    run lefthook-trailing-whitespace /nonexistent/file.txt
    assert_success
}

@test "file without trailing whitespace passes" {
    printf 'clean line\nanother line\n' > "$TMP/clean.txt"
    run lefthook-trailing-whitespace "$TMP/clean.txt"
    assert_success
}

@test "file with trailing spaces fails" {
    printf 'clean line\ntrailing spaces   \n' > "$TMP/spaces.txt"
    run lefthook-trailing-whitespace "$TMP/spaces.txt"
    assert_failure
}

@test "file with trailing tab fails" {
    printf 'clean line\ntrailing tab\t\n' > "$TMP/tab.txt"
    run lefthook-trailing-whitespace "$TMP/tab.txt"
    assert_failure
}

@test "multiple files: one with trailing whitespace causes failure" {
    printf 'clean\n' > "$TMP/good.txt"
    printf 'bad line   \n' > "$TMP/bad.txt"
    run lefthook-trailing-whitespace "$TMP/good.txt" "$TMP/bad.txt"
    assert_failure
}

@test "empty file passes" {
    printf '' > "$TMP/empty.txt"
    run lefthook-trailing-whitespace "$TMP/empty.txt"
    assert_success
}
