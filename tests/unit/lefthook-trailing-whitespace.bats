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

@test "file ending in a newline passes" {
    printf 'final newline\n' > "$TMP/final-newline.txt"
    run lefthook-trailing-whitespace "$TMP/final-newline.txt"
    assert_success
}

@test "file without a final newline fails" {
    printf 'missing final newline' > "$TMP/missing-newline.txt"
    run lefthook-trailing-whitespace "$TMP/missing-newline.txt"
    assert_failure
    assert_output --partial "missing final newline in $TMP/missing-newline.txt"
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

@test "file with both defects reports both diagnostics" {
    printf 'trailing space and no newline ' > "$TMP/both-defects.txt"
    run lefthook-trailing-whitespace "$TMP/both-defects.txt"
    assert_failure
    assert_output --partial "trailing whitespace in $TMP/both-defects.txt"
    assert_output --partial "missing final newline in $TMP/both-defects.txt"
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
