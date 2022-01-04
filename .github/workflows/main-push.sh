name: Main Push validations
on: [push, workflow_dispatch]
jobs:
  CI-chart:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout Repo
        uses: actions/checkout@v2

      - name: installing tool chain
        run: ./scripts/install-toolchain.sh

      - name: get fetch to update tags locally
        run: git fetch --prune --unshallow --tags

      - name: verify the release one more time.
        run: make all

      - name: Draft release
        run: ./scripts/draft-release.sh

      - name: Package release
        run: ./scripts/package-charts.sh
