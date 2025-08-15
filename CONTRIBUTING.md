# Contributing to KIB in Batch

The KIB in Batch project welcomes contributions from anyone, but they must follow the guidelines below:

* Make sure your contributions match the coding style of the code they change or interact with.
* Do not use any compiled languages as the project is written in Windows Batch. Header files in [./src/include](./src/include/) are an exception, but they are only to be used by apps that run in the environment.
* Make sure to use meaningful commit messages and have proper inline comments.

  * Good:

    ```bat
    rem Set foo to bar as it is needed to do baz
    set foo=bar
    ```

  * Bad:

    ```bat
    rem do something
    set foo=bar
    ```
  
  * Good:

    ```bat
    git commit -a -m "Added setting foo to bar as it is needed to do baz"
    ```
  
  * Bad:

    ```bat
    git commit -a -m "Added something"
    ```

  * Descriptive commit messages are expected unless the change is trivial (e.g., typo fixes) or covers multiple unrelated areas (e.g., large refactors).

## How to Contribute

### Step 1: Fork the Repository

Fork the repository [using this link](https://github.com/Kali-in-Batch/kib-in-batch/fork).

### Step 2: Clone the Repository

Clone the forked repository to your local machine using the following command (replace `your-username` with your actual GitHub username):

```bat
git clone https://github.com/your-username/kib-in-batch.git
```

### Step 3: Create a New Branch

Create a new branch for your contribution using the following command (replace `your-branch-name` with a meaningful name for your branch):

```bat
git checkout -b your-branch-name
```

### Step 4: Make Changes

For example, try fixing a bug or add a new feature. Make sure to follow the guidelines above.

### Step 5: Commit Changes

Commit your changes using the following command (replace `your-commit-message` with a descriptive commit message):

```bat
git commit -a -m "Your commit message"
```

### Step 6: Push Changes

Push your changes to your forked repository using the following command (replace `your-branch-name` with the name of your branch):

```bat
git push origin your-branch-name
```

### Step 7: Create a Pull Request

Create a pull request using [this link](https://github.com/Kali-in-Batch/kib-in-batch/compare).

If the CI/CD fails, close the pull request until you fix it as to not waste the maintainers' time.
