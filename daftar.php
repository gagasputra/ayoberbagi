<?php
    require_once('koneksi.php');
    $username   = $_POST['username'];
    $password   = md5($_POST['password']);
    $email     = $_POST['email'];

    $database = "INSERT INTO akun(username, password, akses) VALUES ('$username', '$password', 'user');";
    $query1 = mysqli_query($con, $database);

    $data = mysqli_query($con, "SELECT * FROM akun WHERE username = '$username' AND password = '$password'");
    $row = mysqli_fetch_assoc($data);

    $id = $row['id'];
    $database_2 = "INSERT INTO donatur(email, id) VALUES ('$email', '$id');";
    $query2 = mysqli_query($con, $database_2);

    if ( $query1 && $query2) {
        echo "berhasil";
    }
    else {
        echo mysqli_error($con);
    }
?>