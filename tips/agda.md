- Add .agda-lib file in at the root of the project dir when Agda is installed via
  Nix, or it won't be able to find libraries:
  - Example:
    ```
    name: atpl
    depend:
        standard-library
    include: src
    ```
