# Fix a Single Warning — Process

This process instructs the AI to fix **one** compiler warning, create a branch, commit, and open a PR. Do not fix multiple warnings or change unrelated code.

## Prerequisites

- Start from a **clean working tree** (no uncommitted changes). If there are uncommitted changes, either commit them or stash them before starting.
- Run from the repository root (or from the `csharp` directory where `first-warning.sh` lives).

## Workflow

### 1. Get the single warning

Run the `first-warning.sh` script:

```bash
./first-warning.sh
```

- If the script **exits with code 0**: there are no warnings; stop here and report that there is nothing to fix.
- If the script **exits with code 1**: it printed exactly **one** warning line. Parse this output to get:
  - The warning code (e.g. `CS0168`, `CS0219`)
  - The file path and line number
  - The warning message

Use **only** this one warning for all following steps. Do not run the full build and pick another warning.

### 2. Create a branch to fix it

Create a new branch whose name clearly refers to this single fix, for example:

- `fix/cs0168-unused-variable`
- `fix/cs0219-assignment-has-no-effect`

Use the warning code and a short descriptor. Base the branch on the current branch (usually `main` or `master`).

```bash
git checkout -b fix/<warning-code>-<short-descriptor>
```

### 3. Fix only this single warning

- Edit **only** the file and location indicated by the warning.
- Apply the **minimal** change that removes or resolves that one warning (e.g. use the variable, remove the assignment, add a discard `_`, fix the null reference, etc.).
- Do **not**:
  - Fix other warnings in the same file or elsewhere
  - Refactor unrelated code
  - Change formatting beyond what is needed for the fix

### 4. Verify and commit

1. **Build** to confirm the warning is gone and no new ones are introduced:

   ```bash
   dotnet build --no-incremental
   ```

2. **Run tests** to ensure nothing broke:

   ```bash
   dotnet test TodoApp.slnx
   ```

3. **Confirm the single warning is fixed** by running the script again; it should exit 0:

   ```bash
   ./first-warning.sh
   ```

4. **Commit** the change with a clear message that references the warning (e.g. "Fix CS0168: remove unused variable" or "Fix CS0219: use discard for intentional unused assignment"):

   ```bash
   git add <changed-files>
   git commit -m "Fix <warning-code>: <short description>"
   ```

### 5. Create a PR

- Push the branch:

  ```bash
  git push -u origin <branch-name>
  ```

- Create a pull request targeting the default branch (e.g. `main`).
- PR title and description should state that this PR fixes **one** specific warning (include warning code and file/location if helpful).

### 6. Check out main and merge the branch locally

After the PR is created:

1. **Check out the default branch** (e.g. `main`):

   ```bash
   git checkout main
   ```

2. **Merge the fix branch locally**:

   ```bash
   git merge <branch-name>
   ```

You will then be on `main` with the fix merged locally (the PR can still be used for review/CI; the local merge keeps your main in sync with the fix).

## Constraints (summary)

- One warning per run; one branch per warning; one PR per branch.
- No extra changes: only the minimal edit for that warning.
- Always verify with: `./first-warning.sh`, `dotnet build`, and `dotnet test` before committing.
- Start only from a clean working tree.
