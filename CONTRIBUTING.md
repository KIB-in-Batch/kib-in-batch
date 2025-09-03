# Contributing Guidelines

These are the guidelines for contributing for *KIB in Batch*.

## Open-Source doesn't mean Open-Contribution

*KIB in Batch* is Open-Source software. That doesn't mean it is open to any contributions.

## When you should not contribute

1. When you dislike Linus Torvalds, the creator of Git and Linux.
2. When you don't know how to use Git.
3. When you don't use *KIB in Batch* in any meaningful way (using it as a shell, testing it).
4. When you dislike Open-Source as a concept.
5. When you disagree with Libre Software.
6. When you don't know how to write Batch files.
7. When you don't know how Microsoft Windows functions and works.
8. When you don't know how each component of *KIB in Batch* interacts with eachother and the operating system.

## Contributing

### 1. Installing GitHub CLI

You can also use the web interface. However, we will use GitHub CLI as it's easier to represent.

Assuming you are on a Microsoft Windows system, you may install GitHub CLI like this:

```powershell
winget install -e --id GitHub.cli
```

### 2. Authenticating GitHub CLI

Use `gh auth login`.

### 3. Forking the repository

Use `gh repo fork KIB-in-Batch/kib-in-batch`. It prompts you to clone the fork. To that, you must accept and then change to the directory using a cd command.

### 4. Making your changes

Use a proper text editor to make changes:

```powershell
nvim
```

Commit the changes using Git. Then, you must push the changes. We will not provide instructions for these, you can see why [above](#when-you-should-not-contribute) at number 2. Use a descriptive commit message.

### 5. Creating the pull request

Use the GitHub web interface.
