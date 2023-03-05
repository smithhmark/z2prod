use std::net::TcpListener;

use z2prod::run;

#[tokio::main]
async fn main() -> std::io::Result<()> {
    //println!("Hello, main function!");
    let listener = TcpListener::bind("127.0.0.1:8000").expect("Failed to bind port");
    run(listener)?.await
}
