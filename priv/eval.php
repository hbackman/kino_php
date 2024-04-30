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

require __DIR__."/boot_composer.php";
require __DIR__."/boot_laravel.php";

eval($argv[1]);
