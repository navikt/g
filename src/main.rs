use rocket_okapi::swagger_ui::{make_swagger_ui, SwaggerUIConfig};

#[macro_use]
extern crate rocket;

#[macro_use]
extern crate rocket_okapi;

#[cfg(target_os = "linux")]
use prometheus::process_collector::ProcessCollector;
use rocket_prometheus::PrometheusMetrics;

#[path = "./grunnbeløp.rs"]
mod grunnbeløp;
#[cfg(test)]
mod tests;

#[launch]
fn rocket() -> _ {
    let prometheus = PrometheusMetrics::new();
    #[cfg(target_os = "linux")]
    {
        prometheus
            .registry()
            .register(Box::new(ProcessCollector::for_self()))
            .unwrap();
    }
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
