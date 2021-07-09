use super::*;
use crate::grunnbeløp::{grunnbeløp_for_dato, Grunnbeloep, Grunnbeløp};
use chrono::NaiveDate;
use rocket::http::Status;
use rocket::local::blocking::Client;

#[test]
fn grunnbeloep() {
    let client = Client::tracked(rocket()).expect("valid rocket instance");
    let response = client.get("/api/v1/grunnbeloep").dispatch();
    assert_eq!(response.status(), Status::Ok);
    let expected = grunnbeløp_for_dato(None).unwrap();
    let got = response.into_json::<Grunnbeloep>().unwrap();
    assert_eq!(expected.grunnbeløp, got.grunnbeloep);
    assert_eq!(expected.dato, got.dato);
    assert_eq!(expected.gjennomsnitt_per_år, got.gjennomsnitt_per_aar);
    assert_eq!(expected.grunnbeløp_per_måned, got.grunnbeloep_per_maaned);
}

#[test]
fn grunnbeløp() {
    let client = Client::tracked(rocket()).expect("valid rocket instance");
    let response = client.get("/api/v1/grunnbel%C3%B8p").dispatch();
    assert_eq!(response.status(), Status::Ok);
    let expected = grunnbeløp_for_dato(None).unwrap();
    let got = response.into_json::<Grunnbeløp>().unwrap();
    assert_eq!(expected.grunnbeløp, got.grunnbeløp);
    assert_eq!(expected.dato, got.dato);
    assert_eq!(expected.gjennomsnitt_per_år, got.gjennomsnitt_per_år);
    assert_eq!(expected.grunnbeløp_per_måned, got.grunnbeløp_per_måned);
}

#[test]
fn grunnbeløp_basert_på_dato() {
    let client = Client::tracked(rocket()).expect("valid rocket instance");
    let response = client
        .get("/api/v1/grunnbel%C3%B8p?dato=1997-04-30")
        .dispatch();
    assert_eq!(response.status(), Status::Ok);
    let got = response.into_json::<Grunnbeløp>().unwrap();
    assert_eq!(41_000, got.grunnbeløp);

    assert_eq!(NaiveDate::from_ymd(1996, 05, 01), got.dato);
    assert_eq!(40_410, got.gjennomsnitt_per_år.unwrap());
    assert_eq!(3_417, got.grunnbeløp_per_måned);
    assert!((got.omregningsfaktor.unwrap() - 1.045119) < 0.00000000000000001);
}

#[test]
fn ugyldig_dato_defaulter_til_i_dag() {
    let client = Client::tracked(rocket()).expect("valid rocket instance");
    let response = client.get("/api/v1/grunnbeloep?dato=24-08-2010").dispatch();
    assert_eq!(response.status(), Status::Ok);
    let expected = grunnbeløp_for_dato(None).unwrap();
    let got = response.into_json::<Grunnbeloep>().unwrap();
    assert_eq!(expected.grunnbeløp, got.grunnbeloep);
    assert_eq!(expected.dato, got.dato);
    assert_eq!(expected.gjennomsnitt_per_år, got.gjennomsnitt_per_aar);
    assert_eq!(expected.grunnbeløp_per_måned, got.grunnbeloep_per_maaned);
}

#[test]
fn for_tidlig_dato_feiler() {
    let client = Client::tracked(rocket()).expect("valid rocket instance");
    let response = client.get("/api/v1/grunnbeloep?dato=1560-01-01").dispatch();
    assert_eq!(Status::BadRequest, response.status());
}
