#!/usr/bin/env bats
load test_helper

setup() {
  dokku "$PLUGIN_COMMAND_PREFIX:create" l
}

teardown() {
  dokku --force "$PLUGIN_COMMAND_PREFIX:destroy" l
}

@test "($PLUGIN_COMMAND_PREFIX:info) error when there are no arguments" {
  run dokku "$PLUGIN_COMMAND_PREFIX:info"
  assert_contains "${lines[*]}" "Please specify a valid name for the service"
}

@test "($PLUGIN_COMMAND_PREFIX:info) error when service does not exist" {
  run dokku "$PLUGIN_COMMAND_PREFIX:info" not_existing_service
  assert_contains "${lines[*]}" "service not_existing_service does not exist"
}

@test "($PLUGIN_COMMAND_PREFIX:info) success" {
  run dokku "$PLUGIN_COMMAND_PREFIX:info" l
  assert_contains "${lines[*]}" "gotenberg://dokku-gotenberg-l:11211"
}

@test "($PLUGIN_COMMAND_PREFIX:info) replaces underscores by dash in hostname" {
  dokku "$PLUGIN_COMMAND_PREFIX:create" test_with_underscores
  run dokku "$PLUGIN_COMMAND_PREFIX:info" test_with_underscores
  assert_contains "${lines[*]}" "gotenberg://dokku-gotenberg-test-with-underscores:11211"
  dokku --force "$PLUGIN_COMMAND_PREFIX:destroy" test_with_underscores
}

@test "($PLUGIN_COMMAND_PREFIX:info) success with flag" {
  run dokku "$PLUGIN_COMMAND_PREFIX:info" l --dsn
  assert_output "gotenberg://dokku-gotenberg-l:11211"

  run dokku "$PLUGIN_COMMAND_PREFIX:info" l --config-dir
  assert_success

  run dokku "$PLUGIN_COMMAND_PREFIX:info" l --data-dir
  assert_success

  run dokku "$PLUGIN_COMMAND_PREFIX:info" l --dsn
  assert_success

  run dokku "$PLUGIN_COMMAND_PREFIX:info" l --exposed-ports
  assert_success

  run dokku "$PLUGIN_COMMAND_PREFIX:info" l --id
  assert_success

  run dokku "$PLUGIN_COMMAND_PREFIX:info" l --internal-ip
  assert_success

  run dokku "$PLUGIN_COMMAND_PREFIX:info" l --links
  assert_success

  run dokku "$PLUGIN_COMMAND_PREFIX:info" l --service-root
  assert_success

  run dokku "$PLUGIN_COMMAND_PREFIX:info" l --status
  assert_success

  run dokku "$PLUGIN_COMMAND_PREFIX:info" l --version
  assert_success
}

@test "($PLUGIN_COMMAND_PREFIX:info) error when invalid flag" {
  run dokku "$PLUGIN_COMMAND_PREFIX:info" l --invalid-flag
  assert_failure
}
