# package-compatible-checker

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

   2. This script is used to check that the which minimum pacakge version is compatible with the PHP version.
   ```sh
     ./min-package-version-compatible-checker.sh package_name php_version
   ```
