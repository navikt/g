use chrono::{Local, NaiveDate};
use once_cell::sync::Lazy;
use rocket::response::status;
use rocket::response::status::BadRequest;
use rocket::serde::json;
use rocket::serde::json::Json;
use rocket::serde::{Deserialize, Serialize};
use schemars::JsonSchema;

const GRUNNBELØP_TEXT: &str = include_str!("../grunnbeløp.json");

static GRUNNBELØP: Lazy<Vec<Grunnbeløp>> = Lazy::new(|| {
    json::from_str::<GrunnbeløpList>(GRUNNBELØP_TEXT)
        .unwrap()
        .grunnbeløp
});

#[derive(Serialize, Deserialize, Debug, JsonSchema)]
#[schemars(example = "example_grunnbeløp")]
pub struct Grunnbeløp {
    pub dato: NaiveDate,
    pub grunnbeløp: u32,
    // Serde renaming is broken for non-ascii-identifiers
    #[serde(rename = "grunnbeløpPerMåned")]
    pub grunnbeløp_per_måned: u32,
    #[serde(rename = "gjennomsnittPerÅr")]
    pub gjennomsnitt_per_år: Option<u32>,
    pub omregningsfaktor: Option<f64>,
}

fn example_grunnbeløp() -> &'static Grunnbeløp {
    &GRUNNBELØP[0]
}

#[derive(Serialize, Deserialize, Debug, JsonSchema)]
#[schemars(example = "example_grunnbeløp")]
#[serde(rename_all = "camelCase")]
pub struct Grunnbeloep {
    pub dato: NaiveDate,
    pub grunnbeloep: u32,
    pub grunnbeloep_per_maaned: u32,
    pub gjennomsnitt_per_aar: Option<u32>,
    pub omregningsfaktor: Option<f64>,
}

impl From<&Grunnbeløp> for Grunnbeloep {
    fn from(g: &Grunnbeløp) -> Self {
        Self {
            dato: g.dato,
            grunnbeloep: g.grunnbeløp,
            grunnbeloep_per_maaned: g.grunnbeløp_per_måned,
            gjennomsnitt_per_aar: g.gjennomsnitt_per_år,
            omregningsfaktor: g.omregningsfaktor,
        }
    }
}

#[derive(Serialize, Deserialize, Debug)]
struct GrunnbeløpList {
    pub grunnbeløp: Vec<Grunnbeløp>,
}

pub fn grunnbeløp_for_dato(dato: Option<&str>) -> Option<&Grunnbeløp> {
    let filter_dato: NaiveDate = dato
        .map(|d| d.parse().ok())
        .flatten()
        .unwrap_or_else(|| Local::now().naive_local().date());
    GRUNNBELØP
        .iter()
        .filter(|g| g.dato <= filter_dato)
        .min_by_key(|g| filter_dato - g.dato)
}

/// # Grunnbeløp
///
/// Returnerer dagens grunnbeløp
#[openapi(tag = "Grunnbeløp")]
#[get("/grunnbeløp?<dato>")]
pub fn grunnbeløp(dato: Option<&str>) -> Result<Json<&Grunnbeløp>, BadRequest<&str>> {
    grunnbeløp_for_dato(dato).map_or_else(
        || {
            Err(status::BadRequest(Some(
                "Forespurt Grunnbeløp fra før det eksisterte",
            )))
        },
        |g| Ok(Json(g)),
    )
}

/// # Grunnbeløp
///
/// Returnerer dagens grunnbeløp
#[openapi(tag = "Grunnbeløp")]
#[get("/grunnbeloep?<dato>")]
pub fn grunnbeloep(dato: Option<&str>) -> Result<Json<Grunnbeloep>, BadRequest<&str>> {
    grunnbeløp_for_dato(dato).map_or_else(
        || {
            Err(status::BadRequest(Some(
                "Forespurt Grunnbeløp fra før det eksisterte",
            )))
        },
        |g| Ok(Json(g.into())),
    )
}
