use rocket_okapi::swagger_ui::{make_swagger_ui, SwaggerUIConfig};
use rocket_prometheus::PrometheusMetrics;

#[macro_use]
extern crate rocket;

#[macro_use]
extern crate rocket_okapi;

#[path = "./grunnbeløp.rs"]
mod grunnbeløp;
#[cfg(test)]
mod tests;

#[launch]
fn rocket() -> _ {
    let prometheus = PrometheusMetrics::with_default_registry();
    rocket::build()
        .attach(prometheus.clone())
        .mount("/", routes!(is_alive, is_ready))
        .mount(
            "/api/v1/",
            routes_with_openapi![grunnbeløp::grunnbeløp, grunnbeløp::grunnbeloep],
        )
        .mount(
            "/",
            make_swagger_ui(&SwaggerUIConfig {
                url: "/api/v1/openapi.json".to_owned(),
                ..SwaggerUIConfig::default()
            }),
        )
        .mount("/metrics", prometheus)
}

#[get("/isalive")]
fn is_alive() -> &'static str {
    "OK"
}

#[get("/isready")]
fn is_ready() -> &'static str {
    "OK"
}
