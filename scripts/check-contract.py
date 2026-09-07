"""Check mock plans against the resource addresses exported by DataTF."""

import json
import subprocess
import sys
from pathlib import Path


def import_addresses(fixture: Path) -> list[str]:
    """Return sorted Terraform addresses from a DataTF export file."""
    addresses = []
    for item in json.loads(fixture.read_text())["imports"]:
        address = f'module.{item["module"]}[{json.dumps(item["key"])}].{item["resource"]}.this'
        if "index" in item:
            address += f'[{json.dumps(item["index"])}]'
        addresses.append(address)
    return sorted(addresses)


def run_tests(root: Path) -> list[dict]:
    """Run Terraform tests and return their JSON events on success."""
    result = subprocess.run(
        ["terraform", "test", "-json", "-verbose"],
        cwd=root,
        text=True,
        stdout=subprocess.PIPE,
        check=False,
    )
    events = [json.loads(line) for line in result.stdout.splitlines()]
    messages = {"test_summary", "test_run"}
    if result.returncode:
        messages.add("diagnostic")
    for event in events:
        if event["type"] in messages:
            print(event["@message"])
    if result.returncode:
        sys.exit(result.returncode)
    return events


def main() -> int:
    """Verify every golden import has one planned resource."""
    root = Path(__file__).resolve().parents[1]
    events = run_tests(root)
    plans = {
        event["@testrun"]: sorted(
            resource["address"] for resource in event["test_plan"].get("resource_changes", [])
        )
        for event in events
        if event["type"] == "test_plan"
    }
    expected = {
        "no_inputs": [],
        "golden_workspace_export": import_addresses(root / "tests/fixtures/workspace.json"),
        "golden_shared_export": import_addresses(root / "tests/fixtures/shared.json"),
    }

    for name, addresses in expected.items():
        if plans.get(name) != addresses:
            print(f"{name}: planned addresses differ from the DataTF contract.", file=sys.stderr)
            print(f"Expected: {addresses}\nActual: {plans.get(name)}", file=sys.stderr)
            return 1
        print(f"{name}: {len(addresses)} resource addresses match.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
