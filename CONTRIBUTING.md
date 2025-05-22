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
* You will maintain the copyright of your code, meaning you must add a copyright header to your code, whether you are the original author or not.
Example:
```batch
rem Copyright (c) 2025 Your Name or the Original Author's Name if included verbatim
rem Licensed under the [MIT, apache, or any MIT compatible] License.
echo Code
```
* You will not include any code verbatim that is licensed under a viral license, as that requires relicensing the Kali in Batch project.

* You will agree to be responsible for legal issues caused by including code licensed under a viral license or a proprietary license, as per the first bullet point stating you keep the copyright.

Where to start?
===============

Visit [this link](https://github.com/Kali-in-Batch/kali-in-batch/fork) to fork the Kali in Batch repository.

Clone your fork to your local machine:
```bash
git clone git@github.com:your-username/kali-in-batch.git
```
From there, you can make changes to the code.

If you don't want to use a local repository, this is how to make a pull request:
![image](./assets/edit.png)
Click the edit button, which will automatically fork the repository and make a pull request once you are done making changes.