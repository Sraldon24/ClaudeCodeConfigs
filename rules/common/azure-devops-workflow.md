# Azure DevOps Workflow

## Setup
```bash
az extension add --name azure-devops
az login
az devops configure --defaults organization=https://dev.azure.com/YOUR_ORG project=YOUR_PROJECT
```

## Azure DevOps Ops (az devops CLI) - CRITICAL
NEVER use Azure DevOps MCP. Use `az devops` via Bash (same pattern as `gh` for GitHub).

### Pull Requests
```bash
az repos pr create --title "feat: ..." --description "..." --source-branch feature/x --target-branch main
az repos pr list
az repos pr show --id <PR_ID>
az repos pr update --id <PR_ID> --status completed
az repos pr reviewer add --id <PR_ID> --reviewers user@org.com
```

### Work Items
```bash
az boards work-item list --query "[].{id:id,title:fields.\"System.Title\"}"
az boards work-item show --id <ID>
az boards work-item create --title "..." --type Task
az boards work-item update --id <ID> --state Active
```

### Repos
```bash
az repos list
az repos show --repository REPO_NAME
az repos clone --repository REPO_NAME
```

### Pipelines
```bash
az pipelines list
az pipelines run --name PIPELINE_NAME
az pipelines show --name PIPELINE_NAME
az pipelines build list --status inProgress
```

## PRs (Azure DevOps)
1. Analyze full history: `git log main..HEAD --oneline`
2. `git diff main...HEAD`
3. Draft summary & test plan.
4. Push with `-u`: `git push -u origin feature/branch`
5. Create PR: `az repos pr create --target-branch main`

## Commits
Same format as `git-workflow.md`: `<type>: <description>\n\n<body>`
