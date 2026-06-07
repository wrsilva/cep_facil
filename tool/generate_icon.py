"""Gera app_icon.png 1024x1024 para o CEP Fácil usando apenas stdlib."""
import struct
import zlib
import math


def make_png(width: int, height: int, pixels: list[tuple[int, int, int, int]]) -> bytes:
    def chunk(name: bytes, data: bytes) -> bytes:
        c = struct.pack('>I', len(data)) + name + data
        return c + struct.pack('>I', zlib.crc32(name + data) & 0xFFFFFFFF)

    header = b'\x89PNG\r\n\x1a\n'
    ihdr_data = struct.pack('>IIBBBBB', width, height, 8, 2, 0, 0, 0)
    ihdr = chunk(b'IHDR', ihdr_data)

    raw = b''
    for y in range(height):
        raw += b'\x00'
        for x in range(width):
            r, g, b, _ = pixels[y * width + x]
            raw += bytes([r, g, b])

    idat = chunk(b'IDAT', zlib.compress(raw, 9))
    iend = chunk(b'IEND', b'')
    return header + ihdr + idat + iend


def draw_icon(size: int = 1024) -> list[tuple[int, int, int, int]]:
    pixels = []
    cx = cy = size / 2
    bg = (21, 101, 192, 255)      # #1565C0
    fg = (255, 255, 255, 255)     # branco

    pin_r = size * 0.28           # raio do círculo do pin
    pin_cx = cx
    pin_cy = cy - size * 0.06     # centro do círculo levemente acima

    # ponta do pin (triângulo abaixo do círculo)
    pin_tip_y = cy + size * 0.30
    pin_left_x = pin_cx - size * 0.10
    pin_right_x = pin_cx + size * 0.10
    pin_join_y = pin_cy + pin_r

    # buraco interno do pin
    hole_r = pin_r * 0.38

    for y in range(size):
        for x in range(size):
            # fundo arredondado (círculo para look de ícone)
            dx = x - cx
            dy = y - cy
            corner_r = size * 0.22
            in_bg = dx * dx + dy * dy <= (size * 0.48) ** 2

            if not in_bg:
                pixels.append((0, 0, 0, 0))
                continue

            r, g, b, a = bg

            # círculo principal do pin
            dpx = x - pin_cx
            dpy = y - pin_cy
            in_circle = dpx * dpx + dpy * dpy <= pin_r * pin_r

            # triângulo/cauda do pin
            in_tail = False
            if y >= pin_join_y and y <= pin_tip_y:
                progress = (y - pin_join_y) / (pin_tip_y - pin_join_y)
                half_w = size * 0.10 * (1.0 - progress)
                in_tail = abs(x - pin_cx) <= half_w

            in_pin = in_circle or in_tail

            # buraco branco no centro do círculo
            in_hole = dpx * dpx + dpy * dpy <= hole_r * hole_r

            if in_pin and not in_hole:
                r, g, b, a = fg
            elif in_hole and in_circle:
                r, g, b, a = bg

            pixels.append((r, g, b, a))

    return pixels


if __name__ == '__main__':
    import os
    size = 1024
    print(f"Gerando ícone {size}x{size}...")
    pixels = draw_icon(size)
    png = make_png(size, size, pixels)

    out = os.path.join(os.path.dirname(__file__), '..', 'assets', 'images', 'app_icon.png')
    out = os.path.normpath(out)
    with open(out, 'wb') as f:
        f.write(png)
    print(f"Salvo em: {out} ({len(png):,} bytes)")

    # foreground para adaptive icon (Android)
    out_fg = os.path.join(os.path.dirname(__file__), '..', 'assets', 'images', 'app_icon_foreground.png')
    out_fg = os.path.normpath(out_fg)
    with open(out_fg, 'wb') as f:
        f.write(png)
    print(f"Foreground salvo em: {out_fg}")
