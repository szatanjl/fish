#![cfg(feature = "test_postgres")]
/**
 * These tests are turned off by default because they require running
 * PostgreSQL DB with clear `fish` DB
 */
use fish::{get, populate};

#[tokio::test]
async fn test_get_all_once() {
	let mut names = Vec::from(["fish1", "fish2", "fish3", "fish4"]);

	populate(names.iter().map(|s| *s)).await.unwrap();

	let mut get_names = Vec::new();
	while let Ok(name) = get().await {
		get_names.push(name);
	}

	names.sort();
	get_names.sort();

	assert_eq!(names, get_names);
}
