# Open Journals :: Deposit pull request

This action opens a pull request for an accepted paper and optionally merges it

## Usage

Usually this action is used as a step in a workflow after paper's branch including the needed files is created.

### Inputs

The action accepts the following inputs:

- **papers_repo**: Required. The repository containing the published and submitted papers in `owner/reponame` format.
- **issue_id**: Required. The issue number of the submission of the paper.
- **papers_repo_main_branch**: Optional. The name of the repo's main branch to issue the pull request against. Default: `main`.
- **branch_prefix**: Optional. The prefix of the name of the paper's branch.
- **mode**: Optional. Valid values: [`dry-run`, `deposit`]. If `mode=deposit`, the PR will be merged and the topic branch deleted. Default: `dry-run`.
- **bot_token**: Optional. The GitHub access token to be used to upload files. Default: `ENV['GH_ACCESS_TOKEN']`

### Outputs

- **pr_url**: The URL for the created pull request

### Example

Use it adding it as a step in a workflow `.yml` file in your repo's `.github/workflows/` directory and passing your custom input values:

```yaml
on:
  workflow_dispatch:
   inputs:
      issue_id:
        description: 'The issue number of the submission'
jobs:
  processing:
    runs-on: ubuntu-latest
    steps:
      - name: Open Pull Request
        id: open-pr
        uses: neurolibre/deposit-pull-request-action@main
        with:
          papers_repo: neurolibre/preprints
          branch_prefix: myjournal
          issue_id: ${{ github.event.inputs.issue_id }}
          bot_token: ${{ secrets.BOT_TOKEN }}
          mode: dry-run
```
