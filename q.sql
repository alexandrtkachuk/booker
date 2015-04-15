DROP TABLE IF EXISTS booker_rooms;
CREATE TABLE booker_rooms (id INT NOT NULL AUTO_INCREMENT , name VARCHAR(32) ,  
    PRIMARY KEY (id) );

DROP TABLE IF EXISTS booker_users;
CREATE TABLE booker_users (id INT NOT NULL AUTO_INCREMENT ,
    name VARCHAR(32),
    pass VARCHAR(128),
    email VARCHAR(64),
    role INT,
    PRIMARY KEY (id) );

DROP TABLE IF EXISTS booker_orders;
CREATE TABLE booker_orders (
      `id` int(11) NOT NULL AUTO_INCREMENT,
      `id_room` int(11) DEFAULT NULL,
      `id_user` int(11) DEFAULT NULL,
      `time_start` int(11) DEFAULT NULL,
      `time_end` int(11) DEFAULT NULL,
      `info` text,
      `created` int(11) DEFAULT NULL,
      PRIMARY KEY (`id`)
    );

INSERT INTO booker_users (name , pass , email , role ) VALUES ( 'admin', MD5('admin'), 'admin@mail.ru',0); 
