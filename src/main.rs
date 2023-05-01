use rusty_book_registry::configration::get_configuration;
use rusty_book_registry::startup::run;

#[tokio::main]
async fn main() -> std::io::Result<()> {
    let configuration = get_configuration().expect("Failed to read configuration");
    let address = format!("127.0.0.1:{}", configuration.application_port);
    let listener = std::net::TcpListener::bind(address.clone())?;
    println!("Server started for {}", address);
    run(listener)?.await
}
