JSON-test
============

How to use
------------
1. install cabal-dev

2. prepare executables  

    ```shell
    $ cabal-dev install --only-dependencies  
    $ cabal-dev install  
    ```

3. If you want to setup DB, make db directory & run migrate.sh  

    ```shell
    $ mkdir db  
    $ chmod +x migrate.sh  
    $ ./migrate.sh  
    ```
