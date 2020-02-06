Future delay(int milliseconds, void Function() action) =>
    Future.delayed(Duration(milliseconds: milliseconds)).then((_) => action());
