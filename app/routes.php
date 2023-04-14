<?php

declare(strict_types=1);

use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;
use Slim\App;

return function (App $app) {
    $app->options('/{routes:.*}', function (Request $request, Response $response) {
        // CORS Pre-Flight OPTIONS Request Handler
        return $response;
    });

    $app->get('/', function (Request $request, Response $response) {
        $response->getBody()->write('Hello world!');
        return $response;
    });

    $app->get('/test', function (Request $request, Response $response) {
        $db = $this->get(PDO::class);
        $params = $request->getQueryParams();

        $sql = 'SELECT
    `g`.`id` AS `garage_id`,
    `g`.`name`,
    `g`.`hourly_price`,
    `c1`.`symbol` AS `currency`,
    `g`.`contact_email`,
    CONCAT(ST_Y(`g`.`point`), \' \', ST_X(`g`.`point`)) AS `point`,
    `c2`.`name` AS `country`,
    `o`.`id` AS `owner_id`,
    `o`.`name` AS `garage_owner`
FROM `garages` AS `g`
INNER JOIN `currencies` AS `c1` ON `c1`.`id` = `g`.`currency_id`
INNER JOIN `countries` AS `c2` ON `c2`.`id` = `g`.`country_id`
INNER JOIN `owners` AS `o` ON `o`.`id` = `g`.`owner_id`';

        $where = [];

        if (array_key_exists('country', $params) && !empty($params['country'])) {
            $where[] = '`c2`.`name` = '.$db->quote($params['country']);
        }
        if (array_key_exists('owner', $params) && !empty($params['owner'])) {
            $where[] = '`o`.`name` = '.$db->quote($params['owner']);
        }
        if (array_key_exists('location', $params) && !empty($params['location'])) {
            $where[] = 'ST_DISTANCE_SPHERE(`g`.`point`, POINT('.$params['location']['lon'].', '.$params['location']['lat'].')) <= '.$params['location']['radius'];
        }

        if (!empty($where)) {
            $sql .= ' WHERE '.implode(' AND ', $where);
        }

        $sth = $db->prepare($sql);
        $sth->execute();
        $data = $sth->fetchAll(PDO::FETCH_ASSOC);
        $payload = json_encode($data);
        $response->getBody()->write($payload);
        return $response->withHeader('Content-Type', 'application/json');
    });
};
