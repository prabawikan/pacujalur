import processing.sound.*;

SoundFile scene1Audio;
SoundFile scene2Audio;
SoundFile scene3Audio;
SoundFile scene4Audio;
SoundFile scene5Audio;
SoundFile scene6Audio;

SoundFile scene2AudioPercakapan;
SoundFile scene4AudioPercakapan;
SoundFile scene5AudioPercakapan;
SoundFile scene6AudioPercakapan;

float soundVolume = 0.1;

boolean scene2AudioPlayed = false; // Tambahkan flag untuk scene2
boolean scene6AudioPlayed = false; // Tambahkan flag untuk scene2

  
  int canvasWidth = 1500;
  int canvasHeight = 800;
  float[] boatX = {150, 150, 150};
  float[] boatY = {450, 570, 690};
  float[] boatSpeeds = {0.5, 1, 0.75}; // Kecepatan masing-masing kapal berbeda
  float[] paddleAngles = {0, 0, 0};
  float paddleSpeed = 0.05;
  color[] shirtColors = {color(0, 0, 255), color(0, 255, 0), color(255, 0, 0)};
  boolean isMoving = true; // Perahu bergerak terus menerus sejak awal
  int sceneTransitionTime = 15000; // waktu untuk scene2
  boolean scene2Started = false; // Flag untuk mengecek apakah scene2 sudah dimulai
  int sceneStartTime; // Waktu mulai scene
  //int currentScene = 5;
  int currentScene = 5;
  boolean[] boatCrashed = {false, false, false}; // Flag untuk kapal yang menabrak batu
  float[] flipAngles = {0, 0, 0}; // Sudut rotasi untuk animasi terbalik
  boolean[] isFlipping = {false, false, false}; // Flag untuk memulai animasi terbalik
  int[] flipStartTime = {0, 0, 0}; // Waktu mulai animasi terbalik
  
  
  
  
  
  
  
  float[] groupPersonX; // Array untuk menyimpan posisi X setiap orang dalam kelompok
float[] groupPersonY; // Array untuk menyimpan posisi Y setiap orang dalam kelompok
boolean[] reachedTarget; // Array untuk menyimpan status apakah sudah mencapai tujuan atau belum
float[] legAngle; // Array untuk menyimpan sudut kaki setiap orang dalam kelompok
boolean[] legForward; // Array untuk menyimpan status apakah kaki bergerak maju atau mundur

float singlePersonX; // Posisi X orang yang menghampiri
float singlePersonY; // Posisi Y orang yang menghampiri
boolean singlePersonReachedTarget; // Status apakah orang yang menghampiri sudah mencapai tujuan
float singlePersonLegAngle; // Sudut kaki orang yang menghampiri
boolean singlePersonLegForward; // Status apakah kaki orang yang menghampiri bergerak maju atau mundur
  
  

  
  void setup() {
    size(1500, 800);
    background(255);
      startTime = millis();
  lastWalkAnimationTime = millis();

  float groupStartX = 500; // Memulai posisi X untuk kelompok
  float spacing = 140; // Jarak antar orang dalam kelompok
  int numPeople = 4;

  groupPersonX = new float[numPeople];
  groupPersonY = new float[numPeople];
  shirtColors = new color[numPeople];
  reachedTarget = new boolean[numPeople];
  legAngle = new float[numPeople];
  legForward = new boolean[numPeople];

  for (int i = 0; i < numPeople; i++) {
    groupPersonX[i] = groupStartX + i * spacing; // Posisi X setiap orang dalam kelompok
    groupPersonY[i] = canvasHeight - 150; // Posisi Y setiap orang dalam kelompok

    reachedTarget[i] = true; // Orang dalam kelompok sudah berada di posisi tujuan
    legAngle[i] = 0;
    legForward[i] = true;
  }

  singlePersonX = -100; // Memulai di luar kanvas untuk animasi masuk
  singlePersonY = canvasHeight - 150; // Posisi Y orang yang menghampiri
  singlePersonReachedTarget = false;
  singlePersonLegAngle = 0;
  singlePersonLegForward = true;
  
  scene1Audio = new SoundFile(this, "balapan.mp3");
  //scene2Audio = new SoundFile(this, "scene2.mp3");
  scene3Audio = new SoundFile(this, "balapan.mp3");
  scene4Audio = new SoundFile(this, "persiapan_kapal.mp3");
  //scene5Audio = new SoundFile(this, "scene5.mp3");
  //scene6Audio = new SoundFile(this, "scene6.mp3");
  
  scene5AudioPercakapan = new SoundFile(this, "scene_ngajak_temen.wav");
  scene4AudioPercakapan = new SoundFile(this, "ngobrol_persiapan_kapal.wav");
  scene2AudioPercakapan = new SoundFile(this, "sombong.wav");
  scene6AudioPercakapan = new SoundFile(this, "juara.wav");
  
  
  }
  
  void draw() {
    if (currentScene == 1) {
      scene4();
    } else if (currentScene == 2) {
      scene1();
    } else if (currentScene == 3) {
      scene2();
    } else if (currentScene == 4) {
      scene3();
    } else if (currentScene == 5) {
      scene5(); // mengajak teman untuk mengikuti lomba
    } else if (currentScene == 6) {
      scene6();
    }
  }
  


 void scene1() {
    background(135, 206, 250); // Warna langit biru muda
    drawBackground();
      // Mainkan suara scene1 jika belum dimainkan
  if (!scene1Audio.isPlaying()) {
    scene1Audio.loop();
  }
    scene3Audio.stop();
    scene4Audio.stop();

 

     
  
    boolean allBoatsOffScreen = true;
    color[] shirtColors = {color(0, 0, 255), color(0, 255, 0), color(255, 0, 0)};
    for (int i = 0; i < 3; i++) {
      drawPeopleInBoat(boatX[i], boatY[i], shirtColors[i]); // Gambar orang-orang di dalam perahu dengan warna baju berbeda
      drawBoat(boatX[i], boatY[i], paddleAngles[i]); // Gambar perahu di atas orang-orang dengan skala normal
      if (isMoving) {
        boatX[i] += boatSpeeds[i]; // Gunakan kecepatan khusus untuk masing-masing kapal
        if (boatX[i] <= width) {
          allBoatsOffScreen = false; // Jika ada kapal yang belum keluar layar, set flag menjadi false
        }
      }
    }
  
    // Update sudut dayung untuk animasi mendayung yang lebih natural
    for (int i = 0; i < 3; i++) {
      paddleAngles[i] = sin(frameCount * paddleSpeed) * HALF_PI + HALF_PI;
    }
  
    // Jika semua kapal sudah keluar layar, pindah ke scene2
    if (allBoatsOffScreen) {
      isMoving = false;
      currentScene = 3;
      sceneStartTime = millis(); // Catat waktu mulai scene2
    }

 
  }
  
  void scene2() {
    background(135, 206, 250); // Warna langit biru muda
  if (scene1Audio.isPlaying()) {
    scene1Audio.stop();
  }

  if (!scene2AudioPlayed) {
    scene2AudioPercakapan.play();
    scene2AudioPlayed = true;
  }
  
  drawBackground();
  
    // Gambar ulang kapal kedua dengan ukuran yang diperbesar menggunakan scale
    pushMatrix();
    translate(width / 2, height / 2);
    scale(3); // Perbesar 3 kali
    translate(-boatX[1], -boatY[1]);
    color shirtColors = color(0,255,0);
    drawPeopleInBoat(boatX[1], boatY[1], shirtColors);
    drawBoat(boatX[1], boatY[1], paddleAngles[1]);
    popMatrix();
  
    // Update sudut dayung untuk animasi mendayung yang lebih natural
    paddleAngles[1] = sin(frameCount * paddleSpeed) * HALF_PI + HALF_PI;
  
    // Periksa apakah sudah 5 detik berlalu sejak mulai scene2
    if (millis() - sceneStartTime > sceneTransitionTime) {
      currentScene = 4; // Pindah ke scene3 setelah 5 detik
      resetBoatPositions(); // Reset posisi perahu untuk scene3
    }
  }
  
void scene3() { // ini scene3
  background(135, 206, 250); // Warna langit biru muda
  drawBackground();
    if (!scene3Audio.isPlaying()) {
    scene3Audio.loop();
  }
  scene1Audio.stop();
  scene4Audio.stop();

  // Gambar batu di tengah laut
  drawRock(width / 2 - 300, canvasHeight / 2 + 200);

  // Update posisi kapal dan gambar ulang
  for (int i = 0; i < 3; i++) {
    // Deteksi tabrakan untuk kapal dengan kecepatan tertinggi
    if (i == 0 && !boatCrashed[i] && boatX[i] + 140 * 3 >= width / 2 - 50 && boatX[i] <= width / 2 + 50) {
      boatCrashed[i] = true;
      boatSpeeds[i] = 0; // Hentikan kapal yang menabrak
      isFlipping[i] = true;
      flipStartTime[i] = millis();
    }

    if (boatCrashed[i]) {
      // Animasi kapal terbalik
      if (isFlipping[i]) {
        int elapsedTime = millis() - flipStartTime[i];
        flipAngles[i] = map(elapsedTime, 0, 1000, 0, PI); // 1000 ms untuk rotasi penuh
        if (elapsedTime >= 1000) {
          isFlipping[i] = false; // Selesai animasi setelah 1 detik
        }
      }
      drawFlippingBoat(boatX[i], boatY[i], flipAngles[i]);
    } else {
      drawPeopleInBoat(boatX[i], boatY[i], shirtColors[i]);
      drawBoat(boatX[i], boatY[i], paddleAngles[i]);
      boatX[i] += boatSpeeds[i]; // Kapal bergerak ke kanan
    }

    // Periksa apakah kapal biru sudah sampai di ujung layar
    if (i == 2 && boatX[i] >= width) {
      currentScene = 6; // Pindah ke scene6
      sceneStartTime = millis(); // Catat waktu mulai scene6
    }
  }

  // Update sudut dayung untuk animasi mendayung yang lebih natural
  for (int i = 0; i < 3; i++) {
    if (!boatCrashed[i]) {
      paddleAngles[i] = sin(frameCount * paddleSpeed) * HALF_PI + HALF_PI;
    }
  }
}
  
  
float person1X6 = -100; // Orang peringkat 2
float person1Y = canvasHeight / 2 + 60;
float person2X6 = canvasWidth + 100; // Orang peringkat 1
float person2Y = canvasHeight / 2 + 60;
float person3X = canvasWidth + 100; // Orang peringkat 3
float person3Y = canvasHeight / 2 + 60;

// Kecepatan gerak peserta
float speed = 1.5;
float moveUpSpeed = 1.0; // Kecepatan naik ke podium lebih lambat

// Status animasi
boolean person1Done = false;
boolean person2And3Active = false;
boolean person2OnPodium = false;

void scene6() { // ini scene6
  background(135, 206, 235); // Langit cerah
  if (!scene6AudioPlayed) {
    scene6AudioPercakapan.play();
    scene6AudioPlayed = true;
  }

scene1Audio.stop();
scene3Audio.stop();
scene4Audio.stop();

  // Lapangan
  fill(34, 139, 34); // Warna hijau untuk lapangan
  rect(0, canvasHeight / 2 + 150, canvasWidth, canvasHeight / 2 - 150); // Lapangan hijau mengikuti posisi podium

  // Awan
  drawCloud6(300, 100);
  drawCloud6(600, 150);
  drawCloud6(1000, 120);

  int podiumCenterX = canvasWidth / 2; // Titik tengah canvas untuk pusat podium

  // Podium
  fill(192, 192, 192); // Warna perak untuk posisi kedua
  rect(podiumCenterX - 150, canvasHeight / 2 + 150, 100, 100); // Podium kiri
  
  fill(255, 215, 0); // Warna emas untuk posisi pertama
  rect(podiumCenterX - 50, canvasHeight / 2 + 50, 100, 200); // Podium tengah (lebih tinggi)
  
  fill(205, 127, 50); // Warna perunggu untuk posisi ketiga
  rect(podiumCenterX + 50, canvasHeight / 2 + 150, 100, 100); // Podium kanan

  // Angka pada podium
  textSize(32);
  fill(0);
  text("2", podiumCenterX - 110, canvasHeight / 2 + 220); // Angka 2 di podium kiri
  text("1", podiumCenterX - 10, canvasHeight / 2 + 130); // Angka 1 di podium tengah
  text("3", podiumCenterX + 90, canvasHeight / 2 + 220); // Angka 3 di podium kanan

  // Gerakkan peserta
  moveParticipants6();
}

void drawMinecraftPerson6(float x, float y, color personColor) {
  // Kepala
  fill(255, 224, 189);
  rect(x - 30, y - 90, 60, 60); // Membesar kepala

  // Rambut
  fill(0); // Warna hitam untuk rambut
  beginShape();
  vertex(x - 30, y - 90);
  vertex(x - 30, y - 110);
  vertex(x - 25, y - 120);
  vertex(x - 20, y - 110);
  vertex(x - 10, y - 120);
  vertex(x, y - 110);
  vertex(x + 10, y - 120);
  vertex(x + 20, y - 110);
  vertex(x + 25, y - 120);
  vertex(x + 30, y - 110);
  vertex(x + 30, y - 90);
  endShape(CLOSE);

  // Mata
  fill(255);
  rect(x - 15, y - 75, 12, 12); // Mata kiri putih
  rect(x + 3, y - 75, 12, 12); // Mata kanan putih
  fill(0);
  rect(x - 12, y - 72, 6, 6); // Mata kiri hitam
  rect(x + 6, y - 72, 6, 6); // Mata kanan hitam

  // Hidung
  fill(255, 224, 189);
  rect(x - 4, y - 62, 8, 8);

  // Mulut
  fill(150, 75, 0); // Warna coklat gelap untuk mulut
  rect(x - 12, y - 50, 24, 6);
  
  // Tubuh
  fill(personColor); // Warna untuk tubuh
  rect(x - 25, y - 30, 50, 70); // Membesar tubuh

  // Tangan (tidak bergerak)
  fill(255, 224, 189); // Warna kulit untuk tangan
  rect(x - 50, y - 30, 30, 60); // Kiri
  rect(x + 20, y - 30, 30, 60); // Kanan

  // Baju pada tangan
  fill(personColor); // Warna untuk baju pada tangan
  rect(x - 50, y - 30, 30, 30); // Kiri
  rect(x + 20, y - 30, 30, 30); // Kanan

  // Kaki
  fill(0, 128, 0); // Warna hijau untuk kaki
  rect(x - 25, y + 40, 20, 50); // Kiri
  rect(x + 5, y + 40, 20, 50); // Kanan
}


void drawCloud6(float x, float y) {
  fill(255);
  noStroke();
  ellipse(x, y, 60, 60);
  ellipse(x + 30, y - 10, 80, 80);
  ellipse(x + 60, y, 60, 60);
  ellipse(x + 30, y + 10, 60, 60);
}

void moveParticipants6() {
  int podiumCenterX = canvasWidth / 2;

  // Gerakkan orang peringkat 1 dari kanan ke podium tengah
  if (person2X6 > podiumCenterX ) {
    person2X6 -= speed;
  } else if (person2Y > canvasHeight / 2 - 40) {
    // Jika sudah di atas podium tengah, mulai gerakkan orang peringkat 1 ke atas podium
    person2Y -= moveUpSpeed;
    if (person2Y <= canvasHeight / 2 - 40) {
      person2Y = canvasHeight / 2 - 40; // Pastikan posisi y tetap di atas podium
      person2OnPodium = true;
    }
  } else if (person2OnPodium) {
    // Setelah orang peringkat 1 berada di podium, aktifkan gerakan orang peringkat 2 dan 3
    person2And3Active = true;
  }

  // Gerakkan orang peringkat 2 dari kiri ke podium kiri
  if (person1X6 < canvasWidth / 2 - 100 && person2And3Active) {
    person1X6 += speed;
  }

  // Gerakkan orang peringkat 3 dari kanan ke podium kanan
  if (person3X > canvasWidth / 2 + 100 && person2And3Active) {
    person3X -= speed;
  }

  // Gambar orang dengan posisi baru
 drawMinecraftPerson6(person1X6, person1Y, color(0, 0, 255)); // Orang peringkat 2 dengan warna biru
  drawMinecraftPerson6(person2X6, person2Y, color(255, 0, 0)); // Orang peringkat 1 dengan warna merah
  drawMinecraftPerson6(person3X, person3Y, color(0, 255, 0));
}

  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  void scene5() { // ini scene5
    if (!scene5AudioPercakapan.isPlaying()) {
    scene5AudioPercakapan.play();
  }

  drawBackground2();
  moveSinglePerson();
  drawCrowd();
  drawSinglePerson();
  checkAndChangeScene();
}

void drawBackground2() {
  background(135, 206, 235); // Warna biru langit
  drawClouds22();
  drawField();
}

void drawClouds22() {
  fill(255);
  noStroke();

  // Gambar beberapa awan
  ellipse(200, 100, 200, 100);
  ellipse(300, 100, 150, 80);
  ellipse(250, 70, 180, 90);
  
  ellipse(800, 150, 250, 120);
  ellipse(900, 150, 200, 100);
  ellipse(850, 120, 220, 110);
  
  ellipse(1300, 100, 220, 110);
  ellipse(1400, 100, 200, 100);
  ellipse(1350, 70, 230, 115);
}

void drawField() {
  fill(144, 238, 144); // Warna hijau muda untuk lapangan
  rect(0, canvasHeight / 2, canvasWidth, canvasHeight / 2); // Menggambar lapangan di bagian bawah kanvas
}

void moveSinglePerson() {
  float speed = 2.0; // Kecepatan bergerak
  float legSpeed = 0.05; // Kecepatan ayunan kaki
  float targetX = groupPersonX[0] - 150; // Tujuan akhir orang yang menghampiri

  if (!singlePersonReachedTarget) {
    if (singlePersonX < targetX) {
      singlePersonX += speed;
      if (singlePersonLegForward) {
        singlePersonLegAngle += legSpeed;
        if (singlePersonLegAngle > 0.5) {
          singlePersonLegForward = false;
        }
      } else {
        singlePersonLegAngle -= legSpeed;
        if (singlePersonLegAngle < -0.5) {
          singlePersonLegForward = true;
        }
      }
    } else {
      singlePersonReachedTarget = true;
      singlePersonLegAngle = 0; // Reset sudut kaki ketika sudah mencapai tujuan
    }
  }
}

void drawCrowd() {
  for (int i = 0; i < groupPersonX.length; i++) {
    drawMinecraftPersonFront(groupPersonX[i], groupPersonY[i], shirtColors[i], legAngle[i]);
  }
}

void drawSinglePerson() {
  drawMinecraftPersonFront(singlePersonX, singlePersonY, color(255, 0, 0), singlePersonLegAngle);
}

void drawMinecraftPersonFront(float x, float y, color shirtColor, float legAngle) {
  float legHeight = 60; // Tinggi kaki
  float legWidth = 22.5; // Lebar kaki

  // Kaki depan
  fill(0, 128, 0); // Warna hijau untuk kaki

  pushMatrix();
  translate(x - legWidth / 2 - 11.25, y + 45); // Titik rotasi untuk kaki kiri
  rotate(legAngle);
  rect(-legWidth / 2, 0, legWidth, legHeight);
  popMatrix();

  pushMatrix();
  translate(x + legWidth / 2 + 11.25, y + 45); // Titik rotasi untuk kaki kanan
  rotate(-legAngle);
  rect(-legWidth / 2, 0, legWidth, legHeight);
  popMatrix();

  // Kepala depan
  fill(255, 224, 189);
  rect(x - 30, y - 90, 60, 60); // Memperbesar ukuran kepala

  // Rambut depan
  fill(0); // Warna hitam untuk rambut
  rect(x - 30, y - 120, 60, 30); // Memperbesar ukuran rambut
  beginShape();
  vertex(x - 30, y - 90);
  vertex(x - 30, y - 120);
  vertex(x - 22.5, y - 127.5);
  vertex(x - 15, y - 120);
  vertex(x - 7.5, y - 127.5);
  vertex(x, y - 120);
  vertex(x + 7.5, y - 127.5);
  vertex(x + 15, y - 120);
  vertex(x + 22.5, y - 127.5);
  vertex(x + 30, y - 120);
  vertex(x + 30, y - 90);
  endShape(CLOSE);

  // Wajah depan
  fill(0); // Warna hitam untuk mata
  rect(x - 15, y - 70, 10, 10); // Mata kiri
  rect(x + 5, y - 70, 10, 10); // Mata kanan
  fill(255, 0, 0); // Warna merah untuk mulut
  rect(x - 10, y - 50, 20, 5); // Mulut

  // Tubuh depan
  fill(shirtColor); // Warna acak untuk tubuh
  rect(x - 22.5, y - 30, 45, 75); // Memperbesar ukuran tubuh

  // Tangan depan
  fill(255, 224, 189); // Warna kulit untuk tangan
  rect(x - 52.5, y - 30, 30, 75); // Kiri (Memperbesar ukuran tangan)
  rect(x + 22.5, y - 30, 30, 75); // Kanan (Memperbesar ukuran tangan)

  // Baju pada tangan depan
  fill(shirtColor); // Warna acak untuk baju pada tangan
  rect(x - 52.5, y - 30, 30, 30); // Kiri (Memperbesar ukuran baju pada tangan)
  rect(x + 22.5, y - 30, 30, 30); // Kanan (Memperbesar ukuran baju pada tangan)
}

void checkAndChangeScene() {
  int stayDuration = 30000; //waktu untuk scene5

  if (singlePersonReachedTarget) {
    int currentTime = millis();
    if (currentTime - startTime >= stayDuration) {
      currentScene = 1;
    }
  }
}
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
 
  
  // Mengatur ulang posisi kapal untuk scene3
  void resetBoatPositions() {
    // Urutan berdasarkan kecepatan: hijau, merah, biru
    float[] speeds = {1, 0.75, 0.5};
    float[] positions = {570, 690, 450}; // Y posisi kapal
    color[] colors = {color(0, 255, 0), color(255, 0, 0), color(0, 0, 255)};
  
    // Mengatur ulang posisi kapal berdasarkan kecepatan
    for (int i = 0; i < 3; i++) {
      boatSpeeds[i] = speeds[i];
      boatX[i] = -100; // Mengatur ulang posisi X kapal ke kiri layar
      boatY[i] = positions[i];
      shirtColors[i] = colors[i];
    }
  
    for (int i = 0; i < 3; i++) {
      boatCrashed[i] = false; // Reset flag tabrakan
      flipAngles[i] = 0; // Reset sudut rotasi
      isFlipping[i] = false; // Reset flag animasi terbalik
    }
  
    isMoving = true; // Mulai gerakan kembali
  }
  
  void drawMinecraftPerson(float x, float y, color shirtColor) {
    // Kepala
    fill(255, 224, 189);
    rect(x - 10, y - 30, 20, 20);
  
    // Rambut
    fill(0); // Warna hitam untuk rambut
    beginShape();
    vertex(x - 10, y - 30);
    vertex(x - 10, y - 40);
    vertex(x - 8, y - 42);
    vertex(x - 6, y - 40);
    vertex(x - 4, y - 42);
    vertex(x - 2, y - 40);
    vertex(x, y - 42);
    vertex(x + 2, y - 40);
    vertex(x + 4, y - 42);
    vertex(x + 6, y - 40);
    vertex(x + 8, y - 42);
    vertex(x + 10, y - 40);
    vertex(x + 10, y - 30);
    endShape(CLOSE);
  
    // Mata
    fill(255);
    rect(x - 5, y - 25, 4, 4); // Mata kiri putih
    rect(x + 1, y - 25, 4, 4); // Mata kanan putih
    fill(0);
    rect(x - 3, y - 23, 2, 2); // Mata kiri hitam
    rect(x + 3, y - 23, 2, 2); // Mata kanan hitam
  
    // Hidung
    fill(255, 224, 189);
    rect(x - 1, y - 20, 2, 2);
  
    // Mulut
    fill(255, 105, 180); // Warna pink untuk mulut
    rect(x - 3, y - 18, 6, 2);
  
    // Tubuh
    fill(shirtColor); // Warna baju yang dapat diubah
    rect(x - 7.5, y - 10, 15, 20);
  
    // Lengan
    fill(shirtColor); // Warna baju yang dapat diubah
    //rect(x - 12.5, y - 10, 5, 15); // Kiri
    //rect(x + 7.5, y - 10, 5, 15); // Kanan
      fill(shirtColor); // Warna baju yang dapat diubah
  rect(x - 7.5, y - 10, 15, 10); // Tubuh bawah
  fill(255, 224, 189); // Warna cream untuk tangan
  rect(x - 12.5, y - 10, 5, 15); // Kiri
  rect(x + 7.5, y - 10, 5, 15); // Kanan
  
    // Kaki (disembunyikan di perahu)
    fill(shirtColor); // Warna baju yang dapat diubah
    rect(x - 7.5, y + 10, 15, 10); // Bagian bawah tubuh
  }
  
  void drawBackground() {
    // Langit
    fill(135, 206, 250); // Warna langit biru muda
    rect(0, 0, canvasWidth, canvasHeight / 2);
  
    // Gambar awan
    drawCloud(200, 100);
    drawCloud(400, 150);
    drawCloud(700, 80);
    drawCloud(1000, 120);
    drawCloud(1200, 170);
  
    // Air
    fill(0, 191, 255); // Warna biru untuk air
    rect(0, canvasHeight / 2, canvasWidth, 2 * canvasHeight / 2); // Menyesuaikan ketinggian air menjadi lebih tinggi
    
  
    // Gambar ikan
    drawFish(300, 600);
    drawFish(600, 700);
    drawFish(900, 650);
    drawFish(1200, 600);
  }
  
  void drawCloud(float x, float y) {
    fill(255);
    noStroke();
    ellipse(x, y, 60, 60);
    ellipse(x + 40, y, 80, 80);
    ellipse(x + 80, y, 60, 60);
  }
  
  
  void drawFish(float x, float y) {
    fill(255, 140, 0);
    noStroke();
    // Badan ikan
    ellipse(x, y, 40, 20);
    // Ekor ikan
    triangle(x - 20, y, x - 40, y - 10, x - 40, y + 10);
    // Mata ikan
    fill(0);
    ellipse(x + 10, y - 5, 5, 5);
  }
  
  void drawBoat(float x, float y, float paddleAngle) {
    // Badan perahu yang lebih panjang
    fill(160, 82, 45);
    beginShape();
    vertex(x - 140, y);
    vertex(x + 140, y);
    vertex(x + 100, y + 20);
    vertex(x - 100, y + 20);
    endShape(CLOSE);
  
    // Dayung di perahu
    drawOar(x - 90 + 7.5, y, paddleAngle);
    drawOar(x + 7.5, y, paddleAngle);
    drawOar(x + 90 + 7.5, y, paddleAngle);
  }
  
  void drawFlippedBoat(float x, float y) {
    // Badan perahu yang terbalik
    fill(160, 82, 45);
    beginShape();
    vertex(x - 140, y + 20);
    vertex(x + 140, y + 20);
    vertex(x + 100, y);
    vertex(x - 100, y);
    endShape(CLOSE);
  
    // Dayung di perahu yang terbalik (dayung diam)
    drawOar(x - 90 + 7.5, y + 20, 0);
    drawOar(x + 7.5, y + 20, 0);
    drawOar(x + 90 + 7.5, y + 20, 0);
  }
  
  void drawOar(float x, float y, float angle) {
    pushMatrix();
    translate(x, y);
    rotate(angle);
    stroke(0, 0, 0);
    strokeWeight(6);
    line(0, 0, 50, 0);
    noStroke();
    fill(0, 0, 0);
    ellipse(55, 0, 20, 10);
    popMatrix();
  }
  
  void drawPeopleInBoat(float x, float y, color shirtColor) {
    drawPersonInBoat(x - 90, y - 10, shirtColor);
    drawPersonInBoat(x, y - 10, shirtColor);
    drawPersonInBoat(x + 90, y - 10, shirtColor);
  }
  
  void drawPersonInBoat(float x, float y, color shirtColor) {
    drawMinecraftPerson(x, y, shirtColor);
  }
  
  void drawRock(float x, float y) {
    fill(100);
    noStroke();
    beginShape();
    vertex(x - 50, y);
    vertex(x, y - 50);
    vertex(x + 50, y);
    vertex(x, y + 30);
    endShape(CLOSE);
  }
  
  void drawFlippingBoat(float x, float y, float angle) {
    pushMatrix();
    translate(x, y);
    rotate(angle);
    drawBoat(0, 0, 0); // Menggambar kapal pada posisi (0, 0) karena sudah ditranslasi dan dirotasi
    popMatrix();
  }
  
  
  
  
  
  
  
  
  
  
  
  
  
float person1X = -70; // Posisi awal orang 1 di luar layar (kiri)
float person2X = canvasWidth + 70; // Posisi awal orang 2 di luar layar (kanan)
float person1FinalX = 300; // Posisi akhir orang 1 (kiri)
float person2FinalX = 1200; // Posisi akhir orang 2 (kanan)
float yPos = canvasHeight - 120;
int totalDuration = 40000; // Total durasi untuk seluruh scene (40 detik)
int startTime;
boolean isPerson1Arrived = false; // Menandakan jika orang 1 sudah tiba
boolean isPerson2Arrived = false; // Menandakan jika orang 2 sudah tiba
boolean isWalking = true; // Menandakan jika animasi berjalan aktif
int walkAnimationFrame = 0; // Frame untuk animasi kaki
int walkAnimationDuration = 500; // Durasi satu siklus animasi kaki (ms)
int lastWalkAnimationTime; // Waktu terakhir update animasi kaki
int timeForWalking = 10000; // Waktu yang dihabiskan untuk berjalan (10 detik)
int stayDuration = 20000; // waktu untuk scene4
boolean stayFinished = false; // Menandakan apakah waktu berhenti telah selesai

void scene4() { //ini scene4
  background(135, 206, 235); // Langit biru
  
    if (!scene4Audio.isPlaying()) {
    scene4Audio.loop();
    scene4AudioPercakapan.play();
  }
  
  scene5AudioPercakapan.stop();

  
  // Menggambar laut
  fill(0, 119, 190); // Warna biru untuk laut
  rect(0, canvasHeight / 2, canvasWidth, canvasHeight / 2);
  
  // Menggambar pasir
  fill(194, 178, 128); // Warna pasir
  rect(0, canvasHeight - 100, canvasWidth, 100);
  
  // Menggambar awan
  drawCloud(canvasWidth / 2 - 300, canvasHeight / 4 - 50, 100); // Awan 1
  drawCloud(canvasWidth / 2 - 200, canvasHeight / 4 - 30, 100); // Awan 2
  drawCloud(canvasWidth / 2 + 100, canvasHeight / 4 - 50, 100); // Awan 3
  drawCloud(canvasWidth / 2 + 300, canvasHeight / 4 - 30, 100); // Awan 4

  // Menggambar matahari
  drawSun(canvasWidth / 2, canvasHeight / 4, 80); // Posisikan matahari di tengah atas

  // Menggambar kapal pacu jalur yang lebih besar
  drawBoat1(canvasWidth / 2, canvasHeight - 150, 2); // Panggil dengan faktor skala 2
  
  // Menggerakkan orang 1 dari kiri ke kanan
  if (person1X < person1FinalX) {
    person1X += 2; // Kecepatan gerakan orang 1
  } else {
    isPerson1Arrived = true;
  }
  // Menggerakkan orang 2 dari kanan ke kiri
  if (person2X > person2FinalX) {
    person2X -= 2; // Kecepatan gerakan orang 2
  } else {
    isPerson2Arrived = true;
  }

  // Menampilkan animasi kaki jika karakter masih bergerak
  if (isWalking) {
    // Update animasi kaki
    int currentTime = millis();
    if (currentTime - lastWalkAnimationTime >= walkAnimationDuration) {
      walkAnimationFrame = (walkAnimationFrame + 1) % 4; // 4 frame animasi kaki
      lastWalkAnimationTime = currentTime;
    }
    drawWalkAnimation(person1X, yPos); // Gambar animasi berjalan untuk orang 1
    drawWalkAnimation(person2X, yPos); // Gambar animasi berjalan untuk orang 2
  }

  // Menggambar orang 1 dan 2
  drawMinecraftPerson1(person1X, yPos);
  drawMinecraftPerson1(person2X, yPos);

  // Jika kedua orang sudah tiba, hentikan animasi berjalan dan mulai hitung waktu berhenti
  if (isPerson1Arrived && isPerson2Arrived) {
    isWalking = false; // Hentikan animasi berjalan
    int currentTime = millis();
    if (currentTime - startTime >= stayDuration) {
      currentScene = 2; // Pindah ke scene 1 setelah 5 detik
      startTime = millis(); // Reset startTime untuk scene berikutnya
    }
  } else {
    // Jika belum selesai, reset startTime untuk memastikan waktu berhenti tidak dimulai
    startTime = millis();
  }
}

void drawSun(float x, float y, float radius) {
  fill(255, 255, 0); // Warna kuning untuk matahari
  noStroke();
  ellipse(x, y, radius * 2, radius * 2); // Menggambar lingkaran matahari
}

void drawCloud(float x, float y, float size) {
  fill(255);
  noStroke();
  ellipse(x, y, size, size); // Awan utama
  
  // Menambahkan beberapa bulatan untuk efek awan
  ellipse(x - size / 4, y - size / 4, size / 1.5, size / 1.5);
  ellipse(x + size / 4, y - size / 4, size / 1.5, size / 1.5);
  ellipse(x - size / 4, y + size / 4, size / 1.5, size / 1.5);
  ellipse(x + size / 4, y + size / 4, size / 1.5, size / 1.5);
}

void drawMinecraftPerson1(float x, float y) {
  // Kepala
  fill(255, 224, 189);
  rect(x - 30, y - 90, 60, 60); // Membesar kepala

  // Rambut
  fill(0); // Warna hitam untuk rambut
  beginShape();
  vertex(x - 30, y - 90);
  vertex(x - 30, y - 110);
  vertex(x - 25, y - 120);
  vertex(x - 20, y - 110);
  vertex(x - 10, y - 120);
  vertex(x, y - 110);
  vertex(x + 10, y - 120);
  vertex(x + 20, y - 110);
  vertex(x + 25, y - 120);
  vertex(x + 30, y - 110);
  vertex(x + 30, y - 90);
  endShape(CLOSE);

  // Mata
  fill(255);
  rect(x - 15, y - 75, 12, 12); // Mata kiri putih
  rect(x + 3, y - 75, 12, 12); // Mata kanan putih
  fill(0);
  rect(x - 12, y - 72, 6, 6); // Mata kiri hitam
  rect(x + 6, y - 72, 6, 6); // Mata kanan hitam

  // Hidung
  fill(255, 224, 189);
  rect(x - 4, y - 62, 8, 8);

  // Mulut
  fill(150, 75, 0); // Warna coklat gelap untuk mulut
  rect(x - 12, y - 50, 24, 6);
  
  // Tubuh
  fill(0, 0, 255); // Warna biru untuk tubuh
  rect(x - 25, y - 30, 50, 70); // Membesar tubuh

  // Tangan (tidak bergerak)
  fill(255, 224, 189); // Warna kulit untuk tangan
  rect(x - 50, y - 30, 30, 60); // Kiri
  rect(x + 20, y - 30, 30, 60); // Kanan

  // Baju pada tangan
  fill(0, 0, 255); // Warna biru untuk baju pada tangan
  rect(x - 50, y - 30, 30, 30); // Kiri
  rect(x + 20, y - 30, 30, 30); // Kanan

  // Kaki
  fill(0, 128, 0); // Warna hijau untuk kaki
  rect(x - 25, y + 40, 20, 50); // Kiri
  rect(x + 5, y + 40, 20, 50); // Kanan
}

void drawWalkAnimation(float x, float y) {
  // Gambar kaki kiri dan kanan
  fill(0, 128, 0); // Warna hijau untuk kaki
  
  // Kaki kiri dan kanan berdasarkan frame
  if (walkAnimationFrame == 0) {
    rect(x - 25, y + 40, 20, 50); // Kaki kiri saat frame 0
    rect(x + 5, y + 40, 20, 50); // Kaki kanan saat frame 0
  } else if (walkAnimationFrame == 1) {
    rect(x - 25, y + 50, 20, 50); // Kaki kiri saat frame 1 (ke depan)
    rect(x + 5, y + 40, 20, 50); // Kaki kanan saat frame 1
  } else if (walkAnimationFrame == 2) {
    rect(x - 25, y + 40, 20, 50); // Kaki kiri saat frame 2 (kembali)
    rect(x + 5, y + 50, 20, 50); // Kaki kanan saat frame 2 (ke depan)
  } else if (walkAnimationFrame == 3) {
    rect(x - 25, y + 50, 20, 50); // Kaki kiri saat frame 3
    rect(x + 5, y + 40, 20, 50); // Kaki kanan saat frame 3
  }
}

void drawBoat1(float x, float y, float scaleFactor) {
  // Badan perahu yang lebih besar
  fill(160, 82, 45);
  beginShape();
  vertex(x - 150 * scaleFactor, y);
  vertex(x + 150 * scaleFactor, y);
  vertex(x + 100 * scaleFactor, y + 25 * scaleFactor);
  vertex(x - 100 * scaleFactor, y + 25 * scaleFactor);
  endShape(CLOSE);

  // Menghapus bagian putih di atas kapal
  fill(160, 82, 45);
  rect(x - 150 * scaleFactor, y - 10, 300 * scaleFactor, 10); // Menutupi bagian putih di atas kapal
}
