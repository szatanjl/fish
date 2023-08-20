//#![deny(clippy::pedantic)]

use std::env::var;

use sqlx::{query, Connection, Error, PgConnection, QueryBuilder};

pub fn fetch() -> Result<Vec<String>, Error> {
	todo!()
}

pub async fn populate<'a>(
	names: impl IntoIterator<Item = &'a str>,
) -> Result<(), Error> {
	let mut conn = connect().await?;

	query("CREATE TABLE IF NOT EXISTS fish(
		name VARCHAR PRIMARY KEY,
		used BOOLEAN NOT NULL DEFAULT false
	)")
	.execute(&mut conn)
	.await?;

	let mut builder = QueryBuilder::new("INSERT INTO fish(name) ");
	builder.push_values(names, |mut b, name| {
		b.push_bind(name);
	});
	builder.push(" ON CONFLICT DO NOTHING");

	let query = builder.build();
	query.execute(&mut conn).await?;

	Ok(())
}

pub fn get() -> Result<String, Error> {
	todo!()
}

async fn connect() -> Result<PgConnection, Error> {
	let user = var("PG_USER")
		.unwrap_or_else(|_| String::from("postgres"));
	let pass = var("PG_PASS")
		.unwrap_or_else(|_| String::from("postgres"));
	let host = var("PG_HOST")
		.unwrap_or_else(|_| String::from("localhost"));
	let db = var("PG_DB").unwrap_or_else(|_| String::from("fish"));
	let conn =
		format!("postgres://{}:{}@{}/{}", user, pass, host, db);
	PgConnection::connect(&conn).await
}
