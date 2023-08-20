//#![deny(clippy::pedantic)]

use thiserror::Error;

#[derive(Debug, Error)]
pub enum Error {}

pub fn fetch() -> Result<Vec<String>, Error> {
	todo!()
}

pub fn populate<'a>(
	_names: impl IntoIterator<Item = &'a str>,
) -> Result<(), Error> {
	todo!()
}

pub fn get() -> Result<String, Error> {
	todo!()
}
