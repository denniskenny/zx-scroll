# ZX Spectrum TileEd Integration

## Exporting from TileEd

1. Create your tilemap in TileEd with tiles indexed 0-3:
   - Tile 0: Empty
   - Tile 1: Solid block  
   - Tile 2: Checkerboard
   - Tile 3: Border

2. Export your map as CSV from TileEd:
   - File → Export → CSV
   - Make sure the export uses 0-based tile indices

3. Convert the CSV to ZX Spectrum format:
   ```bash
   ./generate_map your_tilemap.csv
   ```

4. Update the embedded map data:
   ```bash
   xxd -i map.bin > map_data.h
   ```

5. Rebuild the scroller:
   ```bash
   make scroll -B && make
   ```

## Map Requirements

- **Size**: Up to 96x48 tiles (larger maps will be cropped)
- **Tile indices**: 0-3 (values outside this range are clamped)
- **Format**: CSV with comma-separated tile indices
- **Coordinates**: (0,0) is top-left corner

## Example CSV Format

```csv
3,3,3,3,3,3,3,3
3,0,0,0,0,0,0,3
3,0,1,2,1,2,0,3
3,0,0,0,0,0,0,3
3,3,3,3,3,3,3,3
```

This creates a border (tile 3) with some internal tiles (1 and 2).
