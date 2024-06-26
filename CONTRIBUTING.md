# Contributing

## terraform

Terraform is used to handle provisioning of systems and tracking their state.

<!-- TODO| ### Installation

    REDO| write terraform install instructions
    REDO| write terraform-docs install instructions
    REDO| write instructions on running `terraform-docs markdown
    REDO| write trivy install instructions
    REDO| write tflint install instructions
    REDO| verify checkov and provide install instructions as needed
    REDO| write instructions on running `terraform fmt -diff -list -recursive -write=true` if terraform formatting issues come from pre-commit
-->

## pre-commit

To help ensure high-quality contributions this repository includes a [pre-commit](https://pre-commit.com) configuration which terraform fmt -diff -list -recursive -write=true
corrects and tests against common issues that would otherwise cause CI to fail.

### Installation

Follow the [pre-commit-instructions](https://pre-commit.com/#install) provided with pre-commit and run `pre-commit install` under the repository base.

If for any reason you would like to disable the pre-commit hooks run `pre-commit uninstall`.

### Running pre-commit checks

You can trigger it locally with `pre-commit run --all-files` or even to run only for a given file `pre-commit run --files YOUR_FILE`.
