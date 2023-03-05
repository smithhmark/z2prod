use std::net::TcpListener;

#[tokio::test]
async fn health_check_works() {
    //Arange
    let address = spawn_app();
    let client = reqwest::Client::new();

    //Act
    let response = client
        .get(&format!("{}/health_check", address))
        .send()
        .await
        .expect("Failed to execute request");

    //Assert
    assert!(response.status().is_success());
    assert_eq!(Some(0), response.content_length());
}

//Arrange
//Act
//Assert
#[tokio::test]
async fn subscribe_returns_200_for_valid_form() {
    //Arrange
    let app_address = spawn_app();
    let client = reqwest::Client::new();

    //Act
    let body = "name=le%20guin&email=ursula_le_quin%40example.com";
    let response = client
        .post(&format!("{}/subscriptions", &app_address))
        .header("Content-Type", "application/x-www-form-urlencoded")
        .body(body)
        .send()
        .await
        .expect("failed to execute request");

    //Assert
    assert_eq!(200, response.status().as_u16());
}

fn spawn_app() -> String {
    let listener = TcpListener::bind("127.0.0.1:0").expect("Failed to bind port");
    let port = listener.local_addr().unwrap().port();
    let server = z2prod::run(listener).expect("Can't bind address");
    let _ = tokio::spawn(server);
    format!("http://127.0.0.1:{}", port)
}
