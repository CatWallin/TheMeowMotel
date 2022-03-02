DROP TABLE IF EXISTS customer;
DROP TABLE IF EXISTS employee;
DROP TABLE IF EXISTS cat_customer;
DROP TABLE IF EXISTS cat;
DROP TABLE IF EXISTS room;
DROP TABLE IF EXISTS reservation;
DROP TABLE IF EXISTS cat_reservation;

CREATE TABLE `customer` (
    `customer_id` int(11) AUTO_INCREMENT UNIQUE NOT NULL,
    `first_name` varchar(255) NOT NULL,
    `last_name` varchar(255) NOT NULL,
    `reservation_id` int(11),
    PRIMARY KEY (`customer_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `employee` (
    `employee_id` int(11) AUTO_INCREMENT UNIQUE NOT NULL,
    `first_name` varchar(255) NOT NULL,
    `last_name` varchar(255) NOT NULL,
    `room_id` int(11),
    PRIMARY KEY (`employee_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `reservation` (
    `reservation_id` int(11) auto_increment not NULL,
    `check_in` date,
    `check_out` date,
    `customer_id` int(11) NOT NULL,
    FOREIGN KEY (`customer_id`) REFERENCES customer(`customer_id`),
    PRIMARY KEY (`reservation_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `cat` (
    `cat_id` int(11) auto_increment not NULL,
    `first_name` varchar(225) not NULL,
    `last_name` varchar(225) not NULL,
    `notes` varchar(225) not NULL,
    `room_id` int(11),
    `customer_id` int(11) NOT NULL,
    `reservation_id` int(11),
    FOREIGN KEY (`customer_id`) REFERENCES customer(`customer_id`),
    FOREIGN KEY (`reservation_id`) REFERENCES reservation(`reservation_id`),
    PRIMARY KEY (`cat_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `cat_customer` (
    `cat_id` int(11) NOT NULL,
    `customer_id` int(11) NOT NULL,
    FOREIGN KEY (`cat_id`) REFERENCES cat(`cat_id`),
    FOREIGN KEY (`customer_id`) REFERENCES customer(`customer_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE  `room` (
    `room_id` int(11) unique,
    `clean` boolean,
    `occupied` boolean,
    `cat_id` int(11),
    `employee_id` int(11),
    `reservation_id` int(11),
    FOREIGN KEY (`cat_id`) REFERENCES cat(`cat_id`),
    FOREIGN KEY (`employee_id`) REFERENCES employee(`employee_id`),
    FOREIGN KEY (`reservation_id`) REFERENCES reservation(`reservation_id`),
    PRIMARY KEY (`room_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `cat_reservation` (
    `cat_reservation_id` int(11) auto_increment not NULL,
    `cat_id` int(11) NOT NULL,
    `reservation_id` int(11) NOT NULL,
    FOREIGN KEY (`cat_id`) REFERENCES cat(`cat_id`),
    FOREIGN KEY (`reservation_id`) REFERENCES reservation(`reservation_id`),
    PRIMARY KEY (`cat_reservation_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

ALTER TABLE `cat` 
ADD FOREIGN KEY (`room_id`) REFERENCES room(`room_id`);

INSERT INTO customer (first_name, last_name)
VALUES ("Maddie", "Acosta"),
("Catherine", "Wallin"),
("Mark", "Scott"),
("Katy", "Scott"),
("Greg", "Calvin");

INSERT INTO employee (first_name, last_name)
VALUES ("Mirabel", "Calico"),
("Dolores", "Tortie"),
("Luisa", "Tabby"),
("Isabella", "Sphynx"),
("Camillo", "Ragdoll");

INSERT INTO cat (first_name, last_name, room_id, customer_id, reservation_id) VALUES
    ("Doge", "Scott", 
    (SELECT room_id FROM room WHERE room_id=1),
    (SELECT customer_id FROM customer WHERE first_name="Mark" AND last_name="Scott"),
    (SELECT reservation_id FROM reservation WHERE check_in=2022-02-28 AND check_out=2022-03-05)
    ),
    ("Ripley", "Wallin", NULL,
    (SELECT customer_id FROM customer WHERE first_name="Catherine" AND last_name="Wallin"),
    NULL
    ),
    ("Hammy", "Scott", NULL,
    (SELECT customer_id FROM customer WHERE first_name="Mark" AND last_name="Scott"),
    NULL
    ),
    ("Hobbes", "Calvin", NULL,
    (SELECT customer_id FROM customer WHERE first_name="Greg" AND last_name="Calvin"),
    NULL
    ),
    ("Ember", "Acosta", NULL,
    (SELECT customer_id FROM customer WHERE first_name="Maddie" AND last_name="Acosta"),
    NULL
    );

INSERT INTO cat_customer (cat_id, customer_id)
VALUES ((SELECT cat_id FROM cat WHERE first_name="Ember" AND last_name="Acosta"),
    (SELECT customer_id FROM customer WHERE first_name="Maddie" AND last_name="Acosta")),
    ((SELECT cat_id FROM cat WHERE first_name="Ripley" AND last_name="Wallin"),
    (SELECT customer_id FROM customer WHERE first_name="Catherine" AND last_name="Wallin")),
    ((SELECT cat_id FROM cat WHERE first_name="Hammy" AND last_name="Scott"),
    (SELECT customer_id FROM customer WHERE first_name="Katy" AND last_name="Scott")),
    ((SELECT cat_id FROM cat WHERE first_name="Doge" AND last_name="Scott"),
    (SELECT customer_id FROM customer WHERE first_name="Katy" AND last_name="Scott")),
    ((SELECT cat_id FROM cat WHERE first_name="Hobbes" AND last_name="Calvin"),
    (SELECT customer_id FROM customer WHERE first_name="Greg" AND last_name="Calvin")),
    ((SELECT cat_id FROM cat WHERE first_name="Hammy" AND last_name="Scott"),
    (SELECT customer_id FROM customer WHERE first_name="Mark" AND last_name="Scott")),
    ((SELECT cat_id FROM cat WHERE first_name="Doge" AND last_name="Scott"),
    (SELECT customer_id FROM customer WHERE first_name="Mark" AND last_name="Scott"));

INSERT INTO reservation (check_in, check_out, customer_id) VALUES
    ('2022-02-28', '2022-03-05', 
    (SELECT customer_id FROM customer WHERE first_name="Maddie" AND last_name="Acosta")),
    ('2022-03-20', '2022-03-25', 
    (SELECT customer_id FROM customer WHERE first_name="Katy" AND last_name="Scott")),
    ('2022-03-21', '2022-03-22', 
    (SELECT customer_id FROM customer WHERE first_name="Greg" AND last_name="Calvin"));

INSERT INTO room (room_id, clean, occupied, cat_id, employee_id, reservation_id) VALUES
    (1, TRUE, FALSE, 
    (SELECT cat_id FROM cat WHERE first_name="Doge" AND last_name="Scott"),
    (SELECT employee_id FROM employee WHERE first_name="Mirabel" AND last_name="Calico"),
    NULL),
    (2, TRUE, FALSE, NULL, 
    (SELECT employee_id FROM employee WHERE first_name="Isabella" AND last_name="Sphynx"),
    NULL),
    (3, TRUE, FALSE, NULL, 
    (SELECT employee_id FROM employee WHERE first_name="Camillo" AND last_name="Ragdoll"),
    NULL);

INSERT INTO cat_reservation (cat_id, reservation_id)
    VALUES ((SELECT cat_id FROM cat WHERE first_name="Doge" AND last_name="Scott"),
    (SELECT reservation_id FROM reservation WHERE check_in='2022-02-28' AND check_out='2022-03-05'));