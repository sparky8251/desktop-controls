use axum::http::StatusCode;
use axum::{Router, routing::post};
use std::process::Command;

#[tokio::main(flavor = "current_thread")]
async fn main() {
    let app = Router::new().route("/disable-monitors", post(disable_monitors));
    let listener = tokio::net::TcpListener::bind("127.0.0.1:3000")
        .await
        .unwrap();

    axum::serve(listener, app).await.unwrap();
}

async fn disable_monitors() -> StatusCode {
    println!("disabling monitors...");
    let _ = Command::new("kscreen-doctor")
        .args(["--dpms", "off"])
        .output();
    StatusCode::OK
}
