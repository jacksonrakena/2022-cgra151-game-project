class GameMap {
 ArrayList<Wall> walls = new ArrayList<Wall>();
 int cellWidth;
 int cellHeight;
 ArrayList<MapMarker> markers = new ArrayList<MapMarker>();
}

class MapMarker {
  float x;
  float y;
  float height;
  float width;
  String type;
  
  MapMarker(float x, float y, float width, float height, String type) {
    this.x = x;
    this.y = y;
    this.height = height;
    this.width = width;
    this.type = type;
  }
}

GameMap readMap(String path) {
  Table t = loadTable(path, "csv");
 
  GameMap m = new GameMap();
  m.cellWidth = height / t.getColumnCount();
  m.cellHeight = width / t.getRowCount();
  println("Loaded " + t.getRowCount() + "x" + t.getColumnCount() +" map from " + path);
  for (int r = 0; r < t.getRowCount(); r++) {
    TableRow row = t.getRow(r);
    for (int c = 0; c < row.getColumnCount(); c++) {
      String cell = row.getString(c);
      if (!cell.equals("")) {
        String[] components = cell.split(":");
        String type = components[0];
        String data = components[1];
        switch (type) {
          case "w":
            m.walls.add(new Wall(c*m.cellWidth,r*m.cellHeight, m.cellWidth, m.cellHeight, new DefaultWallTexture()));
            break;
          case "m":
            m.markers.add(new MapMarker(c*m.cellWidth, r*m.cellHeight, m.cellWidth, m.cellHeight, data));
            break;
          default:
            println("Unknown map entity type " + type);
            break;
        }
      }
    }
  }
  return m;
}
