--                                  Prueba - SQL
--En esta prueba validaremos nuestros conocimientos de SQL. Para lograrlo, necesitarás
--aplicar lo aprendido en las unidades anteriores.

DROP DATABASE IF EXISTS desafiofinal_larissonrivero_504; -- Elimina la database si existe
CREATE DATABASE "desafiofinal_larissonrivero_504"; -- Crea la database 
\c desafiofinal_larissonrivero_504; -- Conecta a la database

-- Requerimiento 1 ¿Crea el modelo (revisa bien cuál es el tipo de relación antes de crearlo), respeta las claves primarias, foráneas y tipos de datos?
DROP TABLE IF EXISTS "Peliculas";
CREATE TABLE "Peliculas" (
    "id" SERIAL PRIMARY KEY,
    "name" VARCHAR(255),
    "anno" INTEGER
);

DROP TABLE IF EXISTS "Tags";
CREATE TABLE "Tags" (
    "id" SERIAL PRIMARY KEY,
    "tag" VARCHAR(35)
);

DROP TABLE IF EXISTS "peliculas_tags";
CREATE TABLE "peliculas_tags" (
    "id" SERIAL PRIMARY KEY,
    "peliculas_id" INTEGER NOT NULL,
    "tags_id" INTEGER NOT NULL
);

ALTER TABLE "peliculas_tags" ADD FOREIGN KEY ("peliculas_id") REFERENCES "Peliculas" ("id");
ALTER TABLE "peliculas_tags" ADD FOREIGN KEY ("tags_id") REFERENCES "Tags" ("id");

-- Requerimiento 2 ¿Inserta 5 películas y 5 tags, la primera película tiene que tener 3 tags asociados, la segunda película debe tener dos tags asociados?
-- Insertar 5 películas;
INSERT INTO "Peliculas" ("name", "anno") VALUES ('La roca', 1996);
INSERT INTO "Peliculas" ("name", "anno") VALUES ('El senor de los anillos', 2002);
INSERT INTO "Peliculas" ("name", "anno") VALUES ('El libro de los secretos', 2010);
INSERT INTO "Peliculas" ("name", "anno") VALUES ('John wick', 2014);
INSERT INTO "Peliculas" ("name", "anno") VALUES ('Mad max', 2015);

-- Insertar 5 tags;
INSERT INTO "Tags" ("tag") VALUES ('accion');
INSERT INTO "Tags" ("tag") VALUES ('aventura');
INSERT INTO "Tags" ("tag") VALUES ('fantasia');
INSERT INTO "Tags" ("tag") VALUES ('comedia');
INSERT INTO "Tags" ("tag") VALUES ('drama');

--La primera película tiene que tener 3 tags asociados;
INSERT INTO "peliculas_tags" ("peliculas_id", "tags_id") VALUES (1, 1);
INSERT INTO "peliculas_tags" ("peliculas_id", "tags_id") VALUES (1, 2);
INSERT INTO "peliculas_tags" ("peliculas_id", "tags_id") VALUES (1, 5);

--la segunda película debe tener dos tags asociados;
INSERT INTO "peliculas_tags" ("peliculas_id", "tags_id") VALUES (2, 2);
INSERT INTO "peliculas_tags" ("peliculas_id", "tags_id") VALUES (2, 3);

-- Requerimiento 3 ¿Cuenta la cantidad de tags que tiene cada película. Si una película no tiene tags debe mostrar 0?
SELECT peliculas.name, COUNT(peliculas_tags.tags_id) FROM "Peliculas" peliculas LEFT JOIN "peliculas_tags" peliculas_tags ON peliculas.id = peliculas_tags.peliculas_id GROUP BY peliculas.name;

-- Requerimiento 4 ¿Crea las tablas respetando los nombres, tipos, claves primarias y foráneas y tipos de datos?
DROP TABLE IF EXISTS "Respuestas";
CREATE TABLE "Respuestas" (
    "id" SERIAL PRIMARY KEY,
    "respuesta" VARCHAR(255),
    "pregunta_id" INTEGER,
    "usuario_id" INTEGER
);

DROP TABLE IF EXISTS "Preguntas";
CREATE TABLE "Preguntas" (
    "id" SERIAL PRIMARY KEY,
    "pregunta" VARCHAR(255),
    "respuesta_correcta" VARCHAR(255)
);

DROP TABLE IF EXISTS "Usuarios";
CREATE TABLE "Usuarios" (
    "id" SERIAL PRIMARY KEY,
    "nombre" VARCHAR(255),
    "edad" INTEGER
);

ALTER TABLE "Respuestas" ADD FOREIGN KEY ("usuario_id") REFERENCES "Usuarios" ("id");
ALTER TABLE "Respuestas" ADD FOREIGN KEY ("pregunta_id") REFERENCES "Preguntas" ("id");

--Requerimiento 5; Agrega datos, 5 usuarios y 5 preguntas.
--a. Contestada correctamente significa que la respuesta indicada en la tabla respuestas es exactamente igual al texto indicado en la tabla de preguntas.

--Pregiuntas y respuestas;
INSERT INTO "Preguntas" ("pregunta", "respuesta_correcta") VALUES ('¿Cual es el lugar mas frio de la tierra?', 'La antartida');
INSERT INTO "Preguntas" ("pregunta", "respuesta_correcta") VALUES ('¿Quien escribio La Odisea?', 'Homero');
INSERT INTO "Preguntas" ("pregunta", "respuesta_correcta") VALUES ('¿Cual es el rio mas largo del mundo?', 'El Nilo');
INSERT INTO "Preguntas" ("pregunta", "respuesta_correcta") VALUES ('¿Donde originaron los juegos olimpicos?', 'Grecia');
INSERT INTO "Preguntas" ("pregunta", "respuesta_correcta") VALUES ('¿Quien pinto la ultima cena?', 'Leonardo Da Vinci');

--Usuarios y Edad;
INSERT INTO "Usuarios" ("nombre", "edad") VALUES ('Larisson', 35);
INSERT INTO "Usuarios" ("nombre", "edad") VALUES ('Lenny', 34);
INSERT INTO "Usuarios" ("nombre", "edad") VALUES ('Analia', 30);
INSERT INTO "Usuarios" ("nombre", "edad") VALUES ('Anahis', 25);
INSERT INTO "Usuarios" ("nombre", "edad") VALUES ('Ramona', 20);

--la primera pregunta debe estar contestada dos veces correctamente por distintos usuarios;
INSERT INTO "Respuestas" ("respuesta", "pregunta_id", "usuario_id") VALUES ('La antartida', 1, 1);
INSERT INTO "Respuestas" ("respuesta", "pregunta_id", "usuario_id") VALUES ('La antartida', 1, 2);

--la pregunta 2 debe estar contestada correctamente sólo por un usuario;
INSERT INTO "Respuestas" ("respuesta", "pregunta_id", "usuario_id") VALUES ('Homero', 2, 1);

--las otras 2 respuestas deben estar incorrectas;
INSERT INTO "Respuestas" ("respuesta", "pregunta_id", "usuario_id") VALUES ('El amazonas', 2, 2);
INSERT INTO "Respuestas" ("respuesta", "pregunta_id", "usuario_id") VALUES ('Bart', 2, 3);

--Requerimiento 6 ¿Cuenta la cantidad de respuestas correctas totales por usuario (independiente de la pregunta)?
SELECT u.nombre, COUNT(r.respuesta) FILTER (WHERE r.respuesta = p.respuesta_correcta) FROM "Usuarios" u LEFT JOIN "Respuestas" r ON u.id = r.usuario_id LEFT JOIN "Preguntas" p ON r.pregunta_id = p.id GROUP BY u.nombre;

--Requerimiento 7 ¿Por cada pregunta, en la tabla preguntas, cuenta cuántos usuarios tuvieron la respuesta correcta.?
SELECT preguntas.pregunta, COUNT(usuarios.id) FILTER(WHERE respuestas.respuesta=preguntas.respuesta_correcta) FROM "Preguntas" preguntas LEFT JOIN "Respuestas" respuestas ON preguntas.id=respuestas.pregunta_id LEFT JOIN "Usuarios" usuarios ON usuarios.id=respuestas.usuario_id GROUP BY preguntas.pregunta;

--Requerimiento 8 ¿Implementa borrado en cascada de las respuestas al borrar un usuario y borrar el primer usuario para probar la implementación?;
ALTER TABLE "Respuestas" DROP CONSTRAINT "Respuestas_usuario_id_fkey", ADD FOREIGN KEY(usuario_id) REFERENCES "Usuarios" (id) ON DELETE CASCADE;
DELETE FROM "Usuarios" WHERE id = 1;

--Requerimiento 9 ¿Crea una restricción que impida insertar usuarios menores de 18 años en la base de datos?;
ALTER TABLE "Usuarios" ADD CONSTRAINT "Usuarios_edad" CHECK (edad >= 18);
INSERT INTO "Usuarios" ("nombre", "edad") VALUES ('Josefo', 17);
INSERT INTO "Usuarios" ("nombre", "edad") VALUES ('Juanit', 55);

--Requerimiento 10 ¿Altera la tabla existente de usuarios agregando el campo email con la restricción de único?;
ALTER TABLE "Usuarios" ADD COLUMN "email" VARCHAR(255) UNIQUE;

INSERT INTO "Usuarios" ("nombre", "edad", "email") VALUES ('Jose', 32, 'Laririvero2@gmail.com');
INSERT INTO "Usuarios" ("nombre", "edad", "email") VALUES ('Anto', 32, 'Antocuspide@gmail.com');
