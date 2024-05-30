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

    $file = "$path/vendor/autoload.php";

    if (is_readable($file)) {
        require_once $file;

        return $file;
    }

    return boot_composer(dirname($path));
}

if ($path = boot_composer(getcwd())) {
    define("KINO_PHP_COMPOSER", $path);
} else {
    define("KINO_PHP_COMPOSER", false);
}
