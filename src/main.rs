#![feature(proc_macro_hygiene, decl_macro)]

#[macro_use]
extern crate rocket;

use std::collections::HashMap;

use rocket_contrib::serve::StaticFiles;
use rocket_contrib::templates::Template;

#[get("/")]
fn index() -> Template {
    let context = HashMap::<String, String>::new();
    Template::render("index", &context)
}

fn main() {
    rocket::ignite()
        .attach(Template::fairing())
        .mount("/", routes![index])
        .mount("/", StaticFiles::from("./static"))
        .launch();
}
