<?php

/**
 * Joins a list of paths.
 *
 * @param array $path
 * @return string
 */
function path_join($path)
{
    return implode(DIRECTORY_SEPARATOR, $path);
}

/**
 * Attempt to load a composer autoloader file if found.
 */
function boot_composer()
{
    if (file_exists(getcwd()."/vendor/autoload.php")) {
        define("KINO_PHP_COMPOSER", true);

        require getcwd()."/vendor/autoload.php";
    } else {
        define("KINO_PHP_COMPOSER", false);
    }
}

boot_composer();

eval($argv[1]);
