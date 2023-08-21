#![deny(clippy::pedantic)]

use std::{
	error::Error as StdError,
	fs::{write, File},
	io::{BufRead, BufReader},
};

use clap::{arg, Command};
use fish::{fetch, get, populate};
use thiserror::Error;

#[derive(Debug, Error)]
#[error("No command provided")]
struct NoCommand;

#[tokio::main]
async fn main() -> Result<(), Box<dyn StdError>> {
	let args = Command::new("Fish")
		.about("Generate random fish names")
		.args([
			arg!(-f --fetch <FNAME> "Fetch fish names into file"),
			arg!(-p --populate <FNAME> "Populate DB with fish names from file"),
			arg!(-P --fetch_populate "Fetch fish names from web and populate DB"),
			arg!(-g --get "Get random fish name"),
		])
		.get_matches();

	if args.get_flag("get") {
		let name = get().await?;
		println!("{}", name);
	} else if args.get_flag("fetch_populate") {
		let names = fetch()?;
		populate(names.iter().map(String::as_str)).await?;
	} else if let Some(fname) = args.get_one::<String>("populate") {
		let file = File::open(fname)?;
		let names = BufReader::new(file)
			.lines()
			.collect::<Result<Vec<_>, _>>()?;
		populate(names.iter().map(String::as_str)).await?;
	} else if let Some(fname) = args.get_one::<String>("fetch") {
		let names = fetch()?;
		write(fname, names.join("\n"))?;
	} else {
		Err(NoCommand)?;
	}

	Ok(())
}
