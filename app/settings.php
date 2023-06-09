<?php

declare(strict_types=1);

use App\Application\Settings\Settings;
use App\Application\Settings\SettingsInterface;
use DI\ContainerBuilder;
use Monolog\Logger;

return function (ContainerBuilder $containerBuilder) {

    // Global Settings Object
    $containerBuilder->addDefinitions([
        SettingsInterface::class => function () {
            return new Settings([
                'displayErrorDetails' => true, // Should be set to false in production
                'logError'            => false,
                'logErrorDetails'     => false,
                'logger' => [
                    'name' => 'slim-app',
                    'path' => isset($_ENV['docker']) ? 'php://stdout' : __DIR__ . '/../logs/app.log',
                    'level' => Logger::DEBUG,
                ],
                'db' => [
                    'driver' => 'mysql',
                    'host' => 'mariadb',
                    'username' => 'parkman',
                    'database' => 'parkman',
                    'password' => 'parkman',
                    'charset' => 'utf8mb4',
                    'collation' => 'utf8mb4_unicode_ci',
                    'flags' => [
                        PDO::ATTR_PERSISTENT => false, // Turn off persistent connections
                        PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION, // Enable exceptions
                        PDO::ATTR_EMULATE_PREPARES => true, // Emulate prepared statements
                        PDO::ATTR_STRINGIFY_FETCHES => false,
                        PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC // Set default fetch mode to array
                    ],
                ],
            ]);
        }
    ]);
};
