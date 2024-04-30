<?php
/**
 * Traverse the $path upwards to scan for a composer autoloader file.
 *
 * @param string $path
 *
 * @return bool
 */
function boot_composer($path)
{
    if ($path == "/") {
        return false;
    }

    if (is_readable("$path/vendor/autoload.php")) {
        require_once "$path/vendor/autoload.php";

        return true;
    }

    return boot_composer(dirname($path));
}

if (boot_composer(getcwd())) {
    define("KINO_PHP_COMPOSER", true);
} else {
    define("KINO_PHP_COMPOSER", false);
}
