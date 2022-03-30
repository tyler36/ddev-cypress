setup() {
  set -eu -o pipefail

  # Load bats support files; assumes they have been installed via BREW
  TEST_BREW_PREFIX="$(brew --prefix)"
  load "${TEST_BREW_PREFIX}/lib/bats-support/load.bash"
  load "${TEST_BREW_PREFIX}/lib/bats-assert/load.bash"
  load "${TEST_BREW_PREFIX}/lib/bats-file/load.bash"

  export DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )/.."
  export TESTDIR=~/tmp/ddev-cypress
  mkdir -p $TESTDIR
  export PROJNAME=ddev-cypress
  export DDEV_NON_INTERACTIVE=true
  ddev delete -Oy ${PROJNAME} || true
  cd "${TESTDIR}"
  ddev config --project-name=${PROJNAME}
  ddev start
}

teardown() {
  set -eu -o pipefail
  cd ${TESTDIR} || ( printf "unable to cd to ${TESTDIR}\n" && exit 1 )
  ddev delete -Oy ${PROJNAME}
  [ "${TESTDIR}" != "" ] && rm -rf ${TESTDIR}
}

@test "install from directory" {
  set -eu -o pipefail
  cd ${TESTDIR}
  echo "# ddev get ${DIR} with project ${PROJNAME} in ${TESTDIR} ($(pwd))" >&3
  ddev get ${DIR}

  # ASSERT: required files exist
  assert_exist "${TESTDIR}/.ddev/docker-compose.cypress.yaml"
  assert_exist "${TESTDIR}/.ddev/commands/cypress/cypress-open"
  assert_exist "${TESTDIR}/.ddev/commands/cypress/cypress-run"

  # ASSERT: command works
  ddev restart
  run ddev cypress-run --version
  assert_output --partial "Cypress package version"
  run ddev cypress-open --version
  assert_output --partial "Cypress package version"
}

@test "install from release" {
  set -eu -o pipefail
  cd ${TESTDIR} || ( printf "unable to cd to ${TESTDIR}\n" && exit 1 )
  echo "# ddev get tyler36/ddev-cypress with project ${PROJNAME} in ${TESTDIR} ($(pwd))" >&3
  ddev get tyler36/ddev-cypress

  # ASSERT: required files exist
  assert_exist "${TESTDIR}/.ddev/docker-compose.cypress.yaml"
  assert_exist "${TESTDIR}/.ddev/commands/cypress/cypress-open"
  assert_exist "${TESTDIR}/.ddev/commands/cypress/cypress-run"

  # ASSERT: command works
  ddev restart
  run ddev cypress-run --version
  assert_output --partial "Cypress package version"
  run ddev cypress-open --version
  assert_output --partial "Cypress package version"
}
