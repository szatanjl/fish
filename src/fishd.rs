#![deny(clippy::pedantic)]

use std::error::Error;

use axum::{
	http::StatusCode, response::IntoResponse, routing::get, Json,
	Router, Server,
};
use fish::get as get_fish_name;
use serde::Serialize;

#[derive(Serialize)]
struct Fish {
	name: String,
}

#[tokio::main]
async fn main() -> Result<(), Box<dyn Error>> {
	let app = Router::new().route("/", get(get_fish));
	let addr = "0.0.0.0:3000".parse()?;
	Server::bind(&addr).serve(app.into_make_service()).await?;
	Ok(())
}

#[allow(clippy::unused_async)]
async fn get_fish() -> impl IntoResponse {
	match get_fish_name() {
		Ok(name) => Json(Fish { name }).into_response(),
		Err(_) => StatusCode::INTERNAL_SERVER_ERROR
			.into_response(),
	}
}
