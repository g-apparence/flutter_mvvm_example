import 'dart:collection';
import 'dart:convert';

import 'package:todo_app/services/local_storage/entity_adapter.dart';

import 'local_storage_manager.dart';

class StoreService<T> {

  final StorageManager storageManager;
  final GenericEntityAdapter<T> itemAdapter;
  final int maxLength;
  bool hasInit = false;
  ListQueue<T> queue;

  StoreService(this.storageManager, this.itemAdapter, this.maxLength);

  Future init() async {
    assert(this.storageManager != null);
    if (hasInit) {
      return Future.error("ALREADY_INIT");
    }
    String fileContent;
    try {
      fileContent = await this.storageManager.read();
      List<T> items = itemAdapter.parseArray(fileContent);
      this.queue = new ListQueue.from(items);

    } catch (e) {
      print("Error while loading file content... $e");
      this.queue = new ListQueue();
      this.hasInit = true;
    }
    this.hasInit = true;
  }

  Future add(T entity) {
    assert(hasInit);
    if (this.queue.contains(entity)) {
      return Future(() => null);
    }
    if (this.queue.length >= this.maxLength) {
      this.queue.removeLast();
    }
    this.queue.addFirst(entity);
    var encoded = json.encode(this.queue.toList());
    return this.storageManager.store(encoded);
  }

  List<T> getItems() {
    assert(hasInit);
    return this.queue.toList();
  }

}