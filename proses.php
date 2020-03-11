<?php
    $proses = new Proses();

    if ($_GET['menu'] == "register" ) {
        $proses->register();
    } else if($_GET['menu'] == "login") {
        $proses->login();
    } else if($_GET['menu'] == "view_bencana") {
        $proses->view_bencana();
    } else if($_GET['menu'] == "add_donasi") {
        $proses->add_donasi();
    } else if($_GET['menu'] == "view_profile") {
        $proses->view_profile();
    } else if($_GET['menu'] == "view_laporan") {
        $proses->view_laporan();
    } else if($_GET['menu'] == "detail_laporan") {
        $proses->detail_laporan();
    } else if($_GET['menu'] == "view_donasi_proses") {
        $proses->view_donasi_proses();
    } else if($_GET['menu'] == "view_donasi_history") {
        $proses->view_donasi_history();
    } else if($_GET['menu'] == "view_profile_pj") {
        $proses->view_profile_pj();
    } else if($_GET['menu'] == "dashboard_relawan") {
        $proses->dashboard_relawan();
    } else if($_GET['menu'] == "view_relawan_proses") {
        $proses->view_relawan_proses();
    }

    class Proses{
        private $connect;

        // DATABASE
        public function Proses() {
            $servername = "localhost";
            $username   = "root";
            $password   = "";
            $db         = "ayo_berbagi_2";

            $this->connect = mysqli_connect($servername, $username, $password, $db);
            // if($this->connect){
            //     echo "Berhasil";
            // }
        }

        // LOGIN
        public function login() {

            // session_start();
            $username   = $_POST['username'];
            $password   = md5($_POST['password']);

            $database = "SELECT akun.*, donatur.id_donatur AS id_donatur, pj.id_pj AS id_pj, donatur.nama AS nama_donatur, pj.nama AS nama_pj
                            FROM akun
                            LEFT JOIN donatur ON donatur.id = akun.id
                            LEFT JOIN pj ON pj.id = akun.id
                            WHERE username = '$username' AND password = '$password'";
            $result = mysqli_query($this->connect, $database);
            $row = mysqli_fetch_assoc($result);
            $data_user = [];

            if (mysqli_num_rows($result) != 0) {
                if ($row['akses'] == 'user') {
                    $data_user['akses'] = $row['akses'];
                    $data_user['id'] = $row['id'];
                    $data_user['username'] = $username;
                    $data_user['id_donatur'] = $row['id_donatur'];
                    $data_user['nama_donatur'] = $row['nama_donatur'];
                    $data_user['role'] = "user";
                    $data_user['berhasil'] = "berhasil";
                } else if ($row['akses'] == 'pj'){
                    $data_user['akses'] = $row['akses'];
                    $data_user['id'] = $row['id'];
                    $data_user['username'] = $username;
                    $data_user['id_pj'] = $row['id_pj'];
                    $data_user['nama_pj'] = $row['nama_pj'];
                    $data_user['berhasil'] = "berhasil";
                    $data_user['role'] = "pj";
                } else {
                    $data_user['akses'] = $row['akses'];
                    $data_user['berhasil'] = "Berhasil";
                }
                header('Content-Type: application/json');
                echo json_encode($data_user);
            } else {
                ?>
                <script>
                    alert("Login Gagal");
                </script>
                <?php
                header('Content-Type: application/json');
                echo json_encode('error');
            }

            // if(isset($row)){
            //     echo "Berhasil";
            // }else{
            //     echo "Gagal";
            // }

            mysqli_close($this->connect);
        }

        // REGISTER
        public function register() {
            $username   = $_POST['username'];
            $password   = md5($_POST['password']);
            $email     = $_POST['email'];
            $noktp      = $_POST['no_ktp'];

            $database = "INSERT INTO akun(username, password, akses) VALUES ('$username', '$password', 'user');";
            $query1 = mysqli_query($this->connect, $database);

            $data = mysqli_query($this->connect, "SELECT * FROM akun WHERE username = '$username' AND password = '$password'");
            $row = mysqli_fetch_assoc($data);

            $id = $row['id'];
            $database_2 = "INSERT INTO donatur(email, no_ktp, id) VALUES ('$email', '$noktp', '$id');";
            $query2 = mysqli_query($this->connect, $database_2);

            if ( $query1 && $query2) {
                echo "berhasil";
            }
            else {
                echo mysqli_error($this->connect);
            }
        }

        // VIEW BENCANA
        public function view_bencana(){
            $database = "SELECT id_bencana, nama_bencana, gambar, gambar2, gambar3, nama, if(hitung_total(id_bencana) >= 0, 
            format(hitung_total(id_bencana), 0), 0) as total_donasi, if(sisa_hari(deadline) >= 0, sisa_hari(deadline), 0) as deadline 
            FROM view_bencana WHERE status = 0 AND sisa_hari(deadline) > 0";
            $result = mysqli_query($this->connect, $database);

            $arraydata = array();
            while ($data = mysqli_fetch_assoc($result)) {
                $arraydata[] = $data;
            }
            header('Content-Type: application/json');
            echo json_encode($arraydata);
        }

        public function view_profile(){
            $id_donatur = $_POST['id_donatur'];
            $database = "SELECT * FROM donatur WHERE id_donatur = $id_donatur";
            $result = mysqli_query($this->connect, $database);
            $row = mysqli_fetch_assoc($result);
            header('Content-Type: application/json');
            echo json_encode($row);
        }

        public function add_donasi(){
            $id_bencana = $_POST['id_bencana'];
            $id_donatur = $_POST['id_donatur'];
            $nominal = $_POST['nominal'];

            $database = "INSERT INTO `donasi`(
                            `id_bencana`,
                            `id_donatur`,
                            `kategori`,
                            `nominal`,
                            `bukti`,
                            `konfirmasi`
                        ) VALUES (
                            '$id_bencana',
                            '$id_donatur',
                            'Uang',
                            '$nominal',
                            null,
                            '0'
                        )";
            $result = mysqli_query($this->connect, $database) or die (mysqli_error($this->connect));
            $res = [];
            if($result){
                $res['success'] = "true";
            } else {
                $res['success'] = "false";
            }
            echo json_encode($res);
        }

        public function view_laporan(){
            $database = "SELECT id_laporan, id_pj, nama_bencana, format(total_donasi, 0) AS total_donasi, nama,  laporan, gambar1, gambar2, gambar3 FROM view_laporan";
            $result = mysqli_query($this->connect, $database);

            $arraydata = array();
            while ($data = mysqli_fetch_assoc($result)) {
                $arraydata[] = $data;
            }
            header('Content-Type: application/json');
            echo json_encode($arraydata);
        }

        public function detail_laporan(){
            $id_laporan = $_POST['id_laporan'];
            $database = "SELECT id_laporan, id_pj, nama_bencana, format(total_donasi, 0) AS total_donasi, nama,  laporan, gambar1, gambar2, gambar3 
            FROM view_laporan WHERE id_laporan=$id_laporan";
            
            $result = mysqli_query($this->connect, $database);

            $data = mysqli_fetch_assoc($result);
            header('Content-Type: application/json');
            echo json_encode($data);
        }

        public function view_donasi_proses(){
            $id_donatur = $_POST['id_donatur'];
            $database = "SELECT * FROM donasi_proses WHERE id_donatur = $id_donatur ORDER BY 1 DESC";
            $result = mysqli_query($this->connect, $database);

            $arraydata = array();
            while ($data = mysqli_fetch_array($result)) {
                $arraydata[] = $data;
            }
            header('Content-Type: application/json');
            echo json_encode($arraydata);
        }

        public function view_donasi_history(){
            $id_donatur = $_POST['id_donatur'];
            $database = "SELECT * FROM history_donasi WHERE id_donatur = $id_donatur ORDER BY 1 DESC";
            $result = mysqli_query($this->connect, $database);

            $arraydata = array();
            while ($data = mysqli_fetch_array($result, MYSQLI_ASSOC)) {
                $arraydata[] = $data;
            }
            // print_r($arraydata);
            header('Content-Type: application/json');
            echo json_encode($arraydata);
        }

        // public function upload_bukti(){
        //     $id_donatur = $_POST['id_donatur'];
        //     $ImageData = $_POST['bukti'];
        //     $ImageName = $_POST['image_name'];
            
        //     if($_SERVER['REQUEST_METHOD'] == 'POST'){
        //     $DefaultId = 0;
        //     $GetOldIdSQL ="SELECT * from donatur where 'id_donatur' = $id_donatur";
            
        //     $Query = mysqli_query($this->connect ,$GetOldIdSQL);
            
        //     while($row = mysqli_fetch_array($Query)){
            
        //     $DefaultId = $row['id_donatur'];
        //     }
            
        //     $ImagePath = "images/$DefaultId.png";
            
        //     $ServerURL = "https://androidjsonblog.000webhostapp.com/$ImagePath";
            
        //     $InsertSQL = "insert into UploadImageToServer (image_path,image_name) values ('$ServerURL','$ImageName')";
            
        //     if(mysqli_query($this->connect, $InsertSQL)){

        //     file_put_contents($ImagePath,base64_decode($ImageData));

        //     echo "Your Image Has Been Uploaded.";
        //     }
            
        //     mysqli_close($this->connect);
        //     }else{
        //     echo "Not Uploaded";
        //     }
        // }

        // Relawan

        public function view_profile_pj(){
            $id_pj = $_POST['id_pj'];
            $database = "SELECT * FROM pj WHERE id_pj = $id_pj";
            $result = mysqli_query($this->connect, $database);
            $row = mysqli_fetch_assoc($result);
            header('Content-Type: application/json');
            echo json_encode($row);
        }

        public function dashboard_relawan(){
            $id_pj = $_POST['id_pj'];
            $database = "SELECT id_bencana, id_pj, nama_bencana, banyak, tgl_kejadian, format(hitung_total, 0) AS 'hitung_total', format(total_donasi, 0) AS 'total_donasi', format(total_diproses, 0) AS 'total_diproses'  FROM dashboard_pj WHERE id_pj = $id_pj";
            $result = mysqli_query($this->connect, $database);
            $row = mysqli_fetch_assoc($result);
            header('Content-Type: application/json');
            echo json_encode($row);
        }

        public function view_relawan_proses(){
            $id_pj = $_POST['id_pj'];
            $database = "SELECT * FROM konf_donasi WHERE id_pj = $id_pj ORDER BY 1 DESC";
            $result = mysqli_query($this->connect, $database);

            $arraydata = array();
            while ($data = mysqli_fetch_assoc($result)) {
                $arraydata[] = $data;
            }
            header('Content-Type: application/json');
            echo json_encode($arraydata);
        }

}
?>