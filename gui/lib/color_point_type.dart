import "package:flutter/material.dart";

enum ColorPointType {
  first(
    color: const Color.fromARGB(255, 52, 168, 83),
    selectedColor: const Color.fromARGB(255, 52, 230, 83),
  ),
  stop(
    color: const Color.fromARGB(204, 224, 68, 68),
    selectedColor: const Color.fromARGB(255, 255, 83, 83),
  ),
  last(
    color: const Color.fromARGB(255, 174, 67, 53),
    selectedColor: const Color.fromARGB(255, 230, 67, 53),
  ),
  regular(
    color: Color.fromARGB(255, 238, 238, 238),
    selectedColor: Color.fromARGB(255, 238, 238, 238),
  );

  const ColorPointType({
    required final Color color,
    required final Color selectedColor,
  });
}
