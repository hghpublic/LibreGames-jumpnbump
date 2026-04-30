meta:
  id: gob
  file-extension: gob
  endian: le
seq:
  - id: header
    type: header
  - id: images
    type: image
    repeat: expr
    repeat-expr: header.num_images
types:
  header:
    seq:
      - id: num_images
        type: u2
      - id: image_offsets
        type: u4
        repeat: expr
        repeat-expr: num_images
  image:
    seq:
      - id: width
        type: u2
      - id: height
        type: u2
      - id: hotspot_x
        type: s2
      - id: hotspot_y
        type: s2
      - id: data
        type: u1
        repeat: expr
        repeat-expr: width*height
