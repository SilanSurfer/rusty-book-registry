use rusty_book_registry::run;

#[tokio::main]
async fn main() -> std::io::Result<()> {
    let listener = std::net::TcpListener::bind("127.0.0.1:8000")?;
    let address = listener.local_addr()?;
    println!("Server started for {}", address);
    run(listener)?.await
}
