# Package compatibility checker

### Prerequisites
1. Clone the repository
   
2. Set composer.json in root directory

2. Install the dependency via composer install

3. You can use this script to check compatibility with PHP.

   1. This script is used to check that the package's latest version is compatible with the PHP version.
   ```sh
     ./package-compatible-checker.sh package_name php_version
   ```

   Exmaple:      
   ```sh
     ./package-compatible-checker.sh doctrine/dbal 8.2
     ./package-compatible-checker.sh doctrine/dbal 7.4
   ```

   ![image](https://github.com/jay-biztech/package-compatible-checker/assets/74171859/7b56b59e-87e4-4ab3-9b0b-4a3eb096c1c1)


   2. This script is used to check that the which minimum pacakge version is compatible with the PHP version.
   ```sh
     ./min-package-version-compatible-checker.sh package_name php_version
   ```

   3. This script is used to check the minimum version compatible with all packages.
   ```sh
     ./min-packages-version-compatible-checker.sh php_version
   ```

   ![image](https://github.com/jay-biztech/package-compatible-checker/assets/74171859/ec96aa54-3c0f-4e01-aaa8-1a3ee2319fee)



   
