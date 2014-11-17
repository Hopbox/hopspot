DROP TABLE IF EXISTS gwcontrollers CASCADE;
DROP TABLE IF EXISTS otpcache CASCADE;
DROP TABLE IF EXISTS nodes CASCADE;
DROP TABLE IF EXISTS sessions CASCADE;
DROP TABLE IF EXISTS users CASCADE;

CREATE TABLE gwcontrollers (
	id		SERIAL PRIMARY KEY,
	controller_id	TEXT,
	first_seen		TIMESTAMP NOT NULL DEFAULT now(),
	last_seen		TIMESTAMP,
	sys_load		DECIMAL,
	sys_memfree		INTEGER,
	sys_uptime		INTEGER,
	cp_uptime		INTEGER,
	status			TEXT NOT NULL DEFAULT 'AUTO_CREATED_ON_PING'
);

CREATE TABLE otpcache (
	id		SERIAL PRIMARY KEY,
	mac		TEXT,
	mobile		TEXT,
	gw_id		INTEGER REFERENCES gwcontrollers(id) ON DELETE CASCADE ON UPDATE CASCADE,
	gw_name		TEXT,
	ip		TEXT,
	otp		INTEGER,
	url		TEXT,
	sent_time	TIMESTAMP NOT NULL DEFAULT now(),
	resent_count	INTEGER,
	last_resent_time TIMESTAMP NOT NULL DEFAULT now(),
);

CREATE TABLE nodes (
	id				SERIAL PRIMARY KEY,
	node_id			TEXT NOT NULL,
	first_seen		TIMESTAMP NOT NULL DEFAULT now(),
	last_seen		TIMESTAMP,
	sys_load		DECIMAL,
	sys_memfree		INTEGER,
	sys_uptime		INTEGER,
	cp_uptime		INTEGER,
	status			TEXT
);

CREATE TABLE sessions (
	token			TEXT NOT NULL PRIMARY KEY,
	mac				TEXT,
	ip				TEXT,
	gw_id			INTEGER REFERENCES gwcontrollers(id) ON DELETE CASCADE ON UPDATE CASCADE,
	gw_name			TEXT,
	mobile			INTEGER,
	status			TEXT,
	stage			TEXT,
	in_bytes		INTEGER,
	out_bytes		INTEGER,
	start_time		TIMESTAMP NOT NULL DEFAULT now(),
	last_update		TIMESTAMP
);

CREATE TABLE users (
	id				SERIAL PRIMARY KEY,
	mac				TEXT,
	first_seen_gw	INTEGER REFERENCES gwcontrollers(id) ON DELETE CASCADE ON UPDATE CASCADE,
	last_seen_gw	INTEGER REFERENCES gwcontrollers(id) ON DELETE CASCADE ON UPDATE CASCADE,
	mobile			TEXT,
	first_seen		TIMESTAMP NOT NULL DEFAULT now(),
	last_seen		TIMESTAMP
);
