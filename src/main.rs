use z2prod::run;

#[tokio::main]
async fn main() -> std::io::Result<()> {
    //println!("Hello, main function!");
    run()?.await
}
