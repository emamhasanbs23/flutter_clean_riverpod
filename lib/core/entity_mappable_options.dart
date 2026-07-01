import 'package:dart_mappable/dart_mappable.dart';

/// Domain entities use mappable for `copyWith`, `==`, `hashCode`, and
/// `toString` only — no wire serialization (`fromJson` / `toJson`).
const int entityGenerateMethods =
    GenerateMethods.copy | GenerateMethods.stringify | GenerateMethods.equals;
