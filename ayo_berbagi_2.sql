-- phpMyAdmin SQL Dump
-- version 4.8.4
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 28, 2019 at 12:00 PM
-- Server version: 10.1.37-MariaDB
-- PHP Version: 7.3.0

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `ayo_berbagi_2`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `view_donasi` ()  BEGIN
    SELECT 
    	id_bencana,
        nama_bencana,
        nama,
        tgl_kejadian,
        lokasi,
        deadline
    FROM 
        bencana
        JOIN pj USING(id_pj);
END$$

--
-- Functions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `hitung_campaign` () RETURNS INT(11) BEGIN
	DECLARE total INT DEFAULT 0;
    SELECT COUNT(id_bencana) INTO total FROM bencana;
    RETURN(total);
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `hitung_donatur` () RETURNS INT(11) BEGIN
	DECLARE total INT DEFAULT 0;
    SELECT COUNT(id_donatur) INTO total FROM donatur;
    RETURN(total);
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `hitung_donaturpj` () RETURNS INT(11) NO SQL
    DETERMINISTIC
BEGIN
	DECLARE total INT DEFAULT 0;
    SELECT COUNT(id_donatur) INTO total FROM full_donasi GROUP BY 2;
    RETURN(total);
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `hitung_pj` () RETURNS INT(11) BEGIN
	DECLARE total INT DEFAULT 0;
    SELECT COUNT(id_pj) INTO total FROM pj;
    RETURN(total);
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `hitung_total` (`id` INT) RETURNS TEXT CHARSET latin1 BEGIN
	DECLARE total TEXT DEFAULT '';
    SELECT round(SUM(nominal), 0) INTO total FROM donasi WHERE id_bencana = id AND konfirmasi = 1;
    RETURN(total);
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `sisa_hari` (`dedline` DATE) RETURNS INT(11) BEGIN
    DECLARE hariini date;
    select CURRENT_DATE() into hariini;
    RETURN datediff(dedline, hariini);
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `total_diproses` (`id` INT) RETURNS INT(11) NO SQL
    DETERMINISTIC
BEGIN
	DECLARE total TEXT DEFAULT '';
    SELECT round(SUM(nominal), 0) INTO total FROM donasi WHERE id_bencana = id AND konfirmasi = 0;
    RETURN(total);
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `total_donasi` (`id` INT) RETURNS INT(11) NO SQL
    DETERMINISTIC
BEGIN
	DECLARE total TEXT DEFAULT '';
    SELECT round(SUM(nominal), 0) INTO total FROM donasi WHERE id_bencana = id;
    RETURN(total);
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `total_semua` () RETURNS TEXT CHARSET latin1 BEGIN
	DECLARE total TEXT DEFAULT '';
    SELECT round(SUM(nominal), 0) INTO total FROM donasi WHERE konfirmasi = 1;
    RETURN(total);
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `akun`
--

CREATE TABLE `akun` (
  `id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(50) NOT NULL,
  `akses` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `akun`
--

INSERT INTO `akun` (`id`, `username`, `password`, `akses`) VALUES
(18, 'admin', '21232f297a57a5a743894a0e4a801fc3', 'admin'),
(57, 'dida1234', 'c1f0d426e387438cf21f0d17ee55c233', 'user'),
(58, 'edikun', 'b37b2f094c7827dc7fb9090e3b8b4b16', 'pj'),
(59, 'zahid123', 'd32ec73eb8d6d4c5527287af5eb707d7', 'pj'),
(60, 'hafizh123', 'a00163e00203850e59ccbd5cb3ec7dee', 'pj'),
(61, 'ichad123', 'dbb56d421481c00e2028d126c0029a8e', 'pj'),
(62, 'ferdy123', '548aa782b9f0174edbeb8042d20cf6c1', 'pj'),
(63, 'arif123', 'd53d757c0f838ea49fb46e09cbcc3cb1', 'pj'),
(64, 'kelvin123', 'dc0026f5522b59bff313ecf34181ddc7', 'pj'),
(65, 'fadil123', '8d90d3b4702c9df2567603dfb1c26978', 'user'),
(66, 'shinta123', 'ccab7b13e0d94c700ba15234e5b68aa2', 'pj'),
(67, '1', '48b600b1bf23fbbb535e6a3dd17106de', 'pj'),
(68, 'rahmi123', '5f08aa0b709b40d938f57fcd7d25ead1', 'pj'),
(69, 'uti123', 'b50a803c3b0172ef360e3e1d6c59f329', 'pj'),
(70, 'aul123', '9d43863a1e1b460a4632f7c31420d6c3', 'pj'),
(71, 'aulia123', '9d43863a1e1b460a4632f7c31420d6c3', 'pj'),
(72, 'telyu', '6a20aacb2cd5d04e93bb466657ed8be3', 'user'),
(73, 'jono', '2213dbda8b7cb03bdfcdbf9045ffb315', 'user'),
(74, 'ferdi', '6547ad729f26699e3157f8847616e970', 'user'),
(75, 'haha99', '392d35b30a5c4adb99bf3d7e3cf029a0', 'user'),
(76, '', 'd41d8cd98f00b204e9800998ecf8427e', 'user'),
(77, 'miracleman', '8fca37b0b48a8d13d76d1e69102dd4cc', 'pj');

-- --------------------------------------------------------

--
-- Table structure for table `bencana`
--

CREATE TABLE `bencana` (
  `id_bencana` int(11) NOT NULL,
  `nama_bencana` text NOT NULL,
  `tgl_kejadian` date NOT NULL,
  `lokasi` varchar(15) NOT NULL,
  `tipe_bencana` varchar(30) NOT NULL,
  `deskripsi` longtext NOT NULL,
  `jumlah_korban` int(11) NOT NULL,
  `kerugian` int(11) NOT NULL,
  `deadline` date NOT NULL,
  `gambar` text NOT NULL,
  `gambar2` text NOT NULL,
  `gambar3` text NOT NULL,
  `saksi1` varchar(50) NOT NULL,
  `saksi2` varchar(50) NOT NULL,
  `id_pj` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `bencana`
--

INSERT INTO `bencana` (`id_bencana`, `nama_bencana`, `tgl_kejadian`, `lokasi`, `tipe_bencana`, `deskripsi`, `jumlah_korban`, `kerugian`, `deadline`, `gambar`, `gambar2`, `gambar3`, `saksi1`, `saksi2`, `id_pj`) VALUES
(18, 'Gempa Permukaan Mars', '2019-05-01', 'Mars', 'Tsunami', 'Ada gempa di permukaan Mars bagian barat', 10, 10000000, '2019-05-31', 'cloud9-csgo-wallpaper-12.jpg', '0dc5cb8af0606280483fcfa221b0ede260592e8d0378b52df521b0782685135962.jpg', '1_GsptKrTlU6dAUrj-7_A9iw4.jpeg', 'Irfan', 'Ilham', 11),
(19, 'Tsunami Tahunan Uranus', '2019-05-02', 'Uranus', 'Tsunami', 'Ada tsunami akibat es di barat daya Uranus', 20, 20000000, '2019-06-21', 'NIP-Walppapers-HD-CS-GO1.png', 'mossawi_220158176910_20180424185641_854916236446.png', 'Funny-3D-Background-Cool-Wallpapers-for-desktop-Background.jpg', 'Sumarni', 'Sumarno', 12),
(20, 'Banjir Bandang Gua Barat Neptunus', '2019-05-03', 'Neptunus', 'Banjir', 'Ada banjir bandang akibat alien buang sampah sembarangan di planet Uranus kecamatan Mantan kabupaten Manten', 8, 5200000, '2019-05-31', 'fnatic-Wallpaper.jpg', 'ff19c461649bf5f0bd330a42162f2b45.jpg', 'juggernauts_mask_mask_dota_2_logo_94172_1920x10801.jpg', 'Alien', 'Alan Walker', 13),
(21, 'Kebakaran Pohon Kehidupan Merkurius', '2019-05-01', 'Merkurius', 'Kebakaran', 'Ada kebakaran akibat mercon di Merkurius', 20, 200000000, '2019-07-04', 'mossawi_19770421087_20160329035700_2190314368343.png', '101603-clouds-dark_blue-stripes-abstract1.jpg', 'mossawi_106090440522_20180412182851_907634304071.jpg', 'Oajayakan', 'D doang R kagak', 14),
(22, 'Gempa Di Mana Mana', '2019-11-12', 'Dimana mana', 'Gempa Bumi', 'ada gempa dimana mana', 121, 10000000, '2019-12-25', 'IMG_20191122_082333.jpg', 'IMG_20191122_0823501.jpg', 'IMG_20191122_082433.jpg', 'Sumaras', 'Arigatou', 24);

--
-- Triggers `bencana`
--
DELIMITER $$
CREATE TRIGGER `update_pj` AFTER DELETE ON `bencana` FOR EACH ROW BEGIN	
    INSERT INTO history_bencana
    SET 
    id_bencana = OLD.id_bencana,
    nama_bencana = OLD.nama_bencana,	
    tgl_kejadian = OLD.tgl_kejadian,	
    lokasi = OLD.lokasi,	
    tipe_bencana = OLD.tipe_bencana,	
    deskripsi = OLD.deskripsi,	
    jumlah_korban = OLD.jumlah_korban,	
    kerugian = OLD.kerugian,	
    deadline = OLD.deadline,
    gambar = OLD.gambar,
    gambar2 = OLD.gambar2,
    gambar3 = OLD.gambar3,
    saksi1 = OLD.saksi1,
    saksi2 = OLD.saksi2,
    id_pj = OLD.id_pj;

    UPDATE pj SET status = 1 WHERE id_pj = OLD.id_pj;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Stand-in structure for view `confirm_donasi`
-- (See below for the actual view)
--
CREATE TABLE `confirm_donasi` (
`id_donasi` int(11)
,`id_bencana` int(11)
,`id_donatur` int(11)
,`nominal` varchar(20)
,`konfirmasi` int(1)
,`keterangan` varchar(15)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `dashboard_pj`
-- (See below for the actual view)
--
CREATE TABLE `dashboard_pj` (
`id_bencana` int(11)
,`id_pj` int(11)
,`nama_bencana` text
,`tgl_kejadian` varchar(72)
,`hitung_total` text
,`total_donasi` int(11)
,`total_diproses` int(11)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `data_donasi`
-- (See below for the actual view)
--
CREATE TABLE `data_donasi` (
`nama_bencana` text
,`lokasi` varchar(15)
,`total_donasi` varchar(63)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `detail_bencana`
-- (See below for the actual view)
--
CREATE TABLE `detail_bencana` (
`id_bencana` int(11)
,`id_pj` int(11)
,`nama_pj` varchar(50)
,`nama_bencana` text
,`tgl_kejadian` date
,`lokasi` varchar(15)
,`tipe_bencana` varchar(30)
,`deskripsi` longtext
,`jumlah_korban` int(11)
,`kerugian` int(11)
,`deadline` date
,`gambar` text
,`gambar2` text
,`gambar3` text
,`saksi1` varchar(50)
,`saksi2` varchar(50)
);

-- --------------------------------------------------------

--
-- Table structure for table `donasi`
--

CREATE TABLE `donasi` (
  `id_donasi` int(11) NOT NULL,
  `id_bencana` int(11) NOT NULL,
  `id_donatur` int(11) NOT NULL,
  `kategori` text NOT NULL,
  `jumlah` int(11) DEFAULT NULL,
  `foto` text,
  `nominal` varchar(20) DEFAULT NULL,
  `bukti` text,
  `konfirmasi` int(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `donasi`
--

INSERT INTO `donasi` (`id_donasi`, `id_bencana`, `id_donatur`, `kategori`, `jumlah`, `foto`, `nominal`, `bukti`, `konfirmasi`) VALUES
(11, 18, 33, 'Uang', NULL, NULL, '1000000', 'images1.png', 1),
(12, 19, 33, 'Uang', NULL, NULL, '4000000', 'mossawi_106090440522_20180412182851_9076343040712.jpg', 1),
(13, 18, 34, 'Uang', NULL, NULL, '10000000', '0dc5cb8af0606280483fcfa221b0ede260592e8d0378b52df521b0782685135964.jpg', 1),
(14, 18, 34, 'Uang', NULL, NULL, '3500000', '101603-clouds-dark_blue-stripes-abstract2.jpg', 1),
(15, 18, 33, 'Uang', NULL, NULL, '5000000', 'jadwal_semester_5.PNG', 0),
(16, 18, 33, 'Buku', 20, 'csgo-wallpapers-1920x1080-laptop-WTG30379131.jpg', NULL, NULL, 0),
(17, 19, 34, 'Uang', NULL, NULL, '2500000', 'hitman_absolution_game_hitman_47_bar_code_97619_1920x10802.jpg', 0),
(18, 19, 34, 'Uang', NULL, NULL, '100000', NULL, 0),
(19, 20, 34, 'Buku', 10, '101603-clouds-dark_blue-stripes-abstract9.jpg', NULL, NULL, 0),
(20, 18, 35, 'Pakaian', 100, 'cloud9-csgo-wallpaper-13.jpg', NULL, 'cs-go-wallpaper-csgo-wallpapers-728x3932.jpg', 1),
(21, 18, 33, 'Uang', NULL, NULL, '1500000', '896401.jpg', 1),
(22, 18, 33, 'Uang', NULL, NULL, '500000', ',,.png', 1),
(23, 18, 33, 'Uang', NULL, NULL, '80000', 'jadwal_semester_51.PNG', 1);

-- --------------------------------------------------------

--
-- Stand-in structure for view `donasi_proses`
-- (See below for the actual view)
--
CREATE TABLE `donasi_proses` (
`id_donasi` int(11)
,`id_donatur` int(11)
,`kategori` text
,`jumlah` int(11)
,`foto` text
,`id_pj` int(11)
,`nama_bencana` text
,`lokasi` varchar(15)
,`nama` varchar(50)
,`no_rek` varchar(50)
,`nominal` varchar(20)
,`bukti` text
,`konfirmasi` int(1)
,`keterangan` varchar(14)
);

-- --------------------------------------------------------

--
-- Table structure for table `donatur`
--

CREATE TABLE `donatur` (
  `id_donatur` int(11) NOT NULL,
  `no_ktp` varchar(15) NOT NULL,
  `nama` varchar(50) NOT NULL,
  `email` varchar(30) NOT NULL,
  `telp` varchar(15) NOT NULL,
  `tipedonatur` varchar(30) NOT NULL,
  `alamat` varchar(30) NOT NULL,
  `foto` text NOT NULL,
  `id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `donatur`
--

INSERT INTO `donatur` (`id_donatur`, `no_ktp`, `nama`, `email`, `telp`, `tipedonatur`, `alamat`, `foto`, `id`) VALUES
(33, '9959311601', 'Dida Pradana', 'dida123@gmail.com', '08999844199', 'Perorangan', 'Sleman', '90768-adventure-time-jake-smile5.gif', 57),
(34, '928321313197', 'Fadil Armando', 'fadil@gmail.com', '828382823382', 'Perorangan', 'Bengkulu', 'default_pp.jpg', 65),
(35, '331141231', 'Telyu', 'telyu@gmail.com', '123123123', 'Perorangan', 'Sukapura', '90768-adventure-time-jake-smile4.gif', 72),
(36, '', '', 'jono@gmail.com', '', '', '', '', 73),
(39, '08291', '', 'ferdi@gmail.com', '', '', '', '', 74),
(40, '64376', '', 'haha99@gmail.com', '', '', '', '', 75);

-- --------------------------------------------------------

--
-- Stand-in structure for view `full_donasi`
-- (See below for the actual view)
--
CREATE TABLE `full_donasi` (
`id_donasi` int(11)
,`id_donatur` int(11)
,`id_pj` int(11)
,`nama_bencana` text
,`lokasi` varchar(15)
,`nama_donatur` varchar(50)
,`telp` varchar(15)
,`kategori` text
,`jumlah` int(11)
,`foto` text
,`bukti` text
,`nama` varchar(50)
,`no_rek` varchar(50)
,`nominal` varchar(20)
,`konfirmasi` int(1)
,`keterangan` varchar(15)
);

-- --------------------------------------------------------

--
-- Table structure for table `history_bencana`
--

CREATE TABLE `history_bencana` (
  `id_history` int(11) NOT NULL,
  `id_bencana` int(11) DEFAULT NULL,
  `nama_bencana` varchar(50) DEFAULT NULL,
  `tgl_kejadian` date DEFAULT NULL,
  `lokasi` varchar(50) DEFAULT NULL,
  `tipe_bencana` varchar(50) DEFAULT NULL,
  `deskripsi` text,
  `jumlah_korban` int(11) DEFAULT NULL,
  `kerugian` int(11) DEFAULT NULL,
  `deadline` date DEFAULT NULL,
  `gambar` text,
  `gambar2` text,
  `gambar3` text,
  `saksi1` varchar(50) DEFAULT NULL,
  `saksi2` varchar(50) DEFAULT NULL,
  `id_pj` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `history_bencana`
--

INSERT INTO `history_bencana` (`id_history`, `id_bencana`, `nama_bencana`, `tgl_kejadian`, `lokasi`, `tipe_bencana`, `deskripsi`, `jumlah_korban`, `kerugian`, `deadline`, `gambar`, `gambar2`, `gambar3`, `saksi1`, `saksi2`, `id_pj`) VALUES
(4, 23, 'Gunung Hakuna Matata Meletus', '2019-05-01', 'Jupiter', 'Gunung Meletus', 'Gunung Hakuna Matata meletus dashyat di pagi buta', 123, 123000000, '2019-06-28', 'images.png', 'hitman_absolution_game_hitman_47_bar_code_97619_1920x1080.jpg', 'mossawi_106090440522_20180412182851_9076343040711.jpg', 'Widya', 'Hitman', 16),
(5, 24, 'Puting Beliung 200 km/jam Terjang Saturnus', '2019-05-03', 'Saturnus', 'Puting Beliung', 'Puting beliung berkekuatan 200 km/jam terjang pemukiman alien di barat daya kota Ame Ame, Saturnus', 441, 441000000, '2019-05-17', 'images1.jpg', 'pink-and-black-desktop-backgrounds-wallpaper-wiki.png', 'redline-1920x1080-wallpaper-1708300.jpg', 'Joni', 'Jono', 17),
(6, 22, 'Tanah Longsor Besar Venus', '2019-04-04', 'Venus', 'Tanah Longsor', 'Ada tanah longsor karena hutan tidak di reboisasi di Venus Tengah', 200, 1000000000, '2019-07-12', 'mossawi_938216104511_20170924212939_867160672550.jpg', '0dc5cb8af0606280483fcfa221b0ede260592e8d0378b52df521b0782685135963.jpg', 'cs-go-wallpaper-csgo-wallpapers-728x3931.jpg', 'Mamamia', 'Figaro', 15),
(7, 25, 'Banjir Bandang Gua Barat Neptunus', '2019-05-01', 'Neptunus', 'Banjir', 'ada banjir', 11, 11000000, '2019-05-30', '0dc5cb8af0606280483fcfa221b0ede260592e8d0378b52df521b0782685135972.jpg', '1_GsptKrTlU6dAUrj-7_A9iw11.jpeg', '896402.jpg', 'Sumarni', 'Ilham', 17);

-- --------------------------------------------------------

--
-- Stand-in structure for view `history_donasi`
-- (See below for the actual view)
--
CREATE TABLE `history_donasi` (
`id_donasi` int(11)
,`id_donatur` int(11)
,`kategori` text
,`jumlah` int(11)
,`foto` text
,`id_pj` int(11)
,`nama_bencana` text
,`lokasi` varchar(15)
,`nama` varchar(50)
,`no_rek` varchar(50)
,`nominal` varchar(20)
,`bukti` text
,`konfirmasi` int(1)
,`keterangan` varchar(15)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `konf_donasi`
-- (See below for the actual view)
--
CREATE TABLE `konf_donasi` (
`id_donasi` int(11)
,`id_pj` int(11)
,`id_bencana` int(11)
,`id_donatur` int(11)
,`nama_donatur` varchar(50)
,`telp` varchar(15)
,`nama_bencana` text
,`kategori` text
,`jumlah` int(11)
,`nominal` varchar(20)
,`foto` text
,`bukti` text
,`keterangan` varchar(14)
);

-- --------------------------------------------------------

--
-- Table structure for table `laporan`
--

CREATE TABLE `laporan` (
  `id_laporan` int(11) NOT NULL,
  `id_bencana` int(11) NOT NULL,
  `id_pj` int(11) NOT NULL,
  `nama_bencana` varchar(50) NOT NULL,
  `total_donasi` int(15) NOT NULL,
  `laporan` text NOT NULL,
  `gambar1` text NOT NULL,
  `gambar2` text NOT NULL,
  `gambar3` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `pj`
--

CREATE TABLE `pj` (
  `id_pj` int(11) NOT NULL,
  `nama` varchar(50) NOT NULL,
  `no_identitas` varchar(15) NOT NULL,
  `telp` varchar(15) NOT NULL,
  `alamat` varchar(30) NOT NULL,
  `no_rek` varchar(50) NOT NULL,
  `foto` text NOT NULL,
  `id` int(11) NOT NULL,
  `status` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `pj`
--

INSERT INTO `pj` (`id_pj`, `nama`, `no_identitas`, `telp`, `alamat`, `no_rek`, `foto`, `id`, `status`) VALUES
(11, 'Agung Edi Kuncoro', '2147483647', '081999593116', 'Kediri', '9911002299', 'd597c461c5f7fdc6afd0782cb08c80532.jpg', 58, 0),
(12, 'Zahid Mustofainal Akhyar', '1234123499', '08199001199', 'Adiyaksa', '9090121290', 'juggernauts_mask_mask_dota_2_logo_94172_1920x1080.jpg', 59, 0),
(13, 'Hafizh \'Azizi Nasution', '6767858590', '889988998812', 'Padang', '1029384756', 'Download-AK-Vulcan-Counter-Strike-Global-Offensive-Weapon-Skin-1920x-wallpaper-wp44042821.jpg', 60, 0),
(14, 'M Irsyad Fadhil', '9080706050', '808012128090', 'Majalaya', '1290349056', 'Screenshot_(31).png', 61, 0),
(15, 'Ferdy Pittardi Susanto', '7878907878', '8080707060', 'Tangsel', '0101293848', '1_GsptKrTlU6dAUrj-7_A9iw3.jpeg', 62, 1),
(16, 'Arif Firdaus Nasapola', '998887766232', '093131313131', 'Tarakan', '9283845839', 'firewatch_2016_game1.jpg', 63, 1),
(17, 'Kelvin Yulinda Febianto', '9029022201', '902902902902', 'Cianjur', '9928921023', 'mossawi_543859784025_20170410164228_620587368961.png', 64, 1),
(18, 'Shinta Pramuwidya', '1029381723', '887788778877', 'Semarang', '8127348192', 'irene1.jpg', 66, 1),
(20, 'Rahmi Agustina', '8183918290', '9984412312', 'Tasikmalaya', '9912839201', '42.gif', 68, 1),
(21, 'Tri Agustina Putri', '9201839201', '99002299120', 'Lampung', '9281038491', 'CarelessLimpingFoxhound-size_restricted1.gif', 69, 1),
(23, 'Aulia Hasna', '12312314512', '8877887723', 'Ciparay', '1210711298', '43.gif', 71, 1),
(24, 'Miracle', '330517148821311', '08999222121', 'Kediri', '887291', 'IMG_20191122_082350.jpg', 77, 0);

-- --------------------------------------------------------

--
-- Stand-in structure for view `view_bencana`
-- (See below for the actual view)
--
CREATE TABLE `view_bencana` (
`id_bencana` int(11)
,`nama_bencana` text
,`gambar` text
,`nama` varchar(50)
,`deadline` date
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `view_grafik`
-- (See below for the actual view)
--
CREATE TABLE `view_grafik` (
`id_bencana` int(11)
,`tipe_bencana` varchar(30)
,`total_donasi` double
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `view_laporan`
-- (See below for the actual view)
--
CREATE TABLE `view_laporan` (
`id_laporan` int(11)
,`id_pj` int(11)
,`nama_bencana` text
,`total_donasi` int(15)
,`nama_pj` varchar(50)
,`laporan` text
,`gambar1` text
,`gambar2` text
,`gambar3` text
);

-- --------------------------------------------------------

--
-- Structure for view `confirm_donasi`
--
DROP TABLE IF EXISTS `confirm_donasi`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `confirm_donasi`  AS  select `donasi`.`id_donasi` AS `id_donasi`,`donasi`.`id_bencana` AS `id_bencana`,`donasi`.`id_donatur` AS `id_donatur`,`donasi`.`nominal` AS `nominal`,`donasi`.`konfirmasi` AS `konfirmasi`,(case when (`donasi`.`konfirmasi` = 0) then 'Sedang diproses' else 'Telah diterima' end) AS `keterangan` from `donasi` where (`donasi`.`konfirmasi` = 0) ;

-- --------------------------------------------------------

--
-- Structure for view `dashboard_pj`
--
DROP TABLE IF EXISTS `dashboard_pj`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `dashboard_pj`  AS  select `bencana`.`id_bencana` AS `id_bencana`,`pj`.`id_pj` AS `id_pj`,`bencana`.`nama_bencana` AS `nama_bencana`,date_format(`bencana`.`tgl_kejadian`,'%d %M %Y') AS `tgl_kejadian`,`hitung_total`(`donasi`.`id_bencana`) AS `hitung_total`,`total_donasi`(`donasi`.`id_bencana`) AS `total_donasi`,`total_diproses`(`donasi`.`id_bencana`) AS `total_diproses` from ((`donasi` join `bencana` on((`donasi`.`id_bencana` = `bencana`.`id_bencana`))) join `pj` on((`bencana`.`id_pj` = `pj`.`id_pj`))) group by 1 ;

-- --------------------------------------------------------

--
-- Structure for view `data_donasi`
--
DROP TABLE IF EXISTS `data_donasi`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `data_donasi`  AS  select `bencana`.`nama_bencana` AS `nama_bencana`,`bencana`.`lokasi` AS `lokasi`,format(sum(`donasi`.`nominal`),2) AS `total_donasi` from (`bencana` join `donasi` on((`bencana`.`id_bencana` = `donasi`.`id_bencana`))) group by 1,2 ;

-- --------------------------------------------------------

--
-- Structure for view `detail_bencana`
--
DROP TABLE IF EXISTS `detail_bencana`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `detail_bencana`  AS  select `bencana`.`id_bencana` AS `id_bencana`,`bencana`.`id_pj` AS `id_pj`,`pj`.`nama` AS `nama_pj`,`bencana`.`nama_bencana` AS `nama_bencana`,`bencana`.`tgl_kejadian` AS `tgl_kejadian`,`bencana`.`lokasi` AS `lokasi`,`bencana`.`tipe_bencana` AS `tipe_bencana`,`bencana`.`deskripsi` AS `deskripsi`,`bencana`.`jumlah_korban` AS `jumlah_korban`,`bencana`.`kerugian` AS `kerugian`,`bencana`.`deadline` AS `deadline`,`bencana`.`gambar` AS `gambar`,`bencana`.`gambar2` AS `gambar2`,`bencana`.`gambar3` AS `gambar3`,`bencana`.`saksi1` AS `saksi1`,`bencana`.`saksi2` AS `saksi2` from (`bencana` join `pj` on((`bencana`.`id_pj` = `pj`.`id_pj`))) ;

-- --------------------------------------------------------

--
-- Structure for view `donasi_proses`
--
DROP TABLE IF EXISTS `donasi_proses`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `donasi_proses`  AS  select `donasi`.`id_donasi` AS `id_donasi`,`donasi`.`id_donatur` AS `id_donatur`,`donasi`.`kategori` AS `kategori`,`donasi`.`jumlah` AS `jumlah`,`donasi`.`foto` AS `foto`,`pj`.`id_pj` AS `id_pj`,`bencana`.`nama_bencana` AS `nama_bencana`,`bencana`.`lokasi` AS `lokasi`,`pj`.`nama` AS `nama`,`pj`.`no_rek` AS `no_rek`,`donasi`.`nominal` AS `nominal`,`donasi`.`bukti` AS `bukti`,`donasi`.`konfirmasi` AS `konfirmasi`,(case when ((`donasi`.`konfirmasi` = 0) and (`donasi`.`bukti` is not null)) then 'Sudah Upload' when ((`donasi`.`konfirmasi` = 0) and isnull(`donasi`.`bukti`)) then 'Belum Upload' else 'Telah diterima' end) AS `keterangan` from (((`donasi` join `donatur` on((`donasi`.`id_donatur` = `donatur`.`id_donatur`))) join `bencana` on((`donasi`.`id_bencana` = `bencana`.`id_bencana`))) join `pj` on((`bencana`.`id_pj` = `pj`.`id_pj`))) where (`donasi`.`konfirmasi` = 0) ;

-- --------------------------------------------------------

--
-- Structure for view `full_donasi`
--
DROP TABLE IF EXISTS `full_donasi`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `full_donasi`  AS  select `donasi`.`id_donasi` AS `id_donasi`,`donasi`.`id_donatur` AS `id_donatur`,`pj`.`id_pj` AS `id_pj`,`bencana`.`nama_bencana` AS `nama_bencana`,`bencana`.`lokasi` AS `lokasi`,`donatur`.`nama` AS `nama_donatur`,`donatur`.`telp` AS `telp`,`donasi`.`kategori` AS `kategori`,`donasi`.`jumlah` AS `jumlah`,`donasi`.`foto` AS `foto`,`donasi`.`bukti` AS `bukti`,`pj`.`nama` AS `nama`,`pj`.`no_rek` AS `no_rek`,`donasi`.`nominal` AS `nominal`,`donasi`.`konfirmasi` AS `konfirmasi`,(case when (`donasi`.`konfirmasi` = 0) then 'Sedang diproses' else 'Telah diterima' end) AS `keterangan` from (((`donasi` join `donatur` on((`donasi`.`id_donatur` = `donatur`.`id_donatur`))) join `bencana` on((`donasi`.`id_bencana` = `bencana`.`id_bencana`))) join `pj` on((`bencana`.`id_pj` = `pj`.`id_pj`))) where (`donasi`.`konfirmasi` = 1) ;

-- --------------------------------------------------------

--
-- Structure for view `history_donasi`
--
DROP TABLE IF EXISTS `history_donasi`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `history_donasi`  AS  select `donasi`.`id_donasi` AS `id_donasi`,`donasi`.`id_donatur` AS `id_donatur`,`donasi`.`kategori` AS `kategori`,`donasi`.`jumlah` AS `jumlah`,`donasi`.`foto` AS `foto`,`pj`.`id_pj` AS `id_pj`,`bencana`.`nama_bencana` AS `nama_bencana`,`bencana`.`lokasi` AS `lokasi`,`pj`.`nama` AS `nama`,`pj`.`no_rek` AS `no_rek`,`donasi`.`nominal` AS `nominal`,`donasi`.`bukti` AS `bukti`,`donasi`.`konfirmasi` AS `konfirmasi`,(case when ((`donasi`.`konfirmasi` = 0) and (`donasi`.`bukti` is not null)) then 'Sedang diproses' when ((`donasi`.`konfirmasi` = 0) and isnull(`donasi`.`bukti`)) then 'Belum Upload' else 'Telah diterima' end) AS `keterangan` from (((`donasi` join `donatur` on((`donasi`.`id_donatur` = `donatur`.`id_donatur`))) join `bencana` on((`donasi`.`id_bencana` = `bencana`.`id_bencana`))) join `pj` on((`bencana`.`id_pj` = `pj`.`id_pj`))) where (`donasi`.`konfirmasi` = 1) ;

-- --------------------------------------------------------

--
-- Structure for view `konf_donasi`
--
DROP TABLE IF EXISTS `konf_donasi`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `konf_donasi`  AS  select `donasi`.`id_donasi` AS `id_donasi`,`pj`.`id_pj` AS `id_pj`,`bencana`.`id_bencana` AS `id_bencana`,`donatur`.`id_donatur` AS `id_donatur`,`donatur`.`nama` AS `nama_donatur`,`donatur`.`telp` AS `telp`,`bencana`.`nama_bencana` AS `nama_bencana`,`donasi`.`kategori` AS `kategori`,`donasi`.`jumlah` AS `jumlah`,`donasi`.`nominal` AS `nominal`,`donasi`.`foto` AS `foto`,`donasi`.`bukti` AS `bukti`,`donasi_proses`.`keterangan` AS `keterangan` from ((((`donasi_proses` join `donasi` on((`donasi_proses`.`id_donasi` = `donasi`.`id_donasi`))) join `donatur` on((`donatur`.`id_donatur` = `donasi`.`id_donatur`))) join `bencana` on((`donasi`.`id_bencana` = `bencana`.`id_bencana`))) join `pj` on((`bencana`.`id_pj` = `pj`.`id_pj`))) ;

-- --------------------------------------------------------

--
-- Structure for view `view_bencana`
--
DROP TABLE IF EXISTS `view_bencana`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `view_bencana`  AS  select `bencana`.`id_bencana` AS `id_bencana`,`bencana`.`nama_bencana` AS `nama_bencana`,`bencana`.`gambar` AS `gambar`,`pj`.`nama` AS `nama`,`bencana`.`deadline` AS `deadline` from ((`bencana` left join `donasi` on((`bencana`.`id_bencana` = `donasi`.`id_bencana`))) join `pj` on((`bencana`.`id_pj` = `pj`.`id_pj`))) group by 1 ;

-- --------------------------------------------------------

--
-- Structure for view `view_grafik`
--
DROP TABLE IF EXISTS `view_grafik`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `view_grafik`  AS  select `bencana`.`id_bencana` AS `id_bencana`,`bencana`.`tipe_bencana` AS `tipe_bencana`,sum(`donasi`.`nominal`) AS `total_donasi` from (`bencana` left join `donasi` on((`bencana`.`id_bencana` = `donasi`.`id_bencana`))) where (`donasi`.`konfirmasi` = 1) group by 1,2 ;

-- --------------------------------------------------------

--
-- Structure for view `view_laporan`
--
DROP TABLE IF EXISTS `view_laporan`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `view_laporan`  AS  select `laporan`.`id_laporan` AS `id_laporan`,`pj`.`id_pj` AS `id_pj`,`bencana`.`nama_bencana` AS `nama_bencana`,`laporan`.`total_donasi` AS `total_donasi`,`pj`.`nama` AS `nama_pj`,`laporan`.`laporan` AS `laporan`,`laporan`.`gambar1` AS `gambar1`,`laporan`.`gambar2` AS `gambar2`,`laporan`.`gambar3` AS `gambar3` from ((`laporan` join `bencana` on((`bencana`.`id_bencana` = `laporan`.`id_bencana`))) join `pj` on((`laporan`.`id_pj` = `pj`.`id_pj`))) ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `akun`
--
ALTER TABLE `akun`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- Indexes for table `bencana`
--
ALTER TABLE `bencana`
  ADD PRIMARY KEY (`id_bencana`),
  ADD KEY `id_perantara` (`id_pj`);

--
-- Indexes for table `donasi`
--
ALTER TABLE `donasi`
  ADD PRIMARY KEY (`id_donasi`),
  ADD KEY `id_bencana` (`id_bencana`),
  ADD KEY `id_donatur` (`id_donatur`);

--
-- Indexes for table `donatur`
--
ALTER TABLE `donatur`
  ADD PRIMARY KEY (`id_donatur`),
  ADD UNIQUE KEY `no_ktp` (`no_ktp`),
  ADD KEY `id` (`id`);

--
-- Indexes for table `history_bencana`
--
ALTER TABLE `history_bencana`
  ADD PRIMARY KEY (`id_history`),
  ADD KEY `id_pj` (`id_pj`),
  ADD KEY `id_bencana_2` (`id_bencana`);

--
-- Indexes for table `laporan`
--
ALTER TABLE `laporan`
  ADD PRIMARY KEY (`id_laporan`),
  ADD KEY `id_donasi` (`id_bencana`),
  ADD KEY `id_pj` (`id_pj`);

--
-- Indexes for table `pj`
--
ALTER TABLE `pj`
  ADD PRIMARY KEY (`id_pj`),
  ADD KEY `id` (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `akun`
--
ALTER TABLE `akun`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=78;

--
-- AUTO_INCREMENT for table `bencana`
--
ALTER TABLE `bencana`
  MODIFY `id_bencana` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT for table `donasi`
--
ALTER TABLE `donasi`
  MODIFY `id_donasi` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- AUTO_INCREMENT for table `donatur`
--
ALTER TABLE `donatur`
  MODIFY `id_donatur` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=41;

--
-- AUTO_INCREMENT for table `history_bencana`
--
ALTER TABLE `history_bencana`
  MODIFY `id_history` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `laporan`
--
ALTER TABLE `laporan`
  MODIFY `id_laporan` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `pj`
--
ALTER TABLE `pj`
  MODIFY `id_pj` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `bencana`
--
ALTER TABLE `bencana`
  ADD CONSTRAINT `bencana_ibfk_1` FOREIGN KEY (`id_pj`) REFERENCES `pj` (`id_pj`);

--
-- Constraints for table `donasi`
--
ALTER TABLE `donasi`
  ADD CONSTRAINT `donasi_ibfk_1` FOREIGN KEY (`id_donatur`) REFERENCES `donatur` (`id_donatur`),
  ADD CONSTRAINT `donasi_ibfk_2` FOREIGN KEY (`id_bencana`) REFERENCES `bencana` (`id_bencana`);

--
-- Constraints for table `donatur`
--
ALTER TABLE `donatur`
  ADD CONSTRAINT `donatur_ibfk_1` FOREIGN KEY (`id`) REFERENCES `akun` (`id`);

--
-- Constraints for table `history_bencana`
--
ALTER TABLE `history_bencana`
  ADD CONSTRAINT `history_bencana_ibfk_2` FOREIGN KEY (`id_pj`) REFERENCES `pj` (`id_pj`);

--
-- Constraints for table `laporan`
--
ALTER TABLE `laporan`
  ADD CONSTRAINT `laporan_ibfk_1` FOREIGN KEY (`id_bencana`) REFERENCES `bencana` (`id_bencana`),
  ADD CONSTRAINT `laporan_ibfk_2` FOREIGN KEY (`id_pj`) REFERENCES `pj` (`id_pj`);

--
-- Constraints for table `pj`
--
ALTER TABLE `pj`
  ADD CONSTRAINT `pj_ibfk_1` FOREIGN KEY (`id`) REFERENCES `akun` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
