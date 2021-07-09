#[macro_use]
extern crate rocket;

#[path = "./grunnbeløp.rs"]
mod grunnbeløp;
#[cfg(test)]
mod tests;

#[launch]
fn rocket() -> _ {
    rocket::build()
        .mount("/", routes!(is_alive, is_ready))
        .mount(
            "/api/v1/",
            routes![grunnbeløp::grunnbeløp, grunnbeløp::grunnbeloep],
        )
}

#[get("/isalive")]
fn is_alive() -> &'static str {
    "OK"
}

#[get("/isready")]
fn is_ready() -> &'static str {
    "OK"
}
