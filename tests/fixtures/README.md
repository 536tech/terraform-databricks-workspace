# DataTF contract fixtures

These synthetic exports come from DataTF commit
`2958f18f24c46a42ec3478e370dc0c7c046dc5f1`:

- `internal/contract/testdata/golden/workspace/export.json`
- `internal/contract/testdata/golden/shared/export.json`

Copy both exports from the same DataTF commit when the contract changes.
Run DataTF's `make check` and `scripts/e2e-fake.sh` against this module before you update them.

The native tests read the exported inputs. `scripts/check-contract.py` compares each planned
resource address with the exported imports. The check includes child resource names, map keys,
grant and permission indexes, and secret ACL keys. It also rejects resources in the empty plan.

The fixtures contain no credentials or live workspace data. PR checks need no DataTF repository
token. The fake server and Azure lifecycle checks remain separate integration tests.
