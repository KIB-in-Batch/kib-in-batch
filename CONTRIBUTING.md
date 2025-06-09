Contributing to Kali in Batch
=============================
We welcome contributions from the community, but they must follow these guidelines:
* Your code should be tested.
    To test the code, run this in a command prompt in the directory that contains the script:
    ```batch
    kali_in_batch.bat
    ```
    Use it like you would use a normal Kali Linux environment. If anything fails, do not submit your contribution until it is fixed.
* Your code should follow the style of the rest of the code.
    * Use `rem` for comments, not `::`.
    * Use proper tabbing.

        For example, do this:
        ```batch
        if "%foo%"=="bar" (
            echo foo
        )
        ```
        And not this:
        ```batch
        if "%foo%"=="bar" (
        echo foo
        )
        ```
* Your code should have comments documenting what it does.

    For example, do this:
    ```batch
    rem Set foo to bar
    set foo=bar
    ```
    And not this:
    ```batch
    set foo=bar
    ```
* Any issues must follow templates, otherwise they will be closed.

By contributing, you also agree to the following:
* You will not include any code verbatim that is licensed under a viral license, as that requires relicensing the Kali in Batch project.

Where to start?
===============

Visit [this link](https://github.com/Kali-in-Batch/kali-in-batch/fork) to fork the Kali in Batch repository.

Clone your fork to your local machine:
```bash
git clone git@github.com:your-username/kali-in-batch.git
```
From there, you can make changes to the code.

You can also make changes directly in the GitHub web interface.
