import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deneme/screen/giris.dart'; // Çıkış yapmak için giriş ekranını import ediyoruz

class admin extends StatefulWidget {
  const admin({super.key});

  @override
  State<admin> createState() => _adminState();
}

class _adminState extends State<admin> {
  // 1. Veritabanında Durum Güncelleme Fonksiyonu
  Future<void> updateStatus(String docId, String newStatus) async {
    try {
      await FirebaseFirestore.instance.collection('talepler').doc(docId).update(
        {'durum': newStatus},
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Talep durumu güncellendi!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Hata oluştu: $e')));
      }
    }
  }

  // 2. Durum Değiştirme Pop-up'ı (Dialog)
  void showStatusDialog(
    BuildContext context,
    String docId,
    String currentStatus,
  ) {
    String selectedStatus = currentStatus;
    // Adminin seçebileceği durum listesi
    final List<String> statusOptions = [
      'Bekliyor',
      'İşleme Alındı',
      'Tamamlandı',
      'İptal Edildi',
    ];

    // Eğer mevcut durum listede yoksa, varsayılanı bekleme yap (Hata önleyici)
    if (!statusOptions.contains(selectedStatus)) {
      selectedStatus = 'Bekliyor';
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Durumu Güncelle'),
          content: DropdownButtonFormField<String>(
            value: selectedStatus,
            items: statusOptions.map((status) {
              return DropdownMenuItem(value: status, child: Text(status));
            }).toList(),
            onChanged: (val) {
              if (val != null) {
                selectedStatus = val;
              }
            },
            decoration: const InputDecoration(border: OutlineInputBorder()),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('İptal', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
              onPressed: () {
                updateStatus(docId, selectedStatus);
                Navigator.pop(context); // Dialogu kapat
              },
              child: const Text(
                'Güncelle',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Admin Paneli - Tüm Talepler'),
        backgroundColor: Colors.red[800],
        foregroundColor: Colors.white,
        actions: [
          // Çıkış Yap Butonu
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const giris()),
              );
            },
          ),
        ],
      ),
      // 3. Canlı Veri Çekme (StreamBuilder)
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('talepler')
            .orderBy(
              'olusturulma_tarihi',
              descending: true,
            ) // En yeni talepler en üstte
            .snapshots(),
        builder: (context, snapshot) {
          // Yükleniyorsa veya hata varsa ekranı yönet
          if (snapshot.hasError) {
            return const Center(
              child: Text('Veriler yüklenirken bir hata oluştu.'),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final requests = snapshot.data!.docs;

          // Eğer hiç talep yoksa
          if (requests.isEmpty) {
            return const Center(
              child: Text(
                'Sistemde henüz bir talep bulunmuyor.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          // Talepler varsa listele
          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: requests.length,
            itemBuilder: (context, index) {
              final req = requests[index];
              final docId = req.id; // Firebase belgesinin benzersiz ID'si

              // Verileri güvenli şekilde çek
              final data = req.data() as Map<String, dynamic>;
              final title = data['baslik'] ?? 'Başlık Yok';
              final status = data['durum'] ?? 'Bekliyor';
              final category = data['kategori'] ?? 'Kategori Yok';
              final priority = data['oncelik'] ?? 'Normal';

              // Duruma göre renk belirle ki admin kolayca ayırt etsin
              Color statusColor = Colors.orange;
              if (status == 'Tamamlandı') statusColor = Colors.green;
              if (status == 'İptal Edildi') statusColor = Colors.red;
              if (status == 'İşleme Alındı') statusColor = Colors.blue;

              return Card(
                elevation: 4,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(15),
                  leading: CircleAvatar(
                    radius: 25,
                    backgroundColor: statusColor.withOpacity(0.2),
                    child: Icon(
                      Icons.assignment_late,
                      color: statusColor,
                      size: 28,
                    ),
                  ),
                  title: Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Kategori: $category',
                          style: const TextStyle(color: Colors.black87),
                        ),
                        Text(
                          'Öncelik: $priority',
                          style: const TextStyle(color: Colors.black87),
                        ),
                        const SizedBox(height: 5),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: statusColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            status,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  isThreeLine: true,
                  // Kalem ikonuna basınca güncelleme pop-up'ı açılır
                  trailing: IconButton(
                    icon: const Icon(
                      Icons.edit_document,
                      color: Colors.indigo,
                      size: 30,
                    ),
                    onPressed: () => showStatusDialog(context, docId, status),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
