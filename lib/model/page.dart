class Pageable<T> {
  Pageable.of(this.page, this.size, this.totalPage, {this.list});

  int page;
  int size;
  int totalPage;
  List<T>? list;

  bool hasNext() {
    return page < totalPage;
  }

  int next() {
    if (hasNext()) {
      page += 1;
      return page;
    }
    return -1;
  }
}
