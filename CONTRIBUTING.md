# Contributing Guidelines

These are the guidelines for contributing for *KIB in Batch*.

## When you should not contribute

1. When you don't know how to use Git.
2. When you don't use *KIB in Batch* in any meaningful way (using it as a shell, testing it).
3. When you don't know how to write Batch files.
4. When you don't know how Microsoft Windows functions.

## Contributing

### 1. Installing GitHub CLI

You can also use the web interface. However, we will use GitHub CLI as it's easier to represent.
4Assuming you are on a Microsoft Windows system, you may install GitHub CLI like this:

```powershell
winget install -e --id GitHub.cli
```

### 2. Authenticating GitHub CLI

Use `gh auth login`.

### 3. Forking the repository

Use `gh repo fork KIB-in-Batch/kib-in-batch`. It prompts you to clone the fork. To that, you must accept and then change to the directory using a cd command.

### 4. Making your changes

Use a text editor to make changes:

```sh
your-text-editor # Change to your text editor
```

Commit the changes using Git. Then, you must push the changes. We will not provide instructions for these, you can see why [above](#when-you-should-not-contribute) at number 1. Use a descriptive commit message.

### 5. Creating the pull request

Use the GitHub web interface.
