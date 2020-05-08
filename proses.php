<?php
    $proses = new Proses();

    if ($_GET['menu'] == "register" ) {
        $proses->register();
    } else if($_GET['menu'] == "login") {
        $proses->login();
    } else if($_GET['menu'] == "view_bencana") {
        $proses->view_bencana();
    } else if($_GET['menu'] == "select_bencana") {
        $proses->select_bencana();
    } else if($_GET['menu'] == "donasi_terkini") {
        $proses->donasi_terkini();
    } else if($_GET['menu'] == "add_donasi") {
        $proses->add_donasi();
    } else if($_GET['menu'] == "donasi_barang") {
        $proses->donasi_barang();
    } else if($_GET['menu'] == "view_profile") {
        $proses->view_profile();
    } else if($_GET['menu'] == "cek_profile") {
        $proses->cek_profile();
    } else if($_GET['menu'] == "before_reset_pass") {
        $proses->before_reset_pass();
    } else if($_GET['menu'] == "ubah_password") {
        $proses->ubah_password();
    } else if($_GET['menu'] == "edit_foto_profile") {
        $proses->edit_foto_profile();
    } else if($_GET['menu'] == "edit_akun") {
        $proses->edit_akun();
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
    } else if($_GET['menu'] == "home_relawan") {
        $proses->home_relawan();
    } else if($_GET['menu'] == "info_relawan") {
        $proses->info_relawan();
    } else if($_GET['menu'] == "view_relawan_proses") {
        $proses->view_relawan_proses();
    } else if($_GET['menu'] == "view_relawan_diterima") {
        $proses->view_relawan_diterima();
    } else if($_GET['menu'] == "view_semua_diterima") {
        $proses->view_semua_diterima();
    } else if($_GET['menu'] == "upload_bukti") {
        $proses->upload_bukti();
    } else if($_GET['menu'] == "terima_donasi") {
        $proses->terima_donasi();
    } else if($_GET['menu'] == "tolak_donasi") {
        $proses->tolak_donasi();
    } else if($_GET['menu'] == "view_distribusi") {
        $proses->view_distribusi();
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

            $database = "SELECT akun.*, donatur.id_donatur AS id_donatur, pj.id_pj AS id_pj, donatur.nama AS nama_donatur, donatur.no_ktp AS no_ktp
            , donatur.email AS email, donatur.telp AS telp, donatur.alamat AS alamat, pj.nama AS nama_pj
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
                    $data_user['no_ktp'] = $row['no_ktp'];
                    $data_user['email'] = $row['email'];
                    $data_user['telp'] = $row['telp'];
                    $data_user['alamat'] = $row['alamat'];
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
            $nama   = $_POST['nama'];
            $pertanyaan = $_POST['pertanyaan'];
            $jawaban = md5($_POST['jawaban']);
            $tipedonatur = $_POST['tipedonatur'];
            $email     = $_POST['email'];
            $noktp      = $_POST['no_ktp'];

            $database = "INSERT INTO akun(username, password, secret_q, answer, akses) VALUES ('$username', '$password', '$pertanyaan', '$jawaban', 'user');";
            $query1 = mysqli_query($this->connect, $database);

            $data = mysqli_query($this->connect, "SELECT * FROM akun WHERE username = '$username' AND password = '$password'");
            $row = mysqli_fetch_assoc($data);

            $id = $row['id'];
            $database_2 = "INSERT INTO donatur(nama, email, tipedonatur, foto, no_ktp, id) VALUES ('$nama', '$email', '$tipedonatur', 'ayoberbagi/image/profile/profile+0.jpg', '$noktp', '$id');";
            $query2 = mysqli_query($this->connect, $database_2);

            if ( $query1 && $query2) {
                echo "berhasil";
            }
            else {
                echo mysqli_error($this->connect);
            }
        }

        public function before_reset_pass(){
            $username = $_POST['username'];

            $database = "SELECT username, secret_q, answer FROM akun WHERE username = '$username'";
            $result = mysqli_query($this->connect, $database);
            $row = mysqli_fetch_assoc($result);
            header('Content-Type: application/json');
            echo json_encode($row);
        }

        public function ubah_password(){
            $username = $_POST['username'];
            $password = md5($_POST['password']);

            $database = "UPDATE akun SET password = '$password' WHERE username = '$username'";
            $result = mysqli_query($this->connect, $database);
            if($result){
                echo "Ubah Password Berhasil.";
            } else {
                echo "Ubah Password Gagal.";
            }
        }

        // VIEW BENCANA
        public function view_bencana(){
            $database = "SELECT id_bencana, id_pj, nama_bencana, DATE_FORMAT(tgl_kejadian, '%d-%m-%Y') AS tgl_kejadian, lokasi, deskripsi, jumlah_korban, kerugian, gambar, gambar2, gambar3, nama, if(hitung_total(id_bencana) >= 0, 
            format(hitung_total(id_bencana), 0), 0) as total_donasi, DATE_FORMAT(deadline, '%d-%m-%Y') AS batas_akhir, if(sisa_hari(deadline) >= 0, sisa_hari(deadline), 0) as deadline
            FROM view_bencana WHERE status = 0 AND sisa_hari(deadline) > 0 ORDER BY 1 DESC";
            $result = mysqli_query($this->connect, $database);

            $arraydata = array();
            while ($data = mysqli_fetch_assoc($result)) {
                $arraydata[] = $data;
            }
            header('Content-Type: application/json');
            echo json_encode($arraydata);
        }

        public function select_bencana(){
            $id_bencana = $_POST['id_bencana'];
            $database = "SELECT id_bencana, id_pj, nama_bencana, DATE_FORMAT(tgl_kejadian, '%d-%m-%Y') AS tgl_kejadian, lokasi, deskripsi, jumlah_korban, kerugian, gambar, gambar2, gambar3, nama, if(hitung_total(id_bencana) >= 0, 
            format(hitung_total(id_bencana), 0), 0) as total_donasi, DATE_FORMAT(deadline, '%d-%m-%Y') AS batas_akhir, if(sisa_hari(deadline) >= 0, sisa_hari(deadline), 0) as deadline
            FROM view_bencana WHERE id_bencana = '$id_bencana'";
            $result = mysqli_query($this->connect, $database);

            $arraydata = array();
            while ($data = mysqli_fetch_assoc($result)) {
                $arraydata[] = $data;
            }
            header('Content-Type: application/json');
            echo json_encode($arraydata);
        }

        public function cek_profile(){
            $id_donatur = $_POST['id_donatur'];
            $database = "SELECT * FROM donatur WHERE id_donatur = $id_donatur";
            $result = mysqli_query($this->connect, $database);
            $row = mysqli_fetch_assoc($result);
            $data_user = [];
            if($row['telp'] == NULL && $row['alamat'] == NULL){
                $data_user['akses'] = "update";
            } else {
                $data_user['akses'] = "donasi";
            }
            header('Content-Type: application/json');
            echo json_encode($data_user);
        }

        public function view_profile(){
            $id_donatur = $_POST['id_donatur'];
            $database = "SELECT * FROM donatur WHERE id_donatur = $id_donatur";
            $result = mysqli_query($this->connect, $database);
            $row = mysqli_fetch_assoc($result);
            header('Content-Type: application/json');
            echo json_encode($row);
        }

        public function edit_foto_profile(){
            $id_donatur = $_POST['id_donatur'];
            $database1 = "SELECT foto FROM donatur WHERE id_donatur = $id_donatur";
            $result = mysqli_query($this->connect, $database1);
            $row = mysqli_fetch_assoc($result);
            $file_db = explode('/',$row['foto']);
            $filename_db = explode('+',$file_db[3]);
            $filename_arr = explode('.',$filename_db[1]);

            if($_SERVER['REQUEST_METHOD'] == 'POST'){
                $DefaultId = 0;
                
                $foto = $_POST['image_tag'];
                $number = 1;
                $number = $filename_arr[0];
                $number++;
                $foto_baru = "$foto+$number";
                $ImageData = $_POST['image_data'];
                $nama_donatur = $_POST['nama_donatur'];
                $no_ktp = $_POST['no_ktp'];
                $email = $_POST['email'];
                $telp = $_POST['telp'];
                $alamat = $_POST['alamat'];
               
                
                // $foto = $_POST['image_tag'];
                $ImagePath = "image/profile/$foto_baru.jpg";
                
                $foto = "ayoberbagi/$ImagePath";

                $database = "UPDATE donatur SET nama = '$nama_donatur', no_ktp = '$no_ktp', email = '$email', telp = '$telp', alamat = '$alamat', foto = '$foto' WHERE id_donatur = '$id_donatur'";
            
                if(mysqli_query($this->connect, $database)){
                    file_put_contents($ImagePath, base64_decode($ImageData));
                    echo "Edit Profile Berhasil.";
                } else {
                    echo "Edit Profile Gagal.";
                }
            }
        }

        public function edit_akun(){
            $id = $_POST['id'];
            $username = $_POST['username'];
            $password = $_POST['password'];
            $old_password = $_POST['old_password'];

            $database1 = "SELECT * FROM akun WHERE id = $id";
            $result = mysqli_query($this->connect, $database1);
            $row = mysqli_fetch_assoc($result);
            $data_user = [];
            if($row['password'] == md5($old_password)){
                $data_user['hasil'] = "berhasil";
                $password = md5($password);
                $database = "UPDATE akun SET username = '$username', password = '$password' WHERE id = '$id'";
                $uname = "SELECT username FROM akun WHERE id = $id";
                mysqli_query($this->connect, $database);
                $result_uname = mysqli_query($this->connect, $uname);
                $row1 = mysqli_fetch_assoc($result_uname);
                $data_user['uname'] = $row1['username'];
            } else {
                $data_user['hasil'] = "gagal";
            }
            header('Content-Type: application/json');
            echo json_encode($data_user);
        }

        public function donasi_terkini(){
            $id_bencana = $_POST['id_bencana'];
            $database = "SELECT id_donasi, anonim, nama_donatur, nominal FROM semua_donasi WHERE konfirmasi = 1 AND id_bencana = $id_bencana ORDER BY 1 DESC";
            $result = mysqli_query($this->connect, $database);

            $arraydata = array();
            while ($data = mysqli_fetch_assoc($result)) {
                $arraydata[] = $data;
            }
            header('Content-Type: application/json');
            echo json_encode($arraydata);
        }

        public function add_donasi(){
            $id_donatur = $_POST['id_donatur'];
            $id_bencana = $_POST['id_bencana'];
            $nominal = $_POST['nominal'];
            $anonim = $_POST['anonim'];

            $database1 = "SELECT * FROM donatur WHERE id_donatur = $id_donatur";
            $result = mysqli_query($this->connect, $database1);
            $row = mysqli_fetch_assoc($result);
            $data_user = [];
            if($row['telp'] == NULL && $row['alamat'] == NULL){
                $data_user['akses'] = "update";
            } else {
                $data_user['akses'] = "donasi";
                $database = "INSERT INTO `donasi`(
                    `id_bencana`,
                    `id_donatur`,
                    `kategori`,
                    `nominal`,
                    `waktu_donasi`,
                    `bukti`,
                    `konfirmasi`,
                    `anonim`
                ) VALUES (
                    '$id_bencana',
                    '$id_donatur',
                    'Uang',
                    '$nominal',
                    now(),
                    null,
                    '0',
                    '$anonim'
                )";
                $result = mysqli_query($this->connect, $database) or die (mysqli_error($this->connect));
                $res = [];
                if($result){
                    $res['success'] = "Donasi Berhasil";
                } else {
                    $res['success'] = "Donasi Gagal";
                }
            }
            header('Content-Type: application/json');
            echo json_encode($data_user);

            // $cek_profile = "SELECT * FROM donatur WHERE id_donatur = $id_donatur";
            // $result = mysqli_query($this->connect, $cek_profile);
            // $row = mysqli_fetch_assoc($result);
            
            // $nama = $row['nama'];
            // $no_ktp = $row['no_ktp'];
            // $email = $row['email'];
            // $telp = $row['telp'];
            // $alamat = $row['alamat'];

            // if($nama != NULL && $no_ktp != NULL && $email != NULL && $telp != NULL && $alamat != NULL){
                
            // } else {
            //     $res = "Lengkapi Profile Sebelum Donasi!";
            //     echo $res;
            // }
            
        }

        public function donasi_barang(){
            if($_SERVER['REQUEST_METHOD'] == 'POST')
                {
                $DefaultId = 0;
                $ImageData = $_POST['image_data'];
                
                $foto = $_POST['image_tag'];
                
                $ImagePath = "image/upload/$foto.jpg";
                
                $path_foto = "ayoberbagi/$ImagePath";
                
                $id_bencana = $_POST['id_bencana'];
                $id_donatur = $_POST['id_donatur'];
                // $jumlah_total = $_POST['jumlah_total'];
                // $cb_lain = $_POST['cb_lain'];

                $jml_pakaian = $_POST['jml_pakaian'];
                $jml_selimut = $_POST['jml_selimut'];
                $jml_buku = $_POST['jml_buku'];
                $jml_sembako = $_POST['jml_sembako'];
                $jml_makan_minum = $_POST['jml_makan_minum'];
                $jml_medis_obat = $_POST['jml_medis_obat'];
                $jml_mainan = $_POST['jml_mainan'];
                $jml_alat_rt = $_POST['jml_alat_rt'];
                $barang_lain = $_POST['barang_lain'];
                $jml_lain = $_POST['jml_lain'];

                // $jml_lain = $_POST['jml_lain'];
                // if(isset($_POST['checked'])){
                //     $isi_donasi = implode(', ', $_POST['checked']);
                // }

                $database = "INSERT INTO donasi(
                    id_bencana,
                    id_donatur,
                    kategori,
                    waktu_donasi,
                    bukti,
                    konfirmasi
                ) VALUES (
                    '$id_bencana',
                    '$id_donatur',
                    'Barang',
                    now(),
                    null,
                    '0'
                )";

                if (mysqli_query($this->connect, $database)){
                    $id_donasi = mysqli_insert_id($this->connect);
                } else {
                    echo "Error".$database." ".mysqli_error($this->connect);
                }

                $database2 = "INSERT INTO donasi_barang(
                    id_donasi,
                    id_bencana,
                    id_donatur,
                    jumlah_total,
                    foto,
                    path_foto,
                    jml_pakaian, jml_selimut, jml_buku, jml_sembako, jml_makan_minum, jml_medis_obat, jml_mainan, jml_alat_rt, barang_lain, jml_lain
                ) VALUES (
                    '$id_donasi',
                    '$id_bencana',
                    '$id_donatur',
                    '$jml_pakaian' + '$jml_selimut' + '$jml_buku' + '$jml_sembako' + '$jml_makan_minum' + '$jml_medis_obat' + '$jml_mainan' + '$jml_alat_rt' + '$jml_lain',
                    '$foto',
                    '$path_foto',
                    '$jml_pakaian', '$jml_selimut', '$jml_buku', '$jml_sembako', '$jml_makan_minum', '$jml_medis_obat', '$jml_mainan', '$jml_alat_rt', '$barang_lain', '$jml_lain'
                    )";

                if(mysqli_query($this->connect, $database2)){
                    file_put_contents($ImagePath,base64_decode($ImageData));
                    echo "Donasi Barang Berhasil.";
                } else {
                    echo "Donasi Barang Gagal.".mysqli_error($this->connect);
                }
            }
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

        public function upload_bukti(){
            if($_SERVER['REQUEST_METHOD'] == 'POST')
                {
                $DefaultId = 0;
            
                $id_donasi = $_POST['id_donasi'];
                $ImageData = $_POST['image_data'];
                
                $bukti = $_POST['image_tag'];
                
                $ImagePath = "image/upload/$bukti.jpg";
                
                $upload_path = "ayoberbagi/$ImagePath";
                
                // $database = "INSERT INTO imageupload (image_path,image_name) values('$bukti','$upload_path')";
                $database = "UPDATE donasi SET bukti = '$bukti', upload_path = '$upload_path' WHERE id_donasi = '$id_donasi'";
                
                if(mysqli_query($this->connect, $database)){
                    file_put_contents($ImagePath,base64_decode($ImageData));
                    echo "Bukti Berhasil Diupload.";
                } else {
                    echo "Bukti Gagal Diupload.";
                }
            }
        }

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
            $database = "SELECT id_bencana, id_pj, nama_bencana, tgl_kejadian, deadline, banyak, format(hitung_total, 0) AS 'hitung_total', format(total_donasi, 0) AS 'total_donasi', format(total_diproses, 0) AS 'total_diproses', jumlah_diterima, jumlah_diproses FROM dashboard_pj WHERE id_pj = $id_pj";
            $result = mysqli_query($this->connect, $database);
            $row = mysqli_fetch_assoc($result);
            header('Content-Type: application/json');
            echo json_encode($row);
        }

        public function home_relawan(){
            $id_pj = $_POST['id_pj'];
            $database = "SELECT id_bencana, id_pj, nama_bencana, tgl_kejadian FROM home_pj WHERE id_pj = $id_pj";
            $result = mysqli_query($this->connect, $database);
            $row = mysqli_fetch_assoc($result);
            header('Content-Type: application/json');
            echo json_encode($row);
        }

        public function info_relawan(){
            $id_pj = $_POST['id_pj'];
            $database = "SELECT * FROM info_relawan WHERE id_pj = $id_pj";
            $result = mysqli_query($this->connect, $database);
            $row = mysqli_fetch_assoc($result);
            header('Content-Type: application/json');
            echo json_encode($row);
        }

        public function view_relawan_proses(){
            $id_pj = $_POST['id_pj'];
            $database = "SELECT * FROM konf_donasi WHERE id_pj = $id_pj AND status = 0 ORDER BY 1 DESC";
            $result = mysqli_query($this->connect, $database);

            $arraydata = array();
            while ($data = mysqli_fetch_assoc($result)) {
                $arraydata[] = $data;
            }
            header('Content-Type: application/json');
            echo json_encode($arraydata);
        }

        public function view_relawan_diterima(){
            $id_pj = $_POST['id_pj'];
            $database = "SELECT * FROM semua_donasi WHERE id_pj = $id_pj AND status = 0 AND konfirmasi = 1  ORDER BY 1 DESC";
            $result = mysqli_query($this->connect, $database);

            $arraydata = array();
            while ($data = mysqli_fetch_assoc($result)) {
                $arraydata[] = $data;
            }
            header('Content-Type: application/json');
            echo json_encode($arraydata);
        }

        public function view_semua_diterima(){
            $id_bencana = $_POST['id_bencana'];
            $id_pj = $_POST['id_pj'];
            $database = "SELECT * FROM semua_donasi WHERE id_pj = $id_pj AND id_bencana = $id_bencana AND konfirmasi = 1  ORDER BY 1 DESC";
            $result = mysqli_query($this->connect, $database);

            $arraydata = array();
            while ($data = mysqli_fetch_assoc($result)) {
                $arraydata[] = $data;
            }
            header('Content-Type: application/json');
            echo json_encode($arraydata);
        }

        public function terima_donasi(){
            $id_donasi = $_POST['id_donasi'];

            $database = "UPDATE donasi SET konfirmasi = 1, waktu_diterima = NOW() WHERE id_donasi = $id_donasi";
            $result = mysqli_query($this->connect, $database) or die (mysqli_error($this->connect));
            $res = [];
            if($result){
                $res['success'] = "Donasi Berhasil Diterima";
            } else {
                $res['success'] = "Donasi Gagal Diterima";
            }
            echo json_encode($res);
        }

        public function tolak_donasi(){
            $id_donasi = $_POST['id_donasi'];

            $database = "UPDATE donasi SET bukti = NULL, upload_path = NULL WHERE id_donasi = $id_donasi";
            $result = mysqli_query($this->connect, $database) or die (mysqli_error($this->connect));
            $res = [];
            if($result){
                $res['success'] = "Donasi Berhasil Ditolak";
            } else {
                $res['success'] = "Donasi Gagal Ditolak";
            }
            echo json_encode($res);
        }

        public function view_distribusi(){

            $id_pj = $_POST['id_pj'];
            $database = "SELECT id_bencana, id_pj, nama_bencana, status, jumlah_donasi, DATE_FORMAT(tgl_kejadian, '%d-%m-%Y') AS tgl_kejadian, lokasi, deskripsi, jumlah_korban, kerugian, gambar1, gambar2, gambar3, nama, if(hitung_total(id_bencana) >= 0, 
            format(hitung_total(id_bencana), 0), 0) as total_donasi, DATE_FORMAT(deadline, '%d-%m-%Y') AS batas_akhir, if(sisa_hari(deadline) >= 0, sisa_hari(deadline), 0) as deadline, 
            DATE_FORMAT(tanggal_distribusi, '%d-%m-%Y') AS tanggal_distribusi, DATE_FORMAT(tgl_akhir_distribusi, '%d-%m-%Y') AS tgl_akhir_distribusi, lokasi_distribusi, konfirmasi, laporan
            FROM view_distribusi WHERE id_pj = $id_pj ORDER BY 1 DESC";
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