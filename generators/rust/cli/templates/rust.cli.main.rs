#[macro_use]
extern crate human_panic;
#[macro_use]
extern crate clap;
use clap::{App, Arg};

fn main() {
	setup_panic!();

	let matches = App::new(crate_name!())
		.version(crate_version!())
		.author(crate_authors!("\n"))
		.about(crate_description!())
		.arg(
			Arg::with_name("URL")
				.required(true)
				.takes_value(true)
				.index(1)
				.help("URL of the website to get the IP address for."),
		)
		.get_matches();
}
